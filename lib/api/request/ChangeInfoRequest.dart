import 'dart:isolate';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:trans/api/connector/Connector.dart';
import 'package:trans/api/params/Params.dart';
import 'package:trans/api/request/BaseRequest.dart';
import 'package:trans/api/result/Result.dart';
import 'package:trans/api/result/User.dart';

class ChangeInfoRequest extends BaseRequest {
  @override
  Future<Result> handleRequest(BuildContext context) async {
    await Isolate.spawn(callBackgroundRequest, params);
    return await receivePort.first;
  }

  /// Handle call request at background
  static void callBackgroundRequest(Params params) async {
    Result result;
    try {
      /// Get connector
      Dio connector = Connector.instance
          .getConnector(baseUrl: params.baseUrl, headers: params.headers);

      /// Call api
      Response response =
          await connector.post('user/update_info', data: params.data);
      print(response);
      result = Result<User>();
      result.code = response.statusCode;
      result.data = User.fromJson(response.data);
    } on DioError catch (e) {
      result = Connector.instance.handleError(e);
    }
    params.sendPort.send(result);
  }
}
