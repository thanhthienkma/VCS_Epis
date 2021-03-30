import 'package:flutter/material.dart';
import 'package:trans/identifiers/Screens.dart';
import 'package:trans/base/screen/BaseScreen.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/components/button/ButtonComponent.dart';
import 'package:trans/screens/login/loginconstants/LoginConstants.dart';

class ConfirmPasswordScreen extends BaseScreen {
  Map<String, dynamic> args = Map();
  String postCode;
  String phoneNumber;
  String password;

  @override
  void initState() {
    super.initState();

    /// Get arguments
    getArguments();
  }

  getArguments() {
    args = widget.arguments;
    postCode = args[LoginConstants.POST_CODE];
    phoneNumber = args[LoginConstants.PHONE_NUMBER];
    password = args[LoginConstants.PASSWORD];
  }

  @override
  Widget onInitBody(BuildContext context) {
    return Padding(
      padding: paddingAll20,
      child: ListView(
        children: <Widget>[
          /// Avatar
          Image.asset('assets/images/deco_logo.png', height: 80),

          /// Green check
          Image.asset('assets/images/green_check.png', height: 100),

          /// Title
          Container(
              margin: marginTop20,
              alignment: Alignment.center,
              child: Text('Đặt lại mật khẩu thành công',
                  style: TextStyle(
                      fontSize: font18, fontWeight: FontWeight.bold))),
          Container(
              margin: marginTop20,
              alignment: Alignment.center,
              child: Text(
                'Từ nay bạn hãy dùng mật khẩu mới',
                style: TextStyle(fontSize: font16),
              )),
          Container(
              alignment: Alignment.center,
              child: Text(
                'đăng nhập VCS',
                style: TextStyle(fontSize: font16),
              )),

          ///  Next button
          ButtonComponent(
            text: 'Tiếp tục',
            color: primaryColor,
            margin: 30,
            enable: true,
            onClick: () {
              /// Go to social screen
              pushScreen(BaseWidget(screen: Screens.UPDATE_NAME, arguments: args),
                  Screens.UPDATE_NAME);
            },
          ),
        ],
      ),
    );
  }
}
