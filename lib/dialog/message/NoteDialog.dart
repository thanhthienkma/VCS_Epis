//import 'dart:ui';
//
//import 'package:bravo2/dialog/companyid/components/ForTestingComponent.dart';
//import 'package:bravo2/language/Languages.dart';
//import 'package:flutter/material.dart';
//
//class NoteDialog {
//  /// Controller
//  TextEditingController _textEditingController = TextEditingController();
//
//  /// Singleton pattern
//  NoteDialog._privateConstructor();
//
//  static final NoteDialog _instance = NoteDialog._privateConstructor();
//
//  bool isShowing = false;
//
//  static NoteDialog get instance {
//    return _instance;
//  }
//
//  /// Show message dialog
//  /// params (context, message, {title, yesLabel, noLabel callback})
//  void showNoteYesNoDialog(BuildContext context, String title,
//      {String yesLabel, String noLabel, Function(String value) yesCallback, Function() noCallback}) {
//    Future.delayed(Duration.zero, () {
//      showDialog(
//          context: context,
//          barrierDismissible: false,
//          builder: (BuildContext context) {
//            /// Prevent back press on Android, we use WillPopScope and override onWillPop.
//            return WillPopScope(
//                key: GlobalKey(),
//                onWillPop: () {},
//                child: createNoteYesNoDialog(context, title,
//                    yesCallback: yesCallback, noCallback: noCallback));
//          });
//    });
//  }
//
//  /// Create message dialog
//  /// params (context, message, {title, yesLabel, noLabel callback})
//  Widget createNoteYesNoDialog(BuildContext context, String title,
//      {String yesLabel, String noLabel,Function(String value)  yesCallback, Function noCallback}) {
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
//
//        /// Create title
//        createTitleWidget(title),
//
//        /// Create note
//        createNoteWidget(),
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
//      {Function(String value) yesCallback, Function noCallback}) {
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
//                       yesCallback(_textEditingController.text);
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
//  /// Create note widget
//  Widget createNoteWidget() {
//    return Container(
//      alignment: Alignment.center,
//      margin: EdgeInsets.only(left  : 20, bottom: 20, right: 20, top: 10),
//      child: TextField(
//        controller: _textEditingController,
//        decoration: InputDecoration(
//          filled: true,
//          fillColor: Color(0xfff2f2f2),
//          contentPadding:
//          const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
//          focusedBorder: OutlineInputBorder(
//            borderSide: BorderSide(color: Colors.white),
//            borderRadius: BorderRadius.circular(10),
//          ),
//          enabledBorder: UnderlineInputBorder(
//            borderSide: BorderSide(color: Colors.white),
//            borderRadius: BorderRadius.circular(10),
//          ),
//        ),
//        maxLines: 4,
//      ),
//    );
//  }
//
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
