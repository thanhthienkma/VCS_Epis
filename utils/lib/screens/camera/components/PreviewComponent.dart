import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:utils/model/Photo.dart';
import 'package:utils/screens/camera/UtilCameraScreen.dart';
import 'package:utils/utils.dart';
import 'package:utils/support/PhotoSupport.dart';

class PreviewComponent extends StatefulWidget {
  /// Arguments
  final Map arguments;

  /// Constructor
  PreviewComponent({this.arguments});

  @override
  State<StatefulWidget> createState() {
    return PreviewState();
  }
}

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

class PreviewState extends State<PreviewComponent> with WidgetsBindingObserver {
  /// For back camera
  static const int BACK_CAMERA = 0;

  /// For front camera
  static const int FRONT_CAMERA = 1;

  /// List camera description, include font camera and back camera
  List<CameraDescription> _cameras;

  /// Camera controller to capture image
  CameraController _controller;

  /// Photos is selected
  List<PhotoSupport> _photoSupportSelected = [];

  /// All photos
  List<PhotoSupport> _photoSupport = [];

  /// Size of screen
  Size _size;

  /// Fire event capture photo
  StreamController<bool> _updateCaptureStream;

  /// Update preview
  StreamController<Map> _updatePreviewStream;

  /// Update selected bottom when capture image
  StreamController<Map> _initPhotoStream;

  /// Callback data after capture photo
  Function(List<PhotoSupport> photos, List<PhotoSupport> selectedPhotos,
      PhotoSupport newPhotoVM) _callback;

  /// With multi photos, limit photo is captured
  int _limit = 10;

  /// Camera is selected (front camera or back camera)
  int _cameraSelected;

  @override
  void initState() {
    super.initState();

    _photoSupportSelected = widget.arguments[UtilCameraConstant.SELECTED];
    _cameras = widget.arguments[UtilCameraConstant.CAMERAS];
    _size = widget.arguments[UtilCameraConstant.SIZE];
    _limit = widget.arguments[UtilCameraConstant.LIMIT];
    _callback = widget.arguments[UtilCameraConstant.PREVIEW_CALLBACK];

    _updateCaptureStream = widget.arguments[UtilCameraConstant.CAPTURE_STREAM];

    /// Listen event to capture photo.
    _updateCaptureStream.stream.listen((bool isCapture) {
      if (!mounted) {
        return;
      }
      onTakePictureButtonPressed();
    });
    _updatePreviewStream = widget.arguments[UtilCameraConstant.UPDATE_PREVIEW_STREAM];

    /// Update data.
    _updatePreviewStream.stream.listen((Map value) {
      _photoSupportSelected = value[UtilCameraConstant.SELECTED];
      _photoSupport = value[UtilCameraConstant.PHOTOS];
    });

    _initPhotoStream = widget.arguments[UtilCameraConstant.INIT_PHOTOS_STREAM];

    /// Init data
    _initPhotoStream.stream.listen((Map value) {
      _photoSupportSelected = value[UtilCameraConstant.SELECTED];
      _photoSupport = value[UtilCameraConstant.PHOTOS];
    });

    WidgetsBinding.instance.addObserver(this);
    if (_cameras == null || _cameras.isEmpty) {
      return;
    }

    /// Init with back camera
    _cameraSelected = BACK_CAMERA;
    onNewCameraSelected(_cameras.first);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (_controller == null || !_controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (_controller != null) {
        onNewCameraSelected(_controller.description);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    return Stack(
      children: <Widget>[
        Container(
            height: _size.height - UtilCameraConstant.BOTTOM_HEIGHT,
            width: _size.width,
            color: Colors.black,
            alignment: Alignment.center,
            child: _cameraPreviewWidget()),
        Container(
            margin: EdgeInsets.only(top: 40, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[_createSwitchWidget()],
            ))
      ],
    );
  }

  /// Create switch widget
  Widget _createSwitchWidget() {
    if (_cameras.length < 2) {
      return Container();
    }
    return InkWell(
        onTap: () {
          /// Change to back camera or font camera.
          if (_cameraSelected == BACK_CAMERA) {
            _cameraSelected = FRONT_CAMERA;
            onNewCameraSelected(_cameras.last);
          } else {
            _cameraSelected = BACK_CAMERA;
            onNewCameraSelected(_cameras.first);
          }
        },
        child: Container(
            child: Image.asset('assets/switch.png', package: 'utils',
                width: 20, height: 20, color: Colors.white)));
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (_controller == null || !_controller.value.isInitialized) {
      return Container(
          color: Colors.black,
          alignment: Alignment.center,
          child: Text(
            'Initialing a camera...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.w900,
            ),
          ));
    } else {
      return AspectRatio(
        aspectRatio: (_size.width) / (_size.height - UtilCameraConstant.BOTTOM_HEIGHT),
        child: CameraPreview(_controller),
      );
    }
  }

  /// Timestamp for name of image
  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();


//  void onNewCameraSelected(CameraDescription cameraDescription) async {
//    if (controller != null) {
//      await controller.dispose();
//    }
//    controller = CameraController(
//      cameraDescription,
//      ResolutionPreset.medium,
//      enableAudio: enableAudio,
//    );
//
//    // If the controller is updated then update the UI.
//    controller.addListener(() {
//      if (mounted) setState(() {});
//      if (controller.value.hasError) {
//        showInSnackBar('Camera error ${controller.value.errorDescription}');
//      }
//    });
//
//    try {
//      await controller.initialize();
//    } on CameraException catch (e) {
//      _showCameraException(e);
//    }
//
//    if (mounted) {
//      setState(() {});
//    }
//  }



  /// New camera is selected
  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (_controller != null) {
      await _controller.dispose();
    }
    _controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    // If the controller is updated then update the UI.
    _controller.addListener(() {
      if (mounted) setState(() {});
      if (_controller.value.hasError) {
        print('Camera error ${_controller.value.errorDescription}');
      }
    });

    try {
      await _controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }


//  void onTakePictureButtonPressed() {
//    takePicture().then((String filePath) {
//      if (mounted) {
//        setState(() {
//          imagePath = filePath;
//          videoController?.dispose();
//          videoController = null;
//        });
//        if (filePath != null) showInSnackBar('Picture saved to $filePath');
//      }
//    });
//  }

  /// Handle take photo
  void onTakePictureButtonPressed() {
    if (_controller == null) {
      return;
    }
    if (!_controller.value.isInitialized) {
      print('Error: select a camera first.');
      return null;
    }
    if (_controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    takePicture().then((String orgFilePath) async {
      if (orgFilePath == null || !mounted) {
        return;
      }

      String stringValue = await Utils.sharePhoto(orgFilePath);
      if (stringValue == null || stringValue == '') {
        return;
      }
      dynamic valueMap = json.decode(stringValue);
      Photo photo = Photo.fromJson(valueMap);

      PhotoSupport photoVM = PhotoSupport(photo);
      if (_photoSupportSelected.length < _limit) {
        photoVM.isSelected = true;
        _photoSupportSelected.insert(0,photoVM);
      }
      _photoSupport.insert(0, photoVM);

      _callback(_photoSupport, _photoSupportSelected, photoVM);
    });
  }

  /// Take picture
  Future<String> takePicture() async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';
    try {
      await _controller.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    print('Error: ${e.code}\n${e.description}');
  }

  void logError(String code, String message) =>
      print('Error: $code\nError Message: $message');
}
