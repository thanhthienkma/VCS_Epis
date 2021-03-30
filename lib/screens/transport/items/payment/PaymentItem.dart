import 'package:flutter/material.dart';
import 'package:trans/api/local/Payment.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/widgets/divider_widget.dart';

class PaymentItem extends StatefulWidget {
  final Payment item;
  final Function(Payment item) callback;

  PaymentItem(this.item, {this.callback});

  @override
  State<StatefulWidget> createState() => _PaymentItemState();
}

class _PaymentItemState extends State<PaymentItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          widget.callback(widget.item);
          Navigator.pop(context);
        },
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    Image.asset(widget.item.image, height: 26),
                    Container(
                        padding: paddingAll15, child: Text(widget.item.text))
                  ],
                )),
            DividerWidget(color: Colors.grey[300]),
          ],
        ));
  }
}
