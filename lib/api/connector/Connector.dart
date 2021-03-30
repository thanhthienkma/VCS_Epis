import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:trans/api/result/Result.dart';
import 'package:trans/api/result/Error.dart';

class ConnectorConstants {
  /// Status is ok
  static const int OK = 200;

  /// Status is created
  static const int CREATED = 201;

  /// Status is accepted
  static const int ACCEPTED = 202;

  /// Token expire
  static const int EXPIRE = 401;

  /// Not found
  static const int NOT_FOUND = 404;

  /// Status is not internet
  static const int NO_INTERNET = -1;
}

class Connector {
  Dio _dio;

  /// Singleton pattern
  Connector._privateConstructor() {
    BaseOptions options = new BaseOptions(
      //172.16.2.73.
//      baseUrl: 'http://61.28.233.71:4000/api/',
//      connectTimeout: 5000,
      connectTimeout: 100000,
      receiveTimeout: 100000,
    );

    Map<String, dynamic> headers = Map();
    headers['Content-Type'] = 'application/json';

    options.headers = headers;

    _dio = Dio(options);
    _dio.interceptors.add(LogInterceptor(responseBody: true));

    /// Check certificate
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  static final Connector _instance = Connector._privateConstructor();

  static Connector get instance {
    return _instance;
  }

  /// Get connector
  Dio getConnector({@required String baseUrl, Map headers}) {
    /// Add header
    if (headers != null) {
      _dio.options.headers = headers;
    }

    /// Add base url
    _dio.options.baseUrl = baseUrl;
    return _dio;
  }

  /// Handle error
  Result handleError(DioError e) {
    Result result = Result();
    if (e.response == null) {
      result.code = ConnectorConstants.NO_INTERNET;
      result.error = Error(code: ConnectorConstants.NO_INTERNET, message: '');
    } else if (e.response.statusCode == ConnectorConstants.EXPIRE) {
      result.code = ConnectorConstants.EXPIRE;
      result.error = getErrorObj(e.response);
    } else if (e.response.statusCode == ConnectorConstants.NOT_FOUND) {
      result.code = ConnectorConstants.NOT_FOUND;
      result.error = Error(code: ConnectorConstants.NOT_FOUND, message: '');
    } else {
      result.code = e.response.statusCode;
      result.error = getErrorObj(e.response);
    }
    return result;
  }

  /// Get error object
  Error getErrorObj(Response response) {
    return Error.fromJson(response.data);
  }
}
