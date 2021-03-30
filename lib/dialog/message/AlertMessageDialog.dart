//import 'dart:ui';
//
//import 'package:bravo2/language/Languages.dart';
//import 'package:flutter/material.dart';
//
//class AlertMessageDialog {
//  /// Singleton pattern
//  AlertMessageDialog._privateConstructor();
//
//  static final AlertMessageDialog _instance = AlertMessageDialog._privateConstructor();
//
//  bool isShowing = false;
//
//  static AlertMessageDialog get instance {
//    return _instance;
//  }
//
//  /// Show message dialog
//  /// params (context, message, {title, okLabel, callback})
//  void showAlertDialog(BuildContext context, String message, String image,
//      {String okLabel, Function callback}) {
//    print('showMessageDialog');
//
//    if(isShowing){
//      return;
//    }
//    isShowing = true;
//
//    Future.delayed(Duration.zero, () {
//      showDialog(
//          context: context,
//          barrierDismissible: false,
//          builder: (BuildContext context) {
//            /// Prevent back press on Android, we use WillPopScope and override onWillPop.
//            return WillPopScope(
//                key: GlobalKey(),
//                onWillPop: () {},
//                child: createAlertDialog(context, message, image, callback: callback));
//          });
//    });
//  }
//
//  /// Create message dialog
//  /// Params (context, message, {title, okLabel, okTap})
//  Widget createAlertDialog(BuildContext context, String message, String image,
//      {String okLabel, Function callback}) {
//    String okText = okLabel;
//    if (okLabel == null) {
//      okText = Languages.of(context).getString(Languages.BAS_OK);
//    }
//
//    /// Create dialog.
//    return SimpleDialog(
//      contentPadding: EdgeInsets.all(10),
//      shape: RoundedRectangleBorder(
//        borderRadius: BorderRadius.circular(10),
//      ),
//      children: <Widget>[
//        /// Create image
//        createImageWidget(image),
//
//        /// Create message
//        createMessageWidget(message),
//
//        /// Create ok
//        createOkWidget(context, okText, callback: callback)
//      ],
//    );
//  }
//
//  /// Create ok widget
//  Widget createOkWidget(BuildContext context, String okText, {Function() callback}) {
//    return Container(
//        margin: EdgeInsets.only(left: 40, right: 40, bottom: 20),
//        child: InkWell(
//            onTap: () {
//              Navigator.pop(context);
//              isShowing = false;
//              if (callback != null) {
//                callback();
//              }
//            },
//            child: Container(
//                height: 55,
//                alignment: Alignment.center,
//                width: double.infinity,
//                decoration: BoxDecoration(
//                    color: Color(0xff2F80ED), borderRadius: BorderRadius.all(Radius.circular(10))),
//                child: Text(okText,
//                    style: TextStyle(
//                        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)))));
//  }
//
//  /// Create message widget
//  Widget createMessageWidget(String message) {
//    if(message == null || message == ''){
//      return Container();
//    }
//    return Container(
//      alignment: Alignment.center,
//      margin: EdgeInsets.only(top: 15, left: 20, bottom: 20, right: 20),
//      child: Text(
//        message,
//        textAlign: TextAlign.center,
//        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
//      ),
//    );
//  }
//
//  /// Create image widget
//  Widget createImageWidget(String image) {
//    return Container(
//        margin: EdgeInsets.only(top: 20), width: 100, height: 100, child: Image.asset(image));
//  }
//}
