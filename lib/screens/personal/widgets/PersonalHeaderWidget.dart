import 'package:flutter/material.dart';
import 'package:trans/base/style/BaseStyle.dart';

class PersonalHeaderWidget extends StatefulWidget {
  final String title;
  final Function leftCallback;
  final Function rightCallback;
  final bool isBack;
  final Widget rightWidget;

  PersonalHeaderWidget(
      {this.title,
      this.leftCallback,
      this.rightCallback,
      this.isBack = false,
      this.rightWidget});

  @override
  State<StatefulWidget> createState() => _PersonalHeaderWidgetState();
}

class _PersonalHeaderWidgetState extends State<PersonalHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 5.0,
              spreadRadius: 0.0,
              offset: Offset(1.0, 3.0))
        ],
      ),
      height: 60,
      child: Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          child: Container(margin: marginRight10, child: createRowWidget())),
    );
  }

  Widget createRowWidget() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          /// Back icon
          widget.isBack
              ? IconButton(
                  onPressed: () => widget.leftCallback(),
                  icon: Icon(Icons.arrow_back_ios, size: 18),
                )
              : Container(),

          /// Title
          Text(widget.title,
              style: TextStyle(
                  fontSize: font18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),

          /// Something

          widget.rightWidget == null
              ? Container()
              : InkWell(
                  onTap: () {
                    if (widget.rightCallback == null) {
                      return;
                    }
                    widget.rightCallback();
                  },
                  child: widget.rightWidget)
        ]);
  }
}
