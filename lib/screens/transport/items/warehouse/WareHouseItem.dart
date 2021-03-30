import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trans/api/result/WareHouse.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/widgets/divider_widget.dart';

class WareHouseItem extends StatefulWidget {
  final Result item;
  final StreamController<Result> selectedStream;
  final Function(Result item) callback;

  WareHouseItem(this.item, {this.callback, this.selectedStream});

  @override
  State<StatefulWidget> createState() => _WareHouseItemState();
}

class _WareHouseItemState extends State<WareHouseItem> {
  StreamSubscription<Result> streamSubscription;

  Color backgroundColor = Colors.white;

  @override
  void initState() {
    super.initState();
    streamSubscription = widget.selectedStream.stream.listen((event) {
      if (event == null) {
        return;
      }

      if (event == widget.item) {
        backgroundColor = Colors.grey[200];
      } else {
        backgroundColor = Colors.white;
      }

      /// Update background color
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    streamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          widget.callback(widget.item);
        },
        child: Column(
          children: <Widget>[
            Container(
                color: backgroundColor,
                padding: paddingAll10,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.pin_drop, color: Colors.orange),
                    Expanded(
                        child: Container(
                            margin: marginLeft10,
                            child: Text(widget.item.address))),
                  ],
                )),
            DividerWidget(color: Colors.orange),
          ],
        ));
  }
}
