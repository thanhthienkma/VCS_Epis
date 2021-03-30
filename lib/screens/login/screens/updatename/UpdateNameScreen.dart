import 'package:flutter/material.dart';
import 'package:trans/identifiers/Screens.dart';
import 'package:trans/api/request/PasswordRequest.dart';
import 'package:trans/api/request/UpdateInfoRequest.dart';
import 'package:trans/api/result/Result.dart';
import 'package:trans/api/result/Error.dart';
import 'package:trans/base/screen/BaseScreen.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/components/button/ButtonComponent.dart';
import 'package:trans/dialog/loading/LoadingDialog.dart';
import 'package:trans/dialog/message/MessageDialog.dart';
import 'package:trans/screens/login/loginconstants/LoginConstants.dart';

class UpdateNameScreen extends BaseScreen {
  TextEditingController nicknameController = TextEditingController();
  bool enable = false;
  Map<String, dynamic> args = Map();
  String postCode;
  String phoneNumber;
  String password;
  PasswordRequest passwordLoginRequest = PasswordRequest();
  String token;

  UpdateInfoRequest updateInfoRequest = UpdateInfoRequest();

  @override
  void initState() {
    super.initState();

    /// Get arguments
    getArguments();

    /**
     * Call API login phone
     */
    loginPhone(postCode, phoneNumber, password);
  }

  getArguments() {
    args = widget.arguments;
    postCode = args[LoginConstants.POST_CODE];
    phoneNumber = args[LoginConstants.PHONE_NUMBER];
    password = args[LoginConstants.PASSWORD];
  }

  @override
  void dispose() {
    super.dispose();
    nicknameController.dispose();
  }

  @override
  Widget onInitBody(BuildContext context) {
    return Padding(
      padding: paddingAll20,
      child: ListView(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(left: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  /// Title
                  Container(
                      margin: marginTop20,
                      child: Text('Tài khoản VCS : $phoneNumber',
                          style: TextStyle(fontSize: font16))),
                  Container(
                      margin: marginTop10,
                      child: Text(
                        'của bạn chưa có tên hiển thị trên VCS',
                        style: TextStyle(fontSize: font16),
                      )),
                ],
              )),

          Container(
              alignment: Alignment.center,
              margin: marginTop10,
              child: Text(
                'Vui lòng nhập tên hiển thị',
                style: TextStyle(fontSize: font16),
              )),

          Container(
              margin: marginTop10,
              child: Text('Nguyễn Văn A',
                  style: TextStyle(fontSize: font12, color: loginBaseColor))),

          /// Nick name
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
                        controller: nicknameController,
                        maxLines: 1,
                        onChanged: (String text) {
                          enableButton(nicknameController.text);
                        },
                        decoration: InputDecoration(
                          hintText: 'Tên hiển thị',
                          contentPadding: paddingLeft10,
                          border: InputBorder.none,
                        ))),
              ],
            ),
          ),

          ///  Next button
          ButtonComponent(
            text: 'Tiếp tục',
            color: primaryColor,
            margin: 20,
            enable: this.enable,
            onClick: () {
              /**
               * Call API update info
               */
              updateInfo(postCode, phoneNumber);
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
        await passwordLoginRequest.callRequest(context, data: data);
    print(result);
    await LoadingDialog.instance.dismissLoading();

    if (result.isSuccess()) {
      token = result.data.token;
    } else {
      Error error = result.error;
      MessageDialog.instance.showMessageOkDialog(
          context, '', error.message, 'assets/images/failure.png');
    }
  }

  void updateInfo(String postCode, String phoneNumber) async {
    LoadingDialog.instance.showLoadingDialog(context);
    Map<String, dynamic> data = Map();
    Map<String, dynamic> headers = Map();

    /// Params
    data['postCode'] = postCode;
    data['phone'] = phoneNumber;
    data['displayName'] = nicknameController.text;

    /// Headers
    headers['Authorization'] = 'Bearer $token';
    Result<dynamic> result = await updateInfoRequest.callRequest(context,
        data: data, headers: headers);
    print(result);
    await LoadingDialog.instance.dismissLoading();
    if (result.isSuccess()) {
      MessageDialog.instance.showMessageOkDialog(
          context, '', 'Cập nhật thành công.', 'assets/images/success.png',
          callback: () {
        /// Go to phone screen
        pushScreen(BaseWidget(screen: Screens.PHONE), Screens.PHONE);
      });
    } else {
      Error error = result.error;
      switch (error.code) {

        /// Can not find phone number
        case 1:
          MessageDialog.instance.showMessageOkDialog(
              context, '', error.message, 'assets/images/failure.png');
          break;

        /// Something went wrong
        case 2:
          MessageDialog.instance.showMessageOkDialog(
              context, '', error.message, 'assets/images/failure.png');
          break;
      }
    }
  }

  void enableButton(String text) {
    if (text.isEmpty) {
      this.enable = false;
    } else {
      this.enable = true;
    }
    setState(() {});
  }
}
