import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trans/identifiers/Screens.dart';
import 'package:trans/base/screen/BaseScreen.dart';
import 'package:trans/screens/transport/widgets/SearchTransportWidget.dart';
import 'package:trans/screens/transport/widgets/TabsOrderWidget.dart';

class ManagesOrderScreen extends BaseScreen {
  final PageController _pageController =
      PageController(initialPage: 0, keepPage: true);
  StreamController refreshStream;

  StreamSubscription streamSubscription;

  @override
  void initState() {
    super.initState();

    /// Listen stream
    _listenerStream();
  }

  _listenerStream() {
    refreshStream = widget.arguments;
    streamSubscription = refreshStream.stream.listen((event) {
      if (event == null) {
        return;
      }

      _pageController.animateToPage(0,
          duration: Duration(milliseconds: 100), curve: Curves.ease);
    });
  }

  @override
  void dispose() {
    super.dispose();
    streamSubscription.cancel();
  }

  @override
  Widget onInitBody(BuildContext context) {
    return Column(
      children: [
        /// Search
//        SearchTransportWidget(
//          callback: (String text) {
//            print(text);
//          },
//        ),

        /// Create tabs order widget
        _createTabsOrderWidget(),

        /// Create pages widget
        _createPagesWidget(),
      ],
    );
  }

  Widget _createPagesWidget() {
    /// Initialize list of screens
    List<Widget> _pages = [
      BaseWidget(screen: Screens.ORDER_HANDED),
      BaseWidget(screen: Screens.ORDER_UNHANDED),
      BaseWidget(screen: Screens.ORDER_DRAFT),
    ];

    return Expanded(
      child: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: _pages,
      ),
    );
  }

  Widget _createTabsOrderWidget() {
    return TabsOrderWidget(
      refreshStream: this.refreshStream,
      callback: (TabOrderSupport value) {
        /// Jump to page with index
        _pageController.animateToPage(value.index,
            duration: Duration(milliseconds: 100), curve: Curves.ease);
      },
    );
  }
}
