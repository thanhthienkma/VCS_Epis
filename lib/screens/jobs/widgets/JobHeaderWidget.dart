import 'package:flutter/material.dart';

class JobHeaderWidget extends StatefulWidget {
  final String title;
  final Function leftCallback;
  final Function rightCallback;
  final Icon rightIcon;

  JobHeaderWidget(this.title,
      {this.leftCallback, this.rightCallback, this.rightIcon});

  @override
  State<StatefulWidget> createState() => _JobHeaderWidgetState();
}

class _JobHeaderWidgetState extends State<JobHeaderWidget> {
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
          elevation: 4,
          child: Row(
            children: <Widget>[
              /// Back icon
              IconButton(
                  icon: Icon(Icons.arrow_back_ios,size: 18),
                  onPressed: () {
                    widget.leftCallback();
                  }),

              Expanded(
                child: Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),

              /// Person icon
              IconButton(
                  icon: widget.rightIcon,
                  onPressed: () {
                    if (widget.rightCallback == null) {
                      return;
                    }
                    widget.rightCallback();
                  }),
            ],
          ),
        ));
  }
}
