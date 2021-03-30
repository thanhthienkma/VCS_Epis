import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trans/api/result/WareHouse.dart' as wh;
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/components/button/ButtonComponent.dart';
import 'package:trans/screens/transport/TransportScreen.dart';
import 'package:trans/screens/transport/items/warehouse/WareHouseItem.dart';

class WareHouseWidget extends StatefulWidget {
  final Map mapCallback;

  WareHouseWidget({this.mapCallback});

  @override
  State<StatefulWidget> createState() => _WareHouseWidgetState();
}

class _WareHouseWidgetState extends State<WareHouseWidget> {
  bool loading = false;
  bool enable = false;
  List<wh.Result> list = List();
  StreamController selectedStream = StreamController<wh.Result>.broadcast();
  wh.Result tracking;

  @override
  void initState() {
    super.initState();
    /**
     *  Get ware houses
     */
    getWareHouses();

    /**
     * Listen stream
     */
    listenerStream();
  }

  @override
  void dispose() {
    super.dispose();
    selectedStream.close();
  }

  listenerStream() {
    selectedStream.stream.listen((event) {
      if (event == null) {
        return;
      }
      this.enable = true;
      if (!mounted) {
        return;
      }

      /// Update enable status
      setState(() {});
    });
  }

  getWareHouses() async {
    try {
      Response response =
          await Dio().get('https://vanchuyen.etado.vn/api/v1/warehouses');
      print(response);
      final data = response.data['data']['result'];
      print(data);
      for (var item in data) {
        wh.Result obj = wh.Result.fromJson(item);
        list.add(obj);
      }
    } catch (e) {
      print(e);
    }
    loading = true;

    /// Update new data
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets padding = MediaQuery.of(context).padding;

    return Column(
      children: <Widget>[
        Container(
          height: 50,
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(margin: marginLeft10),

              Text('Chọn điểm giao nhận',
                  style: TextStyle(
                      color: Colors.orange,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),

              /// Title
              InkWell(
                onTap: () {
                  var dismissCallback =
                      widget.mapCallback[TransportConstants.DISMISS_CALLBACK];
                  dismissCallback(false);
                  Navigator.pop(context);
                },
                child: Text('Đóng'),
              ),
            ],
          ),
        ),

        /// Ware houses widget
        Expanded(
            child: Container(
                child: !loading
                    ? SpinKitCircle(color: Colors.orange, size: 35)
                    : ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (BuildContext context, int index) {
                          return WareHouseItem(list[index],
                              selectedStream: this.selectedStream,
                              callback: (wh.Result item) {
                            tracking = item;
                            selectedStream.sink.add(item);
                          });
                        }))),

        /// Confirm button
        Container(
            padding: EdgeInsets.only(bottom: padding.bottom / 2),
            child: ButtonComponent(
              text: 'Xác nhận',
              margin: 0,
              enable: this.enable,
              color: Colors.orange,
              onClick: () {
                var warehouseCallback =
                    widget.mapCallback[TransportConstants.WARE_HOUSE_CALLBACK];
                warehouseCallback(tracking);

                Navigator.pop(context);
              },
            ))
      ],
    );
  }
}
