import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:trans/identifiers/Screens.dart';
import 'package:trans/api/request/CancelOTPRequest.dart';
import 'package:trans/api/request/SendOTPRequest.dart';
import 'package:trans/api/request/VerifyOTPRequest.dart';
import 'package:trans/api/result/Result.dart';
import 'package:trans/base/screen/BaseScreen.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/components/button/ButtonComponent.dart';
import 'package:trans/dialog/loading/LoadingDialog.dart';
import 'package:trans/dialog/message/MessageDialog.dart';
import 'package:trans/api/result/Error.dart';
import 'package:trans/preferences/Preferences.dart';
import 'package:trans/screens/login/loginconstants/LoginConstants.dart';

class ReceiveOTPScreen extends BaseScreen {
  String phoneVal = '';
  bool enable = false;
  String code = '';
  bool resent = false;
  Map args = Map();
  String postCode;
  String phoneNumber;
  String third;
  int count = 0;

  /// Objects call API
  SendOTPRequest otpRequest = SendOTPRequest();
  VerifyOTPRequest verifyOTPRequest = VerifyOTPRequest();
  CancelOTPRequest cancelOTPRequest = CancelOTPRequest();

  /// Timer
  Timer timer;
  int timesDelay = 180;
  String requestId;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    /// Get arguments
    getArguments();

