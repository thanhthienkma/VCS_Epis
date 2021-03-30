import 'dart:async';
import 'package:flutter/material.dart';
import 'package:trans/base/screen/BaseScreen.dart';
import 'package:trans/identifiers/Screens.dart';
import 'package:trans/preferences/Preferences.dart';
import 'package:trans/screens/main/widgets/MainBottomWidget.dart';
import 'package:trans/screens/news/NewsScreen.dart';

class MainConstants {
  static const HOME_INDEX = 0;
  static const NEWS_INDEX = 1;
  static const SHOPPING_INDEX = 2;
  static const PERSONAL_INDEX = 3;

  static const String MORNING = 'Chào buổi sáng';
  static const String AFTERNOON = 'Chào buổi trưa';
  static const String EVENING = 'Chào buổi chiều';
  static const String NIGHT = 'Chào buổi tối';

  static const String HOME_KEY = 'home';
  static const String NEWS_KEY = 'news';
  static const String SHOPPING_KEY = 'shopping';
  static const String PERSONAL_KEY = 'personal';

  static const HOME_CALLBACK = 'home callback';
  static const BOTTOM_STREAM = 'bottom stream';
  static const SHOPPING_CALLBACK = 'shopping callback';
  static const NEWS_CALLBACK = 'news callback';
  static const PERSONAL_CALLBACK = 'personal callback';
  static const LOGOUT_CALLBACK = 'log out callback';
}

class MainScreen extends BaseScreen {
  final PageController _pageController =
      PageController(initialPage: 0, keepPage: true);
  StreamController bottomStream = StreamController<String>.broadcast();

  /// Args
  Map<String, dynamic> args = Map();

  /// Map callback
  Map mapCallback = Map();

  /// Init value as Home Key
  String value = MainConstants.HOME_KEY;

  String newsKey = 'news';

  String token;

  @override
  void initState() {
    super.initState();

    /**
     *  Init data
     */
    _initData();
    /**
     * Handle callback
     */
    _handleCallback();
  }

  _initData() async {
    token = await Preferences.getToken();

    if (widget.arguments == newsKey) {
      Future.delayed(Duration.zero, () {
        _pageController.animateTo(1,
            duration: Duration(milliseconds: 100), curve: Curves.ease);
        bottomStream.sink.add(newsKey);
      });
    }
  }

  _switchBottom(int value) {
    _pageController.animateToPage(value,
        duration: Duration(milliseconds: 100), curve: Curves.ease);
  }

  _handleCallback() {
    mapCallback[MainConstants.HOME_CALLBACK] = (String key) {
      /// Switch to home screen
      _switchBottom(MainConstants.HOME_INDEX);
      value = key;
    };
    mapCallback[MainConstants.NEWS_CALLBACK] = (String key) {
      /// Switch to news screen
      _switchBottom(MainConstants.NEWS_INDEX);

      value = key;
    };
    mapCallback[MainConstants.SHOPPING_CALLBACK] = (String key) {
      /// Switch to shopping screen
      _switchBottom(MainConstants.SHOPPING_INDEX);
      value = key;
    };

    mapCallback[MainConstants.PERSONAL_CALLBACK] = (String key) {
      /// Check authorize
      _checkAuthorize();
    };
    mapCallback[MainConstants.LOGOUT_CALLBACK] = () {
      /// Log out
      _logoutAction();
    };
  }

  _logoutAction() {
    print('_logoutAction');
    _pageController.jumpToPage(MainConstants.HOME_INDEX);
    _pageController.animateToPage(MainConstants.HOME_INDEX,
        duration: Duration(milliseconds: 100), curve: Curves.ease);
    bottomStream.sink.add(MainConstants.HOME_KEY);
    token = '';
  }

  _checkAuthorize() async {
    if (token == null || token.isEmpty) {
      var result = await pushScreen(
          BaseWidget(screen: Screens.PHONE, arguments: value), Screens.PHONE);
      bottomStream.sink.add(result);
    } else {
      /// Switch to profile screen
      _pageController.jumpToPage(MainConstants.PERSONAL_INDEX);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    bottomStream.close();
  }

  @override
  Widget onInitBody(BuildContext context) {
    return Column(
      children: <Widget>[
        /// Create body
        _createBody(),

        /// Create bottom navigation
        _createBottomNavigation(),
      ],
    );
  }

  /// Body
  Widget _createBody() {
    /// Map to stream
    args[MainConstants.BOTTOM_STREAM] = bottomStream;

    /// Map to shopping callback
    args[MainConstants.SHOPPING_CALLBACK] = (indexOfShopping) {
      if (indexOfShopping == null) {
        return;
      }
      _pageController.jumpToPage(indexOfShopping);
    };

    /// Map to news callback
    args[MainConstants.NEWS_CALLBACK] = (indexOfNews) {
      if (indexOfNews == null) {
        return;
      }
      _pageController.jumpToPage(indexOfNews);
    };

    /// Initialize list of screens
    List<Widget> _pages = [
      BaseWidget(screen: Screens.HOME, arguments: this.args),
      NewsScreen(),
      BaseWidget(screen: Screens.SHOPPING),
      BaseWidget(screen: Screens.PERSONAL, arguments: this.mapCallback),
    ];

    return Expanded(
      child: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: _pages,
      ),
    );
  }

  /// Bottom navigation
  Widget _createBottomNavigation() {
    return MainBottomWidget(
        bottomStream: this.bottomStream, mapCallback: this.mapCallback);
  }
}
