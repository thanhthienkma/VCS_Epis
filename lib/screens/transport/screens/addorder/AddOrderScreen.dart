import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trans/api/local/Package.dart';
import 'package:trans/api/result/Goods.dart' as g;
import 'package:trans/base/screen/BaseScreen.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/components/button/ButtonComponent.dart';
import 'package:trans/screens/transport/TransportScreen.dart';
import 'package:trans/screens/transport/items/package/PackageItem.dart';
import 'package:trans/screens/transport/items/type/TypeItem.dart';
import 'package:trans/screens/transport/widgets/TransportHeaderWidget.dart';

class AddOrderScreen extends BaseScreen {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  /// Init stream
  StreamController itemStream = StreamController<Package>.broadcast();

  /// Init controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  List<Package> packageList;
  int numPackage = 0;
  g.Result good;
  List<g.Result> _list = List();
  List<g.Result> searchList = List();
  Map args = Map();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    /**
     * Init data
     */
    initData();
  }

  void initData() async {
    /// Get arguments
    getArguments();

    /// Get goods
    _getGoods();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    quantityController.dispose();
    itemStream.close();
  }

  getArguments() {
    args = widget.arguments;
    packageList = args[TransportConstants.PACKAGE_LIST];
    if (packageList == null) {
      packageList = List();
      return;
    }
    numPackage = packageList.length;
  }

  _getGoods() async {
    try {
      Response response =
          await Dio().get('https://vanchuyen.etado.vn/api/v1/goods');
      print(response);
      final data = response.data['data']['result'];
      for (var item in data) {
        g.Result obj = g.Result.fromJson(item);
        _list.add(obj);
      }
    } catch (e) {
      print(e);
    }
    if (!mounted) {
      return;
    }
    loading = true;
    searchList = _list;

    /// Update new data
    setState(() {});
  }

  bool validate() {
    if (nameController.text.isEmpty) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('Vui lòng thêm tên hàng!')));
      return true;
    }
    if (quantityController.text.isEmpty) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('Vui lòng thêm số lượng!')));
      return true;
    }

    return false;
  }

  void addData() {
    /// Input validated
    if (validate()) {
      return;
    }

    packageList.add(Package(
        categoryId: good.id,
        type: good.name,
        name: nameController.text,
        amount: quantityController.text));
    setState(() {
      numPackage++;
    });

    /// Clear data
    clearData();
  }

  clearData() {
    nameController.clear();
    quantityController.clear();
  }

  _handleDelete(Package item) {
    packageList.removeWhere((element) {
      if (item.categoryId == element.categoryId) {
        return true;
      }
      return false;
    });

    item.deleted = true;
    itemStream.sink.add(item);
  }

  void _searchGoods(String value) {
    if (value.isEmpty) {
      searchList = _list;
    } else {
      /// Clone list
      searchList = _list.where((element) {
        var name = element.name;
        if (name == null) {
          name = '';
        }
        if (name.toLowerCase().contains(value.toLowerCase())) {
          return true;
        } else {
          return false;
        }
      }).toList();
      if (!mounted) {
        return;
      }

      setState(() {});
    }
  }

  void showPackagesType() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
              height: 500,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  /// Search
                  Container(
                      decoration: BoxDecoration(
                          color: colorGray,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(5))),
                      child: TextField(
                          controller: searchController,
                          onChanged: (String value) {
                            _searchGoods(value);
                          },
                          style: TextStyle(fontSize: font14),
                          maxLines: 1,
                          decoration: InputDecoration(
                              hintText: 'Tìm kiếm loại hàng.',
                              contentPadding: paddingLeft10,
                              border: InputBorder.none))),

                  /// Package list
                  Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: searchList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return TypeItem(searchList[index],
                                callback: (g.Result value) {
                              /// Update item selected
                              if (good == null) {
                                value.selected = true;
                                good = value;
                              } else {
                                good.selected = false;
                                value.selected = true;
                                good = value;
                              }

                              /// Update new data
                              setState(() {});
                            });
                          })),
                ],
              ));
        });
  }

  @override
  Widget onInitBody(BuildContext context) {
    if (loading == false) {
      return SpinKitFadingCube(color: primaryColor, size: 40);
    }

    return Column(
      children: [
        /// Transport header widget
        TransportHeaderWidget('Thêm đơn hàng', textAlign: TextAlign.center,
            leftCallback: () {
          popScreen(context, data: packageList);
        }),

        Expanded(
            child: Container(
                padding: paddingAll20,
                child: ListView(
                  children: [
                    /// Package type
                    _createDropdownWidget(
                        'Loại hàng gửi', good == null ? 'Chọn...' : good.name,
                        callback: () {
                      if (loading) {
                        /// Show list of packages type
                        showPackagesType();
                      }
                    }),

                    /// Package name
                    _createItemWidget('Tên', 'Nhập tên hàng',
                        textEditingController: nameController),

                    /// Quantity
                    _createItemWidget('Số lượng', 'Nhập số lượng',
                        textEditingController: quantityController,
                        hasNumber: false),

                    /// Add order
                    ButtonComponent(
                      text: 'Thêm',
                      color: Colors.orange,
                      onClick: () {
                        addData();
                      },
                    ),

                    Container(
                      margin: marginTop20,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: packageList.length,
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return PackageItem(
                              packageList[index],
                              index + 1,
                              itemStream: this.itemStream,
                              deleteCallback: (Package item) {
                                /// Handle delete
                                _handleDelete(item);
                              },
                            );
                          }),
                    ),
                  ],
                ))),
      ],
    );
  }

  Widget _createItemWidget(String title, String content,
      {bool hasNumber = true, TextEditingController textEditingController}) {
    return Container(
        margin: marginTop15,
        child: Column(
          children: [
            /// Title
            Row(
              children: [
                Text(title),
                Text('*', style: TextStyle(color: Colors.orange))
              ],
            ),

            /// Box
            Container(
                margin: marginTop5,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: TextField(
                    keyboardType:
                        hasNumber ? TextInputType.text : TextInputType.number,
                    controller: textEditingController,
                    style: TextStyle(fontSize: font14),
                    maxLines: 1,
                    onChanged: (String text) {},
                    decoration: InputDecoration(
                      hintText: content,
                      contentPadding: paddingLeft10,
                      border: InputBorder.none,
                    )))
          ],
        ));
  }

  Widget _createDropdownWidget(
    String title,
    String content, {
    Function callback,
  }) {
    return GestureDetector(
        onTap: () {
          callback();
        },
        child: Container(
            margin: marginTop10,
            child: Column(
              children: [
                /// Title
                Row(
                  children: [
                    Text(title),
                    Text(
                      '*',
                      style: TextStyle(color: Colors.orange),
                    )
                  ],
                ),

                Container(
                  margin: EdgeInsets.only(top: 5),
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          margin: marginLeft10,
                          child: Text(content,
                              style: TextStyle(color: Colors.grey))),
                      Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                    ],
                  ),
                ),
              ],
            )));
  }

  @override
  Key onInitKey(BuildContext context) {
    return _scaffoldKey;
  }
}
