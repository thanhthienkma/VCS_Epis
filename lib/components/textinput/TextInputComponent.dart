import 'package:flutter/material.dart';
import 'package:trans/base/style/BaseStyle.dart';

class TextInputComponent extends StatefulWidget {
  /// Show above text
  final String labelText;

  /// Controller handles input
  final TextEditingController textEditingController;

  /// Change color underline
  final Color underlineColor;

  /// Set margin
  final double margin;

  /// User fills text, then onChanged will be active.
  final Function(String text) onChanged;

  /// Focus user input
  final FocusNode focusNode;

  TextInputComponent({
    @required this.labelText,
    @required this.textEditingController,
    @required this.onChanged,
    this.underlineColor = Colors.grey,
    this.focusNode,
    this.margin = 10.0,
  });

  @override
  State<StatefulWidget> createState() => _TextInputComponentState();
}

class _TextInputComponentState extends State<TextInputComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: widget.margin),
        child: TextField(
          controller: widget.textEditingController,
          onChanged: (String text) => widget.onChanged(text),
          decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle:
                TextStyle(color: loginDefaultUnderlineColor, fontSize: font14),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: loginDefaultUnderlineColor)),
            focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: widget.underlineColor, width: 1.0)),
          ),
        ));
  }
}
