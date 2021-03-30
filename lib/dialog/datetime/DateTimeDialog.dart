import 'package:flutter/material.dart';

class DateTimeDialog {
  /// Show date dialog
  Future<DateTime> showDateDialog(BuildContext context, DateTime selected,
      {DateTime start, DateTime end}) {
    /// Check start value
    DateTime realStart = DateTime(1975);
    if (start != null) {
      realStart = start;
    }

    /// Check end value
    DateTime realEnd = DateTime(3000);
    if (end != null) {
      realEnd = end;
    }

    /// Imagine that this function is
    /// more complex and slow.
    return showDatePicker(
      context: context,
      initialDate: selected,
      firstDate: realStart,
      lastDate: realEnd,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
  }

  /// Show time dialog
  Future<TimeOfDay> showTimeDialog(BuildContext context, TimeOfDay selected) {
    return showTimePicker(initialTime: selected, context: context);
  }
}
