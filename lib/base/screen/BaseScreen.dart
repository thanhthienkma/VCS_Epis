import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trans/api/connector/Connector.dart';
import 'package:trans/api/result/Result.dart';
import 'package:trans/base/slide/SlideRoute.dart';
import 'package:trans/identifiers/Screens.dart';
import 'package:trans/components/classfooter/ClassicFooterComponent.dart';
import 'package:trans/components/refreshwaterdrop/RefreshWaterDropComponent.dart';
import 'package:trans/dialog/message/MessageDialog.dart';
import 'package:trans/api/result/Error.dart';

class BaseWidget extends StatefulWidget {
  final dynamic arguments;
  final String screen;

  BaseWidget({this.screen, this.arguments});

  /// This function is re-called.
  @override
  State<StatefulWidget> createState() {
    return Screens.instance.initScreen(screen: this.screen);
  }
}

abstract class BaseScreen extends State<BaseWidget> {
  /// Status of keyboard show or hide.
//  var isKeyboardOpen = false;

  @override
  Widget build(BuildContext context) {
    print('BaseScreen build');
    return WillPopScope(
        onWillPop: _handleBackPress,
        child: GestureDetector(
            onTap: () {
              /// If keyboard is showing
              /// Call this method here to hide soft keyboard when touching outside keyboard.
//              if(isKeyboardOpen) {
//                print('BaseScreen $isKeyboardOpen');
              FocusScope.of(context).requestFocus(FocusNode());
//              }
              onTapScreen();
            },
            child: Container(
                decoration: onInitBackground(context),
                child: SafeArea(
                  child: Scaffold(
                    key: onInitKey(context),
                    appBar: onInitAppBar(context),
                    body: onInitBody(context),
                    bottomNavigationBar: onInitBottomNavigationBar(context),
                    floatingActionButton: onInitFloatingActionButton(context),
                    floatingActionButtonLocation:
                        onInitFloatingActionButtonLocation(context),
                    drawer: onInitDrawer(context),
                    endDrawer: onInitEndDrawer(context),
                    bottomSheet: onInitBottomSheet(context),
                    backgroundColor: Colors.transparent,
                    resizeToAvoidBottomPadding:
                        onInitResizeToAvoidBottomPadding(context),
                    primary: onInitPrimary(context),
                  ),
                ))));
  }

  /// Event tap on screen
  void onTapScreen() {}

  /// Handle back button of hardware.
  Future<bool> _handleBackPress() async {
    /// Nothing to do.
    onBackPress();

    /// Prevent back event
    return false;
  }

  /// Handle back button of hardware.
  void onBackPress() async {
    /// Nothing to do.
  }

  /// Default background is white
  BoxDecoration onInitBackground(BuildContext context) {
    return BoxDecoration(color: Colors.white);
  }

  Key onInitKey(BuildContext context) {
    return null;
  }

  PreferredSize onInitAppBar(BuildContext context) {
    /// Default appbar is transparent.
    return PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ));
  }

  Widget onInitFloatingActionButton(BuildContext context) {
    return null;
  }

  FloatingActionButtonLocation onInitFloatingActionButtonLocation(
      BuildContext context) {
    return null;
  }

  Widget onInitBody(BuildContext context);

  Widget onInitDrawer(BuildContext context) {
    return null;
  }

  Widget onInitEndDrawer(BuildContext context) {
    return null;
  }

  Widget onInitBottomNavigationBar(BuildContext context) {
    return null;
  }

  Widget onInitBottomSheet(BuildContext context) {
    return null;
  }

  bool onInitResizeToAvoidBottomPadding(BuildContext context) {
    return true;
  }

  bool onInitPrimary(BuildContext context) {
    return true;
  }

  /// Start screen
  dynamic pushScreen(Widget widget, String screen) async {
    return await Navigator.push(
        context, SlideRoute(widget: widget, screen: screen));
  }

  /// Start with replacement screen
  dynamic pushReplaceScreen(Widget widget, String screen) async {
    return await Navigator.pushReplacement(
        context, SlideRoute(widget: widget, screen: screen));
  }

  /// Start with replace all screen
  dynamic pushReplaceAllScreen(Widget widget, String screen) async {
    return await Navigator.of(context).pushAndRemoveUntil(
        SlideRoute(widget: widget, screen: screen),
        (Route<dynamic> route) => false);
  }

  /// Back screen.
  void popScreen(BuildContext context, {dynamic data}) {
    if (data == null) {
      Navigator.pop(context);
    } else {
      Navigator.pop(context, data);
    }
  }

