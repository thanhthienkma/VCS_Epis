import 'package:flutter/material.dart';
import 'package:trans/components/search/support/SearchSupport.dart';

class SearchComConstants {
  static const String CALLBACK = 'callback';
  static const String SUPPORT = 'support';
}

class SearchComponent extends StatefulWidget {
  /// Arguments
  final Map arguments;

  /// Constructor
  SearchComponent({@required this.arguments});

  @override
  State<StatefulWidget> createState() {
    return SearchState();
  }
}

class SearchState extends State<SearchComponent> {
  
  /// Callback
  Function(String value) _callback;
  /// Support object
  SearchSupport _support;


//
//  FocusNode focusNode = FocusNode();
//
//  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if(widget.arguments.containsKey(SearchComConstants.CALLBACK)){
      _callback = widget.arguments[SearchComConstants.CALLBACK];
    }
    if(widget.arguments.containsKey(SearchComConstants.SUPPORT)){
      _support = widget.arguments[SearchComConstants.SUPPORT];
      _support.controller.addListener(() {
        String value = _support.controller.text;
        if (_callback == null) {
          return;
        }
        _callback(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: _support.height,
        decoration: BoxDecoration(
            color: Color(0xffF7F9FA), borderRadius: BorderRadius.all(Radius.circular(50))),
        child: Row(children: <Widget>[
          Container(
              margin: EdgeInsets.only(left: _support.iconMarginLeft),
              width: _support.iconSize,
              height: _support.iconSize,
              child: Image.asset('assets/icons/search.png', color: Color(0xff406D95))),
          Expanded(
              child: Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: TextField(
                    controller: _support.controller,
                    style: TextStyle(color: _support.textColor, fontSize: _support.textFontSize),
                    textInputAction: TextInputAction.search,
                    focusNode: _support.focusNode,
                    onSubmitted: (String value) {
                      if (_callback == null) {
                        return;
                      }
                      _support.focusNode.unfocus();
                      _callback(value);
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: _support.contentPadding),
                        border: InputBorder.none,
                        hintText: _support.hint,
                        hintStyle: TextStyle(color: _support.hintColor, fontSize: _support.hintFontSize)),
                  )))
        ]));
  }
}
