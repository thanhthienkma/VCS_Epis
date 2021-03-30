import 'package:utils/utils.dart';

class PreferencesConstant {
  static const String TOKEN = 'token';
  static const String USER = 'user';
  static const String PACKAGES = 'packages';
  static const String PREPARE_ORDER_SUPPORT = 'request ID';
  static const String LOCATION = 'location';
  static const String PATH = 'path';
  static const String COIN = 'coin';
  static const String TIMES = 'times';
}

class Preferences {
  /// Save token
  static Future<void> saveToken(String value) async {
    await Utils.saveStringValue(PreferencesConstant.TOKEN, value);
  }

  /// Get token
  static Future<String> getToken() async {
    return Utils.getStringValue(PreferencesConstant.TOKEN);
  }

  /// Remove token
  static Future<bool> removeToken() async {
    return Utils.removeValue(PreferencesConstant.TOKEN);
  }

  /// Save user
  static Future<void> saveUser(String value) async {
    await Utils.saveStringValue(PreferencesConstant.USER, value);
  }

  /// Get user
  static Future<String> getUser() async {
    return Utils.getStringValue(PreferencesConstant.USER);
  }

  /// Remove user
  static Future<bool> removeUser() async {
    return Utils.removeValue(PreferencesConstant.USER);
  }

  /// Remove packages
  static Future<bool> removePackages() async {
    return Utils.removeValue(PreferencesConstant.PACKAGES);
  }

  /// Save request ID
  static Future<void> saveRequestId(String value) async {
    await Utils.saveStringValue(
        PreferencesConstant.PREPARE_ORDER_SUPPORT, value);
  }

  /// Get request ID
  static Future<String> getRequestId() async {
    return Utils.getStringValue(PreferencesConstant.PREPARE_ORDER_SUPPORT);
  }

  /// Remove request ID
  static Future<String> removeRequestId() async {
    return Utils.getStringValue(PreferencesConstant.PREPARE_ORDER_SUPPORT);
  }

  /// Save path
  static Future<void> savePath(String value) async {
    await Utils.saveStringValue(PreferencesConstant.PATH, value);
  }

  /// Get path
  static Future<String> getPath() async {
    return Utils.getStringValue(PreferencesConstant.PATH);
  }

  /// Remove path
  static Future<String> removePath() async {
    return Utils.getStringValue(PreferencesConstant.PATH);
  }

  /// Save coin
  static Future<void> saveCoin(int value) async {
    await Utils.saveIntValue(PreferencesConstant.COIN, value);
  }

  /// Get coin
  static Future<int> getCoin() async {
    return Utils.getIntValue(PreferencesConstant.COIN);
  }

  /// Save times
  static Future<void> saveTimes(int value) async {
    await Utils.saveIntValue(PreferencesConstant.TIMES, value);
  }

  /// Get times
  static Future<int> getTimes() async {
    return Utils.getIntValue(PreferencesConstant.TIMES);
  }

  /// Remove times
  static Future<int> removeTimes() async {
    return Utils.getIntValue(PreferencesConstant.TIMES);
  }

  /// Save prepare order support
  static Future<void> savePrepareOrderSupport(String value) async {
    await Utils.saveStringValue(
        PreferencesConstant.PREPARE_ORDER_SUPPORT, value);
  }

  /// Get prepare order support
  static Future<String> getPrepareOrderSupport() async {
    return Utils.getStringValue(PreferencesConstant.PREPARE_ORDER_SUPPORT);
  }

  /// Remove prepare order support
  static Future<String> removePrepareOrderSupport() async {
    return Utils.getStringValue(PreferencesConstant.PREPARE_ORDER_SUPPORT);
  }
}
