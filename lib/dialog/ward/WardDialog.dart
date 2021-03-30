import 'package:flutter/material.dart';
import 'package:trans/api/result/Ward.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/dialog/widgets/WardWidget.dart';

class WardDialog {
  void showWardDialog(BuildContext context, {Function(Result value) callback}) {
    Future.delayed(Duration.zero, () {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            /// Prevent back press on Android, we use WillPopScope and override onWillPop.
            return WillPopScope(
                key: GlobalKey(debugLabel: '111'),
                onWillPop: () async => false,
                child: _wardDialogWidget(callback: (Result value) {
                  callback(value);
                  Navigator.pop(context);
                }));
          });
    });
  }

  Widget _wardDialogWidget({Function(Result) callback}) {
    return Dialog(
      elevation: 0,
      insetPadding: paddingAll20,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
      backgroundColor: Colors.transparent,
      child: WardWidget(
        callback: (Result value) {
          callback(value);
        },
      ),
    );
  }
}
