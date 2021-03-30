import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/utils/ModeUtil.dart';

class LoadingInfinite extends StatelessWidget {
  final bool canLoadMore;

  LoadingInfinite(this.canLoadMore);

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return canLoadMore
        ? Container(
            height: 60,
            child: Center(
              child: SpinKitFadingCube(
                  color: ModeUtil.instance.switchMode(isDark), size: size30),
            ))
        : Container(height: canLoadMore ? 60 : 0);
  }
}
