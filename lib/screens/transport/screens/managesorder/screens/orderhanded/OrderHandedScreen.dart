import 'dart:async';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:trans/base/screen/BaseScreen.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/screens/transport/items/followorder/FollowOrderItem.dart';

class OrderHandedSupport {
  String text;
  bool selected;

  OrderHandedSupport({this.text, this.selected});

  List<OrderHandedSupport> initData() {
    List<OrderHandedSupport> data = List();
    data.add(OrderHandedSupport(text: 'Đã bàn giao cho VCS', selected: false));
    data.add(OrderHandedSupport(
        text: 'Đang xử lí đơn hàng tại Sydney', selected: false));
    data.add(OrderHandedSupport(
        text: 'Đang vận chuyển ra sân bay', selected: false));
    data.add(OrderHandedSupport(text: 'Đang thông quan', selected: false));
    data.add(OrderHandedSupport(
        text: 'Đang xử lí đơn hàng tại kho Việt Nam', selected: false));
    data.add(OrderHandedSupport(
        text: 'Đang giao hàng đến người nhận', selected: false));
    data.add(OrderHandedSupport(
        text: 'Đã giao hàng cho người nhận', selected: false));
    data.add(OrderHandedSupport(text: 'Chờ xác nhận lại', selected: false));
    return data;
  }
}

class OrderHandedScreen extends BaseScreen {
  /// List of orders
  List<OrderHandedSupport> _orders = OrderHandedSupport().initData();

  /// Stream update status of order
  StreamController _updateStream =
      StreamController<OrderHandedSupport>.broadcast();

  @override
  void initState() {
    super.initState();
    /**
     * Update status of order
     */
    _updateStatusOfOrder();
  }

  @override
  void dispose() {
    super.dispose();
    _updateStream.close();
  }

  _updateStatusOfOrder() {
    Socket socket = io('http://localhost:3000');
    socket.on('connect', (_) {
      print('connect');
      socket.emit('msg', 'test');
    });
    socket.on('event', (data) {
      print(data);
      /**
       * Handle receive data
       */
      _handleReceiveData();
    });
    socket.on('disconnect', (_) => print('disconnect'));
    socket.on('fromServer', (_) => print(_));
  }

  _handleReceiveData() {}

  @override
  Widget onInitBody(BuildContext context) {
    return ListView(
      children: <Widget>[
        Card(
          margin: marginAll20,
          elevation: 4,
          child: Column(
            children: _orders.map((element) {
              return FollowOrderItem(element, updateStream: _updateStream,
                  callback: (item) {
//                pushScreen(BaseWidget(screen: Screens.FOLLOW_ORDER),
//                    Screens.FOLLOW_ORDER);
                return;
              });
            }).toList(),
          ),
        ),
      ],
    );
  }
}
