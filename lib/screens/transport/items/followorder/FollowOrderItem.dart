import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/screens/transport/screens/managesorder/screens/orderhanded/OrderHandedScreen.dart';
import 'package:trans/widgets/divider_widget.dart';

class FollowOrderItem extends StatefulWidget {
  final StreamController<OrderHandedSupport> updateStream;
  final OrderHandedSupport item;
  final Function(OrderHandedSupport item) callback;

  FollowOrderItem(this.item, {this.updateStream, this.callback});

  @override
  State<StatefulWidget> createState() => _FollowOrderItemState();
}

class _FollowOrderItemState extends State<FollowOrderItem> {
  StreamSubscription<OrderHandedSupport> streamSubscription;

  @override
  void initState() {
    super.initState();
    streamSubscription = widget.updateStream.stream.listen((order) {
      if (order == null) {
        return;
      }
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
        child: Container(
            padding: EdgeInsets.only(top: 15, left: 15, right: 15),
            child: Column(
              children: <Widget>[
                widget.item.selected
                    ? Container(
                        child: Row(children: <Widget>[
                        Expanded(
                            child: Text(widget.item.text,
                                style: TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold))),
                        Text('0 ĐH',
                            style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold)),
                      ]))
                    : Container(
                        child: Row(children: <Widget>[
                        Expanded(
                            child: Text(widget.item.text,
                                style: TextStyle(
                                    color: Color(0xff4A667C),
                                    fontWeight: FontWeight.bold))),
                        Text('0 ĐH',
                            style: TextStyle(
                                color: Color(0xff4A667C),
                                fontWeight: FontWeight.bold)),
                      ])),
                DividerWidget(margin: marginTop15),
              ],
            )));
  }
}
