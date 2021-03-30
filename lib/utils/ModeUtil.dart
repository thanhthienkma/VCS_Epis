import 'package:flutter/material.dart';

class ModeUtil {
  static final ModeUtil instance = ModeUtil._internal();

  factory ModeUtil() {
    return instance;
  }

  ModeUtil._internal();

  /// Switch light mode or dark mode
  Color switchMode(bool isDark) {
    if (isDark) {
      return Colors.white;
    }
    return Color(0xFF1B1E28);
  }

}