    /// Handle otp
    handleOTP();
  }

  void getArguments() {
    args = widget.arguments;
    postCode = args[LoginConstants.POST_CODE];
    phoneNumber = args[LoginConstants.PHONE_NUMBER];
  }

  void handleOTP() async {
    requestId = await Preferences.getRequestId();

    if (requestId != null && requestId.isNotEmpty) {
      /**
       * Call API cancel OTP
       */
      cancelOTP(requestId);
      return;
    }

    /**
     *  Call API send OTP
     */
    sendOTP(postCode, phoneNumber);
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget onInitBody(BuildContext context) {
    return Padding(
      padding: paddingAll20,
      child: ListView(
        children: <Widget>[
          /// Create back icon
          _createBackIcon(),

          /// Create title OTP
          _createOTPTitle(),

          /// Create pin code
          _createPinCode(),

          ///  Verify button
          ButtonComponent(
            text: 'Xác thực',
            color: primaryColor,
            margin: 30,
            enable: enable,
            onClick: () {
              /// Call API verify OTP
              verifyOTP(requestId, code);
            },
          ),

          /// Crete no OTP
          _createNoOTP(),

          /// Create resend OTP
          _createResendOTP(),

          /// Create time out
          _createTimesOut(),
        ],
      ),
    );
  }

  /// Time out
  Widget _createTimesOut() {
    return Container(
      alignment: Alignment.center,
      margin: marginTop20,
      child: Text(
        'Thời gian : $timesDelay (s)',
        style: TextStyle(color: Colors.black, fontSize: font16),
      ),
    );
  }

  void enableButton(String text) {
    if (text.length == 4) {
      enable = true;
    } else {
      enable = false;
    }
    setState(() {});
  }

  /// Pin code
  Widget _createPinCode() {
    return PinCodeTextField(
      length: 4,
      obsecureText: false,
      textInputType: TextInputType.number,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
          shape: PinCodeFieldShape.underline,
          selectedColor: loginBaseColor,
          inactiveColor: primaryColor,
          activeFillColor: primaryColor,
          activeColor: primaryColor,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 50,
          fieldWidth: 40),
      animationDuration: Duration(milliseconds: 300),
      onCompleted: (value) {
        code = value;
      },
      onChanged: (value) {
        enableButton(value);
      },
    );
  }

  /// No OTP
  Widget _createNoOTP() {
    return Container(
      alignment: Alignment.center,
      margin: marginTop30,
      child: Text(
        'Chưa Nhận Được Mã OTP?',
        style: TextStyle(fontSize: font16, color: loginBaseColor),
      ),
    );
  }

  /// Resend OTP
  Widget _createResendOTP() {
    return Container(
        margin: marginTop20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            !resent
                ? Text(
                    'Gửi OTP Lại',
                    style: TextStyle(fontSize: font16, color: loginBaseColor),
                  )
                : InkWell(
                    onTap: () {
                      /// If count is 5 times, system will temporally lock this number for 5 hours.
                      count++;

                      if (count == 5) {
                        timesDelay *= 5;
                      }

                      /// Call API send OTP
                      sendOTP(postCode, phoneNumber);
                    },
                    child: Text(
                      'Gửi OTP Lại',
                      style: TextStyle(fontSize: font16, color: primaryColor),
                    ),
                  ),
//            Text(
//              ' | ',
//              style: TextStyle(color: primaryColor),
//            ),
//
//            /// Change number
//            InkWell(
//              onTap: () => popScreen(context),
//              child: Text('Thay Đổi Số',
//                  style: TextStyle(fontSize: font16, color: primaryColor)),
//            ),
          ],
        ));
  }

  /// OTP
  Widget _createOTPTitle() {
    return Container(
        alignment: Alignment.topLeft,
        margin: EdgeInsets.only(top: margin20),
        child: Row(
          children: <Widget>[
            Text(
              'Nhập Mã OTP',
              style: TextStyle(fontSize: 30),
            ),
            Container(
              margin: marginLeft10,
              child: Text(phoneVal,
                  style: TextStyle(
                      fontSize: 30,
                      color: primaryColor,
                      fontWeight: FontWeight.bold)),
            )
          ],
        ));
  }

  /// Back icon
  Widget _createBackIcon() {
    return Container(
        alignment: Alignment.topLeft,
        child: InkWell(
          onTap: () {
            popScreen(context);
          },
          child: Icon(
            Icons.navigate_before,
            size: 30,
          ),
        ));
  }

  void verifyOTP(String requestId, String code) async {
    LoadingDialog.instance.showLoadingDialog(context);
    Map<String, String> data = Map();
    data['requestId'] = requestId;
    data['code'] = code;
    Result<dynamic> result =
        await verifyOTPRequest.callRequest(context, data: data);
    print(result);
    await LoadingDialog.instance.dismissLoading();

    if (result.isSuccess()) {
      Map<String, dynamic> args = Map();
      args[LoginConstants.POST_CODE] = postCode;
      args[LoginConstants.PHONE_NUMBER] = phoneNumber;

      /// Go to new password screen
      pushScreen(BaseWidget(screen: Screens.NEW_PASSWORD, arguments: args),
          Screens.NEW_PASSWORD);
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

  void sendOTP(String postCode, String phoneNumber) async {
    LoadingDialog.instance.showLoadingDialog(context);
    Map<String, String> data = Map();
    data['postCode'] = postCode;
    data['phone'] = phoneNumber;
    Result<dynamic> result = await otpRequest.callRequest(context, data: data);
    print(result);
    requestId = result.data.data.requestId;

    Preferences.saveRequestId(requestId);

    await LoadingDialog.instance.dismissLoading();

    if (result.isSuccess()) {
      setState(() {
        resent = false;
      });

      /// Delay for next time send OTP.
      _handleTimer();

      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
              'Mã OTP đang gửi về thiết bị của bạn, vui lòng chờ ít giây.')));
    } else {
      Error error = result.error;
      MessageDialog.instance.showMessageOkDialog(
          context, '', error.message, 'assets/images/failure.png');
    }
  }

  void cancelOTP(String requestId) async {
    LoadingDialog.instance.showLoadingDialog(context);
    Map<String, String> data = Map();
    data['requestId'] = requestId;
    Result<dynamic> result =
        await cancelOTPRequest.callRequest(context, data: data);
    print(result);
    await LoadingDialog.instance.dismissLoading();

    if (result.isSuccess()) {
      resent = true;

      /// Update state
      setState(() {});
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Yêu cầu gửi OTP đã huỷ bỏ vui lòng thử lại.')));
    }
  }

  void _handleTimer() {
    const oneSec = const Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (Timer timer) {
      if (timesDelay < 1) {
        timer.cancel();
        resent = true;
        timesDelay = 180;
      } else {
        timesDelay = timesDelay - 1;
      }

      /// Update state
      setState(() {});
    });
  }

  @override
  Key onInitKey(BuildContext context) {
    return _scaffoldKey;
  }
}
