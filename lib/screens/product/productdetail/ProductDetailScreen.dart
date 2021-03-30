import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:trans/base/screen/BaseScreen.dart';
import 'package:trans/identifiers/Screens.dart';

class ProductDetailScreen extends BaseScreen {
  int count = 0;

  @override
  Widget onInitBody(BuildContext context) {
    return Column(
      children: <Widget>[
        /// Create header widget
        _createHeaderWidget(),

        /// Create list of widgets
        _createListOfWidgets(),

        /// Create add to cart widget
        _createAddToCartWidget(),
      ],
    );
  }

  Widget _createListOfWidgets() {
    return Expanded(
      child: ListView(
        children: <Widget>[
          /// Create photo widget
          _createPhotoWidget(),

          /// Create photo list widget
          _createPhotoListWidget(),

          Container(
              margin: EdgeInsets.only(top: 10),
              height: 5,
              color: Colors.grey[200]),

          /// Create detail info
          _createDetailInfoWidget(),

          Container(
              margin: EdgeInsets.only(top: 10),
              height: 5,
              color: Colors.grey[200]),

          /// Create describe product widget
          _createDescribeProductWidget(),

          Container(
              margin: EdgeInsets.only(top: 10),
              height: 5,
              color: Colors.grey[200]),

          /// Create more products widget
//              _createMoreProductsWidget(),
        ],
      ),
    );
  }

