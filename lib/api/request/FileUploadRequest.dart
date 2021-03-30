import 'dart:convert';
import 'dart:isolate';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:trans/api/connector/Connector.dart';
import 'package:trans/api/params/FileParams.dart';
import 'package:trans/api/params/Params.dart';
import 'package:trans/api/request/BaseRequest.dart';
import 'package:trans/api/result/FileUpload.dart';
import 'package:trans/api/result/Result.dart';
import 'package:http_parser/http_parser.dart';


class FileUploadRequest extends BaseRequest {
  @override
  Future<Result> handleRequest(BuildContext context) async {
    await Isolate.spawn(callBackgroundRequest, params);
    Result result = await receivePort.first;
    return result;
  }

  /// Handle call request at background
  static void callBackgroundRequest(Params params) async {
    Result result;
    try {
      /// Get connector
      Dio connector =
          Connector.instance.getConnector(baseUrl: params.baseUrl, headers: params.headers);

      /// Call API

      List<FileParams> fileParams = params.fileParams;
      List<MultipartFile> list = fileParams.map((e){
        return MultipartFile.fromFileSync(e.path,
            filename: e.name,
            contentType: MediaType('image','jpg'));
      }).toList();

      FormData formData = FormData.fromMap({
        "files": list
      });

      Response response = await connector.post('file/upload', data: formData);
      print(response);

      result = Result<FileUpload>();
      result.code = response.statusCode;
      result.data =  FileUpload.fromJson(json.decode(response.data));
    } on DioError catch (e) {
      result = Connector.instance.handleError(e);
    }
    params.sendPort.send(result);
  }
}
