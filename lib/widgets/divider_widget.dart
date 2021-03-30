import 'package:flutter/material.dart';
import 'package:trans/base/style/BaseStyle.dart';

class DividerWidget extends StatelessWidget {
  final EdgeInsetsGeometry margin;
  final Color color;

  DividerWidget({this.margin, this.color = Colors.grey});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: margin, child: Divider(color: color, height: double0));
  }
}
