import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:utils/screens/selectphotos/UtilSelectPhotosScreen.dart';
import 'package:utils/utils.dart';
import 'package:utils/support/PhotoSupport.dart';

class PhotoComponent extends StatefulWidget {
  /// Arguments
  final Map arguments;
  /// Constructor
  PhotoComponent({Key key, @required this.arguments}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PhotoState();
  }
}

class PhotoState extends State<PhotoComponent> {
  /// Current photo
  PhotoSupport _photoVM;
  /// Photos is selected
  List<PhotoSupport> _photoVMsSelected;
  /// Limit picture is selected
  int _limit;
  /// Call data to UtilSelectedPhotoScreen
  Function(List<PhotoSupport> listSelected, PhotoSupport value) _callback;
  /// Data to display photo
  ByteData _thumbData;
  /// Screen size.
  Size _size;
  /// Update list photo is selected for item
  StreamController<List<PhotoSupport>> _updateSelectedStream;

  @override
  void initState() {
    super.initState();
    print("PhotoState is calling");
    _size = widget.arguments[UtilSelectPhotosConstant.SIZE];
    _callback = widget.arguments[UtilSelectPhotosConstant.CALLBACK];
    _photoVM = widget.arguments[UtilSelectPhotosConstant.VIEW_MODEL];
    _limit = widget.arguments[UtilSelectPhotosConstant.LIMIT];
    _photoVMsSelected = widget.arguments[UtilSelectPhotosConstant.SELECTED];
    _updateSelectedStream = widget.arguments[UtilSelectPhotosConstant.UPDATE_ITEM_STREAM];
    _updateSelectedStream.stream.listen((List<PhotoSupport> value) {
      this._photoVMsSelected = []..addAll(value);
    });

    /// Load thumb
    Future.delayed(Duration(milliseconds: 500), () {
      _loadThumb();
    });
  }

  /// Load thumb
  void _loadThumb() async {
    print("_loadThumb ${_photoVM.photo}");
    ByteData thumbData = await Utils.getThumbByteData(_photoVM.photo, 200);

    if (this.mounted) {
      setState(() {
        _thumbData = thumbData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = _size.width / 3;

    Widget checkedWidget;
    if (_photoVM.isSelected) {
      checkedWidget = Container(
        width: 20,
        height: 20,
        child: Image.asset('assets/checked.png', package: 'utils'),
      );
    } else {
      checkedWidget = Container();
    }

    Widget imageWidget;
    if (_thumbData == null) {
      imageWidget = SpinKitFadingCube(color: Color(0xffDB0000), size: 30);
    } else {
      imageWidget = Image.memory(
        _thumbData.buffer.asUint8List(),
        fit: BoxFit.cover,
        gaplessPlayback: true,
      );
    }

    return InkWell(
        onTap: () {
          if (!mounted) {
            return;
          }
          if (_photoVMsSelected.length >= _limit) {
            if (_photoVM.isSelected) {
              setState(() {
                _photoVM.isSelected = !_photoVM.isSelected;
                _photoVMsSelected.remove(_photoVM);
                _callback(_photoVMsSelected, _photoVM);
              });
            }
            return;
          }
          setState(() {
            _photoVM.isSelected = !_photoVM.isSelected;
            if (_photoVM.isSelected) {
              _photoVMsSelected.add(_photoVM);
            } else {
              _photoVMsSelected.remove(_photoVM);
            }
            _callback(_photoVMsSelected, _photoVM);
          });
        },
        child: Stack(
          children: <Widget>[
            Container(
                color: Colors.black,
                width: width,
                height: 120,
                key: ValueKey(_photoVM.photo.identifier),
                child: imageWidget),
            checkedWidget
          ],
        ));
//    return Container(child: Text('Demo'));
  }
}
