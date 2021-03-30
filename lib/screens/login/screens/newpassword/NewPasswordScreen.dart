import 'package:flutter/material.dart';
import 'package:trans/identifiers/Screens.dart';
import 'package:trans/api/request/NewPasswordRequest.dart';
import 'package:trans/api/result/Result.dart';
import 'package:trans/api/result/Error.dart';
import 'package:trans/base/screen/BaseScreen.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/components/button/ButtonComponent.dart';
import 'package:trans/dialog/loading/LoadingDialog.dart';
import 'package:trans/dialog/message/MessageDialog.dart';
import 'package:trans/screens/login/loginconstants/LoginConstants.dart';

class NewPasswordScreen extends BaseScreen {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController retypePasswordController =
      TextEditingController();
  bool enable = false;

  Map<String, dynamic> args = Map();
  String postCode;
  String phoneNumber;

  NewPasswordRequest newPasswordRequest = NewPasswordRequest();

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
  }

  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
    retypePasswordController.dispose();
  }

  @override
  Widget onInitBody(BuildContext context) {
    return Padding(
      padding: paddingAll20,
      child: ListView(
        children: <Widget>[
          /// Create title
          _createTitle(),

          /// Password
          Container(
            margin: marginTop20,
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
                        maxLength: 20,
                        obscureText: true,
                        onChanged: (String text) {
                          enableButton(passwordController.text,
                              retypePasswordController.text);
                        },
                        decoration: InputDecoration(
                          hintText: 'Nhập mật khẩu',
                          contentPadding: paddingLeft10,
                          counterText: '',
                          border: InputBorder.none,
                        ))),
              ],
            ),
          ),

          /// Retype password
          Container(
            margin: marginTop10,
            decoration: BoxDecoration(
                color: colorGray,
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: Row(
              children: <Widget>[
                Container(),
                Expanded(
                    child: TextField(
                        controller: retypePasswordController,
                        maxLines: 1,
                        maxLength: 20,
                        obscureText: true,
                        onChanged: (String text) {
                          enableButton(passwordController.text,
                              retypePasswordController.text);
                        },
                        decoration: InputDecoration(
                          hintText: 'Xác nhận mật khẩu',
                          contentPadding: paddingLeft10,
                          counterText: '',
                          border: InputBorder.none,
                        ))),
              ],
            ),
          ),

          ///  Add password button
          ButtonComponent(
            text: 'Thêm',
            color: primaryColor,
            margin: 30,
            enable: this.enable,
            onClick: () {
              if (passwordController.text != retypePasswordController.text) {
                MessageDialog.instance.showMessageOkDialog(context, '',
                    'Mật khẩu không trùng khớp', 'assets/images/failure.png');
                return;
              }

              /**
               *  Call API new password
               */
              createNewPassword(postCode, phoneNumber, passwordController.text);
            },
          ),
        ],
      ),
    );
  }

  /// Title
  Widget _createTitle() {
    return Container(
      margin: marginTop20,
      alignment: Alignment.center,
      child: Text(
          'Thêm mật khẩu đăng nhập cho\n \t  số điện thoại $phoneNumber',
          style: TextStyle(fontSize: font18)),
    );
  }

  void createNewPassword(
      String postCode, String phoneNumber, String password) async {
    LoadingDialog.instance.showLoadingDialog(context);
    Map<String, String> data = Map();
    data['postCode'] = postCode;
    data['phone'] = phoneNumber;
    data['password'] = password;
    Result<dynamic> result =
        await newPasswordRequest.callRequest(context, data: data);
    print(result);
    await LoadingDialog.instance.dismissLoading();

    if (result.isSuccess()) {
      Map<String, dynamic> args = Map();
      args[LoginConstants.POST_CODE] = postCode;
      args[LoginConstants.PHONE_NUMBER] = phoneNumber;
      args[LoginConstants.PASSWORD] = passwordController.text;

      /// Go to confirm password screen
      pushScreen(BaseWidget(screen: Screens.CONFIRM_PASSWORD, arguments: args),
          Screens.CONFIRM_PASSWORD);
    } else {
      Error error = result.error;
      MessageDialog.instance.showMessageOkDialog(
          context, '', error.message, 'assets/images/failure.png');
    }
  }

  void enableButton(String password, String retypePassword) {
    if (password.isEmpty || retypePassword.isEmpty) {
      this.enable = false;
    } else {
      this.enable = true;
    }
    setState(() {});
  }
}
