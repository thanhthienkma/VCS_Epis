import 'package:flutter/material.dart';
import 'package:trans/base/screen/BaseScreen.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/screens/personal/widgets/PersonalHeaderWidget.dart';

class AboutScreen extends BaseScreen {
  @override
  Widget onInitBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        /// Personal header widget
        PersonalHeaderWidget(
          title: 'Về VCS',
          isBack: true,
          leftCallback: () {
            popScreen(context);
          },
        ),

        Expanded(
            child: ListView(
          children: <Widget>[
            /// Size box
            SizedBox(height: 10),

            /// Create logo
            _createLogo(),

            /// App name
            _createAppName(),

            /// Create features
            _createFeatures(),
          ],
        ))
      ],
    );
  }

  /// Back icon
  Widget _createBackIcon() {
    return IconButton(
        onPressed: () => popScreen(context),
        icon: Icon(Icons.navigate_before, size: 40));
  }

  /// Feature item
  Widget _featureItem(String title) {
    return Padding(
      padding: paddingTop10,
      child: Row(
        children: <Widget>[
          Icon(Icons.check_box, color: Colors.blue),
          SizedBox(width: double10),
          Expanded(
            child: Text(title),
          ),
        ],
      ),
    );
  }

  /// Features
  Widget _createFeatures() {
    return Container(
      margin: marginTop10,
      padding: EdgeInsets.symmetric(vertical: double15, horizontal: double15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.15),
            blurRadius: double5,
            offset: Offset(double0, double0),
          )
        ],
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Tính năng tuyệt vời',
                  style: TextStyle(
                    color: Color(0xFF1B1E28),
                    fontSize: font16,
                  ),
                ),
              ),
            ],
          ),

          /// Update 24h
          _featureItem('Cập nhật 24h '),

          /// Got news
          _featureItem('Tin nóng và mới nhất'),

          /// Upgrade news by AI
          _featureItem('Liên tục cập nhật bởi AI news'),

          /// Ease to share information
          _featureItem('Dễ Dàng Chia Sẻ Thông Tin'),

          /// Hand out shopping on EPIS VN
          _featureItem('Thỏa Sức Mua Sắm Trên  EPIS VN'),
        ],
      ),
    );
  }

  /// App name
  Widget _createAppName() {
    return Container(
      margin: marginTop20,
      alignment: Alignment.center,
      child: Text(
        'VCS Tin Tức 24h',
        style: TextStyle(fontSize: font20),
      ),
    );
  }

  /// Logo
  Widget _createLogo() {
    return Container(child: Image.asset('images/deco_logo.png', height: 200));
  }
}
