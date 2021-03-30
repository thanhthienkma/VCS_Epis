import 'package:ads/ads.dart';
import 'package:flutter/material.dart';
import 'package:trans/base/screen/BaseScreen.dart';
import 'dart:io' show Platform;
import 'package:firebase_admob/firebase_admob.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/components/button/ButtonComponent.dart';
import 'package:trans/config.dart';
import 'package:trans/preferences/Preferences.dart';
import 'package:trans/screens/earnmoney/TimerPainter.dart';

class VideoAdScreen extends BaseScreen with TickerProviderStateMixin {
  int initOption = 1;
  int _coins = 0;
  int times;
  int count = 0;
  Ads _ads;
  bool _enable = false;
  bool _firstWatch = false;
  bool _isBack = false;
  String value;
  int maxTime = 5;
  AnimationController _controller;
  static String idVideoAd = 'ca-app-pub-6266170585060190/9389147199';
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final String appId = Platform.isAndroid ? Config.adUnitID : Config.adUnitID;
  final String videoUnitId = Platform.isAndroid ? idVideoAd : idVideoAd;

  @override
  void initState() {
    super.initState();

    value = widget.arguments;

    _enable = true;
    _isBack = true;

    /**
     * Get times
     */
//    _getTimes();
    /**
     * Init animation
     */
    _initAnimation();
  }

  @override
  void dispose() {
//    _ads.dispose();
    super.dispose();
    _controller.dispose();
  }

