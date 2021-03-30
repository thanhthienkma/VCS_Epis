import 'package:flutter/material.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/screens/home/HomeScreen.dart';
import 'package:trans/screens/home/widgets/CommonWidget.dart';

class IOSWidget extends StatefulWidget {
  final String leftText;
  final String rightText;
  final String leftPath;
  final String rightPath;
  final String midText;
  final String midPath;
  final Map mapCallback;

  IOSWidget(
      {@required this.leftText,
      @required this.rightText,
      @required this.leftPath,
      @required this.rightPath,
      this.midText,
      this.midPath,
      this.mapCallback});

  @override
  State<StatefulWidget> createState() => _IOSWidgetState();
}

class _IOSWidgetState extends State<IOSWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CommonWidget(
            text: widget.leftText,
            imagePath: widget.leftPath,
            color: primaryColor,
            onClick: () {
              var jobCallback = widget.mapCallback[HomeConstants.JOB_CALLBACK];
              jobCallback();
            }),
        CommonWidget(
            text: widget.midText,
            imagePath: widget.midPath,
            color: primaryColor,
            onClick: () {
              var earnCallback =
                  widget.mapCallback[HomeConstants.EARN_MONEY_CALLBACK];
              earnCallback();
            }),
        CommonWidget(
            text: widget.rightText,
            imagePath: widget.rightPath,
            onClick: () {
              var shoppingCallback =
                  widget.mapCallback[HomeConstants.SHOPPING_CALLBACK];
              shoppingCallback();
            }),
      ],
    );
  }
}
