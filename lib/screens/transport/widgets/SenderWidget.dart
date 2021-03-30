import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trans/api/local/SenderAddress.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/screens/transport/TransportScreen.dart';
import 'package:trans/widgets/divider_widget.dart';

class SenderWidget extends StatefulWidget {
  final SenderAddress senderAddress;
  final bool checkValue;
  final Map mapCallback;

  SenderWidget(this.checkValue, {this.mapCallback, this.senderAddress});

  @override
  State<StatefulWidget> createState() => _SenderWidgetState();
}

class _SenderWidgetState extends State<SenderWidget> {
  bool expanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: paddingAll20,
      child: Column(
        children: [
          /// Collapse
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Bên gửi',
                  style: TextStyle(
                      color: Colors.orange,
                      fontSize: font16,
                      fontWeight: FontWeight.bold)),
              GestureDetector(
                  onTap: () {
                    /// Handle collapse
                    handleCollapse();
                  },
                  child: Row(
                    children: [
                      expanded ? Text('Thu gọn') : Text('Mở rộng'),
                      expanded
                          ? Icon(Icons.keyboard_arrow_up)
                          : Icon(Icons.keyboard_arrow_down),
                    ],
                  )),
            ],
          ),

          expanded
              ?

              /// Info
              Card(
                  margin: EdgeInsets.zero,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Container(
                    padding: paddingAll15,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text('Địa chỉ lấy'),
                                Text('*',
                                    style: TextStyle(color: Colors.orange))
                              ],
                            ),

                            /// Drop it at ware house.
                            Row(
                              children: <Widget>[
                                Checkbox(
                                  value: widget.checkValue,
                                  checkColor: Colors.white,
                                  activeColor: Colors.orange,
                                  onChanged: (bool value) {
                                    var dropCallback = widget.mapCallback[
                                        TransportConstants.WAREHOUSE_CALLBACK];
                                    dropCallback(value);
                                  },
                                ),
                                Text('Gửi hàng tại ware house'),
                              ],
                            ),
                          ],
                        ),
                        widget.senderAddress == null
                            ? Container()
                            : Container(
                                alignment: Alignment.centerLeft,
                                margin: marginTop5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(widget.senderAddress.name,
                                        style: TextStyle(
                                            color: Color(0xff4A667C))),
                                    Text(widget.senderAddress.phone,
                                        style: TextStyle(
                                            color: Color(0xff4A667C))),
                                    Text(
                                        'Địa chỉ gửi : ${widget.senderAddress.address}',
                                        style: TextStyle(
                                            color: Color(0xff4A667C))),
                                    Text(
                                        'Hàng gửi tại : ${widget.senderAddress.result.address ?? ''} ',
                                        style: TextStyle(
                                            color: Color(0xff4A667C))),
                                  ],
                                )),
                        DividerWidget(margin: marginTop10),
                        InkWell(
                            onTap: () {
                              var updateAddressCallback = widget.mapCallback[
                                  TransportConstants.UPDATE_ADDRESS_CALLBACK];
                              updateAddressCallback();
                            },
                            child: Container(
                                margin: marginTop10,
                                child: Row(
                                  children: [
                                    Icon(Icons.add_circle),
                                    Container(
                                      margin: EdgeInsets.only(left: margin10),
                                      child: Text('Cập nhật địa chỉ lấy'),
                                    ),
                                  ],
                                ))),
                      ],
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  void handleCollapse() {
    if (expanded) {
      expanded = false;
    } else {
      expanded = true;
    }

    setState(() {});
  }
}