  _getTimes() async {
    times = await Preferences.getTimes();
    if (times == null || times == 0) {
      times = maxTime;
    }
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  _initAnimation() {
    _controller =
        AnimationController(vsync: this, duration: Duration(minutes: 1));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        _enable = true;
        _isBack = true;
        if (!mounted) {
          return;
        }
        setState(() {});
      }
    });
  }

  _initAdsVideo() {
    _ads = Ads(appId);

    var videoListener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      if (event == RewardedVideoAdEvent.rewarded) {
        print("The video ad has been rewarded.");
      }
    };

    _ads.showVideoAd(
      adUnitId: videoUnitId,
      keywords: ['dart', 'java'],
      contentUrl: 'http://www.publang.org',
      childDirected: true,
      testDevices: null,
      listener: videoListener,
    );

    VoidCallback handlerFunc = () {
      print("The opened ad was clicked on.");
    };

    _ads.banner.loadedListener = () {
      print("An ad has loaded successfully in memory.");
    };

    _ads.banner.removeLoaded(handlerFunc);

    _ads.banner.failedListener = () {
      print("An ad failed to load into memory.");
    };

    _ads.banner.removeFailed(handlerFunc);

    _ads.banner.clickedListener = () {
      print("The opened ad is clicked on.");
    };

    _ads.banner.removeClicked(handlerFunc);

    _ads.banner.impressionListener = () {
      print("The user is still looking at the ad. A new ad came up.");
    };

    _ads.banner.removeImpression(handlerFunc);

    _ads.banner.openedListener = () {
      print("You've closed an ad and returned to your app.");
    };

    _ads.banner.removeOpened(handlerFunc);

    _ads.banner.leftAppListener = () {
      print("You left the app and gone to the ad's website.");
    };

    _ads.banner.removeLeftApp(handlerFunc);

    _ads.banner.closedListener = () {
      print("You've closed an ad and returned to your app.");
    };

    _ads.banner.removeClosed(handlerFunc);

    _ads.screen.loadedListener = () {
      print("An ad has loaded into memory.");
    };

    _ads.screen.removeLoaded(handlerFunc);

    _ads.screen.failedListener = () {
      print("An ad has failed to load in memory.");
    };

    _ads.screen.removeFailed(handlerFunc);

    _ads.screen.clickedListener = () {
      print("The opened ad was clicked on.");
    };

    _ads.screen.removeClicked(handlerFunc);

    _ads.screen.impressionListener = () {
      print("You've clicked on a link in the open ad.");
    };

    _ads.screen.removeImpression(handlerFunc);

    _ads.screen.openedListener = () {
      print("The ad has opened.");
    };

    _ads.screen.removeOpened(handlerFunc);

    _ads.screen.leftAppListener = () {
      print("The user has left the app and gone to the opened ad.");
    };

    _ads.screen.leftAppListener = handlerFunc;

    _ads.screen.closedListener = () {
      print("The ad has been closed. The user returns to the app.");
    };

    _ads.screen.removeClosed(handlerFunc);

    _ads.video.loadedListener = () {
      print("An ad has loaded in memory.");
    };

    _ads.video.removeLoaded(handlerFunc);

    _ads.video.failedListener = () {
      print("An ad has failed to load in memory.");
    };

    _ads.video.removeFailed(handlerFunc);

    _ads.video.clickedListener = () {
      print("An ad has been clicked on.");
    };

    _ads.video.removeClicked(handlerFunc);

    _ads.video.openedListener = () {
      print("An ad has been opened.");
    };

    _ads.video.removeOpened(handlerFunc);

    _ads.video.leftAppListener = () {
      print("You've left the app to view the video.");
    };

    _ads.video.leftAppListener = handlerFunc;

    _ads.video.closedListener = () {
      print("The video has been closed.");

      _firstWatch = true;
      _enable = false;
      _isBack = false;
//      count++;
      setState(() {});

      /**
       * Handle count down
       */
      _handleCountDown();
    };

    _ads.video.removeClosed(handlerFunc);

    _ads.video.rewardedListener = (String rewardType, int rewardAmount) {
      print("The ad was sent a reward amount.");

//      times = maxTime--;
      _coins += rewardAmount;
      setState(() {});
    };

    RewardListener rewardHandler = (String rewardType, int rewardAmount) {
      print("This is the Rewarded Video handler");
    };

    _ads.video.removeRewarded(rewardHandler);

    _ads.video.startedListener = () {
      print("You've just started playing the Video ad.");
    };

    _ads.video.removeStarted(handlerFunc);

    _ads.video.completedListener = () {
      print("You've just finished playing the Video ad.");
    };

    _ads.video.removeCompleted(handlerFunc);
  }

  @override
  Widget onInitBody(BuildContext context) {
    return Column(children: <Widget>[
      /// Create header widget
      _createHeaderWidget(),

      /// Create times widget
//      _createTimesWidget(),

      /// Create coin widget
      _createCoinWidget(),

      /// Create count down widget
      _createCountDownWidget(),

      /// Create watch ads widget
      _createWatchAdsWidget(),
    ]);
  }

  Widget _createWatchAdsWidget() {
    return Container(
        margin: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: ButtonComponent(
          text: 'Xem quảng cáo tích coin',
          color: primaryColor,
          enable: _enable,
          onClick: () {
            /**
             * Check first watch
             */
            if (!_firstWatch) {
              _initAdsVideo();
            }
//
//            print('COUNT : $count');

            /**
             * Show video ad
             */
//            if (count == maxTime) {
//              _showMessageSnackBar(
//                  'Số lần xem ads đã hết, hãy quay lại vào ngày mai.');
//              return;
//            }

            _ads.showVideoAd(state: this);
          },
        ));
  }

  Widget _createTimesWidget() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Container(
          margin: EdgeInsets.only(right: 20),
          child: Text('Bạn còn $times lần xem ads.',
              style: TextStyle(fontSize: 18))),
    );
  }

  Widget _createCoinWidget() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Container(
          margin: EdgeInsets.only(right: 20),
          child: Text('Coins tích luỹ trong ngày : $_coins coin(s)',
              style: TextStyle(fontSize: 18, color: primaryColor))),
    );
  }

  Widget _createCountDownWidget() {
    return Container(
        height: 150,
        margin: EdgeInsets.all(20),
        child: Align(
          alignment: FractionalOffset.center,
          child: AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (BuildContext context, Widget child) {
                      return CustomPaint(
                        painter: TimerPainter(
                            animation: _controller,
                            backgroundColor: Colors.white,
                            color: Theme.of(context).accentColor),
                      );
                    },
                  ),
                ),
                Align(
                    alignment: FractionalOffset.center,
                    child: AnimatedBuilder(
                        animation: _controller,
                        builder: (_, Widget child) {
                          return Text(timerString,
                              style: TextStyle(fontSize: 20));
                        }))
              ],
            ),
          ),
        ));
  }

  Widget _createHeaderWidget() {
    return Container(
        margin: EdgeInsets.only(top: 15, left: 20, right: 20),
        child: Row(children: <Widget>[
          InkWell(
              onTap: () {
                if (_isBack == false) {
                  return;
                }

//                if (times > 0) {
//                  Preferences.saveTimes(times);
//                }

                popScreen(context, data: _coins);
              },
              child: Icon(Icons.arrow_back,
                  color: _isBack == true ? Colors.black : Colors.grey)),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                'Tích coins cho $value',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ]));
  }

  String get timerString {
    Duration duration = _controller.duration * _controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  void _handleCountDown() {
    if (_controller.isAnimating) {
      _controller.stop();
    } else {
      _controller.reverse(
          from: _controller.value == 0.0 ? 1.0 : _controller.value);
    }
  }

  void _showMessageSnackBar(String text) {
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text(text), duration: Duration(milliseconds: 2000)));
  }

  @override
  Key onInitKey(BuildContext context) {
    return _scaffoldKey;
  }
}
