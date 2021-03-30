import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/screens/personal/PersonalScreen.dart';

class PersonalBottomWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PersonalBottomWidgetState();
}

class _PersonalBottomWidgetState extends State<PersonalBottomWidget> {


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF0EFF3),
      child: Column(
        children: <Widget>[
          /// Size box widget
          SizedBox(height: 10),

          /// Create link widget
          _createLinkWidget(),

          /// Create recent action widget
          _createRecentActionWidget(),

          /// Coming soon
          Container(
              margin: marginTop20,
              child: Image.asset('assets/images/coming_soon.png')),
        ],
      ),
    );
  }

  /// Recent action
  Widget _createRecentActionWidget() {
    return Container(
      padding: paddingAll10,
      alignment: Alignment.centerLeft,
      child: Text(
        'Hoạt động gần đây',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: font16,
          color: Colors.grey,
        ),
      ),
    );
  }

  /// Link widget
  Widget _createLinkWidget() {
    return Container(
        color: Colors.white,
        width: double.maxFinite,
        padding: paddingAll10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            /// Name
            Container(
                child: Text('Link giới thiệu',
                    style: TextStyle(
                        fontSize: font16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold))),

            /// Link
            Container(
              margin: EdgeInsets.only(top: margin10, right: margin10),
              padding: paddingAll10,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Row(
                children: <Widget>[
                  Image.asset('assets/images/link.png', height: 20),
                  Expanded(
                      child: Container(
                          margin:
                              EdgeInsets.only(left: margin10, right: margin10),
                          child: Text(
                            PersonalConstants.LINK,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ))),
                  GestureDetector(
                      onTap: () {
                        /// Copy action
                        copyAction();
                      },
                      child: Text('Sao chép',
                          style: TextStyle(
                              color: primaryColor, fontSize: font16))),
                ],
              ),
            ),
          ],
        ));
  }

  void copyAction() {
    Clipboard.setData(ClipboardData(text:  PersonalConstants.LINK));
    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Copied')));
  }
}
