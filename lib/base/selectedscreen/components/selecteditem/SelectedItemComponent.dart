
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:trans/base/selectedscreen/components/selecteditem/support/SelectedItemSupport.dart';
import 'package:trans/utils/image/ImageNetworkUtil.dart';

class SelectedItemComConstants {
  static const String SUPPORT = 'support';
  static const String CALLBACK = 'callback';
  static const String UPDATE = 'update';
}

class SelectedItemComponent<T> extends StatefulWidget {
  /// Arguments
  final Map arguments;

  /// Constructor
  SelectedItemComponent({this.arguments});

  @override
  State<StatefulWidget> createState() {
    return SelectedItemState<T>();
  }
}

class SelectedItemState<T> extends State<SelectedItemComponent> {
  /// Support object
  SelectedItemSupport<T> _itemSupport;

  /// Callback
  Function(SelectedItemSupport<T> value) _callback;

//  /// Update stream
//  StreamController<SelectedItemSupport<T>> _updateStream;

  @override
  void initState() {
    super.initState();

    if (widget.arguments.containsKey(SelectedItemComConstants.CALLBACK)) {
      _callback = widget.arguments[SelectedItemComConstants.CALLBACK];
    }
    if (widget.arguments.containsKey(SelectedItemComConstants.SUPPORT)) {
      _itemSupport = widget.arguments[SelectedItemComConstants.SUPPORT];
    }
//    if (widget.arguments.containsKey(SelectedItemComConstants.UPDATE)) {
//      _updateStream = widget.arguments[SelectedItemComConstants.UPDATE];
//      _updateStream.stream.listen((event) {
//        if(_itemSupport.id != event.id){
//          return;
//        }
//        _itemSupport = event;
//        if(!mounted){
//          return;
//        }
//        /// Update UI.
//        setState(() {
//        });
//      });
//    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          if (_callback == null) {
            return;
          }
          _itemSupport.isSelected = !_itemSupport.isSelected;
          _callback(_itemSupport);
          if (!mounted) {
            return;
          }

          /// Update UI.
          setState(() {});
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
            height: 50,
            child: Row(children: <Widget>[
              /// Create avatar and checked.
              _createAvatarCheckedWidget(),
              Expanded(
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          /// Create name
                          _createNameWidget(),

                          /// Create email
                          _createEmailWidget()
                        ],
                      )))
            ])));
  }

  /// Create avatar and checked widget
  Widget _createAvatarCheckedWidget() {
    return Container(
      margin: EdgeInsets.only(left: 20),
      child: Stack(
        children: <Widget>[
          /// Create avatar
          _createAvatarWidget(),

          /// Create checked
          _createCheckedWidget(),
        ],
      ),
    );
  }

  /// Create check widget
  Widget _createCheckedWidget() {
    if (_itemSupport.isSingleChoose || !_itemSupport.isSelected) {
      return Container();
    }
    String path = 'assets/icons/checked_2.png';
    return Container(
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
              bottomLeft: Radius.circular(10.0))),
      width: 30,
      height: 30,
      padding: EdgeInsets.all(8),
      child: Image.asset(path),
    );
  }

  /// Create email widget
  Widget _createEmailWidget() {
    Color color = _itemSupport.emailColor;
    return Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(left: 8),
        child: Text(_itemSupport.getEmailValue(),
            style: TextStyle(fontSize: 12, color: color)));
  }

  /// Create name widget
  Widget _createNameWidget() {
    Color color = _itemSupport.nameColor;
    return Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(left: 8),
        child: Text(_itemSupport.getNameValue(),
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: color)));
  }

  /// Create avatar widget
  Widget _createAvatarWidget() {
    CachedNetworkImage networkImage = ImageNetworkUtil.loadImage(
        _itemSupport.avatar,
        topLeftRadius: 0,
        topRightRadius: 10,
        bottomRightRadius: 10,
        bottomLeftRadius: 10,
        failLink: 'assets/icons/default_user.png',
        decorationFit: BoxFit.cover);
    return Container(width: 30, height: 30, child: networkImage);
  }
}
