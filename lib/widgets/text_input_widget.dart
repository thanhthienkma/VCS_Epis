import 'package:flutter/material.dart';
import 'package:trans/base/style/BaseStyle.dart';

class TextInputWidget extends StatefulWidget {
  final TextEditingController textEditingController;
  final String hint;
  final FocusNode focus;
  final Function(String text) onSubmitted;

  TextInputWidget(
      {this.textEditingController, this.hint, this.focus, this.onSubmitted});

  @override
  State<StatefulWidget> createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: marginAll20,
        child: TextField(
          focusNode: widget.focus,
          onSubmitted: widget.onSubmitted,
          controller: widget.textEditingController,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(fontSize: font14),
          ),
        ));
  }
}
