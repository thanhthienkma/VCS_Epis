import 'package:flutter/material.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/components/vcslogo/VCSLogoComponent.dart';
import 'package:trans/api/local/Country.dart';

class CountryWidget extends StatefulWidget {
  final Function(Country value) callback;

  CountryWidget({this.callback});

  @override
  State<StatefulWidget> createState() => _CountryWidgetState();
}

class _CountryWidgetState extends State<CountryWidget> {
  List<Country> list = Country().getCountries();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: Stack(
        children: <Widget>[
          /// Countries Widget
          _countriesWidget(),

          /// Close Icon Widget
          _closeIconWidget(),
        ],
      ),
    );
  }

  Widget _closeIconWidget() {
    return Positioned(
      right: 0.0,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Align(
          alignment: Alignment.topRight,
          child: CircleAvatar(
            radius: 14.0,
            backgroundColor: primaryColor,
            child: Icon(Icons.close, size: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _countriesWidget() {
    return Container(
      height: 250,
      padding: EdgeInsets.only(top: 18.0),
      margin: EdgeInsets.only(top: 13.0, right: 8.0),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          /// VCS Logo Component
          VCSLogoComponent(),

          /// Countries
          Expanded(
              child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _countryItem(list[index], callback: (Country value) {
                      widget.callback(value);
                    });
                  })),
        ],
      ),
    );
  }

  /// Country Item
  Widget _countryItem(Country item, {Function(Country value) callback}) {
    return InkWell(
        onTap: () {
          callback(item);
        },
        child: Container(
            padding: paddingAll15,
            child: Row(
              children: <Widget>[
                /// Flag
                Image.asset(item.flag, height: 24, width: 24),

                /// Code
                Container(
                    margin: marginLeft10,
                    child: Text(
                      item.countryCode,
                      style: TextStyle(fontSize: font16),
                    )),

                /// Name
                Container(
                    margin: marginLeft20,
                    child: Text(
                      item.name,
                      style: TextStyle(fontSize: font16),
                    )),
              ],
            )));
  }
}
