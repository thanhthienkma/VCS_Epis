import 'package:flutter/material.dart';
import 'package:trans/identifiers/Screens.dart';
import 'package:trans/api/request/ForgotPasswordRequest.dart';
import 'package:trans/api/request/PhoneRequest.dart';
import 'package:trans/api/result/Result.dart';
import 'package:trans/base/screen/BaseScreen.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/components/button/ButtonComponent.dart';
import 'package:trans/components/vcslogo/VCSLogoComponent.dart';
import 'package:trans/dialog/country/CountryDialog.dart';
import 'package:trans/dialog/loading/LoadingDialog.dart';
import 'package:trans/dialog/message/MessageDialog.dart';
import 'package:trans/api/local/Country.dart';
import 'package:trans/screens/login/loginconstants/LoginConstants.dart';
import 'package:trans/widgets/divider_widget.dart';
import 'package:trans/api/result/Error.dart';

class PhoneScreen extends BaseScreen {
  final TextEditingController phoneController = TextEditingController();
  bool enable = false;
  String postCode = '+61';
  FocusNode phoneNode = FocusNode();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  /// Request API
  PhoneRequest phoneExistedRequest = PhoneRequest();
  ForgotPasswordRequest forgotPasswordRequest = ForgotPasswordRequest();
  String value;

  @override
  void initState() {
    super.initState();
    value = widget.arguments;
    if (value == null) {
      return;
    }
  }

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  @override
  Widget onInitBody(BuildContext context) {
    return Padding(
      padding: paddingAll20,
      child: Column(
        children: <Widget>[
          Expanded(
              child: ListView(children: <Widget>[
            /// VCS logo component
            VCSLogoComponent(
              title: 'Chào Bạn Đến Ngôi Nhà Chung Của VCS',
              backIcon: true,
              callback: () {
                popScreen(context, data: value);
              },
            ),

            /// Create phone widget
            _createPhoneWidget(),

            /// Create forgot password
            _createForgotPassword(() {
              /// Call API forgot password
              callForgotPassword(postCode, phoneController.text);
            }),

            ///  Next button
            ButtonComponent(
              text: 'Tiếp tục',
              color: primaryColor,
              margin: 30,
              enable: this.enable,
              onClick: () {
                /**
                     * Call API check phone existed
                     */
                checkPhoneExisted(postCode, phoneController.text);
              },
            ),
          ])),

          /// Divider widget
          DividerWidget(),

          /// Create no account
          _createNoAccount(),

          /// Create new account
          _createNewAccount(),
        ],
      ),
    );
  }

  /// Phone widget
  Widget _createPhoneWidget() {
    return Container(
      margin: marginTop30,
      decoration: BoxDecoration(
          color: colorGray,
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: Row(
        children: <Widget>[
          /// Country code
          InkWell(
              onTap: () {
                CountryDialog().showCountryDialog(context,
                    callback: (Country value) {
                  setState(() {
                    postCode = value.countryCode;
                  });
                });
              },
              child: Container(
                  margin: marginLeft10,
                  child: Row(
                    children: <Widget>[
                      Text(postCode, style: style16),
                      Container(
                        margin: marginLeft10,
                        child: Icon(Icons.arrow_drop_down),
                      ),
                    ],
                  ))),

          /// Phone number
          Expanded(
              child: TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  maxLines: 1,
                  maxLength: 15,
                  textInputAction: TextInputAction.done,
                  focusNode: phoneNode,
                  onSubmitted: (value) {
                    phoneNode.unfocus();
                  },
                  onChanged: (String text) {
                    enableButton(phoneController.text);
                  },
                  decoration: InputDecoration(
                    hintText: 'Nhập số điện thoại',
                    contentPadding: paddingLeft10,
                    counterText: '',
                    border: InputBorder.none,
                  ))),
        ],
      ),
    );
  }

  /// New account
  Widget _createNewAccount() {
    return GestureDetector(
        onTap: () {
          /// Go to new phone screen
          pushScreen(BaseWidget(screen: Screens.NEW_PHONE), Screens.NEW_PHONE);
        },
        child: Container(
          margin: marginTop10,
          padding: paddingAll15,
          width: double.maxFinite,
          decoration: BoxDecoration(
              color: colorGray,
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Text('Đăng ký tài khoản mới',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: font16,
                  fontWeight: FontWeight.bold,
                  color: primaryColor)),
        ));
  }

  /// No account
  Widget _createNoAccount() {
    return Container(
      margin: marginTop10,
      child: Text(
        'Bạn chưa có tài khoản?',
        style: style16,
      ),
    );
  }

  /// Forgot password
  Widget _createForgotPassword(Function callback) {
    return Container(
        alignment: Alignment.centerRight,
        margin: marginTop20,
        child: InkWell(
            onTap: () => callback(),
            child: Text(
              'Quên mật khẩu?',
              style: TextStyle(color: primaryColor, fontSize: font16),
            )));
  }

  void enableButton(String text) {
    if (text.isEmpty) {
      this.enable = false;
    } else {
      this.enable = true;
    }

    setState(() {});
  }

  void callForgotPassword(String postCode, String phoneNumber) async {
    if (phoneNumber.isEmpty) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('Vui lòng nhập số điện thoại')));
      return;
    }

    LoadingDialog.instance.showLoadingDialog(context);
    Map<String, String> data = Map();
    data['postCode'] = postCode;
    data['phone'] = phoneNumber;
    Result<dynamic> result =
        await forgotPasswordRequest.callRequest(context, data: data);
    print(result);
    await LoadingDialog.instance.dismissLoading();
    if (result.isSuccess()) {
      /// Show successful message
      MessageDialog.instance.showMessageOkDialog(
          context,
          '',
          'Vui lòng kiếm tra SMS để nhận mật khẩu.',
          'assets/images/success.png');
    } else {
      Error error = result.error;
      MessageDialog.instance.showMessageOkDialog(
          context, '', error.message, 'assets/images/failure.png');
    }
  }

  void checkPhoneExisted(String postCode, String phoneNumber) async {
    LoadingDialog.instance.showLoadingDialog(context);
    Map<String, String> data = Map();
    data['postCode'] = postCode;
    data['phone'] = phoneNumber;
    Result<dynamic> result =
        await phoneExistedRequest.callRequest(context, data: data);
    print(result);
    await LoadingDialog.instance.dismissLoading();
    if (result.isSuccess()) {
      Map<String, dynamic> args = Map();
      args[LoginConstants.PHONE_NUMBER] = phoneController.text;
      args[LoginConstants.POST_CODE] = postCode;

      /// Go to password screen
      pushScreen(
        BaseWidget(screen: Screens.PASSWORD, arguments: args),
        Screens.PASSWORD,
      );
    } else {
      Error error = result.error;
      MessageDialog.instance.showMessageOkDialog(
          context, '', error.message, 'assets/images/failure.png');
    }
  }

  @override
  Key onInitKey(BuildContext context) {
    return _scaffoldKey;
  }
}
