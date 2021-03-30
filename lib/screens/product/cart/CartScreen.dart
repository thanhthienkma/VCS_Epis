import 'package:flutter/material.dart';
import 'package:trans/base/screen/BaseScreen.dart';

class CartScreen extends BaseScreen {
  @override
  Widget onInitBody(BuildContext context) {
    return Column(
      children: <Widget>[
        /// Create header widget
        _createHeaderWidget(),

        /// Create list of widgets
        _createListOfWidgets(),

        /// Create confirm cart widget
        _createConfirmCartWidget(),
      ],
    );
  }

  Widget _createListOfWidgets() {
    return Expanded(
      child: ListView(
        children: <Widget>[
          /// Create total widget
          _createTotalWidget(),

          /// Line
          Container(height: 5, color: Colors.grey[200]),

          /// Create recommend widget
          _createRecommendWidget(),
        ],
      ),
    );
  }

  Widget _createCartsWidget() {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[],
    );
  }

  Widget _createTotalWidget() {
    int money = 500000;
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('4 items',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Text('$moneyđ', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _createRecommendWidget() {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 20, top: 10),
          child: Text('Sản phẩm ưa thích', style: TextStyle(fontSize: 16)),
        ),
        Container(
            height: 150,
            margin: EdgeInsets.only(top: 10),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                _itemWidget(),
                _itemWidget(),
                _itemWidget(),
                _itemWidget(),
                _itemWidget(),
              ],
            ))
      ],
    ));
  }

  Widget _itemWidget() {
    return Container(
      margin: EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Image.network(
                  'https://pngimg.com/uploads/dog/dog_PNG50371.png',
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover)),
          Container(
            margin: EdgeInsets.only(top: 5),
            child: Text(
              'Puppy USA',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.black87),
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Text('150.000đ', style: TextStyle(color: Colors.grey)),
                Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Icon(
                      Icons.shopping_cart,
                      color: Colors.grey,
                      size: 20,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _createConfirmCartWidget() {
    final EdgeInsets _padding = MediaQuery.of(context).padding;

    return InkWell(
        onTap: () {},
        child: Container(
            padding: EdgeInsets.only(bottom: _padding.bottom / 2),
            margin: EdgeInsets.only(bottom: 10, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Xác nhận', style: TextStyle(fontSize: 16)),
                Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                    ))
              ],
            )));
  }

  Widget _createHeaderWidget() {
    return Container(
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
          Text('Giỏ hàng',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              )),
          IconButton(
            icon: Icon(
              Icons.search,
              size: 20,
              color: Colors.grey,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
