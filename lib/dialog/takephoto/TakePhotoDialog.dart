import 'package:flutter/material.dart';

class TakePhotoDialog {
  /// Singleton pattern
  TakePhotoDialog._privateConstructor();

  static final TakePhotoDialog _instance =
      TakePhotoDialog._privateConstructor();

  static TakePhotoDialog get instance {
    return _instance;
  }

  /// show confirm dialog
  void showTakePhotoDialog(BuildContext context, String message,
      {Function() cameraCallback, Function() libraryCallback}) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white),
                    margin: EdgeInsets.only(left: 5, right: 5, bottom: 5),
                    child: Column(
                      children: <Widget>[
                        /// Create message
                        _createMessageWidget(message),

                        /// Create line
                        _createLineWidget(),

                        /// Create take photo
                        _createTakePhotoWidget(context, cameraCallback),

                        /// Create line
                        _createLineWidget(),

                        /// Create choose photo
                        _createChooseLibraryWidget(context, libraryCallback)
                      ],
                    )),

                /// Create no
                _createNoWidget(context)
              ],
            ),
          );
        });
  }

  Widget _createChooseLibraryWidget(
      BuildContext context, Function() libraryCallback) {
    return InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          Navigator.pop(context);
          libraryCallback();
        },
        child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: Text('Chọn ảnh từ gallery',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff2F80ED)))));
  }

  Widget _createTakePhotoWidget(
      BuildContext context, Function() cameraCallback) {
    return InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          Navigator.pop(context);
          cameraCallback();
        },
        child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: Text('Chụp ảnh từ camera',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff2F80ED)))));
  }

  /// Create line widget
  Widget _createLineWidget() {
    return Container(color: Color(0xfff2f2f2), height: 1);
  }

  /// Create message widget
  Widget _createMessageWidget(String message
//      , {double fontSize}
      ) {
//    double fsize = 16;
//    if (fontSize != null) {
//      fsize = fontSize;
//    }
    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 20, bottom: 20),
        child: Text(message,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black)));
  }

//  /// Create yes widget
//  Widget _createYesWidget(BuildContext context,
//      {String yesLabel,
//      double fontSize,
//      Color yesColor,
//      Function() yesCallback}) {
//    double fsize = 16;
//    if (fontSize != null) {
//      fsize = fontSize;
//    }
//    String yes = Languages.of(context).getString(Languages.CFB_YES);
//    if (yesLabel != null) {
//      yes = yesLabel;
//    }
//
//    Color yColor = Color(0xff2F80ED);
//    if (yesColor != null) {
//      yColor = yesColor;
//    }
//    return InkWell(
//        onTap: () {
//          Navigator.pop(context);
//          if (yesCallback != null) {
//            yesCallback();
//          }
//        },
//        child: Container(
//            alignment: Alignment.center,
//            padding: EdgeInsets.only(top: 15, bottom: 15),
//            child: Text(yes,
//                style: TextStyle(
//                    fontSize: fsize,
//                    fontWeight: FontWeight.bold,
//                    color: yColor))));
//  }

  /// Create no widget
  Widget _createNoWidget(BuildContext context,
      {String noLabel, double fontSize, Color noColor, Function() noCallback}) {
//    double fsize = 16;
//    if (fontSize != null) {
//      fsize = fontSize;
//    }
//
//    Color nColor = Color(0xffE4003D);
//    if (noColor != null) {
//      nColor = noColor;
//    }

    String no = 'Huỷ bỏ';
    if (noLabel != null) {
      no = noLabel;
    }
    return InkWell(
        onTap: () {
          Navigator.pop(context);
          if (noCallback != null) {
            noCallback();
          }
        },
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white),
            margin: EdgeInsets.only(left: 5, right: 5, bottom: 5),
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: Text(no,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff007AFF)))));
  }
}
