import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:utils/dialog/downloaddialog/components/download/DownloadComponent.dart';

class DownloadDialog {
  /// Singleton pattern
  DownloadDialog._privateConstructor();

  static final DownloadDialog _instance = DownloadDialog._privateConstructor();

  bool isShowing = false;

  static DownloadDialog get instance {
    return _instance;
  }

  /// Show download dialog
  void showDownloadDialog(BuildContext context, String name, String link, int fileSize, String mimeType, {Function(String path) callback}) {
    print('showDownloadDialog');

    if(isShowing){
      return;
    }
    isShowing = true;

    Future.delayed(Duration.zero, () {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            /// Prevent back press on Android, we use WillPopScope and override onWillPop.
            return WillPopScope(
                key: GlobalKey(),
                onWillPop: () {},
                child: createDownloadDialog(context, name, link, fileSize, mimeType, callback:callback));
          });
    });
  }

  /// Create download dialog
  Widget createDownloadDialog(BuildContext context, String name, String link, int fileSize,String mimeType, {Function(String path) callback}) {
    /// Create dialog.
    return SimpleDialog(
      contentPadding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      children: <Widget>[
        /// Create download name
        _createDownloadNameWidget(name),
        /// Create download
        _createDownloadWidget(context, name, link, fileSize, mimeType, callback:callback)
      ],
    );
  }

  /// Download widget
  Widget _createDownloadWidget(BuildContext context, String name, String link, int fileSize, String mimeType,{Function(String path) callback}){
    Map args = Map();
    args[DownloadComConstants.NAME] = name;
    args[DownloadComConstants.LINK] = link;
    args[DownloadComConstants.FILE_SIZE] = fileSize;
    args[DownloadComConstants.MIME_TYPE] = mimeType;
    args[DownloadComConstants.CALLBACK] = (String path){
      /// Close dialog
      Navigator.pop(context);
      isShowing = false;
      callback(path);
    };
   return DownloadComponent(arguments:args);
  }

  /// Create name widget
  Widget _createDownloadNameWidget(String name){
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Text('Downloading $name', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black)),
    );
  }
}
