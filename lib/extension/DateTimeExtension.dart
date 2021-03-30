import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  /// Convert date to string
  String toStringObj(String pattern, {String local}) {
    if (local == null || local == '') {
      return DateFormat(pattern).format(this);
    }
    return DateFormat(pattern, local).format(this);
  }
}
