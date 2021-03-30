import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:utils/model/Photo.dart';

/// Content length
const CONTENT_LENGTH_METHOD = 'content_length_method';

/// Check permission
const CHECK_PERMISSION_METHOD = 'check_permission_method';

/// Request permission
const REQUEST_PERMISSION_METHOD = 'request_permission_method';

/// All photo
const ALL_PHOTOS_METHOD = 'all_photos_method';

/// Path photo
const PHOTO_PATH_METHOD = 'photo_path_method';

/// Thumbnail image
const THUMBNAIL_METHOD = 'thumbnail_method';

/// Share photo
const SHARE_PHOTO_METHOD = 'share_photo_method';

/// Download file
const DOWNLOAD_FILE_METHOD = 'download_file_method';

/// Permission for Android
/// Camera
const ANDROID_CAMERA_PERMISSION = 'android.permission.CAMERA';

/// Write storage
const ANDROID_WRITE_EXTERNAL_STORAGE_PERMISSION = 'android.permission.WRITE_EXTERNAL_STORAGE';

/// Permission for iOS
/// Library
const IOS_PHOTO_LIBRARY_PERMISSION = 'ios.photo_library';

/// Camera
const IOS_CAMERA_PERMISSION = 'ios.camera';

/// Chanel
const CHANNEL = 'utils';

/// Checked
const String CHECKED = "checked";

/// Open setting app for iOS
const OPEN_SETTING_APP_METHOD = 'open_setting_app_method';

/// Key for preference data
const KEY = 'key';

/// Value for preference data
const VALUE = 'value';

/// Save string value
const SAVE_STRING_VALUE_METHOD = 'save_string_value_method';

/// Get string value
const GET_STRING_VALUE_METHOD = 'get_string_value_method';

/// Save int value
const SAVE_INT_VALUE_METHOD = 'save_int_value_method';

/// Get int value
const GET_INT_VALUE_METHOD = 'get_int_value_method';

/// Save double value
const SAVE_DOUBLE_VALUE_METHOD = 'save_double_value_method';

/// Get double value
const GET_DOUBLE_VALUE_METHOD = 'get_double_value_method';

/// Save bool value
const SAVE_BOOL_VALUE_METHOD = 'save_bool_value_method';

/// Get bool value
const GET_BOOL_VALUE_METHOD = 'get_bool_value_method';

/// Remove value
const REMOVE_VALUE_METHOD = 'remove_value_method';

class Utils {
  static const MethodChannel _channel = const MethodChannel(CHANNEL);




  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// Check permission method
  static Future<bool> checkPermissionsAndroid(List<String> args) async {
    return await _channel.invokeMethod(CHECK_PERMISSION_METHOD, args);
  }

  /// Check permission method
  static Future<List<dynamic>> checkPermissionsIOS(List<String> args) async {
    return await _channel.invokeMethod(CHECK_PERMISSION_METHOD, args);
  }

  /// Handle request permission
  static Future<bool> requestPermissionAndroid(List<String> args) async {
    return await _channel.invokeMethod(REQUEST_PERMISSION_METHOD, args);
  }

  /// Handle request permission
  static Future<List<dynamic>> requestPermissionIOS(List<String> args) async {
    return await _channel.invokeMethod(REQUEST_PERMISSION_METHOD, args);
  }

  /// Handle permission for access library and camera.
  static void requestPermissionLibrary(Function() callback) {
    /// Camera is selected
    if (Platform.isAndroid) {
      _haveStoragePermissionForAndroid(callback);
    } else {
      _haveLibraryPermissionForIOS(callback);
    }
  }

  /// Handle permission for access library and camera.
  static void requestPermissionLibraryAndCamera(Function() callback) {
    /// Camera is selected
    if (Platform.isAndroid) {
      _haveStorageCameraPermissionForAndroid(callback);
    } else {
      _haveLibraryCameraPermissionForIOS(callback);
    }
  }

  /// Handle storage permission
  static void _haveStoragePermissionForAndroid(Function() callback) async {
    bool checkResult = await checkPermissionsAndroid([ANDROID_WRITE_EXTERNAL_STORAGE_PERMISSION]);

    if (!checkResult) {
      /// Request permission
      bool requestResult =
          await requestPermissionAndroid([ANDROID_WRITE_EXTERNAL_STORAGE_PERMISSION]);
      if (requestResult) {
        callback();
        return;
      }
    }
    callback();
  }

