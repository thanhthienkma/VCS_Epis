import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:trans/api/params/FileParams.dart';
import 'package:trans/api/params/Params.dart';
import 'package:trans/api/result/Result.dart';
import 'package:trans/preferences/Preferences.dart';

class BaseRequestConstants {
  static const String CONTENT_TYPE = 'Content-Type';
  static const String APPLICATION_JSON = 'application/json';
  static const String LANG = 'lang';
  static const String AUTHORIZATION = 'Authorization';
}

abstract class BaseRequest {
  /// Status is ok
  static const int OK = 200;

  /// Status is created
  static const int CREATED = 201;

  /// Status is accepted
  static const int ACCEPTED = 202;

  /// Token expire
  static const int EXPIRE = 401;

  /// Status is not internet
  static const int NO_INTERNET = -1;

  /// Status is no concurrent
  static const int NO_CONCURRENT = -2;

  /// Status is calling API.
  bool isCalling = false;

  /// Base url login
  static const String baseUrlLogin = 'http://18.191.111.162:3000/';

  /// Base url find work
  static const String baseUrlFindWork =
      'https://findworks.com.au/wp-json/api-app';

  /// Params
  Params params;

  /// This object to call API in background
  ReceivePort receivePort;

  /// Get header
  Future<Map<String, dynamic>> getHeader() async {
    String token = await Preferences.getToken();
    if (token == null || token.isEmpty) {
      Map<String, dynamic> headers = Map();
      headers[BaseRequestConstants.CONTENT_TYPE] =
          BaseRequestConstants.APPLICATION_JSON;
      return headers;
    }
    Map<String, dynamic> headers = Map();
    headers[BaseRequestConstants.CONTENT_TYPE] =
        BaseRequestConstants.APPLICATION_JSON;
    headers[BaseRequestConstants.AUTHORIZATION] = 'Bearer $token';
    return headers;
  }

  /// Call request
  Future<Result> callRequest(
    BuildContext context, {
    Map<String, dynamic> queries,
    Map<String, dynamic> data,
    String url = baseUrlLogin,
    List<String> paths,
    Map<String, dynamic> headers,
    List<FileParams> fileParams,
  }) async {
    /// Get header
    Map<String, dynamic> headersValue = Map();
    if (headers == null) {
      headersValue = await getHeader();
    } else {
      headersValue = headers;
    }

    String baseUrl;
    if (baseUrl != url) {
      baseUrl = url;
    }
    baseUrl = url;
    receivePort = ReceivePort();
    params = Params(
        baseUrl: baseUrl,
        sendPort: receivePort.sendPort,
        headers: headersValue,
        queries: queries,
        data: data,
        paths: paths,
        fileParams: fileParams);

    Result result = await handleRequest(context);

    receivePort.close();

    isCalling = false;
    return result;
  }

  /// Handle request
  Future<Result> handleRequest(BuildContext context);

  /// Get path
  static String getPaths(List<String> paths) {
    if (paths == null || paths.isEmpty) {
      return '';
    }

    String result = '';

    for (var index = 0; index < paths.length; index++) {
      if (index == 0) {
        result = '/${paths[index]}';
      } else {
        result = '$result/${paths[index]}';
      }
    }
    return result;
  }
}
