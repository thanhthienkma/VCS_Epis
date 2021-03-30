import 'package:flutter/material.dart';
import 'package:trans/base/style/BaseStyle.dart';

class VCSLogoComponent extends StatefulWidget {
  final String title;
  final bool backIcon;
  final Function callback;

  VCSLogoComponent({this.backIcon = false, this.title = '', this.callback});

  @override
  State<StatefulWidget> createState() => _VCSLogoComponentState();
}

class _VCSLogoComponentState extends State<VCSLogoComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        widget.backIcon
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, size: 18),
                    onPressed: () {
                      widget.callback();
                    },
                  ),
                  Expanded(
                      child: Image.asset('assets/images/deco_logo.png',
                          height: vcsLogoSize)),
                  Container(margin: marginRight20),
                ],
              )
            : Image.asset('assets/images/deco_logo.png', height: vcsLogoSize),
        Text(widget.title, style: vcsNameStyle)
      ],
    ));
  }
}

double vcsLogoSize = 100;
TextStyle vcsNameStyle = TextStyle(fontSize: font18, color: Color(0xff1B1D26));
