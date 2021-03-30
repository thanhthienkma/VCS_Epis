import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:trans/identifiers/Screens.dart';
import 'package:trans/api/request/PasswordRequest.dart';
import 'package:trans/api/result/Result.dart';
import 'package:trans/api/result/User.dart';
import 'package:trans/base/screen/BaseScreen.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/components/button/ButtonComponent.dart';
import 'package:trans/components/vcslogo/VCSLogoComponent.dart';
import 'package:trans/dialog/loading/LoadingDialog.dart';
import 'package:trans/dialog/message/MessageDialog.dart';
import 'package:trans/preferences/Preferences.dart';
import 'package:trans/screens/login/loginconstants/LoginConstants.dart';
import 'package:trans/api/result/Error.dart';

class PasswordScreen extends BaseScreen {
  final TextEditingController passwordController = TextEditingController();
  bool enable = false;

  Map<String, dynamic> args = Map();

  String postCode;
  String phoneNumber;

  /// Request API
  PasswordRequest passwordRequest = PasswordRequest();

  @override
  void initState() {
    super.initState();

    /// Get arguments
    getArguments();
  }

  void getArguments() {
    args = widget.arguments;
    postCode = args[LoginConstants.POST_CODE];
    phoneNumber = args[LoginConstants.PHONE_NUMBER];
  }

  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
  }

  @override
  Widget onInitBody(BuildContext context) {
    return Padding(
      padding: paddingAll20,
      child: ListView(
        children: <Widget>[
          /// VCS logo component
          VCSLogoComponent(
            title: 'Chào Bạn Đến Ngôi Nhà Chung Của VCS',
            backIcon: true,
            callback: () {
              popScreen(context);
            },
          ),

          /// Password
          Container(
            margin: marginTop30,
            decoration: BoxDecoration(
                color: colorGray,
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: Row(
              children: <Widget>[
                Container(),
                Expanded(
                    child: TextField(
                        controller: passwordController,
                        maxLines: 1,
                        obscureText: true,
                        onChanged: (String text) {
                          enableButton(passwordController.text);
                        },
                        decoration: InputDecoration(
                          hintText: 'Nhập mậu khẩu',
                          contentPadding: paddingLeft10,
                          counterText: '',
                          border: InputBorder.none,
                        ))),
              ],
            ),
          ),

          ///  Next button
          ButtonComponent(
            text: 'Tiếp tục',
            color: primaryColor,
            margin: 30,
            enable: this.enable,
            onClick: () {
              /**
               *  Call API login in phone
               */
              loginPhone(postCode, phoneNumber, passwordController.text);
            },
          ),
        ],
      ),
    );
  }

  void loginPhone(String postCode, String phoneNumber, String password) async {
    LoadingDialog.instance.showLoadingDialog(context);
    Map<String, String> data = Map();
    data['postCode'] = postCode;
    data['phone'] = phoneNumber;
    data['password'] = password;
    Result<dynamic> result =
        await passwordRequest.callRequest(context, data: data);
    print(result);
    await LoadingDialog.instance.dismissLoading();

    User user = result.data;

    if (result.isSuccess()) {
      args['data'] = user.data;

      /// Save user
      Preferences.saveUser(jsonEncode(user.toJson()));

      /// Save token
      Preferences.saveToken(user.token);

      /// Go to main screen
      pushReplaceAllScreen(
          BaseWidget(screen: Screens.MAIN, arguments: args), Screens.MAIN);
    } else {
      Error error = result.error;
      MessageDialog.instance.showMessageOkDialog(
          context, '', error.message, 'assets/images/failure.png');
    }
  }

  void enableButton(String text) {
    if (text.isEmpty) {
      setState(() {
        this.enable = false;
      });
    } else {
      setState(() {
        this.enable = true;
      });
    }
  }
}
