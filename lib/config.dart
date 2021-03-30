//import 'package:firebase_admob/firebase_admob.dart';

class Config {
  /// Define your WordPress API url here
  static final apiEndpoint = 'https://vcs-vn.com.au/wp-json/wp/v2';

  /// Define your default color (light or dark)
  // static final defaultColor = 'dark';
  static final defaultColor = 'light';

  /// Define category IDs which you want to exclude
  static final excludeCategories = [1, 26];

  //static final excludeCategories = [];

  /// Enable push notifications
  static final pushNotificationsEnabled = true;

  /// AdMob settings
  static final adMobEnabled = true;
  static final adMobiOSAppID = 'ca-app-pub-6266170585060190/1750835568';
  static final adMobAndroidID = 'ca-app-pub-6266170585060190/3765790669';

//  static final adMobAdUnitID = BannerAd.testAdUnitId;
  static final adMobPosition = 'top';

  static const adUnitID = 'ca-app-pub-6266170585060190/6038368231';
}
