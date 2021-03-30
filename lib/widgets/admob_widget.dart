import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/config.dart';
import 'package:trans/utils/ModeUtil.dart';

class AdmobWidget extends StatefulWidget {
  final double height;

  AdmobWidget({this.height});

  @override
  State<StatefulWidget> createState() => _AdmobWidgetState();
}

class _AdmobWidgetState extends State<AdmobWidget> {
  final _controller = NativeAdmobController();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: marginAll10,
        height: widget.height,
        child: NativeAdmob(
          adUnitID: Config.adUnitID,
          loading: Center(
              child: SpinKitChasingDots(color: primaryColor, size: size30)),
          error: Text("Failed to load the ad"),
          controller: _controller,
          type: NativeAdmobType.full,
          options: NativeAdmobOptions(ratingColor: Colors.blue),
        ));
  }
}
