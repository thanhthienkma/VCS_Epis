import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:utils/model/Photo.dart';
import 'package:utils/screens/camera/components/AllPreviewComponent.dart';
import 'package:utils/screens/camera/components/SelectedComponent.dart';
import 'package:utils/utils.dart';
import 'dart:async';

import 'package:utils/support/PhotoSupport.dart';

class UtilCameraConstant {
  static const String CAMERAS = 'cameras';
  static const String SIZE = 'size';
  static const String LIMIT = 'limit';
  static const String IS_ONE_BACK = 'is_one_back';
  static const String CALLBACK = 'callback';
  static const String SELECTED = 'selected';
  static const String ALLOW_ACCESS = "allow_access";
  static const String CHECKED = "checked";
  static const double BOTTOM_HEIGHT = 80;
  static const double BOTTOM_LIST_HEIGHT = 80;
  static const String VIEW_MODEL = 'view_model';
  static const String PHOTOS = 'photos';
  static const String NEW = 'new';

  static const String INIT_PHOTOS_STREAM = 'init_photos_stream';
  static const String CAPTURE_STREAM = 'capture_stream';
  static const String UPDATE_ALL_STREAM = 'update_all_stream';
  static const String UPDATE_PREVIEW_STREAM = 'update_preview_stream';
  static const String UPDATE_ITEM_STREAM = 'update_item_stream';
  static const String UPDATE_SELECTED_STREAM = 'update_selected_stream';
  static const String ALL_CALLBACK = 'all_callback';
  static const String PREVIEW_CALLBACK = 'preview_callback';
  static const String SELECTED_CALLBACK = 'selected_callback';
}

List<CameraDescription> cameras = [];

/// Returns a suitable camera icon for [direction].
IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
  }
  throw ArgumentError('Unknown lens direction');
}

void logError(String code, String message) => print('Error: $code\nError Message: $message');

/// Take photo screen
/// Arguments:
/// -> cameras: include front camera, back camera.
/// -> size: screen size.
/// -> limit: limit photo is selected.
/// -> is_multiple_selected: allow multiple selected photos.
class UtilCameraScreen extends StatefulWidget {
  /// Arguments
  final Map arguments;

  /// Constructor
  UtilCameraScreen({@required this.arguments});

  @override
  State<StatefulWidget> createState() {
    return UtilCameraState();
  }
}

class UtilCameraState extends State<UtilCameraScreen> with WidgetsBindingObserver {
  /// List camera description, include font camera and back camera
  List<CameraDescription> _cameras = [];

  /// Photos is selected
  List<PhotoSupport> _photoSupportSelected = [];

  /// Photos
  List<PhotoSupport> _photoSupport = [];

  /// Screen size.
  Size _size;

  /// With multi photos, limit photo is captured
  int _limit = 1;

  /// Choose one and back
  bool _isOneBack = false;

  /// Fire event capture photo in PreviewComponent.
  StreamController<bool> _captureStream = StreamController();

  /// Init data
  StreamController<Map> _initPhotoStream = StreamController.broadcast();

  /// Update all
  StreamController<Map> _updateAllStream = StreamController.broadcast();

  /// Update preview
  StreamController<Map> _updatePreviewStream = StreamController.broadcast();

  /// Update selected
  StreamController<Map> _updateSelectedStream = StreamController.broadcast();

