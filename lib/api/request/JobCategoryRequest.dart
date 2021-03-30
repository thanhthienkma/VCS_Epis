import 'dart:isolate';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:trans/api/connector/Connector.dart';
import 'package:trans/api/params/Params.dart';
import 'package:trans/api/request/BaseRequest.dart';
import 'package:trans/api/result/JobCategory.dart';
import 'package:trans/api/result/Result.dart';

class JobCategoryRequest extends BaseRequest {
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
      Dio connector = Connector.instance.getConnector(baseUrl: params.baseUrl);

      /// Call api
      Response response = await connector.get('/list-job-cat');
      print(response);
      result = Result<JobCategory>();
      result.code = response.statusCode;
      result.data = JobCategory.fromJson(response.data);
    } on DioError catch (e) {
      result = Connector.instance.handleError(e);
    }
    params.sendPort.send(result);
  }
}
