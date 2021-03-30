import 'package:flutter/material.dart';
import 'package:trans/api/request/ChangePasswordRequest.dart';
import 'package:trans/api/result/Result.dart';
import 'package:trans/api/result/Error.dart';
import 'package:trans/api/result/User.dart';
import 'package:trans/base/screen/BaseScreen.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/components/button/ButtonComponent.dart';
import 'package:trans/components/textpassword/TextPasswordComponent.dart';
import 'package:trans/components/vcslogo/VCSLogoComponent.dart';
import 'package:trans/dialog/loading/LoadingDialog.dart';
import 'package:trans/dialog/message/MessageDialog.dart';
import 'package:trans/screens/personal/PersonalScreen.dart';
import 'package:trans/screens/personal/widgets/PersonalHeaderWidget.dart';

class ChangePasswordScreen extends BaseScreen {
  TextEditingController oldPassWordController = TextEditingController();
  TextEditingController newPassWordController = TextEditingController();
  TextEditingController reTypePassWordController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  ChangePasswordRequest changePasswordRequest = ChangePasswordRequest();

  bool enable = false;
  Map args = Map();
  User user;

  @override
  void initState() {
    super.initState();

    /// Get arguments
    getArguments();
  }

  getArguments() async {
    args = widget.arguments;
    user = args[PersonalConstants.USER_DATA];
  }

  @override
  void dispose() {
    super.dispose();
    oldPassWordController.dispose();
    newPassWordController.dispose();
    reTypePassWordController.dispose();
  }

  @override
  Widget onInitBody(BuildContext context) {
    return Column(
      children: <Widget>[
        /// Personal header widget
        PersonalHeaderWidget(
          title: 'Đổi mật khẩu',
          isBack: true,
          leftCallback: () {
            popScreen(context);
          },
        ),

        Expanded(
          child: Padding(
            padding: paddingAll20,
            child: ListView(
              children: <Widget>[
                VCSLogoComponent(),

                /// Old password
                TextPasswordComponent(
                    labelText: 'Mật khẩu cũ',
                    textEditingController: oldPassWordController,
                    onChanged: (String text) {
                      enableButton(
                          oldPassWordController.text,
                          newPassWordController.text,
                          reTypePassWordController.text);
                    }),

                /// New password
                TextPasswordComponent(
                    labelText: 'Mật khẩu mới',
                    textEditingController: newPassWordController,
                    onChanged: (String text) {
                      enableButton(
                          oldPassWordController.text,
                          newPassWordController.text,
                          reTypePassWordController.text);
                    }),

                /// Retype new password
                TextPasswordComponent(
                    labelText: 'Xác nhận mật khẩu mới',
                    textEditingController: reTypePassWordController,
                    onChanged: (String text) {
                      enableButton(
                          oldPassWordController.text,
                          newPassWordController.text,
                          reTypePassWordController.text);
                    }),

                ///  Reset password button
                ButtonComponent(
                  text: 'Xác nhận đổi mật khẩu',
                  color: primaryColor,
                  margin: 40,
                  enable: enable,
                  onClick: () {
                    if (newPassWordController.text !=
                        reTypePassWordController.text) {
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text('Mật khẩu mới không trùng khớp !')));
                      return;
                    }

                    /// Call API change password
                    changePassword(user.data.postCode, user.data.phone,
                        oldPassWordController.text, newPassWordController.text);
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  Key onInitKey(BuildContext context) {
    return _scaffoldKey;
  }

  void changePassword(String postCode, String phoneNumber, String password,
      String newPassword) async {
    LoadingDialog.instance.showLoadingDialog(context);
    Map<String, String> data = Map();
    Map<String, dynamic> headers = Map();

    /// Headers
    headers['Authorization'] = 'Bearer ${user.token}';

    data['postCode'] = postCode;
    data['phone'] = phoneNumber;
    data['password'] = password;
    data['newPassword'] = newPassword;

    Result<dynamic> result = await changePasswordRequest.callRequest(context,
        data: data, headers: headers);
    print(result);
    await LoadingDialog.instance.dismissLoading();
    if (result.isSuccess()) {
      MessageDialog.instance.showMessageOkDialog(context, 'Thông báo',
          'Đổi mật khẩu thành công', 'assets/images/success.png', callback: () {
        popScreen(context);
      });
    } else {
      Error error = result.error;
      MessageDialog.instance.showMessageOkDialog(
          context, '', error.message, 'assets/images/failure.png');
    }
  }

  void enableButton(String oldPass, String newPass, String retypePass) {
    if (oldPass.isEmpty || newPass.isEmpty || retypePass.isEmpty) {
      this.enable = false;
    } else {
      this.enable = true;
    }

    setState(() {});
  }
}
