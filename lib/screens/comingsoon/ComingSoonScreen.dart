import 'package:flutter/material.dart';
import 'package:trans/base/screen/BaseScreen.dart';
import 'package:trans/base/style/BaseStyle.dart';

class ComingSoonScreen extends BaseScreen {
  @override
  Widget onInitBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        /// Back icon
        Container(
            margin: marginTop10,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
            )),

        /// Image
        Expanded(child: Image.asset('assets/images/coming_soon.png')),
      ],
    );
  }
}
