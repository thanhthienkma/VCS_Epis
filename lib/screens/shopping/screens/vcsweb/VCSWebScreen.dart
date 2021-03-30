import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:trans/base/screen/BaseScreen.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/screens/shopping/shopconstants/ShopContants.dart';
import 'dart:io';

class VCSWebScreen extends BaseScreen {
  InAppWebViewController webView;
  double progress = 0;
  Map args = Map();
  String url = '';
  bool disconnected = false;

  @override
  void initState() {
    super.initState();

    /// Check connection
    _checkConnection();
  }

  _checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');

        /// Get arguments
        getArguments();
      }
    } on SocketException catch (_) {
      print('not connected');
      setState(() {
        disconnected = true;
      });
    }
  }

  getArguments() {
    args = widget.arguments;
    url = args[ShopConstants.EPIS_VN];
  }

  @override
  Widget onInitBody(BuildContext context) {
    if (disconnected == true) {
      return _create404Widget();
    }

    return _createWebsiteWidget();
  }

  Widget _create404Widget() {
    return Container(
      child: Center(
        child: Text(
          '404 Not found page :(',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  Widget _createHeaderWidget() {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 5.0,
            spreadRadius: 0.0,
            offset: Offset(1.0, 3.0))
      ]),
      height: 60,
      child: Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          child: Container(margin: marginRight10, child: createRowWidget())),
    );
  }

  Widget createRowWidget() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          /// Back icon
          IconButton(
              onPressed: () {
                popScreen(context);
              },
              icon: Icon(Icons.arrow_back_ios)),

          /// Title
          Text('Mua Sắm Tại EPIS VN',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),

          /// Something

          Container(margin: marginRight10),
        ]);
  }

  Widget _createWebsiteWidget() {
    return Column(children: <Widget>[
      /// Create header widget
      _createHeaderWidget(),

      /// Progress bar
      Container(
          child: progress < 1.0
              ? LinearProgressIndicator(value: progress)
              : Container()),

      /// Website
      Expanded(
        child: Container(
          child: InAppWebView(
            initialUrl: 'https://epis.vn',
            initialHeaders: {},
            initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(debuggingEnabled: true)),
            onWebViewCreated: (InAppWebViewController controller) {
              webView = controller;
            },
            onLoadStart: (InAppWebViewController controller, String url) {
              setState(() {
//                this.url = url;
              });
            },
            onLoadStop: (InAppWebViewController controller, String url) async {
              setState(() {
//                this.url = url;
              });
            },
            onProgressChanged:
                (InAppWebViewController controller, int progress) {
              setState(() {
                this.progress = progress / 100;
              });
            },
          ),
        ),
      ),
    ]);
  }
}