  /// Handle storage camera permission
  static void _haveStorageCameraPermissionForAndroid(Function() callback) async {
    bool checkResult = await checkPermissionsAndroid(
        [ANDROID_WRITE_EXTERNAL_STORAGE_PERMISSION, ANDROID_CAMERA_PERMISSION]);

    if (!checkResult) {
      /// Request permission
      bool requestResult = await requestPermissionAndroid(
          [ANDROID_WRITE_EXTERNAL_STORAGE_PERMISSION, ANDROID_CAMERA_PERMISSION]);
      if (requestResult) {
        callback();
        return;
      }
    }
    callback();
  }

  /// Handle get all photos from storage
  static Future<String> getAllPhotos() async {
    print("getAllPhotos");
    String value = await _channel.invokeMethod(ALL_PHOTOS_METHOD);
    print("getAllPhotos $value");
    return value;
  }

  /// Handle get path from identifier
  static Future<String> getPath(String identifier) async {
    String value = await _channel.invokeMethod(PHOTO_PATH_METHOD, identifier);
    print("getPath $value");
    return value;
  }

  /// Handle thumb
  static Future<ByteData> getThumbByteData(Photo photo, int size,
      {int quality = 100, int times = 1}) async {
    assert(photo != null);
    assert(size != null);

    if (size != null && size < 0) {
      throw new ArgumentError.value(size, 'size cannot be negative');
    }

    if (quality < 0 || quality > 100) {
      throw new ArgumentError.value(quality, 'quality should be in range 0-100');
    }

    String thumbChannel = '$CHANNEL${photo.identifier}$times';

    Completer completer = new Completer<ByteData>();
    ServicesBinding.instance.defaultBinaryMessenger.setMessageHandler(thumbChannel,
        (ByteData message) async {
      completer.complete(message);
      ServicesBinding.instance.defaultBinaryMessenger.setMessageHandler(thumbChannel, null);
      return message;
    });

    await _requestThumbnail(photo, size, quality, times);
    return completer.future;
  }

  /// Requests a thumbnail with [width], [height]
  /// and [quality] for a given [identifier].
  ///
  /// This method is used by the asset class, you
  /// should not invoke it manually. For more info
  /// refer to [Asset] class docs.
  ///
  /// The actual image data is sent via BinaryChannel.
  static Future<bool> _requestThumbnail(Photo photo, int size, int quality, int times) async {
    assert(photo != null);
    assert(size != null);
    if (size != null && size < 0) {
      throw new ArgumentError.value(size, 'size cannot be negative');
    }

    if (quality < 0 || quality > 100) {
      throw new ArgumentError.value(quality, 'quality should be in range 0-100');
    }

    print('Photo ${photo.toJson().toString()}');
    try {
      bool ret = await _channel.invokeMethod(THUMBNAIL_METHOD, <String, dynamic>{
        "photo": json.encode(photo),
        "size": size,
        "quality": quality,
        "times": times
      });
      return ret;
    } on PlatformException catch (e) {
      switch (e.code) {
        case "ASSET_DOES_NOT_EXIST":
          print('Asset does not exist');
          return false;
        case "PERMISSION_DENIED":
          print('Permission denied');
          return false;
        case "PERMISSION_PERMANENTLY_DENIED":
          print('Permission permanently denied');
          return false;
        default:
          print('Default');
          return false;
      }
    }
  }

  /// Get available camera
  static Future<List<CameraDescription>> getAvailableCamera() async {
    return await availableCameras();
  }

  /// Get screen size
//  static Size getScreenSize(BuildContext context){
//    return MediaQuery.of(context).size;
//  }

  /// Share photo
  static Future<String> sharePhoto(String path) async {
    String value = await _channel.invokeMethod(SHARE_PHOTO_METHOD, path);
    return value;
  }

//  /// Share photo
//  static Future<String> copySharePhoto(String path) async {
//    String value = await _channel.invokeMethod(COPY_SHARE_PHOTO_METHOD, path);
//    return value;
//  }

