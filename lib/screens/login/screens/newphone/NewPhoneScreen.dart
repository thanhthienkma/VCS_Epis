import 'package:flutter/material.dart';
import 'package:trans/identifiers/Screens.dart';
import 'package:trans/api/request/NewPhoneRequest.dart';
import 'package:trans/api/result/Result.dart';
import 'package:trans/base/screen/BaseScreen.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/components/button/ButtonComponent.dart';
import 'package:trans/components/vcslogo/VCSLogoComponent.dart';
import 'package:trans/dialog/country/CountryDialog.dart';
import 'package:trans/dialog/loading/LoadingDialog.dart';
import 'package:trans/dialog/message/MessageDialog.dart';
import 'package:trans/api/local/Country.dart';
import 'package:trans/api/result/Error.dart';
import 'package:trans/screens/login/loginconstants/LoginConstants.dart';

class NewPhoneScreen extends BaseScreen {
  final TextEditingController phoneController = TextEditingController();
  bool enable = false;
  String postCode = '+61';
  FocusNode phoneNode = FocusNode();

  NewPhoneRequest newPhoneRequest = NewPhoneRequest();
  Map args = Map();

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  @override
  Widget onInitBody(BuildContext context) {
    return Padding(
      padding: paddingAll20,
      child: ListView(
        children: <Widget>[
          /// VCS logo component
          VCSLogoComponent(
            title: 'Đăng ký nhanh tài khoản VCS',
            backIcon: true,
            callback: () {
              popScreen(context);
            },
          ),

          /// Phone widget
          Container(
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
          ),

          ///  Next button
          ButtonComponent(
            text: 'Tiếp tục',
            color: primaryColor,
            margin: 30,
            enable: this.enable,
            onClick: () {
              /**
               *   Call API new phone
               */
              createNewPhone(postCode, phoneController.text);
            },
          ),
        ],
      ),
    );
  }

  void createNewPhone(String postCode, String phoneNumber) async {
    LoadingDialog.instance.showLoadingDialog(context);
    Map<String, String> data = Map();
    data['postCode'] = postCode;
    data['phone'] = phoneNumber;
    Result<dynamic> result =
        await newPhoneRequest.callRequest(context, data: data);
    print(result);
    await LoadingDialog.instance.dismissLoading();
    if (result.isSuccess()) {
      args[LoginConstants.PHONE_NUMBER] = phoneController.text;
      args[LoginConstants.POST_CODE] = postCode;

      /// Go to receive otp screen
      pushScreen(BaseWidget(screen: Screens.RECEIVE_OTP, arguments: args),
          Screens.RECEIVE_OTP);
    } else {
      Error error = result.error;
      MessageDialog.instance.showMessageOkDialog(
          context, '', error.message, 'assets/images/failure.png');
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

TextStyle titleStyle = TextStyle(color: primaryColor, fontSize: font16);
