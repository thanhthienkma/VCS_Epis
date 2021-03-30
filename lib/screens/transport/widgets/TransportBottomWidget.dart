import 'package:flutter/material.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/screens/transport/TransportScreen.dart';

class TransportBottomWidget extends StatefulWidget {
  final Map mapCallback;

  TransportBottomWidget({this.mapCallback});

  @override
  State<StatefulWidget> createState() => _TransportBottomWidgetState();
}

class _TransportBottomWidgetState extends State<TransportBottomWidget> {
  Color manageColor = Colors.orange;
  Color comingColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          GestureDetector(
              onTap: () {
                setState(() {
                  manageColor = Colors.orange;
                  comingColor = Colors.grey;
                });

                var manageOrderCallback = widget
                    .mapCallback[TransportConstants.MANAGE_ORDER_CALLBACK];
                manageOrderCallback();
              },
              child: Container(
                  margin: marginAll10,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.assignment, size: 18, color: manageColor),
                      Container(
                        margin: marginTop5,
                        child: Text('Quản lí ĐH',
                            style: TextStyle(color: manageColor, fontSize: 12)),
                      ),
                    ],
                  ))),
          GestureDetector(
              onTap: () {
                setState(() {
                  manageColor = Colors.grey;
                  comingColor = Colors.orange;
                });
                var orderCompletedCallback = widget
                    .mapCallback[TransportConstants.ORDER_COMPLETED_CALLBACK];
                orderCompletedCallback();
              },
              child: Container(
                  margin: marginAll10,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.reorder, size: 18, color: comingColor),
                      Container(
                        margin: marginTop5,
                        child: Text('ĐH đã hoàn thành',
                            style: TextStyle(color: comingColor, fontSize: 12)),
                      ),
                    ],
                  ))),
        ],
      ),
    );
  }
}
