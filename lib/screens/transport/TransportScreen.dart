import 'dart:async';
import 'package:flutter/material.dart';
import 'package:trans/identifiers/Screens.dart';
import 'package:trans/base/screen/BaseScreen.dart';
import 'package:trans/screens/transport/widgets/TransportBottomWidget.dart';
import 'package:trans/screens/transport/widgets/TransportHeaderWidget.dart';

class TransportConstants {
  static const int MANAGEMENT_INDEX = 0;
  static const int ORDER_COMPLETED_INDEX = 1;
  static const String PACKAGE_FEE = 'package fee';
  static const String PACKAGE_LIST = 'package list';
  static const String NOTE = 'note';
  static const String SENDER_ADDRESS = 'sender';
  static const String RECEIVER_ADDRESS = 'receiver';

  static const String CITY = 'city';
  static const String DISTRICT = 'district';
  static const String WARD = 'ward';

  static const String PROVINCE_CALLBACK = 'province callback  ';
  static const String DISTRICT_CALLBACK = ' district callback  ';
  static const String WARD_CALLBACK = 'ward callback ';

  static const String WAREHOUSE_CALLBACK = 'ware house callback ';
  static const String UPDATE_ADDRESS_CALLBACK = ' update address callback ';

  static const String ADD_ORDER_CALLBACK = 'add order callback';

  static const String WARE_HOUSE_CALLBACK = 'ware house item callback';
  static const String DISMISS_CALLBACK = 'dismiss callback ';

  static const String SHIP_CALLBACK = 'ship callback';
  static const String PAYMENT_CALLBACK = 'payment callback';

  static const String MANAGE_ORDER_CALLBACK = 'manage order callback';
  static const String ORDER_COMPLETED_CALLBACK = 'order completed callback';
  static const String TERM_CALLBACK = 'term callback';
}

class TransportScreen extends BaseScreen {
  final PageController _pageController =
      PageController(initialPage: 0, keepPage: true);
  StreamController refreshStream = StreamController<bool>.broadcast();

  Map mapCallback = Map();

  @override
  void initState() {
    super.initState();
    /**
     * Handle map call back
     */
    _handleMapCallback();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    refreshStream.close();
  }

  @override
  Widget onInitBody(BuildContext context) {
    print('TransportScreen build.');

    return Column(
      children: <Widget>[
        /// Transport header widget
        TransportHeaderWidget('VCS Giao Vận',
            leftCallback: () => popScreen(context),
            rightIcon: Icon(Icons.notifications, size: 20)),

        /// Pages widget
        _pagesWidget(),
      ],
    );
  }

  Widget _pagesWidget() {
    /// Initialize list of screens
    List<Widget> _pages = [
      BaseWidget(screen: Screens.MANAGES_ORDER, arguments: refreshStream),
      BaseWidget(screen: Screens.ORDER_COMPLETED),
    ];
    return Expanded(
      child: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: _pages,
      ),
    );
  }

  @override
  FloatingActionButtonLocation onInitFloatingActionButtonLocation(
      BuildContext context) {
    return FloatingActionButtonLocation.centerDocked;
  }

  @override
  Widget onInitFloatingActionButton(BuildContext context) {
    return Container(
        height: 40,
        width: 40,
        child: FloatingActionButton.extended(
          elevation: 2,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          backgroundColor: Colors.orange,
          label: Container(
            child: Text('+', style: TextStyle(fontSize: 20)),
          ),
          onPressed: () async {
            /// Go to prepare order screen
            var value = await pushScreen(
                BaseWidget(screen: Screens.PREPARE_ORDER),
                Screens.PREPARE_ORDER);

            /// Value is true
            if (value) {
              refreshStream.sink.add(value);
            }
          },
        ));
  }

  @override
  Widget onInitBottomNavigationBar(BuildContext context) {
    return TransportBottomWidget(mapCallback: this.mapCallback);
  }

  _handleMapCallback() {
    mapCallback[TransportConstants.MANAGE_ORDER_CALLBACK] = () {
      /// Switch to managements screen
      _pageController.animateToPage(TransportConstants.MANAGEMENT_INDEX,
          duration: Duration(milliseconds: 100), curve: Curves.ease);
    };
    mapCallback[TransportConstants.ORDER_COMPLETED_CALLBACK] = () {
      /// Switch to coming soon screen
      _pageController.animateToPage(TransportConstants.ORDER_COMPLETED_INDEX,
          duration: Duration(milliseconds: 100), curve: Curves.ease);
    };
  }
}
