import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:utils/model/Photo.dart';

import '../../../../utils.dart';

class DownloadComConstants {
  static const String NAME = 'name';
  static const String LINK = 'link';
  static const String FILE_SIZE = 'file_size';
  static const String MIME_TYPE = 'mime_type';
  static const String CALLBACK = 'callback';
}

class DownloadComponent extends StatefulWidget {
  /// Arguments
  final Map arguments;

  /// Constructor
  DownloadComponent({this.arguments});

  @override
  State<StatefulWidget> createState() {
    return DownloadState();
  }
}

class DownloadState extends State<DownloadComponent> {
  int _percent = 0;
  int _fileSize;
  String _name;
  String _url;
  String _mimeType;
  String _savePath;
  Function(String path) _callback;


  @override
  void initState() {
    super.initState();
    _url = widget.arguments[DownloadComConstants.LINK];
    _name = widget.arguments[DownloadComConstants.NAME];
    _fileSize = widget.arguments[DownloadComConstants.FILE_SIZE];
    _callback = widget.arguments[DownloadComConstants.CALLBACK];
    _mimeType = widget.arguments[DownloadComConstants.MIME_TYPE];

    /// Call download
    _callDownload();
  }

  /// Call download
  void _callDownload() async {
    try {
      ServicesBinding.instance.defaultBinaryMessenger.setMessageHandler('utilsdownload',
              (ByteData message) async {
              print('utilsdownload Message $message');
              final buffer = message.buffer;
              var list = buffer.asUint8List(message.offsetInBytes, message.lengthInBytes);
              print('utilsdownload Message ${utf8.decode(list)}');
              String per = utf8.decode(list);
              if(per.startsWith('OK')){
                _percent = 100;
                _callback(per.substring(3));
              }else {
                _percent = int.parse(per);
              }
              if(mounted){
                setState(() {
                });
              }
            return message;
          });

      String path = await Utils.downloadFile(_url, _fileSize, _name);


      /// Finish download.

//      if (_mimeType.toLowerCase().endsWith('pdf') ||
//          _mimeType.toLowerCase().endsWith('doc') ||
//          _mimeType.toLowerCase().endsWith('docx') ||
//          _mimeType.toLowerCase().endsWith('xlsx') ||
//          _mimeType.toLowerCase().endsWith('ppt') ||
//          _mimeType.toLowerCase().endsWith('pptx')) {
//        String stringValue = await Utils.copyShareDocument(_savePath);
//        if (stringValue == null || stringValue == '') {
//          return;
//        }
//        _callback(stringValue);
//      } else {
//        String stringValue = await Utils.copySharePhoto(_savePath);
//        if (stringValue == null || stringValue == '') {
//          return;
//        }
//        _callback(stringValue);
//      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Create image
    return LinearPercentIndicator(
      animation: true,
      lineHeight: 20.0,
      animationDuration: 2000,
      percent: _percent / 100,
      center: Text('$_percent%'),
      linearStrokeCap: LinearStrokeCap.roundAll,
      progressColor: Colors.greenAccent,
    );
  }

//  /// Show  download progress
//  /// Received
//  /// Total
//  void showDownloadProgress(received, total) {
////    _percent = ((received / _fileSize) * 100).toInt();
//    if (_percent > 100) {
//      _percent = 100;
//    }
//    print('Percent $_percent');
//
//    /// Update UI.
//    if (!mounted) {
//      return;
//    }
//    setState(() {});
//  }
}
