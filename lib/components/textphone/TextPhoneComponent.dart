import 'package:flutter/material.dart';
import 'package:trans/base/style/BaseStyle.dart';

class TextPhoneComponent extends StatefulWidget {
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

  TextPhoneComponent({
    @required this.labelText,
    @required this.textEditingController,
    @required this.onChanged,
    this.underlineColor = Colors.grey,
    this.focusNode,
    this.margin = 10.0,
  });

  @override
  State<StatefulWidget> createState() => _TextPhoneComponentState();
}

class _TextPhoneComponentState extends State<TextPhoneComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: widget.margin),
        child: TextField(
          keyboardType: TextInputType.phone,
          controller: widget.textEditingController,
          maxLines: 1,
          onChanged: (String text) => widget.onChanged(text),
          decoration: InputDecoration(
            labelText: widget.labelText,
            border: InputBorder.none,
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
