import 'package:flutter/material.dart';
import 'package:trans/api/result/Goods.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/widgets/divider_widget.dart';
import 'package:trans/api/local/Type.dart';

class TypeItem extends StatefulWidget {
  final Function(Result value) callback;
  final Result item;

  TypeItem(this.item, {this.callback});

  @override
  State<StatefulWidget> createState() => _TypeItemState();
}

class _TypeItemState extends State<TypeItem> {
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
                margin: EdgeInsets.only(left: margin10, right: margin10),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            padding: paddingAll15,
                            child: Text(widget.item.name))),

                    /// Selected is true
                    widget.item.selected == false ||
                            widget.item.selected == null
                        ? Icon(Icons.check_circle, color: Colors.grey[300])
                        : Icon(Icons.check_circle, color: Colors.orange),
                  ],
                )),
            DividerWidget(
              color: Colors.grey[300],
            ),
          ],
        ));
  }
}
