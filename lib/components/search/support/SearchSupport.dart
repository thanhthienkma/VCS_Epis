import 'package:flutter/material.dart';

class SearchSupport {
  FocusNode focusNode = FocusNode();
  TextEditingController controller = TextEditingController();
  String hint = 'Searching...';
  double height = 50.0;
  double iconSize = 20.0;
  double iconMarginLeft = 20.0;
  Color hintColor =  Color(0xff828282);
  double hintFontSize = 16.0;
  Color textColor =  Color(0xff828282);
  double textFontSize = 16.0;
  double contentPadding = 0;
}
