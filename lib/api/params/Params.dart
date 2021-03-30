import 'dart:isolate';
import 'FileParams.dart';

class Params {
  final String baseUrl;
  final SendPort sendPort;
  final Map<String, dynamic> headers;
  final Map<String, dynamic> queries;
  final Map<String, dynamic> data;
  final List<String> paths;
  final List<FileParams> fileParams;
  Params({this.baseUrl, this.sendPort, this.queries, this.data, this.paths, this.headers, this.fileParams});
}
