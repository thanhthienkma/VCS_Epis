import 'package:flutter/material.dart';

extension DateTimeExtension on TimeOfDay {
  /// Convert hour, minute to HH:mm string
  String toStringObj(String pattern) {
    String _addLeadingZeroIfNeeded(int value) {
      if (value < 10)
        return '0$value';
      return value.toString();
    }
    final String hourLabel = _addLeadingZeroIfNeeded(hour);
    if(pattern == 'HH'){
      return hourLabel;
    }
    final String minuteLabel = _addLeadingZeroIfNeeded(minute);
    if(pattern == 'mm'){
      return minuteLabel;
    }

    return '$hourLabel:$minuteLabel';
  }
}