  Widget _createAddToCartWidget() {
    final EdgeInsets _padding = MediaQuery.of(context).padding;

    return InkWell(
        onTap: () {},
        child: Container(
            padding: EdgeInsets.only(bottom: _padding.bottom / 2),
            margin: EdgeInsets.only(bottom: 10, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Thêm vào giỏ', style: TextStyle(fontSize: 16)),
                Container(
                  margin: EdgeInsets.only(left: 5),
                  child: Image.asset('assets/images/cart.png',
                      width: 24, height: 24),
                ),
              ],
            )));
  }

  Widget _createMoreProductsWidget() {
    return Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                child: Text('Sản phẩm xem thêm',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w400))),
            Expanded(
              child: Container(
                  height: 100,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Container(
                        height: 60,
                        color: Colors.orange,
                      ),

//                Column(
//                  children: <Widget>[
//                    Container(
//                        margin: EdgeInsets.only(top: 10),
//                        alignment: Alignment.center,
//                        child: Image.network(
//                          'http://1.bp.blogspot.com/-Jrh1sw1LizU/VNTLFiRhgJI/AAAAAAAAFNg/a-ERrbxxBe4/s1600/photo.jpg.png',
//                          height: 60,
//                        )),
//                    Container(
//                      child: Text('Mac book Pro 16inch'),
//                    ),
//                    Container(
//                      child: Text('48.000.000 VND'),
//                    ),
//                  ],
//                ),
                    ],
                  )),
            )
          ],
        ));
  }

  Widget _itemHasBackground(String text, String value) {
    return Container(
      color: Colors.grey[100],
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 150,
            child: Text(
              text,
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w300),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                  color: Color(0xff4A667C), fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemNoBackground(String text, String value) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 150,
            child: Text(
              text,
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w300),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _createDescribeProductWidget() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              child: Text('Mô tả sản phẩm',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400))),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              'Sau 1 năm "Chạy đi chờ chi" kết thúc mùa đầu tiên, "MC quốc dân" cũng liên tục phủ sóng khắp các show truyền hình: từ "Người ấy là ai", "Giọng ải giọng ai" đến "Ơn giời cậu đây rồi!", "Siêu trí tuệ Việt Nam"… Vào đầu năm nay, Trấn Thành còn "gây sốt" với web drama đầu tay "Bố Già" mang thông điệp về tình cảm gia đình thiêng liêng được đông đảo khán giả yêu thích.',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 10),
              alignment: Alignment.center,
              child: Image.network(
                'http://1.bp.blogspot.com/-Jrh1sw1LizU/VNTLFiRhgJI/AAAAAAAAFNg/a-ERrbxxBe4/s1600/photo.jpg.png',
                height: 100,
              )),
          Container(
              margin: EdgeInsets.only(top: 10),
              alignment: Alignment.center,
              child: Text(
                'Xem tất cả',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xff4A667C),
                    decoration: TextDecoration.underline),
              )),
        ],
      ),
    );
  }

  Widget _createDetailInfoWidget() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  child: Text('Thông Tin Chi Tiết',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w400))),
              Icon(Icons.favorite_border, color: Colors.red),
            ],
          ),

          /// Product name
          _itemHasBackground('Tên sản phảm  ',
              'Mac book Pro 16inch, 1 TB - 16GB, superpower.'),

          /// Distributor
          _itemNoBackground('Giá tiền  ', '48.000.000 VND'),

          /// Distributor
          _itemHasBackground('Đại lí cung cấp  ', 'Mac center'),

          /// Brand
          _itemNoBackground('Thương hiệu  ', 'Apple'),

          /// Size
          _itemHasBackground('Kích thước  ', '18 x 30 cm'),

          /// Wrapping
          _itemNoBackground('Quy cách đóng gói  ', 'Dạng hộp'),

          /// SKU
          _itemHasBackground('SKU  ', '1234567890'),

          /// Weight
          _itemNoBackground('Trọng lượng  ', '2,3 kg'),
        ],
      ),
    );
  }

  Widget _createPhotoListWidget() {
    List<Widget> photos = [
      Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey[300]),
              borderRadius: BorderRadius.all(Radius.circular(6))),
          child: Image.network(
            'https://tse1.mm.bing.net/th?id=OIP.wfIpzCfhWc6PH9uabaZ68gHaKt&pid=Api&P=0&w=300&h=300',
            height: 60,
            width: 60,
          )),
      Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey[300]),
              borderRadius: BorderRadius.all(Radius.circular(6))),
          child: Image.network(
            'http://1.bp.blogspot.com/-Jrh1sw1LizU/VNTLFiRhgJI/AAAAAAAAFNg/a-ERrbxxBe4/s1600/photo.jpg.png',
            height: 60,
            width: 60,
          )),
      Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey[300]),
              borderRadius: BorderRadius.all(Radius.circular(6))),
          child: Image.network(
            'https://tse3.mm.bing.net/th?id=OIP.aecPi7boFUnL8UwUGez-cwHaH0&pid=Api&P=0&w=300&h=300',
            height: 60,
            width: 60,
          )),
      Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey[300]),
              borderRadius: BorderRadius.all(Radius.circular(6))),
          child: Image.network(
            'https://tse3.mm.bing.net/th?id=OIP.aecPi7boFUnL8UwUGez-cwHaH0&pid=Api&P=0&w=300&h=300',
            height: 60,
            width: 60,
          )),
      Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey[300]),
              borderRadius: BorderRadius.all(Radius.circular(6))),
          child: Image.network(
            'https://tse3.mm.bing.net/th?id=OIP.aecPi7boFUnL8UwUGez-cwHaH0&pid=Api&P=0&w=300&h=300',
            height: 60,
            width: 60,
          )),
      Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey[300]),
              borderRadius: BorderRadius.all(Radius.circular(6))),
          child: Image.network(
            'https://tse3.mm.bing.net/th?id=OIP.aecPi7boFUnL8UwUGez-cwHaH0&pid=Api&P=0&w=300&h=300',
            height: 60,
            width: 60,
          )),
      Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey[300]),
              borderRadius: BorderRadius.all(Radius.circular(6))),
          child: Image.network(
            'https://tse3.mm.bing.net/th?id=OIP.aecPi7boFUnL8UwUGez-cwHaH0&pid=Api&P=0&w=300&h=300',
            height: 60,
            width: 60,
          )),
    ];

    return Container(
      height: 60,
      margin: EdgeInsets.only(top: 10),
      child: ListView(
        cacheExtent: 10000,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: photos,
      ),
    );
  }

  Widget _createPhotoWidget() {
    return Container(
        height: 150,
        child: Image.network(
            'https://tse1.mm.bing.net/th?id=OIP.wfIpzCfhWc6PH9uabaZ68gHaKt&pid=Api&P=0&w=300&h=300'));
  }

  Widget _createHeaderWidget() {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 20,
              color: Colors.grey,
            ),
            onPressed: () {
              popScreen(context);
            },
          ),
          Row(
            children: <Widget>[
              InkWell(
                onTap: () {},
                child: Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Icon(Icons.search, size: 20, color: Colors.grey)),
              ),
              InkWell(
                onTap: () {
                  pushScreen(BaseWidget(screen: Screens.CART), Screens.CART);
                },
                child: Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Badge(
                      padding: EdgeInsets.all(4),
                      badgeContent: Text(count.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 8)),
                      animationType: BadgeAnimationType.scale,
                      child: Icon(Icons.shopping_cart,
                          color: Colors.grey, size: 20),
                    )),
              ),
              InkWell(
                onTap: () {},
                child: Icon(Icons.more_horiz, size: 20, color: Colors.grey),
              )
            ],
          ),
        ],
      ),
    );
  }
}
