import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trans/components/header/support/HeaderSupport.dart';

class HeaderComConstant {
  static const String SUPPORT = 'support';
  static const String UPDATE = 'update';
  static const String BACKGROUND_COLOR = 'background_color';
  static const String TEXT_COLOR = 'text_color';
  static const String BACK_ICON = 'back_icon';
  static const String IS_SHADOW = 'is_shadow';
  static const String TITLE = 'title';
  static const String LEFT_CALLBACK = 'left_callback';
  static const String RIGHT_CALLBACK = 'right_callback';
  static const String RIGHT_ICON = 'right_icon';
  static const String SHOW_RIGHT_ICON = 'show_right_icon';
}

class HeaderComponent extends StatefulWidget {
  /// Arguments
  final Map arguments;

  /// Constructor
  HeaderComponent({@required this.arguments});

  @override
  State<StatefulWidget> createState() {
    return HeaderState();
  }
}

class HeaderState extends State<HeaderComponent> {
  /// Callback when pressing icon
  Function() _leftCallback;

  /// Right callback when pressing icon
  Function() _rightCallback;

  /// Support object
  HeaderSupport _headerSupport;

  /// Update stream
  StreamController<HeaderSupport> _updatestream;

  @override
  void initState() {
    super.initState();
    if (widget.arguments.containsKey(HeaderComConstant.RIGHT_CALLBACK)) {
      _rightCallback = widget.arguments[HeaderComConstant.RIGHT_CALLBACK];
    }
    if (widget.arguments.containsKey(HeaderComConstant.LEFT_CALLBACK)) {
      _leftCallback = widget.arguments[HeaderComConstant.LEFT_CALLBACK];
    }

    if (widget.arguments.containsKey(HeaderComConstant.SUPPORT)) {
      _headerSupport = widget.arguments[HeaderComConstant.SUPPORT];
    }

    if (widget.arguments.containsKey(HeaderComConstant.UPDATE)) {
      _updatestream = widget.arguments[HeaderComConstant.UPDATE];
      _updatestream.stream.listen((event) {
        _headerSupport = event;
        if (!mounted) {
          return;
        }

        /// Update UI
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _headerSupport.isShadow
            ? Card(
                color: _headerSupport.backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
                margin: EdgeInsets.only(top: 60),
                elevation: 5,
                child: Container(height: 5),
              )
            : Container(),
        Container(
            alignment: Alignment.center,
            color: _headerSupport.backgroundColor,
            height: 60,
            child: Row(
              children: <Widget>[
                /// Back
                _createBackWidget(),

                /// Title
                _createTitleWidget(),

                /// Right
                _createRightWidget(),
              ],
            ))
      ],
    );
  }

  /// Create title widget
  Widget _createTitleWidget() {
    return Expanded(
        child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 10),
            child: Text(_headerSupport.title,
                style: TextStyle(
                    color: _headerSupport.textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600))));
  }

  /// Create right widget
  Widget _createRightWidget() {
    if (!_headerSupport.isShowRightIcon) {
      return Container(
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.all(10),
          width: 40,
          height: 40);
    }

    String path = _headerSupport.rightIconPath;
    Image image;
    if (path == null || path == '') {
      return Container(
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.all(10),
          width: 40,
          height: 40);
    }

    if (path.startsWith('assets')) {
      image = Image.asset(path, width: 24, height: 24);
    } else {
      image = Image.asset(path,
          width: 24, height: 24, color: _headerSupport.rightIconColor);
    }
    return InkWell(
        onTap: () {
          if (_rightCallback == null) {
            return;
          }
          _rightCallback();
        },
        splashColor: Colors.transparent,
        child: Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.all(10),
            width: 40,
            height: 40,
            child: image));
  }

  /// Create back widget
  Widget _createBackWidget() {
    String path = _headerSupport.leftIconPath;
    Image image;
    if (path == null || path == '') {
      image = Image.asset('assets/images/back.png', width: 24, height: 24);
    } else {
      image = Image.asset(path, width: 24, height: 24);
    }
    return InkWell(
        onTap: () {
          if (_leftCallback == null) {
            return;
          }
          _leftCallback();
        },
        splashColor: Colors.transparent,
        child: Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.all(10),
            width: 40,
            height: 40,
            child: image));
  }
}
