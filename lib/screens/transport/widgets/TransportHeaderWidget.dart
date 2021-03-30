import 'package:flutter/material.dart';
import 'package:trans/base/style/BaseStyle.dart';

class TransportHeaderWidget extends StatefulWidget {
  final String title;
  final Function leftCallback;
  final Function rightCallback;
  final Icon rightIcon;
  final TextAlign textAlign;

  TransportHeaderWidget(this.title,
      {this.leftCallback,
      this.rightCallback,
      this.rightIcon,
      this.textAlign = TextAlign.left});

  @override
  State<StatefulWidget> createState() => _TransportHeaderWidgetState();
}

class _TransportHeaderWidgetState extends State<TransportHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        child: Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          elevation: 4,
          child: Row(
            children: <Widget>[
              /// Back icon
              IconButton(
                  icon: Icon(Icons.arrow_back_ios, size: 18),
                  onPressed: () {
                    widget.leftCallback();
                  }),

              Expanded(
                child: Text(
                  widget.title,
                  textAlign: widget.textAlign,
                  style: TextStyle(
                    fontSize: font16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              widget.rightIcon == null
                  ? Icon(Icons.list, color: Colors.transparent)
                  : Stack(
                      children: <Widget>[
                        IconButton(
                            icon: widget.rightIcon,
                            onPressed: () {
                              if (widget.rightCallback == null) {
                                return;
                              }
                              widget.rightCallback();
                            }),
                        Positioned(
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(1),
                            margin: marginRight10,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10)),
                            constraints:
                                BoxConstraints(minWidth: 13, minHeight: 13),
                            child: Text('0',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10),
                                textAlign: TextAlign.center),
                          ),
                        )
                      ],
                    ),
            ],
          ),
        ));
  }
}
