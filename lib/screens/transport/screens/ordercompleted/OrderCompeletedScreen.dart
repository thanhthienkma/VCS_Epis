import 'package:flutter/material.dart';
import 'package:trans/base/screen/BaseScreen.dart';
import 'package:trans/base/style/BaseStyle.dart';

class OrderCompletedScreen extends BaseScreen {
  @override
  Widget onInitBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset('assets/images/empty_box.png', height: 50, width: 50),
        Container(
          margin: marginTop10,
          alignment: Alignment.center,
          child:
              Text('Chưa có đơn hàng.', style: TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }
}
