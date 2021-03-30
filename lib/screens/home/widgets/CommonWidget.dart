import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';

class CommonWidget extends StatefulWidget {
  final Function onClick;
  final String imagePath;
  final String text;
  final Color color;

  CommonWidget({this.onClick, this.imagePath, this.text, this.color});

  @override
  State<StatefulWidget> createState() => _CommonWidgetState();
}

class _CommonWidgetState extends State<CommonWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: InkWell(
            onTap: () {
              widget.onClick();
            },
            child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(widget.imagePath,
                        height: 24, color: widget.color),
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      child: Text(
                        widget.text,
                        style: TextStyle(
                            color: Color.fromARGB(255, 74, 85, 134),
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ))));
  }
}
