import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:trans/base/style/BaseStyle.dart';

class ButtonComponent extends StatefulWidget {
  final String text;
  final Color color;
  final double margin;
  final bool enable;
  final Function onClick;
  final double width;

  ButtonComponent(
      {@required this.text,
      this.color,
      this.enable = true,
      this.onClick,
      this.width,
      this.margin = 20.0});

  @override
  State<StatefulWidget> createState() => _ButtonComponentState();
}

class _ButtonComponentState extends State<ButtonComponent> {
  @override
  Widget build(BuildContext context) {
    return widget.enable
        ? BouncingWidget(
            duration: Duration(milliseconds: 100),
            scaleFactor: 1.0,
            onPressed: () {},
            child: Container(
                margin: EdgeInsets.only(top: widget.margin),
                child: RaisedButton(
                  color: widget.color,
                  onPressed: () {
                    widget.onClick();
                  },
                  elevation: 4,
                  child: Container(
                    alignment: Alignment.center,
                    width: double.maxFinite,
                    padding: paddingAll15,
                    child: Text(
                      widget.text,
                      style: TextStyle(
                          fontSize: font16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )))
        : Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: widget.margin),
            padding: paddingAll15,
            decoration: BoxDecoration(
                color: disableColor,
                boxShadow: [
                  BoxShadow(
                    color: disableColor.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(radius4))),
            child: Text(
              widget.text,
              style: TextStyle(
                  fontSize: font16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          );
  }
}
