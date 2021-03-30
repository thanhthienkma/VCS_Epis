import 'package:flutter/material.dart';
import 'package:trans/api/result/Province.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/dialog/widgets/ProvinceWidget.dart';

class ProvinceDialog {
  void showProvinceDialog(BuildContext context,
      {Function(Result value) callback}) {
    Future.delayed(Duration.zero, () {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            /// Prevent back press on Android, we use WillPopScope and override onWillPop.
            return WillPopScope(
                key: GlobalKey(debugLabel: '111'),
                onWillPop: () async => false,
                child: _provinceDialogWidget(callback: (Result value) {
                  callback(value);
                  Navigator.pop(context);
                }));
          });
    });
  }

  Widget _provinceDialogWidget({Function(Result) callback}) {
    return Dialog(
      elevation: 0,
      insetPadding: paddingAll20,
      backgroundColor: Colors.transparent,
      child: ProvinceWidget(
        callback: (Result value) {
          callback(value);
        },
      ),
    );
  }
}
