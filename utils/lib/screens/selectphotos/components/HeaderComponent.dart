import 'dart:async';

import 'package:flutter/material.dart';
import 'package:utils/screens/selectphotos/UtilSelectPhotosScreen.dart';
import 'package:utils/support/PhotoSupport.dart';

class HeaderComponent extends StatefulWidget {
  /// Arguments
  final Map arguments;

  /// Constructor
  HeaderComponent({Key key, @required this.arguments}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HeaderState();
  }
}

class HeaderState extends State<HeaderComponent> {
  /// Photos is selected
  List<PhotoSupport> _photoVMsSelected;

  /// Limit picture is selected
  int _limit;

  /// Update list photo is selected for item
  StreamController<List<PhotoSupport>> _updateSelectedStream;

  /// Call data to UtilSelectedPhotoScreen
  Function(int status, {List<PhotoSupport> value}) _callback;

  @override
  void initState() {
    super.initState();
    _limit = widget.arguments[UtilSelectPhotosConstant.LIMIT];
    _photoVMsSelected = widget.arguments[UtilSelectPhotosConstant.SELECTED];
    _updateSelectedStream = widget.arguments[UtilSelectPhotosConstant.UPDATE_ITEM_STREAM];
    _callback = widget.arguments[UtilSelectPhotosConstant.CALLBACK];
    _updateSelectedStream.stream.listen((List<PhotoSupport> value) {
      this._photoVMsSelected = []..addAll(value);
      if (!mounted) {
        return;
      }

      /// Update UI
      setState(() {});
    });
  }

  /// Create UI.
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 90,
        child: Column(children: <Widget>[
          _createHeaderWidget(),
          _createLimitSelectedWidget()
        ]));
  }

  /// Create header widget
  Widget _createHeaderWidget(){
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(top: 20, left: 20),
      child: Text('All photos',
          textAlign: TextAlign.left,
          style: TextStyle(color: Colors.white, fontSize: 20)),
    );
  }

  /// Create limit and selected widget
  Widget _createLimitSelectedWidget(){
    String value;
    if (_photoVMsSelected == null || _photoVMsSelected.isEmpty) {
      value = 'Cancel';
    } else {
      value = 'Selected(${_photoVMsSelected.length})';
    }

    return Row(
      children: <Widget>[
        Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
              child: Text('Limit $_limit',
                  style: TextStyle(color: Colors.white)),
            )),
        InkWell(
            onTap: () {
              if (_callback == null) {
                return;
              }
              if (_photoVMsSelected == null ||
                  _photoVMsSelected.isEmpty) {
                _callback(UtilSelectPhotosConstant.HEADER_CANCEL);
              } else {
                _callback(UtilSelectPhotosConstant.HEADER_SELECTED, value: _photoVMsSelected);
              }
            },
            child: Container(
              padding: EdgeInsets.only(
                  right: 20, top: 10, bottom: 10, left: 10),
              child: Text(value, style: TextStyle(color: Colors.white)),
            ))
      ],
    );
  }
}
