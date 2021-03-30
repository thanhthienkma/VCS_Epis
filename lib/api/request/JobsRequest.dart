import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:trans/api/connector/Connector.dart';
import 'package:trans/api/request/BaseRequest.dart';
import 'package:trans/api/result/Job.dart';
import 'package:trans/api/result/Result.dart';

class JobsRequest extends BaseRequest {
  @override
  Future<Result> handleRequest(BuildContext context) async {
    Result result;
    try {
      /// Get connector
      Dio connector = Connector.instance.getConnector(baseUrl: params.baseUrl);
      Response response =
          await connector.get('/list-job', queryParameters: params.queries);

      print(response);
      result = Result<Job>();
      result.code = response.statusCode;
      result.data = Job.fromJson(response.data);
    } on DioError catch (e) {
      result = Connector.instance.handleError(e);
    }
    return result;
  }
}
