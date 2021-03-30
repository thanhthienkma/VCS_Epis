import 'package:flutter/material.dart';

extension StringExtension on String {
  /// Convert string to date
  DateTime toDateTimeObj() {
    return DateTime.parse(this);
  }

  /// Convert string to timeofday
  TimeOfDay toTimeOfDayObj() {
    List<String> split = this.split(':');
    if(split.length < 2){
      return null;
    }
    int hour = int.parse(split[0]);
    int min = int.parse(split[1]);

    return TimeOfDay(hour: hour, minute: min);
  }

  /// Convert string to color. #123456
  Color toColorObj({Color defaultColor = const Color(0xffDB0000)}){
    if(this == null || this == ''){
      return defaultColor;
    }
    if(this == 'transparent'){
     return Colors.transparent;
    }
    if(this.length != 7){
      return defaultColor;
    }
    if(!this.startsWith('#')){
      return defaultColor;
    }
    try {
      return Color(int.parse(this.replaceFirst('#', '0xFF')));
    }catch(e){
      return defaultColor;
    }
  }

  DateTime toDateTimeServerToLocal() {
    return DateTime.parse(this).toLocal();
  }
}
