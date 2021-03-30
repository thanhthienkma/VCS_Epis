import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:utils/model/Photo.dart';
import 'package:utils/screens/selectphotos/components/HeaderComponent.dart';
import 'package:utils/screens/selectphotos/components/PhotoComponent.dart';
import 'package:utils/utils.dart';
import 'package:utils/support/PhotoSupport.dart';

class UtilSelectPhotosConstant {
  static const String LIMIT = 'limit';
  static const String CALLBACK = 'callback';
  static const String VIEW_MODEL = 'view_model';
  static const String SELECTED = 'selected';
  static const String UPDATE_ITEM_STREAM = 'update_item_stream';
  static const String SIZE = 'size';
  static const String IS_ONE_BACK = 'is_one_back';

  static const int HEADER_CANCEL = 0;
  static const int HEADER_SELECTED = 1;
}

class UtilSelectPhotosScreen extends StatefulWidget {
  /// Arguments
  final Map arguments;

  /// Constructor
  UtilSelectPhotosScreen({@required this.arguments});

  @override
  State<StatefulWidget> createState() {
    return UtilSelectPhotosState();
  }
}

class UtilSelectPhotosState extends State<UtilSelectPhotosScreen> {
  /// Photos is selected
  List<PhotoSupport> _photoSupportSelected = [];

  /// Photos
  List<PhotoSupport> _photoSupport = [];

  /// Update list photo is selected for item
  StreamController<List<PhotoSupport>> _updateSelectedStream = StreamController.broadcast();

  /// With multi photos, limit photo is captured
  int _limit;

  /// Screen size.
  Size _size;

  /// Choose one and back
  bool _isOneBack = false;

  @override
  void initState() {
    super.initState();
    _size = widget.arguments[UtilSelectPhotosConstant.SIZE];
    if (widget.arguments.containsKey(UtilSelectPhotosConstant.LIMIT)) {
      _limit = widget.arguments[UtilSelectPhotosConstant.LIMIT];
      if (_limit <= 1) {
        _limit = 1;
      }
    }
    if (widget.arguments.containsKey(UtilSelectPhotosConstant.IS_ONE_BACK)) {
      _isOneBack = widget.arguments[UtilSelectPhotosConstant.IS_ONE_BACK];
    }

    /// Load photos
    Future.delayed(Duration(milliseconds: 200), () {
      _loadPhotos();
    });
//    _loadPhotos();
  }

  @override
  void dispose() {
    super.dispose();
    _updateSelectedStream.close();
  }

  /// Load photos
  void _loadPhotos() async {
    String stringValue = await Utils.getAllPhotos();
    dynamic valueMap = json.decode(stringValue);

    List<Photo> listPhotos = List<Photo>.from(valueMap.map((x) {
      return Photo.fromJson(x);
    }));

    _photoSupport = listPhotos.map((value) {
      PhotoSupport item = PhotoSupport(value);
      for (var data in _photoSupportSelected) {
        if (data.photo == value) {
          item.isSelected = true;
          break;
        }
      }
      return item;
    }).toList();

    if (!mounted) {
      return;
    }

    /// Update UI.
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: onInitAppBar(),
        body: WillPopScope(
            onWillPop: onBackPress,
            child: Container(
                color: Colors.black,
                child: Column(
                  children: <Widget>[_createHeaderWidget(), Expanded(child: _createGridWidget())],
                ))));
  }

  /// Create grid widget
  Widget _createGridWidget() {
    if (_photoSupport == null || _photoSupport.isEmpty) {
      return Container();
    }
    return GridView.count(
      crossAxisCount: 3,
      cacheExtent: 5120,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: _photoSupport.map((value) {
        return _createItemWidget(value);
      }).toList(),
    );
  }

  /// Create header widget
  Widget _createHeaderWidget() {
    Map args = Map();
    args[UtilSelectPhotosConstant.SELECTED] = _photoSupportSelected;
    args[UtilSelectPhotosConstant.LIMIT] = _limit;
    args[UtilSelectPhotosConstant.UPDATE_ITEM_STREAM] = _updateSelectedStream;
    args[UtilSelectPhotosConstant.CALLBACK] = (int status, {List<PhotoSupport> value}) {
      onBackPress();
    };
    return HeaderComponent(arguments: args);
  }

  /// Handle back
  Future<bool> onBackPress() async {
    List<Photo> list = [];
    _photoSupportSelected.forEach((e) => list.add(e.photo));
    Navigator.pop(context, list);
    return false;
  }

  PreferredSize onInitAppBar() {
    /// Default appbar is transparent.
    return PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
        ));
  }

  /// Create item widget
  Widget _createItemWidget(PhotoSupport item) {
    Map args = Map();
    args[UtilSelectPhotosConstant.SIZE] = _size;
    args[UtilSelectPhotosConstant.VIEW_MODEL] = item;
    args[UtilSelectPhotosConstant.SELECTED] = _photoSupportSelected;
    args[UtilSelectPhotosConstant.LIMIT] = _limit;
    args[UtilSelectPhotosConstant.UPDATE_ITEM_STREAM] = _updateSelectedStream;

    args[UtilSelectPhotosConstant.CALLBACK] =
        (List<PhotoSupport> listSelected, PhotoSupport value) {
      _photoSupportSelected = []..addAll(listSelected);
      if (_isOneBack) {
        onBackPress();
      }

      /// Update all items.
      _updateSelectedStream.sink.add(_photoSupportSelected);
    };
    return Container(
        padding: EdgeInsets.all(0),
        key: Key(item.photo.identifier),
        height: 100,
        child: PhotoComponent(key: Key(item.photo.identifier), arguments: args));
  }
}
