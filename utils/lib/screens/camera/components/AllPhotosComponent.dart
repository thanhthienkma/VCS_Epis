import 'dart:async';
import 'package:flutter/material.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:utils/screens/camera/UtilCameraScreen.dart';
import 'package:utils/screens/camera/components/PhotoComponent.dart';
import 'package:utils/sharecomponent/BottomSheet.dart' as UtilBottomSheet;
import 'package:utils/support/PhotoSupport.dart';

class AllPhotosComponent extends StatefulWidget {
  /// Arguments
  final Map arguments;

  AllPhotosComponent({this.arguments});

  @override
  State<StatefulWidget> createState() {
    return AllPhotosState();
  }
}

class AllPhotosState extends State<AllPhotosComponent> {
  /// With multi photos, limit photo is captured
  int _limit = 10;

  /// All photos
  List<PhotoSupport> _photoSupport = [];

  /// Size of screen
  Size _size;

  /// Photos is selected
  List<PhotoSupport> _photoSupportSelected = [];

  /// Callback data after selecting
  Function(List<PhotoSupport> photos, List<PhotoSupport> selectedPhotos,
      PhotoSupport seletedPhoto) _allCallback;

  /// Update selected bottom when capture image
  StreamController<Map> _initPhotoStream;

  /// Update all
  StreamController<Map> _updateAllStream;

  /// Update list photo is selected for item
  StreamController<List<PhotoSupport>> _updateSelectedStream =
      StreamController.broadcast();

  @override
  void dispose() {
    super.dispose();
    _updateSelectedStream.close();
  }

  @override
  void initState() {
    super.initState();
    _photoSupportSelected.addAll(widget.arguments[UtilCameraConstant.SELECTED]);
    _size = widget.arguments[UtilCameraConstant.SIZE];
    _limit = widget.arguments[UtilCameraConstant.LIMIT];
    _allCallback = widget.arguments[UtilCameraConstant.ALL_CALLBACK];
    _photoSupport.addAll(widget.arguments[UtilCameraConstant.PHOTOS]);
    _initPhotoStream = widget.arguments[UtilCameraConstant.INIT_PHOTOS_STREAM];
    _updateAllStream = widget.arguments[UtilCameraConstant.UPDATE_ALL_STREAM];

    /// Init ui when finishing to load data
    _initPhotoStream.stream.listen((Map value) {
      if(!mounted){
        return;
      }
      setState(() {
        _photoSupportSelected = []..addAll(value[UtilCameraConstant.SELECTED]);
        _photoSupport = []..addAll(value[UtilCameraConstant.PHOTOS]);

        /// Update data for items.
        _updateSelectedStream.sink.add(_photoSupportSelected);
      });
    });

    /// Update ui when capture image
    _updateAllStream.stream.listen((Map value) {
      if(!mounted){
        return;
      }
      setState(() {
        _photoSupportSelected = []..addAll(value[UtilCameraConstant.SELECTED]);
        PhotoSupport newPhoto = value[UtilCameraConstant.NEW];
        _photoSupport.insert(0, newPhoto);

        /// Update data for items.
        _updateSelectedStream.sink.add(_photoSupportSelected);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_photoSupport == null) {
      return Container(height: 1, color: Colors.black);
    }

//    this.autoSwiped = true,
//    this.toggleVisibilityOnTap = false,
//    this.canUserSwipe = true,
//    this.draggableBody = false,

    return UtilBottomSheet.BottomSheet(
//      smoothness: Smoothness.low,
//        toggleVisibilityOnTap:true,
//        draggableBody:true,
        controller: SolidController(),
        heightToHide: 60,
        maxHeight: UtilCameraConstant.BOTTOM_LIST_HEIGHT,
        body: Container(
            color: Colors.black,
            height: UtilCameraConstant.BOTTOM_LIST_HEIGHT,
            child: ListView(
              cacheExtent: 2048,
              scrollDirection: Axis.horizontal,
              children: _photoSupport.map((PhotoSupport value) {
                return _createItemWidget(value);
              }).toList(),
            )),
        headerBar: Container(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            height: 30,
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Text(
                    "All photos",
                    style: TextStyle(color: Colors.white),
                  ),
                )),
                Expanded(
                  child: Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.only(right: 20),
                      child: Text(
                        "Limit $_limit",
                        style: TextStyle(color: Colors.white),
                      )),
                )
              ],
            )));
  }

  /// Create item widget
  Widget _createItemWidget(PhotoSupport item) {
    Map args = Map();
    args[UtilCameraConstant.SIZE] = _size;
    args[UtilCameraConstant.VIEW_MODEL] = item;
    args[UtilCameraConstant.SELECTED] = _photoSupportSelected;
    args[UtilCameraConstant.LIMIT] = _limit;
    args[UtilCameraConstant.UPDATE_ITEM_STREAM] = _updateSelectedStream;

    args[UtilCameraConstant.CALLBACK] = (List<PhotoSupport> listSelected, PhotoSupport value) {
      _photoSupportSelected = []..addAll(listSelected);

      /// Update all items.
      _updateSelectedStream.sink.add(_photoSupportSelected);

      /// Callback to update take photo screen.
      _allCallback(_photoSupport, _photoSupportSelected, value);
    };
    return Container(
        key: Key(item.photo.identifier),
        child:
            PhotoComponent(key: Key(item.photo.identifier), arguments: args));
  }
}
