import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trans/identifiers/Screens.dart';
import 'package:trans/base/screen/BaseScreen.dart';

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

final List<Widget> imageSliders = imgList
    .map((item) => Container(
          child: Container(
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    Image.network(item,
                        fit: BoxFit.cover, width: double.maxFinite),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Text(
                          'No. ${imgList.indexOf(item)} image',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ))
    .toList();

class Category {
  String text;
  bool selected;

  Category({this.text, this.selected});

  List<Category> initCategories() {
    List<Category> list = List();
    list.add(Category(text: 'Tất cả', selected: true));
    list.add(Category(text: 'Vệ sinh', selected: false));
    list.add(Category(text: 'Trang trí', selected: false));
    list.add(Category(text: 'Thực phẩm chức năng', selected: false));
    list.add(Category(text: 'Phụ kiện xe', selected: false));
    list.add(Category(text: 'Nước hoa', selected: false));
    list.add(Category(text: 'Trang sức', selected: false));
    return list;
  }
}

class ProductScreen extends BaseScreen {
  List<Category> categoryList = Category().initCategories();
  int count = 0;
  String greeting;
  double categoryHeight = 40.0;

  @override
  Widget onInitBody(BuildContext context) {
    return Column(
      children: <Widget>[
        /// Create header widget
        _createHeaderWidget(),

        /// Create body widget
        _createBodyWidget(),
      ],
    );
  }

  Widget _createBodyWidget() {
    return Expanded(
      child: ListView(
        children: <Widget>[
          /// Create sponsors widget
          _createSponsorsWidget(),

          /// Create categories widget
          _createCategoriesWidget(),

          /// Create products widget
          _createProductsWidget(),
        ],
      ),
    );
  }

  Widget _createHeaderWidget() {
    final EdgeInsets _padding = MediaQuery.of(context).padding;

    return Container(
        padding: EdgeInsets.only(top: _padding.top, bottom: 10),
        color: Colors.blue,
        child: Column(
          children: <Widget>[
            /// Create greetings widget
            _createGreetingWidget(),

            /// Create search widget
            _createSearchWidget(),
          ],
        ));
  }

  Widget _createGreetingWidget() {
    return Container(
        margin: EdgeInsets.only(left: 20, top: 10, right: 20),
        child: Row(
          children: <Widget>[
            Expanded(
                child: Text('$greetings, Nam Agile',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontStyle: FontStyle.italic))),
            Icon(Icons.shopping_cart, color: Colors.grey[300]),
          ],
        ));
  }

  Widget _createProductsWidget() {
    double deviceWidth = MediaQuery.of(context).size.width;
    int widgetsInRow = 1;

    if (deviceWidth > 1200) {
      widgetsInRow = 3;
    } else if (deviceWidth > 768) {
      widgetsInRow = 2;
    }

    double aspectRatio = MediaQuery.of(context).size.height / 600;
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 1,
      padding: EdgeInsets.all(5.0),
      mainAxisSpacing: 10.0,
      childAspectRatio: MediaQuery.of(context).size.height / 600,
      cacheExtent: 10000,
      physics: ClampingScrollPhysics(),
      children: List.generate(6, (index) {
        return _itemProduct();
      }),
    );
//    return GridView.builder(
//        padding: EdgeInsets.symmetric(horizontal: 10),
////            itemCount: 0,
//        shrinkWrap: true,
//        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//            crossAxisCount: widgetsInRow,
//            crossAxisSpacing: 10,
//            childAspectRatio: aspectRatio),
//        itemBuilder: (BuildContext context, int index) {
//          return _itemProduct();
//        });
  }

  Widget _itemProduct() {
    return InkWell(
        onTap: () {
          pushScreen(BaseWidget(screen: Screens.PRODUCT_DETAIL),
              Screens.PRODUCT_DETAIL);
        },
        child: Card(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.topRight,
              constraints: BoxConstraints.expand(height: 150),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4)),
                  image: DecorationImage(
                      image: NetworkImage(imgList[2]), fit: BoxFit.cover)),
              child: Container(
//                margin: EdgeInsets.only(top: 10, right: 10),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(4),
                        bottomLeft: Radius.circular(4))),
                child: Text('Ưu đãi 29%',
                    style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 5, left: 5, right: 5),
                margin: EdgeInsets.only(top: 5, left: 5, right: 5),
                child: Text(
                  'Ghế sofa được ngoài biển với trang trí theo phong cách biển, mang cảm giác tận hương bãi biển',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                )),
            Container(
              margin: EdgeInsets.only(left: 5, right: 5),
              padding: EdgeInsets.all(5),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(child: Text('Giá gốc : 39.000.000 vnd')),
                      Container(
                          margin: EdgeInsets.only(top: 3),
                          child: Text('Giá ưu đãi : 17.529.000 vnd')),
                      Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.star,
                                color: Colors.yellow[600],
                                size: 20,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.yellow[600],
                                size: 20,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.yellow[600],
                                size: 20,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Text('(3)'),
                              ),
                            ],
                          )),
                    ],
                  )),
                  Container(
                      margin: EdgeInsets.only(right: 3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  count++;
                                });
                              },
                              child: Container(
                                  child: Icon(Icons.add_shopping_cart,
                                      size: 20, color: Colors.red))),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Text(
                              'Còn lại 5',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ],
        )));
  }

  Widget _itemCategory(Category category) {
    return category.selected
        ? Container(
            height: categoryHeight,
            margin: EdgeInsets.only(top: 10, left: 10),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(4))),
            child: Text(
              category.text,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ))
        : Container(
            height: categoryHeight,
            margin: EdgeInsets.only(top: 10, left: 10),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                border: Border.all(width: 1, color: Colors.blueGrey)),
            child: Text(
              category.text,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black),
            ));
  }

  Widget _createCategoriesWidget() {
    return Container(
        height: categoryHeight,
        child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: categoryList.map((element) {
              return _itemCategory(element);
            }).toList()));
  }

  Widget _createSponsorsWidget() {
    return Container(
        height: 120,
        width: double.maxFinite,
        child: CarouselSlider(
          options: CarouselOptions(
              aspectRatio: 2.0,
              enlargeCenterPage: true,
              initialPage: 2,
              autoPlay: true),
          items: imageSliders,
        ));
  }

  Widget _createSearchWidget() {
    return Container(
        margin: EdgeInsets.only(top: 10, left: 20, right: 20),
        child: GestureDetector(
          onTap: () {
            print('search');

            pushScreen(BaseWidget(screen: Screens.SEARCH), Screens.SEARCH);
          },
          child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              child: Row(
                children: <Widget>[
                  Row(children: <Widget>[
                    Icon(Icons.search, size: 20),
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      child: Text('Tìm kiếm sản phẩm.'),
                    ),
                  ]),
                ],
              )),
        ));
  }

  /// Set up greetings
  String get greetings {
    DateTime now = DateTime.now().toLocal();
    String time = DateFormat.Hm().format(now);
    int hour = int.parse(time.substring(0, 2));

    if (hour > 6 && hour <= 11) {
      /// For morning
      setState(() {
        greeting = 'Good moring';
      });
    } else if (hour > 12 && hour <= 18) {
      /// For evening
      setState(() {
        greeting = 'Good evening';
      });
    } else {
      /// For night
      setState(() {
        greeting = 'Good night';
      });
    }
    return greeting;
  }

  @override
  PreferredSize onInitAppBar(BuildContext context) {
    return null;
  }
}
