import 'dart:async';
import 'package:flutter/material.dart';
import 'package:trans/api/local/Package.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/widgets/divider_widget.dart';

class PackageItem extends StatefulWidget {
  final Package item;
  final int index;
  final Function(Package item) deleteCallback;
  final bool hideDeleted;
  final StreamController<Package> itemStream;

  PackageItem(this.item, this.index,
      {this.deleteCallback, this.itemStream, this.hideDeleted = true});

  @override
  State<StatefulWidget> createState() => _PackageItemState();
}

class _PackageItemState extends State<PackageItem> {
  @override
  void initState() {
    super.initState();

    if (widget.itemStream == null) {
      return;
    }

    widget.itemStream.stream.listen((event) {
      if (event == null) {
        return;
      }

      /// Check item deleted
      if (widget.item.categoryId == event.categoryId) {
        widget.item.deleted = event.deleted;
        if (!mounted) {
          return;
        }

        /// Update new data
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.item.deleted == true) {
      return Container();
    }
    return Container(
        margin: marginTop10,
        child: Column(
          children: [
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.index.toString()),
                  Expanded(
                    child: Container(
                      margin: marginLeft10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(widget.item.type),
                          ),
                          Container(
                            child: Text(widget.item.name),
                          ),
                          Container(
                            child: Text('Sô lượng : ${widget.item.amount}'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// Icon delete
                  widget.hideDeleted
                      ? IconButton(
                          onPressed: () {
                            if (widget.deleteCallback == null) {
                              return;
                            }

                            widget.deleteCallback(widget.item);
                          },
                          icon: Icon(Icons.delete_forever, color: primaryColor),
                        )
                      : Container()
                ],
              ),
            ),
            DividerWidget(margin: marginTop10),
          ],
        ));
  }
}
