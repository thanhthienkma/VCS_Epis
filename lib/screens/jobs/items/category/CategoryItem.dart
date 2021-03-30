import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/api/result/JobCategory.dart';
import 'package:trans/utils/image/ImageNetworkUtil.dart';

class CategoryItem extends StatefulWidget {
  final Data item;
  final Function(Data item) callback;

  final StreamController<Data> filterStream;

  CategoryItem(this.item, {this.callback, this.filterStream});

  @override
  State<StatefulWidget> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  Color background = Colors.white;
  StreamSubscription streamSubscription;

  @override
  void initState() {
    super.initState();
    streamSubscription = widget.filterStream.stream.listen((event) {
      if (event == null) {
        return;
      }

      if (widget.item == event) {
        background = Color.fromARGB(255, 249, 244, 231);
      } else {
        background = Colors.white;
      }

      /// Update background
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
    return GestureDetector(
        onTap: () => widget.callback(widget.item),
        child: Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Column(
            children: <Widget>[
              Container(
                  width: 30,
                  height: 30,
                  margin: EdgeInsets.only(top: 8),
                  child: ImageNetworkUtil.loadImage(widget.item.imageThumb)),
              Container(
                  alignment: Alignment.center,
                  margin: marginTop10,
                  width: 100,
                  child: Text(widget.item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600))),
            ],
          ),
        ));
  }
}