  @override
  void initState() {
    super.initState();
    _cameras = widget.arguments[UtilCameraConstant.CAMERAS];
    _size = widget.arguments[UtilCameraConstant.SIZE];
    if (widget.arguments.containsKey(UtilCameraConstant.LIMIT)) {
      _limit = widget.arguments[UtilCameraConstant.LIMIT];
      if (_limit <= 1) {
        _limit = 1;
      }
    }
    if (widget.arguments.containsKey(UtilCameraConstant.IS_ONE_BACK)) {
      _isOneBack = widget.arguments[UtilCameraConstant.IS_ONE_BACK];
    }

    /// Load photos
    Future.delayed(Duration(milliseconds: 100), () {
      _loadPhotos();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _captureStream.close();
    _initPhotoStream.close();
    _updateAllStream.close();
    _updatePreviewStream.close();
    _updateSelectedStream.close();
  }

  /// Create all preview widget
  Widget _createAllPreviewWidget() {
    Map args = Map();
    args[UtilCameraConstant.SELECTED] = _photoSupportSelected;
    args[UtilCameraConstant.CAMERAS] = _cameras;
    args[UtilCameraConstant.SIZE] = _size;
    args[UtilCameraConstant.LIMIT] = _limit;
    args[UtilCameraConstant.ALL_CALLBACK] = (List<PhotoSupport> photoVMs,
        List<PhotoSupport> photoVMsSelected, PhotoSupport selectedPhotoVM) {
      if (!mounted) {
        return;
      }
      _photoSupportSelected = []..addAll(photoVMsSelected);
      _photoSupport = []..addAll(photoVMs);
      if (_isOneBack) {
        onBackPress();
        return;
      }

      /// Update
      Map args = Map();
      args[UtilCameraConstant.PHOTOS] = _photoSupport;
      args[UtilCameraConstant.SELECTED] = _photoSupportSelected;
      args[UtilCameraConstant.NEW] = selectedPhotoVM;
      _updateSelectedStream.sink.add(args);
      _updatePreviewStream.sink.add(args);
    };
    args[UtilCameraConstant.PREVIEW_CALLBACK] = (List<PhotoSupport> photoVMs,
        List<PhotoSupport> photoVMsSelected, PhotoSupport newPhotoVM) {
      if (!mounted) {
        return;
      }

      _photoSupportSelected = []..addAll(photoVMsSelected);
      _photoSupport = []..addAll(photoVMs);
      if (_isOneBack) {
        onBackPress();
        return;
      }

      /// Update
      Map args = Map();
      args[UtilCameraConstant.PHOTOS] = _photoSupport;
      args[UtilCameraConstant.SELECTED] = _photoSupportSelected;
      args[UtilCameraConstant.NEW] = newPhotoVM;

      _updateSelectedStream.sink.add(args);
      _updateAllStream.sink.add(args);
    };
    args[UtilCameraConstant.CAPTURE_STREAM] = _captureStream;
    args[UtilCameraConstant.INIT_PHOTOS_STREAM] = _initPhotoStream;
    args[UtilCameraConstant.UPDATE_ALL_STREAM] = _updateAllStream;
    args[UtilCameraConstant.UPDATE_PREVIEW_STREAM] = _updatePreviewStream;

    return AllPreviewComponent(arguments: args);
  }

  /// Create selected widget
  Widget _createSelectedWidget() {
    Map args = Map();
    args[UtilCameraConstant.LIMIT] = _limit;
    args[UtilCameraConstant.UPDATE_SELECTED_STREAM] = _updateSelectedStream;
    args[UtilCameraConstant.SELECTED_CALLBACK] = (int status, {List<PhotoSupport> value}) {
      if (status == SelectedComponent.CAPTURE) {
        _captureStream.sink.add(true);
      } else if (status == SelectedComponent.CANCEL) {
        onBackPress();
      } else if (status == SelectedComponent.SELECTED) {
        onBackPress();
      }
    };

    return SelectedComponent(arguments: args);
  }

  /// Handle back
  Future<bool> onBackPress() async {
    List<Photo> list = [];
    _photoSupportSelected.forEach((element) {
      list.add(element.photo);
    });
    Navigator.pop(context, list);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return Scaffold(
        body: WillPopScope(
            onWillPop: onBackPress,
            child: Column(
              children: <Widget>[
                Expanded(child: _createAllPreviewWidget()),
                _createSelectedWidget(),
              ],
            )));
  }

  /// Load photos
  void _loadPhotos() async {
    if (!mounted) {
      return;
    }
    String stringValue = await Utils.getAllPhotos();
    dynamic valueMap = json.decode(stringValue);

    List<Photo> listPhotos = List<Photo>.from(valueMap.map((x) {
      return Photo.fromJson(x);
    }));

    _photoSupport = listPhotos.map((value) {
      PhotoSupport item = PhotoSupport(value);
      for (var data in _photoSupportSelected) {
        if (data.photo == value) {
          item.isSelected = true;
          break;
        }
      }
      return item;
    }).toList();

    /// Update bottom
    Map args = Map();
    args[UtilCameraConstant.PHOTOS] = _photoSupport;
    args[UtilCameraConstant.SELECTED] = _photoSupportSelected;
    _initPhotoStream.sink.add(args);
  }
}
