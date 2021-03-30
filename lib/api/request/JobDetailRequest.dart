import 'dart:isolate';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:trans/api/connector/Connector.dart';
import 'package:trans/api/params/Params.dart';
import 'package:trans/api/request/BaseRequest.dart';
import 'package:trans/api/result/JobDetail.dart';
import 'package:trans/api/result/Result.dart';

class JobDetailRequest extends BaseRequest {
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

      String value = params.data['jobID'];

      /// Call api
      Response response = await connector.get('/detail-job?p=$value');
      print(response);
      result = Result<JobDetail>();
      result.code = response.statusCode;
      result.data = JobDetail.fromJson(response.data);
    } on DioError catch (e) {
      result = Connector.instance.handleError(e);
    }
    params.sendPort.send(result);
  }
}
