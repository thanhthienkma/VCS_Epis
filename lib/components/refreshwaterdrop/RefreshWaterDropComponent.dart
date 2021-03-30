import 'dart:async';
import 'package:flutter/material.dart'
    hide RefreshIndicatorState, RefreshIndicator;
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trans/extension/StringExtension.dart';

/// QQ ios refresh  header effect
class RefreshWaterDropComponent extends RefreshIndicator {
  /// refreshing content
  final Widget refresh;

  /// complete content
  final Widget complete;

  /// failed content
  final Widget failed;



  final Map stylesColor;
  final Map strings;

  const RefreshWaterDropComponent({
    Key key,
    this.stylesColor,
    this.strings,
    this.refresh,
    this.complete,
    Duration completeDuration: const Duration(milliseconds: 600),
    this.failed,
//    this.waterDropColor: Colors.grey,
  }) : super(
            key: key,
            height: 60.0,
            completeDuration: completeDuration,
            refreshStyle: RefreshStyle.UnFollow);

  @override
  State<StatefulWidget> createState() {
    return _RefreshWaterDropState();
  }
}

class _RefreshWaterDropState
    extends RefreshIndicatorState<RefreshWaterDropComponent>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  AnimationController _dismissCtl;

  @override
  void onOffsetChange(double offset) {
    final double realOffset =
        offset - 44.0; //55.0 mean circleHeight(24) + originH (20) in Painter
    // when readyTorefresh
    if (!_animationController.isAnimating)
      _animationController.value = realOffset;
  }

  @override
  Future<void> readyToRefresh() {
    _dismissCtl.animateTo(0.0);
    return _animationController.animateTo(0.0);
  }

  @override
  void initState() {
    _dismissCtl = AnimationController(
        vsync: this, duration: Duration(milliseconds: 400), value: 1.0);
    _animationController = AnimationController(
        vsync: this,
        lowerBound: 0.0,
        upperBound: 50.0,
        duration: Duration(milliseconds: 400));
    super.initState();
  }

  @override
  bool needReverseAll() {
    return false;
  }

  @override
  Widget buildContent(BuildContext context, RefreshStatus mode) {
    Widget child;
    if (mode == RefreshStatus.refreshing) {
      String loadingString = widget.stylesColor['loading_color'];
      Color loadingColor = loadingString.toColorObj(defaultColor: Color(0xffDB0000));

      child = widget.refresh ??
          SizedBox(
            width: 25.0,
            height: 25.0,
            child: SpinKitFadingCube(color: loadingColor, size: 25),
          );
    } else if (mode == RefreshStatus.completed) {

      String completeString = widget.stylesColor['complete_color'];
      Color completeColor = completeString.toColorObj(defaultColor: Color(0xffDB0000));

      String loadCompletedText = widget.strings['load_completed_text'];
      if(loadCompletedText == null || loadCompletedText == ''){
        loadCompletedText = 'Load completed';
      }

      child = widget.complete ??
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.done,
                color: completeColor,
              ),
              Container(
                width: 15.0,
              ),
              Text(
                loadCompletedText,
                style: TextStyle(color: completeColor),
              )
            ],
          );
      Container();
    } else if (mode == RefreshStatus.failed) {
      String failString = widget.stylesColor['fail_color'];
      Color failColor = failString.toColorObj(defaultColor: Color(0xffDB0000));

      String loadFailedText = widget.strings['load_failed_text'];
      if(loadFailedText == null || loadFailedText == ''){
        loadFailedText = 'Load failed';
      }

      child = widget.failed ??
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.close,
                color: failColor,
              ),
              Container(
                width: 15.0,
              ),
              Text(
                  loadFailedText,
                  style: TextStyle(color: failColor))
            ],
          );
    } else if (mode == RefreshStatus.idle || mode == RefreshStatus.canRefresh) {
      String waterDropString = widget.stylesColor['water_drop_color'];
      Color waterDropColor =
          waterDropString.toColorObj(defaultColor: Color(0xffDB0000));

      String idleIconString = widget.stylesColor['idle_icon_color'];
      Color idleIconColor = idleIconString.toColorObj(defaultColor: Color(0xffFFFFFF));
      Widget idleIcon = Icon(
        Icons.autorenew,
        size: 15,
        color: idleIconColor,
      );

      return FadeTransition(
          child: Container(
            child: Stack(
              children: <Widget>[
                RotatedBox(
                  child: CustomPaint(
                    child: Container(
                      height: 60.0,
                    ),
                    painter: _QqPainter(
                      color: waterDropColor,
                      listener: _animationController,
                    ),
                  ),
                  quarterTurns:
                      Scrollable.of(context).axisDirection == AxisDirection.up
                          ? 10
                          : 0,
                ),
                Container(
                  alignment:
                      Scrollable.of(context).axisDirection == AxisDirection.up
                          ? Alignment.bottomCenter
                          : Alignment.topCenter,
                  margin:
                      Scrollable.of(context).axisDirection == AxisDirection.up
                          ? EdgeInsets.only(bottom: 12.0)
                          : EdgeInsets.only(top: 12.0),
                  child: idleIcon,
                )
              ],
            ),
            height: 60.0,
          ),
          opacity: _dismissCtl);
    }
    return Container(
      height: 60.0,
      child: Center(
        child: child,
      ),
    );
  }

  Color getColor(String strColor) {
    Color result;
    if (strColor == null) {
      result = Color(0xffDB0000);
    } else {
      result = strColor.toColorObj();
      if (result == null) {
        result = Color(0xffDB0000);
      }
    }
    return result;
  }

  @override
  void resetValue() {
    _animationController.reset();
    _dismissCtl.value = 1.0;
  }

  @override
  void dispose() {
    _dismissCtl.dispose();
    _animationController.dispose();
    super.dispose();
  }
}

class _QqPainter extends CustomPainter {
  final Color color;
  final Animation<double> listener;

  double get value => listener.value;
  final Paint painter = Paint();

  _QqPainter({this.color, this.listener}) : super(repaint: listener);

  @override
  void paint(Canvas canvas, Size size) {
    final double originH = 20.0;
    final double middleW = size.width / 2;

    final double circleSize = 12.0;

    final double scaleRatio = 0.1;

    final double offset = value;

    painter.color = color;
    canvas.drawCircle(Offset(middleW, originH), circleSize, painter);
    Path path = Path();
    path.moveTo(middleW - circleSize, originH);

    //drawleft
    path.cubicTo(
        middleW - circleSize,
        originH,
        middleW - circleSize + value * scaleRatio,
        originH + offset / 5,
        middleW - circleSize + value * scaleRatio * 2,
        originH + offset);
    path.lineTo(
        middleW + circleSize - value * scaleRatio * 2, originH + offset);
    //draw right
    path.cubicTo(
        middleW + circleSize - value * scaleRatio * 2,
        originH + offset,
        middleW + circleSize - value * scaleRatio,
        originH + offset / 5,
        middleW + circleSize,
        originH);
    //draw upper circle
    path.moveTo(middleW - circleSize, originH);
    path.arcToPoint(Offset(middleW + circleSize, originH),
        radius: Radius.circular(circleSize));

    //draw lowwer circle
    path.moveTo(
        middleW + circleSize - value * scaleRatio * 2, originH + offset);
    path.arcToPoint(
        Offset(middleW - circleSize + value * scaleRatio * 2, originH + offset),
        radius: Radius.circular(value * scaleRatio));
    path.close();
    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return oldDelegate != this;
  }
}
