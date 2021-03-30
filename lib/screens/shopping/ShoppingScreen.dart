import 'package:flutter/material.dart';
import 'package:trans/identifiers/Screens.dart';
import 'package:trans/base/screen/BaseScreen.dart';
import 'package:trans/screens/shopping/shopconstants/ShopContants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/widgets/divider_widget.dart';

class ShoppingScreen extends BaseScreen {
  Map args = Map();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    args[ShopConstants.EPIS_VN] = 'https://epis.vn';
  }

  @override
  Widget onInitBody(BuildContext context) {
    return Column(
      children: <Widget>[
        /// Create header widget
        _createHeaderWidget(),

        /// Create shopping widget
        _createShoppingWidget(),

        /// Create actions widget
        _createActionsWidget(callback: () {
          /// Go to vcs website.
//          pushScreen(BaseWidget(screen: Screens.VCS_WEB, arguments: args),
//              Screens.VCS_WEB);
//          _showMessageSnackBar('Tính năng sẽ cập nhật sau.');
          _downloadEPISVN();
        }),
      ],
    );
  }

  _downloadEPISVN() async {
    const String url =
        'https://play.google.com/store/apps/details?id=com.epis.vn&fbclid=IwAR06PH8wDVC13Fu1nRzJe8v_IbSbuxF5aL9wm8kIKeacLPMAET86CyXBptI';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  /// Actions
  Widget _createActionsWidget({Function callback}) {
    return Expanded(
      child: ListView(
        children: <Widget>[
          /// Create action item
          _createActionItem('EPIS VN', 'Giá rẻ và nhiều khuyến mãi.',
              callback: () {
            callback();
//            await _navigateEPIS();
          }),

          /// Create train
          _createTrain(),
        ],
      ),
    );
  }

  /// Train
  Widget _createTrain() {
    return Container(
      child: Image.asset('assets/images/train.jpg'),
    );
  }

  /// Action item
  Widget _createActionItem(String title, String content,
      {Function() callback}) {
    return InkWell(
        onTap: () => callback(),
        child: Container(
            child: Column(
          children: <Widget>[
            /// Info
            Container(
                padding: paddingAll15,
                child: Row(
                  children: <Widget>[
                    /// Image path
                    Image.asset('images/deco_logo.png', width: 40, height: 40),

                    /// Content
                    Expanded(
                        child: Container(
                            margin: marginLeft10,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(title),
                                Container(
                                    margin: marginTop5, child: Text(content)),
                              ],
                            ))),

                    /// Navigate icon
                    Icon(
                      Icons.navigate_next,
                      color: Colors.grey,
                    ),
                  ],
                )),

            /// Divider widget
            DividerWidget(),
          ],
        )));
  }

  /// Shopping action
  Widget _createShoppingWidget() {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            padding: paddingAll15,
            child: Text(
              'Mua sắm',
              style: TextStyle(color: Colors.black),
            )),

        /// Divider widget
        DividerWidget(),
      ],
    ));
  }

  /// Header
  Widget _createHeaderWidget() {
    return Container(
        constraints: BoxConstraints.expand(height: size180),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/shopping_background.jpg'),
                fit: BoxFit.cover)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                margin: marginTop10,
                alignment: Alignment.topCenter,
                child: Text('Mua sắm',
                    style: TextStyle(
                        fontSize: font16, fontWeight: FontWeight.w500))),
            Container(
                width: size135,
                margin: EdgeInsets.only(top: margin10, left: margin15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    /// Title
                    Container(
                        child: Text('Thoả sức mua sắm',
                            style: TextStyle(fontWeight: FontWeight.bold))),

                    /// Description
                    Container(
                        margin: marginTop20,
                        child: Text(
                            'Mua và bán chỉ trong vòng 30 giây. Bạn đã có trong tay sản phẩm Úc.')),
                  ],
                )),
          ],
        ));
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
