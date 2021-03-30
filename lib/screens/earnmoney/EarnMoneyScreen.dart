import 'dart:io';

import 'package:ads/ads.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trans/identifiers/Screens.dart';
import 'package:trans/base/screen/BaseScreen.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/config.dart';
import 'package:trans/preferences/Preferences.dart';
import 'package:firebase_admob/firebase_admob.dart';

class EarnMoneyScreen extends BaseScreen {
  int totalCoins;
  int initOption = 1;
  Ads ads;

  static String idScreenUnit = 'ca-app-pub-6266170585060190/9389147199';

  final String screenUnitId = Platform.isAndroid ? idScreenUnit : idScreenUnit;

  static String idVideoAd = 'ca-app-pub-6266170585060190/9389147199';
  final String appId = Platform.isAndroid ? Config.adUnitID : Config.adUnitID;
  final String videoUnitId = Platform.isAndroid ? idVideoAd : idVideoAd;

  void initState() {
    super.initState();

    /**
     * Get total coins
     */
    _getTotalCoins();
    /**
     * Init ads
     */
    _initAds();
  }

  _initAds() {
    switch (initOption) {
      case 1:

        /// Assign a listener.
        var eventListener = (MobileAdEvent event) {
          if (event == MobileAdEvent.clicked) {
            print("The opened ad is clicked on.");
          }
        };

        ads = Ads(
          appId,
          screenUnitId: screenUnitId,
          videoUnitId: videoUnitId,
          keywords: <String>['ibm', 'computers'],
          contentUrl: 'http://www.ibm.com',
          childDirected: false,
          testDevices: ['Samsung_Galaxy_SII_API_26:5554'],
          testing: false,
          listener: eventListener,
        );

        break;

      case 2:
        ads = Ads(appId);

        /// Assign the listener.
        var eventListener = (MobileAdEvent event) {
          if (event == MobileAdEvent.closed) {
            print("User has opened and now closed the ad.");
          }
        };

        /// You can set the Banner, Fullscreen and Video Ads separately.

        ads.setBannerAd(
          size: AdSize.banner,
          keywords: ['andriod, flutter'],
          contentUrl: 'http://www.andrioussolutions.com',
          childDirected: false,
          testDevices: ['Samsung_Galaxy_SII_API_26:5554'],
          listener: eventListener,
        );

        ads.setFullScreenAd(
            adUnitId: screenUnitId,
            keywords: ['dart', 'flutter'],
            contentUrl: 'http://www.fluttertogo.com',
            childDirected: false,
            testDevices: ['Samsung_Galaxy_SII_API_26:5554'],
            listener: (MobileAdEvent event) {
              if (event == MobileAdEvent.opened) {
                print("An ad has opened up.");
              }
            });

        var videoListener = (RewardedVideoAdEvent event,
            {String rewardType, int rewardAmount}) {
          if (event == RewardedVideoAdEvent.rewarded) {
            print("The video ad has been rewarded.");
          }
        };

        ads.setVideoAd(
          adUnitId: videoUnitId,
          keywords: ['dart', 'java'],
          contentUrl: 'http://www.publang.org',
          childDirected: true,
          testDevices: null,
          listener: videoListener,
        );

        break;

      case 3:
        ads = Ads(appId);

        /// Assign the listener.
        var eventListener = (MobileAdEvent event) {
          if (event == MobileAdEvent.closed) {
            print("User has opened and now closed the ad.");
          }
        };

        /// You just show the Banner, Fullscreen and Video Ads separately.

        ads.showBannerAd(
          size: AdSize.banner,
          keywords: ['andriod, flutter'],
          contentUrl: 'http://www.andrioussolutions.com',
          childDirected: false,
          testDevices: ['Samsung_Galaxy_SII_API_26:5554'],
          listener: eventListener,
        );

        ads.showFullScreenAd(
            adUnitId: screenUnitId,
            keywords: ['dart', 'flutter'],
            contentUrl: 'http://www.fluttertogo.com',
            childDirected: false,
            testDevices: ['Samsung_Galaxy_SII_API_26:5554'],
            listener: (MobileAdEvent event) {
              if (event == MobileAdEvent.opened) {
                print("An ad has opened up.");
              }
            });

        var videoListener = (RewardedVideoAdEvent event,
            {String rewardType, int rewardAmount}) {
          if (event == RewardedVideoAdEvent.rewarded) {
            print("The video ad has been rewarded.");
          }
        };

        ads.showVideoAd(
          adUnitId: videoUnitId,
          keywords: ['dart', 'java'],
          contentUrl: 'http://www.publang.org',
          childDirected: true,
          testDevices: null,
          listener: videoListener,
        );

        break;

      default:
        ads = Ads(appId, testing: true);
    }
  }

  _getTotalCoins() async {
    totalCoins = await Preferences.getCoin();
    if (totalCoins == null) {
      return;
    }

    /// Update coins
    setState(() {});
  }

  @override
  Widget onInitBody(BuildContext context) {
    return Column(
      children: <Widget>[
        /// Create header widget
        _createHeaderWidget(),

        /// Create list widget
        _createListWidget(),
      ],
    );
  }

  Widget _createListWidget() {
    return Expanded(
      child: ListView(
        children: <Widget>[
//          _itemCheckIn('DAILY CHECK-INS', Icons.today, callback: () {
//            pushScreen(BaseWidget(screen: Screens.DAILY), Screens.DAILY);
//          }),
          _itemCheckIn('WATCH VIDEO', Icons.play_circle_outline, callback: () {
            ads.showVideoAd(state: this);
          }),
          _itemCheckIn('SMALL AD', Icons.donut_small, callback: () {
            ads.showFullScreenAd(state: this);
          }),
        ],
      ),
    );
  }

  Widget _itemCheckIn(String title, IconData iconData, {Function() callback}) {
    return GestureDetector(
        onTap: () {
          if (callback == null) {
            return;
          }

          callback();
        },
        child: Card(
            elevation: 4,
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Container(
                padding: paddingAll20,
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 118, 212, 193),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Icon(iconData, color: Colors.white),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 10),
                      child: Text(title,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ))));
  }

  Widget _createHeaderWidget() {
    var backgroundDecoration = BoxDecoration(
        color: Color.fromARGB(255, 80, 70, 154),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)));

    return Container(
      decoration: backgroundDecoration,
      constraints: BoxConstraints.expand(height: 150),
      child: Column(
        children: <Widget>[
          /// Create header icons
          _createHeaderIcons(),

          /// Create total coins widget
//          _createTotalCoinsWidget(),
        ],
      ),
    );
  }

  Widget _createTotalCoinsWidget() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
              child: Text('Coins tích luỹ',
                  style: TextStyle(color: Colors.white, fontSize: 22))),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(totalCoins.toString() ?? '0',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontStyle: FontStyle.italic)),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Image.asset('assets/images/coin.png',
                      height: 26, width: 26),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _createHeaderIcons() {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(left: 10, right: 10, top: 20),
      child: BouncingWidget(
        onPressed: () {
          popScreen(context);
        },
        child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: Colors.white38),
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Icon(Icons.keyboard_backspace, color: Colors.white),
        ),
      ),
    );
  }
}
