import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/screens/main/MainScreen.dart';

class MainBottomWidget extends StatefulWidget {
  final Map mapCallback;
  final StreamController bottomStream;

  const MainBottomWidget({this.mapCallback, this.bottomStream});

  @override
  State<StatefulWidget> createState() => _MainBottomWidgetState();
}

class _MainBottomWidgetState extends State<MainBottomWidget> {
  Color color;
  String key = MainConstants.HOME_KEY;

  @override
  void initState() {
    super.initState();

    /// Listen data to update status
    widget.bottomStream.stream.listen((value) {
      if (value == null) {
        return;
      }

      if (value == MainConstants.NEWS_KEY) {
        key = value;
      } else {
        key = value;
      }

      if (!mounted) {
        return;
      }

      /// Update new key
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets padding = MediaQuery.of(context).padding;

    return Container(
        padding: EdgeInsets.only(bottom: padding.bottom / 2),
        child: Stack(
          children: <Widget>[
            Card(
              margin: marginAll0,
              shadowColor: Colors.black,
              elevation: 20,
              child: Container(height: 20),
            ),
            Container(
              color: Colors.white,
              margin: marginTop10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  /// Home
                  _bottomItem(
                      title: 'Trang chủ',
                      imagePath: 'assets/images/home.png',
                      defaultKey: MainConstants.HOME_KEY,
                      key: key,
                      callback: () {
                        setState(() {
                          key = MainConstants.HOME_KEY;
                        });

                        var homeCallback =
                            widget.mapCallback[MainConstants.HOME_CALLBACK];
                        homeCallback(key);
                      }),

                  /// News
                  _bottomItem(
                      title: 'Tin tức',
                      imagePath: 'assets/images/news.png',
                      defaultKey: MainConstants.NEWS_KEY,
                      key: key,
                      callback: () {
                        setState(() {
                          key = MainConstants.NEWS_KEY;
                        });

                        var newsCallback =
                            widget.mapCallback[MainConstants.NEWS_CALLBACK];
                        newsCallback(key);
                      }),

                  /// Shopping
                  _bottomItem(
                      title: 'Mua sắm',
                      imagePath: 'assets/images/shopping.png',
                      defaultKey: MainConstants.SHOPPING_KEY,
                      key: key,
                      callback: () {
                        setState(() {
                          key = MainConstants.SHOPPING_KEY;
                        });
                        var shoppingCallback =
                            widget.mapCallback[MainConstants.SHOPPING_CALLBACK];
                        shoppingCallback(key);
                      }),

                  /// Personal
                  _bottomItem(
                      title: 'Tài khoản',
                      imagePath: 'assets/images/personal.png',
                      defaultKey: MainConstants.PERSONAL_KEY,
                      key: key,
                      callback: () {
                        setState(() {
                          key = MainConstants.PERSONAL_KEY;
                        });
                        var personalCallback =
                            widget.mapCallback[MainConstants.PERSONAL_CALLBACK];
                        personalCallback(key);
                      }),
                ],
              ),
            )
          ],
        ));
  }

  Widget _bottomItem(
      {String title,
      String key,
      String defaultKey,
      String imagePath,
      Function() callback}) {
    return InkWell(
        onTap: () => callback(),
        child: Container(
            margin: EdgeInsets.only(
                bottom: margin10, left: margin10, right: margin10),
            padding: EdgeInsets.all(8),
            decoration: key == defaultKey
                ? BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.all(Radius.circular(8)))
                : BoxDecoration(),
            child: Column(
              children: <Widget>[
                /// Path
                Image.asset(imagePath, height: 16, width: 16),

                /// Title
                Container(
                    margin: marginTop5,
                    child: Text(title,
                        style: TextStyle(
                            color: Color.fromARGB(255, 132, 205, 251),
                            fontSize: 11,
                            fontWeight: FontWeight.w500))),
              ],
            )));
  }
}
