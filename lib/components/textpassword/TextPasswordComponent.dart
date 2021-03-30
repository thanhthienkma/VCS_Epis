import 'package:flutter/material.dart';
import 'package:trans/base/style/BaseStyle.dart';

class TextPasswordComponent extends StatefulWidget {
  final String labelText;
  final TextEditingController textEditingController;
  final Color underlineColor;
  final Function(String text) onChanged;

  TextPasswordComponent({
    @required this.labelText,
    @required this.textEditingController,
    @required this.onChanged,
    this.underlineColor = Colors.grey,
  });

  @override
  State<StatefulWidget> createState() => _TextPasswordComponentState();
}

class _TextPasswordComponentState extends State<TextPasswordComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: marginTop10,
        child: TextField(
          controller: widget.textEditingController,
          obscureText:true,
          onChanged: (String text) => widget.onChanged(text),
          decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle: TextStyle(color: loginBaseColor, fontSize: font14),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: loginDefaultUnderlineColor)),
            focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: widget.underlineColor, width: 1.0)),
          ),
        ));
  }
}
