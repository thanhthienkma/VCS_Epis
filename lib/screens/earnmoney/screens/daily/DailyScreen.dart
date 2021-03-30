import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trans/identifiers/Screens.dart';
import 'package:trans/base/screen/BaseScreen.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/preferences/Preferences.dart';

class DailySupport {
  String day;

  DailySupport({this.day});

  initDays() {
    List<DailySupport> days = List();

    var monday = DailySupport(day: 'Monday');
    days.add(monday);
    var tuesday = DailySupport(day: 'Tuesday');
    days.add(tuesday);
    var wednesday = DailySupport(day: 'Wednesday');
    days.add(wednesday);
    var thursday = DailySupport(day: 'Thursday');
    days.add(thursday);
    var friday = DailySupport(day: 'Friday');
    days.add(friday);
    var saturday = DailySupport(day: 'Saturday');
    days.add(saturday);
    var sunday = DailySupport(day: 'Sunday');
    days.add(sunday);

    return days;
  }
}

class DailyScreen extends BaseScreen {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<DailySupport> data = DailySupport().initDays();
  DateTime now = DateTime.now();
  String _currentDay;
  int totalCoins;

  void initState() {
    super.initState();

    _currentDay = DateFormat('EEEE').format(now);
    print('CURRENT DAY : $_currentDay');

    /**
     * Get total coins
     */
    _getTotalCoins();
  }

  _getTotalCoins() async {
    totalCoins = await Preferences.getCoin();
    if (totalCoins == null) {
      return;
    }

    /// Update coins
    setState(() {});
  }

  @override
  Widget onInitBody(BuildContext context) {
    return Column(
      children: <Widget>[
        /// Create header widget
        _createHeaderWidget(),

        /// Create day widget
        _createDaysWidget(),
      ],
    );
  }

  Widget _createDaysWidget() {
    return Expanded(
        child: ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        return _itemCheckIn(data[index], callback: (item) async {
          /// Go to video ad screen
          int value = await pushScreen(
              BaseWidget(screen: Screens.VIDEO_AD, arguments: item.day),
              Screens.VIDEO_AD);

          if (value == null || value == 0) {
            return;
          }
          if (!mounted) {
            return;
          }

          /// Update coins
          setState(() {
            totalCoins += value;
          });
        });
      },
    ));
  }

  Widget _itemCheckIn(DailySupport value,
      {Function(DailySupport value) callback}) {
    return GestureDetector(
        onTap: () {
          if (value.day != _currentDay) {
            return;
          }

          if (callback == null) {
            return;
          }

          callback(value);
        },
        child: Card(
            elevation: 4,
            color: value.day == _currentDay ? Colors.white : Colors.grey[200],
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Container(
                padding: paddingAll20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 118, 212, 193),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child:
                          Icon(Icons.playlist_add_check, color: Colors.white),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Text('Check-In ${value.day}',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ))));
  }

  Widget _createHeaderWidget() {
    var backgroundDecoration = BoxDecoration(
        color: Color.fromARGB(255, 80, 70, 154),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)));

    return Container(
      decoration: backgroundDecoration,
      constraints: BoxConstraints.expand(height: 150),
      child: Column(
        children: <Widget>[
          /// Create header icons
          _createHeaderIcons(),

          /// Create total coins widget
//          _createTotalCoinsWidget(),
        ],
      ),
    );
  }

  Widget _createTotalCoinsWidget() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
              child: Text('Coins tích luỹ',
                  style: TextStyle(color: Colors.white, fontSize: 22))),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(totalCoins.toString() ?? '0',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontStyle: FontStyle.italic)),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Image.asset('assets/images/coin.png',
                      height: 26, width: 26),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _createHeaderIcons() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          BouncingWidget(
            onPressed: () {
              popScreen(context);
            },
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.white38),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Icon(Icons.keyboard_backspace, color: Colors.white),
            ),
          ),
//          BouncingWidget(
//            onPressed: () {
//              if (totalCoins != null) {
//                Preferences.saveCoin(totalCoins);
//                _showMessageSnackBar('Lưu coins thành công.');
//              }
//            },
//            child: Container(
//              padding: EdgeInsets.all(5),
//              decoration: BoxDecoration(
//                  color: primaryColor,
//                  borderRadius: BorderRadius.all(Radius.circular(8))),
//              child: Row(
//                children: <Widget>[
//                  Text('Lưu coins',
//                      style: TextStyle(
//                          color: Colors.white, fontWeight: FontWeight.bold)),
//                  Container(
//                      margin: EdgeInsets.only(left: 5),
//                      child:
//                          Icon(Icons.save_alt, color: Colors.white, size: 24)),
//                ],
//              ),
//            ),
//          ),
        ],
      ),
    );
  }

  void _showMessageSnackBar(String text) {
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text(text), duration: Duration(milliseconds: 2000)));
  }

  @override
  Key onInitKey(BuildContext context) {
    return _scaffoldKey;
  }
}
