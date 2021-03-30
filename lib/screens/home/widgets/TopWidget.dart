import 'package:flutter/material.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/screens/home/HomeScreen.dart';
import 'package:trans/screens/home/widgets/CommonWidget.dart';

class TopWidget extends StatefulWidget {
  final String leftText;
  final String rightText;
  final String leftPath;
  final String rightPath;
  final String midText;
  final String midPath;
  final Map mapCallback;

  TopWidget(
      {@required this.leftText,
      @required this.rightText,
      @required this.leftPath,
      @required this.rightPath,
      this.midPath,
      this.midText,
      this.mapCallback});

  @override
  State<StatefulWidget> createState() => _TopWidgetState();
}

class _TopWidgetState extends State<TopWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CommonWidget(
            text: widget.leftText,
            imagePath: widget.leftPath,
            onClick: () {
              var transportCallback =
                  widget.mapCallback[HomeConstants.TRANSPORT_CALLBACK];
              transportCallback();
            }),
        CommonWidget(
            text: widget.midText,
            imagePath: widget.midPath,
            color: primaryColor,
            onClick: () {
              var tourCallback =
                  widget.mapCallback[HomeConstants.TOUR_CALLBACK];
              tourCallback();
            }),
        CommonWidget(
            text: widget.rightText,
            imagePath: widget.rightPath,
            color: primaryColor,
            onClick: () {
              var jobCallback = widget.mapCallback[HomeConstants.JOB_CALLBACK];
              jobCallback();
            }),
      ],
    );
  }
}