//  /// Show no internet dialog
//  void showNoInternetDialog() {
//    MessageDialog.instance.showMessageOkDialog(
//        context,
//        Languages.of(context).getString(Languages.BAS_FAILURE),
//        Languages.of(context).getString(Languages.BAS_PLEASE_CHECK_INTERNET),
//        'assets/images/failure.png');
//  }
//
//  /// Show no authentication dialog
//  void showNoAuthenticationDialog() {
//    MessageDialog.instance.showMessageOkDialog(
//        context,
//        Languages.of(context).getString(Languages.BAS_FAILURE),
//        Languages.of(context).getString(Languages.BAS_NO_AUTHENTICATION),
//        'assets/images/failure.png', callback: () async {
//      logout();
//    });
//  }
//
//  /// Logout
//  void logout() async {
//    String languageCode = await Preference.getLanguageCode();
//    Map args = Map();
//    args['languagecode'] = languageCode;
//    await removeData();
//    pushReplaceAllScreen(BaseWidget(screen: Screens.LOGIN, arguments: args), Screens.LOGIN);
//  }
//
//  /// Remove data
//  Future<bool> removeData() async {
//    Preference.saveSession(null);
//    Preference.savePin(null);
//    Preference.saveMe(null);
//    Preference.saveFingerPrintOrFaceID(false);
////    Preference.saveNewLogin(false);
////    Preference.saveFirebaseToken('');
//    return true;
//  }

  /// Create refresh water drop widget
  Widget createRefreshWaterDropWidget() {
    Map styles = Map();
    styles['water_drop_color'] = "#4B9DF4";
    styles['idle_icon_color'] = "#FFFFFF";
    styles['loading_color'] = "#4B9DF4";
    styles['complete_color'] = "#4B9DF4";
    styles['fail_color'] = "#4B9DF4";

    Map strings = Map();
    strings['load_completed_text'] = 'Load completed';
    strings['load_failed_text'] = 'Load failed';

    return RefreshWaterDropComponent(stylesColor: styles, strings: strings);
  }

  /// Create load classic widget
  Widget createLoadClassicWidget() {
    Map styles = Map();
    styles['can_loading_color'] = "#4B9DF4";
    styles['loading_color'] = "#4B9DF4";
    styles['idle_loading_color'] = "#4B9DF4";
    styles['fail_color'] = "#4B9DF4";
    Map strings = Map();
    strings['can_loading_text'] = 'Release to load more';
    strings['load_failed_text'] = 'Load failed';
    strings['idle_loading_text'] = 'Pull up load more';

    return ClassicFooterComponent(
      stylesColor: styles,
      strings: strings,
      loadStyle: LoadStyle.ShowWhenLoading,
      completeDuration: Duration(milliseconds: 500),
    );
  }

  /// Handle API request error
  void handleAPIRequestError(BuildContext context, Result result,
      {Function callback}) async {
    if (result.error == null) {
      return;
    }
    if (result.code == ConnectorConstants.NO_INTERNET) {
      MessageDialog.instance.showMessageOkDialog(context, 'Không thành công',
          'Vui lòng kiểm tra đường truyền mạng', 'assets/images/failure.png',
          callback: callback);
    } else if (result.code == ConnectorConstants.EXPIRE) {
      MessageDialog.instance.showMessageOkDialog(
          context,
          'Không thành công',
          'Không thể xác thực tài khoản',
          'assets/images/failure.png', callback: () async {
//        logout();
      });
    } else if (result.code == ConnectorConstants.NOT_FOUND) {
      MessageDialog.instance.showMessageOkDialog(context, 'Không thành công',
          'Có lỗi xảy ra trong hệ thống', 'assets/images/failure.png',
          callback: callback);
    } else if (result.isOtherError()) {
      Error error = result.error;
      String message = '';
      if (error.message != null) {
        message = error.message;
      }
      MessageDialog.instance.showMessageOkDialog(
          context, 'Không thành công', message, 'assets/images/failure.png',
          callback: callback);
    }
  }
}
