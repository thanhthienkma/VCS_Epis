import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:trans/base/style/BaseStyle.dart';

class TypeWidget extends StatefulWidget {
  final String title;
  final String imagePath;
  final Function() callback;
  final Color color;

  TypeWidget({this.title, this.imagePath, this.color, this.callback});

  @override
  State<StatefulWidget> createState() => _TypeWidgetState();
}

class _TypeWidgetState extends State<TypeWidget> {
  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
        onPressed: () => widget.callback(),
        child: Container(
//            padding: paddingAll10,
            child: Column(
          children: <Widget>[
            /// Image path
            Container(
                child: Image.asset(widget.imagePath,
                    height: size28, width: size28, color: widget.color)),

            /// Title
            Container(margin: marginTop5, child: Text(widget.title)),
          ],
        )));
  }
}
