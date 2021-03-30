import 'package:flutter/material.dart';
import 'package:trans/base/style/BaseStyle.dart';

class SearchTransportWidget extends StatefulWidget {
  final Function(String value) callback;

  SearchTransportWidget({this.callback});

  @override
  State<StatefulWidget> createState() => _SearchTransportWidgetState();
}

class _SearchTransportWidgetState extends State<SearchTransportWidget> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(() {
      String value = _textEditingController.text;
      if (widget.callback == null) {
        return;
      }
      widget.callback(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: margin10, left: margin10, right: margin10),
      decoration: BoxDecoration(
          color: colorGray,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Row(
        children: <Widget>[
          Container(
            margin: marginLeft10,
            child: Icon(Icons.search),
          ),

          /// Phone number
          Expanded(
              child: TextField(
                  controller: _textEditingController,
                  maxLines: 1,
                  onChanged: (String text) {
                    widget.callback(text);
                  },
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm',
                    contentPadding: paddingLeft10,
                    border: InputBorder.none,
                  ))),
        ],
      ),
    );
  }
}
