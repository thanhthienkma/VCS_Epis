import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:utils/screens/camera/UtilCameraScreen.dart';
import 'package:utils/screens/camera/components/AllPhotosComponent.dart';
import 'package:utils/screens/camera/components/PreviewComponent.dart';
import 'package:utils/support/PhotoSupport.dart';

class AllPreviewComponent extends StatefulWidget {
  /// Arguments
  final Map arguments;

  /// Constructor
  AllPreviewComponent({this.arguments});

  @override
  State<StatefulWidget> createState() {
    return AllPreviewState();
  }
}

class AllPreviewState extends State<AllPreviewComponent> {

  /// List camera description, include font camera and back camera
  List<CameraDescription> _cameras;

  /// Camera controller to capture image
  CameraController _controller;

  /// Photos is selected
  List<PhotoSupport> _photoVMsSelected = [];

  /// All photos
  List<PhotoSupport> _photoVMs = [];

  /// Size of screen
  Size _size;

  /// With multi photos, limit photo is captured
  int _limit = 10;

  /// Fire event capture photo
  StreamController<bool> _captureStream;

  /// Init data
  StreamController<Map> _initPhotoStream;

  /// Update all
  StreamController<Map> _updateAllStream;

  /// Update preview
  StreamController<Map> _updatePreviewStream;

  /// Callback data after selecting
  Function(List<PhotoSupport> photos, List<PhotoSupport> selectedPhotos,
      PhotoSupport newSelectedPhotoVM) _allCallback;

  /// Callback data after capture photo
  Function(List<PhotoSupport> photos, List<PhotoSupport> selectedPhotos, PhotoSupport newPhotoVM)
      _previewCallback;

  @override
  void initState() {
    super.initState();
    _photoVMsSelected = widget.arguments[UtilCameraConstant.SELECTED];
    _cameras = widget.arguments[UtilCameraConstant.CAMERAS];
    _size = widget.arguments[UtilCameraConstant.SIZE];
    _limit = widget.arguments[UtilCameraConstant.LIMIT];

    _captureStream = widget.arguments[UtilCameraConstant.CAPTURE_STREAM];
    _initPhotoStream = widget.arguments[UtilCameraConstant.INIT_PHOTOS_STREAM];
    _updateAllStream = widget.arguments[UtilCameraConstant.UPDATE_ALL_STREAM];
    _updatePreviewStream = widget.arguments[UtilCameraConstant.UPDATE_PREVIEW_STREAM];

    _allCallback = widget.arguments[UtilCameraConstant.ALL_CALLBACK];
    _previewCallback = widget.arguments[UtilCameraConstant.PREVIEW_CALLBACK];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _createPreviewWidget(),
        bottomSheet: _createAllPhotosWidget());
  }

  Widget _createAllPhotosWidget() {
    Map args = Map();
    args[UtilCameraConstant.CAMERAS] = _cameras;
    args[UtilCameraConstant.SIZE] = _size;
    args[UtilCameraConstant.SELECTED] = _photoVMsSelected;
    args[UtilCameraConstant.PHOTOS] = _photoVMs;
    args[UtilCameraConstant.LIMIT] = _limit;
    args[UtilCameraConstant.UPDATE_ALL_STREAM] = _updateAllStream;
    args[UtilCameraConstant.ALL_CALLBACK] = _allCallback;
    args[UtilCameraConstant.INIT_PHOTOS_STREAM] = _initPhotoStream;
    return AllPhotosComponent(arguments: args);
  }

  /// Create preview widget
  Widget _createPreviewWidget() {
    Map args = Map();
    args[UtilCameraConstant.CAMERAS] = _cameras;
    args[UtilCameraConstant.SIZE] = _size;
    args[UtilCameraConstant.SELECTED] = _photoVMsSelected;
    args[UtilCameraConstant.LIMIT] = _limit;
    args[UtilCameraConstant.PREVIEW_CALLBACK] = _previewCallback;
    args[UtilCameraConstant.UPDATE_PREVIEW_STREAM]  = _updatePreviewStream;
    args[UtilCameraConstant.CAPTURE_STREAM] = _captureStream;
    args[UtilCameraConstant.INIT_PHOTOS_STREAM] = _initPhotoStream;
    return PreviewComponent(arguments: args);
  }
}
