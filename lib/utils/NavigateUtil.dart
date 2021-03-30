import 'package:flutter/material.dart';

class NavigateUtil {
  static final NavigateUtil instance = NavigateUtil._internal();

  factory NavigateUtil() {
    return instance;
  }

  NavigateUtil._internal();

  /// Pop screen
  void popScreen(BuildContext context, {dynamic data}) {
    if (data == null) {
      Navigator.pop(context);
    } else {
      Navigator.pop(context, data);
    }
  }
}
