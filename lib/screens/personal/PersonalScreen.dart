import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:trans/identifiers/Screens.dart';
import 'package:trans/api/request/LogoutRequest.dart';
import 'package:trans/api/result/Error.dart';
import 'package:trans/api/result/Result.dart';
import 'package:trans/api/result/User.dart';
import 'package:trans/base/screen/BaseScreen.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/dialog/confirm/ConfirmDialog.dart';
import 'package:trans/dialog/loading/LoadingDialog.dart';
import 'package:trans/dialog/message/MessageDialog.dart';
import 'package:trans/preferences/Preferences.dart';
import 'package:trans/screens/main/MainScreen.dart';
import 'package:trans/screens/personal/widgets/PersonalBottomWidget.dart';
import 'package:trans/screens/personal/widgets/PersonalHeaderWidget.dart';
import 'package:trans/utils/image/ImageNetworkUtil.dart';

class PersonalConstants {
  static const String LINK =
      'https://play.google.com/store/apps/details?id=com.vcs.trans';

  static const String USER_DATA = 'user data';
}

class PersonalScreen extends BaseScreen {
  User _currentUser;
  LogoutRequest logoutRequest = LogoutRequest();
  String displayName = '';
  String phoneNumber = '';
  String avatar;

  /// Args
  Map args = Map();

  /// Map callback
  Map mapCallback;

  @override
  void initState() {
    super.initState();

    mapCallback = widget.arguments;

    /// Init data
    initData();
  }

  void initData() {
    Preferences.getUser().then((value) {
      if (value == null) {
        return;
      }
      _currentUser = User.fromJson(jsonDecode(value));
      displayName = _currentUser.data.displayName;
      phoneNumber = _currentUser.data.phone;
      avatar = _currentUser.data.avatar;
      if (!mounted) {
        return;
      }

      /// Update new data
      setState(() {});

      args[PersonalConstants.USER_DATA] = _currentUser;
    });
  }

  @override
  Widget onInitBody(BuildContext context) {
    return Column(
      children: <Widget>[
        /// Personal header widget
        PersonalHeaderWidget(title: 'Thông tin cá nhân'),

        Expanded(
          child: ListView(
            children: <Widget>[
              /// Create avatar widget
              _createAvatarWidget(),

              /// Size box
              SizedBox(height: 10),

              /// Create change personal information
              _createActionWidget(
                  'Thay đổi thông tin cá nhân', 'assets/images/change_info.png',
                  callback: () async {
                /// Go to change info
                var result = await pushScreen(
                    BaseWidget(screen: Screens.CHANGE_INFO, arguments: args),
                    Screens.CHANGE_INFO);
                if (result == null) {
                  return;
                }
                if (!mounted) {
                  return;
                }

                /// Update new data
                setState(() {
                  _currentUser = result;
                });
              }),

              /// Create change pass word
              _createActionWidget(
                  'Đổi mật khẩu', 'assets/images/change_password.png',
                  callback: () {
                /// Go to change password
                pushScreen(
                    BaseWidget(
                        screen: Screens.CHANGE_PASSWORD, arguments: args),
                    Screens.CHANGE_PASSWORD);
              }),

              /// Create current version
              _createActionWidget(
                  'Phiên bản hiện tại', 'assets/images/version.png'),

              /// Create about vcs
              _createActionWidget('Về VCS', 'assets/images/about.jpeg',
                  callback: () {
                /// Go to about vcs
                pushScreen(BaseWidget(screen: Screens.ABOUT), Screens.ABOUT);
              }),

              /// Create log out
              _createActionWidget('Đăng xuất', 'assets/images/logout.png',
                  callback: () async {
                /// Show dialog logout
                ConfirmDialog.instance.showMessageYesNoDialog(
                    context,
                    '',
                    'Bạn muốn đăng xuất tài khoản này ?',
                    'assets/images/success.png', yesCallback: () {
                  /**
                       * Handle log out
                       */
                  handleLogout();
                });
              }),

              /// Bottom personal widget
              PersonalBottomWidget(),
            ],
          ),
        ),
      ],
    );
  }

  Future<bool> removeData() async {
    Preferences.removeToken();
    Preferences.removeUser();
    Preferences.removeRequestId();
    Preferences.removePackages();
    Preferences.removePath();
    return true;
  }

  /// Action widget
  Widget _createActionWidget(String title, String imagePath,
      {Function callback}) {
    return InkWell(
        onTap: () {
          if (callback == null) {
            return;
          }
          callback();
        },
        child: Container(
          padding: paddingAll10,
          child: Row(
            children: <Widget>[
              Image.asset(imagePath, height: 24, width: 24),
              Container(
                margin: marginLeft10,
                child: Text(
                  title,
                  style: TextStyle(fontSize: font16),
                ),
              ),
            ],
          ),
        ));
  }

  /// Avatar widget
  Widget _createAvatarWidget() {
    if (avatar == null) {
      return Container();
    }
    return Container(
        margin: EdgeInsets.only(top: margin10, left: margin10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                width: 100,
                height: 100,
                child: ImageNetworkUtil.loadImageAllCorner(
                    'http://18.191.111.162:3000/$avatar', 50.0,
                    failLink: 'assets/images/avatar_empty.png')),
            Container(
                margin: marginLeft10,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      /// Display name
                      Container(
                          child: Text(displayName,
                              style: TextStyle(
                                  fontSize: font16,
                                  fontWeight: FontWeight.bold))),

                      /// Phone
                      Container(
                        margin: marginTop10,
                        child: Text(phoneNumber,
                            style: TextStyle(fontSize: font16)),
                      ),
                    ]))
          ],
        ));
  }

  void handleLogout() async {
    LoadingDialog.instance.showLoadingDialog(context);
    Result<dynamic> result = await logoutRequest.callRequest(context);
    print(result);
    await LoadingDialog.instance.dismissLoading();

    if (result.isSuccess()) {
      /// Remove data stored cache
      await removeData();
      var logoutCallback = mapCallback[MainConstants.LOGOUT_CALLBACK];
      logoutCallback();
    } else {
      Error error = result.error;
      MessageDialog.instance.showMessageOkDialog(
          context, '', error.message, 'assets/images/failure.png');
    }
  }

  @override
  BoxDecoration onInitBackground(BuildContext context) {
    return BoxDecoration(color: Color(0xffFAFAFA));
  }
}
