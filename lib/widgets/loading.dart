import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/utils/ModeUtil.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
        child: SpinKitFadingCube(
            color: ModeUtil.instance.switchMode(isDark), size: size30));
  }
}