  /// Share photo
  static Future<String> downloadFile(String path, int fileSize, name) async {
    Map args = Map();
    args["file_size"] = fileSize;
    args["url"] = path;
    args["file_name"] = name;
    String value = await _channel.invokeMethod(DOWNLOAD_FILE_METHOD,args);
    return value;
  }

//  /// Share document
//  static Future<String> copyShareDocument(String path) async {
//    String value = await _channel.invokeMethod(COPY_SHARE_DOCUMENT_METHOD, path);
//    return value;
//  }

  /// Handle library permission
  static void _haveLibraryPermissionForIOS(Function() callback) async {
    List<dynamic> checkResult = await checkPermissionsIOS([IOS_PHOTO_LIBRARY_PERMISSION]);
    if (checkResult[0] == 1) {
      callback();
      return;
    } else if (checkResult[0] == 2) {
      List<int> requestResult = await requestPermissionIOS([IOS_PHOTO_LIBRARY_PERMISSION]);
      if (requestResult[0] == 0) {
        callback();
        return;
      }
    } else {
      openAppSettingForIOS();
      return;
    }
  }

  /// Handle library camera permission
  static void _haveLibraryCameraPermissionForIOS(Function() callback) async {
    List<dynamic> result =
        await checkPermissionsIOS([IOS_CAMERA_PERMISSION, IOS_PHOTO_LIBRARY_PERMISSION]);
    if (result[0] == 1 && result[1] == 1) {
      callback();
      return;
    } else if (result[0] == 2 && result[1] == 2) {
      List<dynamic> requestResult =
          await requestPermissionIOS([IOS_CAMERA_PERMISSION, IOS_PHOTO_LIBRARY_PERMISSION]);
      if (requestResult[0] == 1 && requestResult[1] == 1) {
        callback();
        return;
      }
    } else if (result[0] == 2 && result[1] == 1) {
      List<dynamic> requestResult = await requestPermissionIOS([IOS_CAMERA_PERMISSION]);
      if (requestResult[0] == 1) {
        callback();
        return;
      }
    } else if (result[0] == 1 && result[1] == 2) {
      List<dynamic> requestResult = await requestPermissionIOS([IOS_PHOTO_LIBRARY_PERMISSION]);
      if (requestResult[0] == 1) {
        callback();
        return;
      }
    } else {
      openAppSettingForIOS();
      return;
    }
  }

  /// Open app setting for iOS
  static void openAppSettingForIOS() async {
    _channel.invokeMethod(OPEN_SETTING_APP_METHOD);
  }

  /// Save string value
  static Future<bool> saveStringValue(String key, String value) async {
    bool result = await _channel
        .invokeMethod(SAVE_STRING_VALUE_METHOD, <String, dynamic>{KEY: key, VALUE: value});
    return result;
  }

  /// Get string value
  static Future<String> getStringValue(String key) async {
    String result = await _channel.invokeMethod(GET_STRING_VALUE_METHOD, key);
    return result;
  }

  /// Save int value
  static Future<bool> saveIntValue(String key, int value) async {
    bool result = await _channel
        .invokeMethod(SAVE_INT_VALUE_METHOD, <String, dynamic>{KEY: key, VALUE: value});
    return result;
  }

  /// Get int value
  static Future<int> getIntValue(String key) async {
    int result = await _channel.invokeMethod(GET_INT_VALUE_METHOD, key);
    return result;
  }

  /// Save float value
  static Future<bool> saveDoubleValue(String key, double value) async {
    bool result = await _channel
        .invokeMethod(SAVE_DOUBLE_VALUE_METHOD, <String, dynamic>{KEY: key, VALUE: value});
    return result;
  }

  /// Get double value
  static Future<double> getDoubleValue(String key) async {
    double result = await _channel.invokeMethod(GET_DOUBLE_VALUE_METHOD, key);
    return result;
  }

  /// Save bool value
  static Future<bool> saveBoolValue(String key, bool value) async {
    bool result = await _channel
        .invokeMethod(SAVE_BOOL_VALUE_METHOD, <String, dynamic>{KEY: key, VALUE: value});
    return result;
  }

  /// Get bool value
  static Future<bool> getBoolValue(String key) async {
    bool result = await _channel.invokeMethod(GET_BOOL_VALUE_METHOD, key);
    return result;
  }

  /// Remove value
  static Future<bool> removeValue(String key) async {
    bool result = await _channel.invokeMethod(REMOVE_VALUE_METHOD, key);
    return result;
  }
}
