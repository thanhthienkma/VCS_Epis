import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trans/base/style/BaseStyle.dart';

class LoadingDialog {
  BuildContext context;

  /// Status show or dismiss
  bool status = false;

  /// Singleton pattern
  LoadingDialog._privateConstructor();

  static final LoadingDialog _instance = LoadingDialog._privateConstructor();

  static LoadingDialog get instance {
    return _instance;
  }

  /// Show loading dialog
  void showLoadingDialog(BuildContext context) async {
    status = true;
    this.context = context;
    Future.delayed(Duration.zero, () {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            /// Prevent back press on Android, we use WillPopScope and override onWillPop.
            return WillPopScope(
                key: GlobalKey(debugLabel: '111'),
                onWillPop: () {},
                child: createLoadingDialog(context));
          });
    });
  }

  /// Create message dialog
  /// Params (context, message, {title, okLabel, okTap})
  Widget createLoadingDialog(BuildContext context) {
    /// Create dialog.
    return SimpleDialog(
      contentPadding: EdgeInsets.all(10),
      backgroundColor: Colors.transparent,
      elevation: 0,
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(20),
            child: SpinKitFadingCube(color: primaryColor, size: 50))
      ],
    );
  }

  /// Dismiss loading
  /// Delay for showing dialog, we must be closed it
  /// If not, Navigator.pop(this.context) close current screen.
  Future<dynamic> dismissLoading() async {
    var result = await Future.delayed(Duration(milliseconds: 100), () {
      if (!status) {
        print('TAG dismiss 0');
        return false;
      }
      status = false;

      /// Close dialog
      Navigator.pop(this.context);
      context = null;
      return true;
    });
  }
}
