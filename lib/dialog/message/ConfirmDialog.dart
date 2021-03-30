//import 'dart:ui';
//
//import 'package:bravo2/language/Languages.dart';
//import 'package:flutter/material.dart';
//
//class ConfirmDialog {
//  /// Singleton pattern
//  ConfirmDialog._privateConstructor();
//
//  static final ConfirmDialog _instance = ConfirmDialog._privateConstructor();
//
//  static ConfirmDialog get instance {
//    return _instance;
//  }
//
//  /// Show message dialog
//  /// params (context, message, {title, yesLabel, noLabel callback})
//  void showMessageYesNoDialog(BuildContext context, String title, String message, String image,
//      {String yesLabel, String noLabel, Function yesCallback, Function noCallback}) {
//    print('showMessageDialog');
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
//                child: createMessageOkDialog(context, title, message, image,
//                    yesCallback: yesCallback, noCallback: noCallback));
//          });
//    });
//  }
//
//  /// Create message dialog
//  /// params (context, message, {title, yesLabel, noLabel callback})
//  Widget createMessageOkDialog(BuildContext context, String title, String message, String image,
//      {String yesLabel, String noLabel, Function yesCallback, Function noCallback}) {
//    String yesText = yesLabel;
//    if (yesText == null) {
//      yesText = Languages.of(context).getString(Languages.BAS_YES);
//    }
//    String noText = noLabel;
//    if (noText == null) {
//      noText = Languages.of(context).getString(Languages.BAS_NO);
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
//        /// Create title
//        createTitleWidget(title),
//
//        /// Create message
//        createMessageWidget(message),
//
//        /// Create ok
//        createYesNoWidget(context, yesText, noText,
//            yesCallback: yesCallback, noCallback: noCallback)
//      ],
//    );
//  }
//
//  /// Create yes no widget
//  Widget createYesNoWidget(BuildContext context, String yesText, String noText,
//      {Function yesCallback, Function noCallback}) {
//    return Container(
//        margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
//        child: Row(
//          children: [
//            Expanded(
//                child: InkWell(
//                    onTap: () {
//                      Navigator.pop(context);
//                      if (noCallback != null) {
//                        noCallback();
//                      }
//                    },
//                    child: Container(
//                        margin: EdgeInsets.only(right: 5),
//                        height: 55,
//                        alignment: Alignment.center,
//                        decoration: BoxDecoration(
//                            color: Color(0xffED1C24),
//                            borderRadius: BorderRadius.all(Radius.circular(10))),
//                        child: Text(noText,
//                            style: TextStyle(
//                                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white))))),
//            Expanded(
//                child: InkWell(
//                    onTap: () {
//                      Navigator.pop(context);
//                      if (yesCallback != null) {
//                        yesCallback();
//                      }
//                    },
//                    child: Container(
//                        margin: EdgeInsets.only(left: 5),
//                        height: 55,
//                        alignment: Alignment.center,
//                        decoration: BoxDecoration(
//                            color: Color(0xff2F80ED),
//                            borderRadius: BorderRadius.all(Radius.circular(10))),
//                        child: Text(yesText,
//                            style: TextStyle(
//                                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)))))
//          ],
//        ));
//  }
//
//  /// Create message widget
//  Widget createMessageWidget(String message) {
//    return Container(
//      alignment: Alignment.center,
//      margin: EdgeInsets.only(top: 15, left: 20, bottom: 20, right: 20),
//      child: Text(
//        message,
//        textAlign: TextAlign.center,
//      ),
//    );
//  }
//
//  /// Create image widget
//  Widget createImageWidget(String image) {
//    return Container(
//        margin: EdgeInsets.only(top: 20), width: 100, height: 100, child: Image.asset(image));
//  }
//
//  /// Create title widget
//  Widget createTitleWidget(String title) {
//    return Container(
//      alignment: Alignment.center,
//      margin: EdgeInsets.only(top: 20),
//      child: Text(title,
//          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
//    );
//  }
//}
