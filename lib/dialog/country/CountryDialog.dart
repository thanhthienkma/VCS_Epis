import 'package:flutter/material.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/dialog/widgets/CountryWidget.dart';
import 'package:trans/api/local/Country.dart';

class CountryDialog {
  void showCountryDialog(BuildContext context,
      {Function(Country value) callback}) {
    Future.delayed(Duration.zero, () {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            /// Prevent back press on Android, we use WillPopScope and override onWillPop.
            return WillPopScope(
                key: GlobalKey(debugLabel: '111'),
                onWillPop: () async => false,
                child: _countryDialogWidget(callback: (Country value) {
                  callback(value);
                  Navigator.pop(context);
                }));
          });
    });
  }

  Widget _countryDialogWidget({Function(Country value) callback}) {
    return Dialog(
      elevation: 0,
      insetPadding: paddingAll20,
      backgroundColor: Colors.transparent,
      child: CountryWidget(
        callback: (Country value) {
          callback(value);
        },
      ),
    );
  }
}
