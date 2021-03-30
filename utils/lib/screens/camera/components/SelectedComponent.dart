import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:utils/model/Photo.dart';
import 'package:utils/screens/camera/UtilCameraScreen.dart';
import 'package:utils/utils.dart';
import 'package:utils/support/PhotoSupport.dart';

class SelectedComponent extends StatefulWidget {
  static const CANCEL = 0;
  static const SELECTED = 1;
  static const CAPTURE = 2;

  final Map arguments;

  SelectedComponent({this.arguments});

  @override
  State<StatefulWidget> createState() {
    return SelectedState();
  }
}

class SelectedState extends State<SelectedComponent> with TickerProviderStateMixin {
  /// Photos is selected
  List<PhotoSupport> _photoSupportSelected = [];

  /// All photos
  List<PhotoSupport> _photoSupport = [];

  /// Limit allow user is selected
  int _limit;

  /// Data of current image is selected
  ByteData _thumbData;

  /// Callback data to UtilCameraScreen
  Function(int status, {List<PhotoSupport> value}) _callback;

  /// Update UI when items selected or capture.
  StreamController<Map> _updateSelectedStream;

  /// Animation controller to display image
  AnimationController _controller;

  /// Animation type
  Animation<double> _animation;

  /// Chanel
  static const MethodChannel _channel = const MethodChannel('utils');

  @override
  void initState() {
    super.initState();
    _photoSupport = widget.arguments[UtilCameraConstant.PHOTOS];
    _photoSupportSelected = widget.arguments[UtilCameraConstant.SELECTED];
    _limit = widget.arguments[UtilCameraConstant.LIMIT];
    _callback = widget.arguments[UtilCameraConstant.SELECTED_CALLBACK];
    _updateSelectedStream = widget.arguments[UtilCameraConstant.UPDATE_SELECTED_STREAM];
    _updateSelectedStream.stream.listen((Map value) {
      _photoSupportSelected = value[UtilCameraConstant.SELECTED];
      _photoSupport = value[UtilCameraConstant.PHOTOS];
      if (_photoSupportSelected.isNotEmpty) {
        _loadThumb();
      }
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  /// Load thumbnail
  void _loadThumb() async {
    if (_photoSupportSelected == null || _photoSupportSelected.isEmpty) {
      return;
    }
    ByteData thumbData = await Utils.getThumbByteData(_photoSupportSelected.first.photo, 200, times: 2);
    _thumbData = thumbData;
    if (!mounted) {
      return;
    }
    /// Update UI.
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    if (_controller != null) {
      _controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        child: SafeArea(
            top: false,
            child: Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                width: double.infinity,
                color: Colors.black,
                child: Row(
                  children: <Widget>[
                    _createPhotoViewWidget(),
                    _createTakePhotoWidget(),
                    _createSelectedWidget(),
                  ],
                ),
                height: UtilCameraConstant.BOTTOM_HEIGHT)));
  }

  /// Create photo view widget
  Widget _createPhotoViewWidget() {
    Widget imageWidget;
    if (_photoSupportSelected == null || _photoSupportSelected.isEmpty) {
      /// If images is not selected we show default image.
      imageWidget = Image.asset('assets/default_image.png', package: 'utils', fit: BoxFit.contain);
      print('_createPhotoViewWidget default image');
    } else {
      if (_thumbData == null) {
        /// Show loading
        imageWidget = Container(
            padding: EdgeInsets.all(8),
            child: SpinKitFadingCube(color: Color(0xffDB0000), size: 25));
        print('_createPhotoViewWidget loading');
      } else {
        /// Show image with animation
        _controller = AnimationController(
            duration: const Duration(milliseconds: 2000), value: 0.5, vsync: this);
        _animation = CurvedAnimation(parent: _controller, curve: Curves.bounceInOut);

        imageWidget = ScaleTransition(
            scale: _animation,
            alignment: Alignment.center,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.memory(
                  _thumbData.buffer.asUint8List(),
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                )));
        _controller.forward();
        print('_createPhotoViewWidget ok --');
      }
    }
    String key = '';
    if (_photoSupportSelected != null && _photoSupportSelected.isNotEmpty) {
      key = _photoSupportSelected.last.photo.identifier;
    }
    return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(key: Key(key), width: 40, height: 40, child: imageWidget));
  }

  /// Create take photo widget
  Widget _createTakePhotoWidget() {
    return Expanded(
        child: Container(
      child: IconButton(
          iconSize: 40,
          icon: const Icon(Icons.camera_alt),
          color: Colors.white,
          onPressed: () {
            if (_callback == null) {
              return;
            }
            _callback(SelectedComponent.CAPTURE);
          }),
    ));
  }

  /// Create selected widget
  Widget _createSelectedWidget() {
    String value;
    if (_photoSupportSelected == null || _photoSupportSelected.isEmpty) {
      value = 'Cancel';
    } else {
      value = 'Selected(${_photoSupportSelected.length})';
    }
    return InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          if (_callback == null) {
            return;
          }
          if (_photoSupportSelected == null || _photoSupportSelected.isEmpty) {
            _callback(SelectedComponent.CANCEL);
          } else {
            _callback(SelectedComponent.SELECTED, value: _photoSupportSelected);
          }
        },
        child: Container(
            alignment: Alignment.centerLeft,
            width: 80,
            padding: EdgeInsets.only(top: 5, bottom: 5),
            child: Text(value, style: TextStyle(color: Colors.white))));
  }
}
