import 'package:flutter/material.dart';
import 'package:trans/api/local/Payment.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/screens/transport/TransportScreen.dart';
import 'package:trans/screens/transport/items/payment/PaymentItem.dart';

class NoteWidget extends StatefulWidget {
  final Map mapCallback;
  final TextEditingController textEditingController;
  final String shipText;

  NoteWidget({this.mapCallback, this.shipText, this.textEditingController});

  @override
  State<StatefulWidget> createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
  bool expanded = true;
  List<Payment> payments = List();
  Payment payment;

  @override
  void initState() {
    super.initState();

    /// Get payments
    payments = Payment().getPayments();
    payment = payments[0];

//    if (widget.textEditingController == null) {
//      return;
//    }
  }

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
              Text('Lưu ý - Ghi chú',
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
                    margin: EdgeInsets.only(
                        left: margin15, right: margin15, bottom: margin15),
                    child: Column(
                      children: [
                        /// Note for shipping
                        _createDropdownWidget(
                            'Lưu ý giao hàng', widget.shipText ?? 'Chọn',
                            selectedCallback: () {
                          var shipCallback = widget
                              .mapCallback[TransportConstants.SHIP_CALLBACK];
                          shipCallback();
                        }),

                        /// Create charge widget
                        _createChargeWidget(() {
                          /// Show payment methods
                          showPaymentMethods();
                        }),

                        /// Note for shipper
                        _createItemLongWidget(
                            'Ghi chú', 'Nhập ghi chú giao hàng cho tài xế',
                            textEditingController:
                                widget.textEditingController),
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _createDropdownWidget(String title, String text,
      {Function selectedCallback}) {
    return GestureDetector(
        onTap: () {
          selectedCallback();
        },
        child: Container(
            margin: marginTop10,
            child: Column(
              children: [
                /// Title
                Row(
                  children: [
                    Text(title),
                    Text(
                      '*',
                      style: TextStyle(color: Colors.orange),
                    )
                  ],
                ),

                Container(
                  margin: EdgeInsets.only(top: 5),
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          margin: marginLeft10,
                          child: Text(
                            text,
                            style: TextStyle(color: Colors.black54),
                          )),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }

  Widget _createChargeWidget(Function callback) {
    return Container(
        margin: marginTop15,
        child: Column(
          children: <Widget>[
            Row(children: [
              Text('Phương thức thanh toán'),
              Text('*', style: TextStyle(color: Colors.orange))
            ]),
            GestureDetector(
                onTap: () {
                  callback();
                },
                child: Container(
                  margin: marginTop5,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          margin: marginLeft10,
                          child: Text(payment.text,
                              style: TextStyle(color: Colors.black54))),
                      Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                    ],
                  ),
                )),
          ],
        ));
  }

  Widget _createItemLongWidget(String title, String content,
      {TextEditingController textEditingController}) {
    return Container(
        margin: marginTop15,
        child: Column(
          children: [
            /// Title
            Row(
              children: [
                Text(title),
                Text(
                  '*',
                  style: TextStyle(color: Colors.orange),
                )
              ],
            ),

            /// Box
            Container(
                margin: marginTop5,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.all(Radius.circular(16))),
                child: TextField(
                    controller: textEditingController,
                    style: TextStyle(fontSize: font14),
                    maxLines: 5,
                    onChanged: (String text) {},
                    decoration: InputDecoration(
                      hintText: content,
                      contentPadding: EdgeInsets.only(top: 10, left: margin10),
                      border: InputBorder.none,
                    )))
          ],
        ));
  }

  void showPaymentMethods() async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
              height: 200,
              child: ListView.builder(
                  itemCount: payments.length,
                  itemBuilder: (BuildContext context, int index) {
                    return PaymentItem(payments[index],
                        callback: (Payment item) {
                      if (!mounted) {
                        return;
                      }

                      /// Update new data
                      setState(() {
                        payment = item;
                      });
                      var paymentCallback = widget
                          .mapCallback[TransportConstants.PAYMENT_CALLBACK];
                      paymentCallback(payment);
                    });
                  }));
        });
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
