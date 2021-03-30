import 'package:flutter/material.dart';
import 'package:trans/base/screen/BaseScreen.dart';

class SearchScreen extends BaseScreen {
  @override
  Widget onInitBody(BuildContext context) {
    return Column(
      children: <Widget>[
        /// Create header widget
        _createHeaderWidget(),
      ],
    );
  }



  Widget _createHeaderWidget() {
    final EdgeInsets _padding = MediaQuery.of(context).padding;

    return Container(
        padding: EdgeInsets.only(top: _padding.top, bottom: 10),
        color: Colors.blue,
        child: Row(
          children: <Widget>[
            InkWell(
                onTap: () {
                  popScreen(context);
                },
                child: Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Icon(Icons.navigate_before, color: Colors.white))),
            Expanded(
              child: Container(
                  height: 40,
                  margin: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(color: Colors.grey[100]),
                  child: TextField(
//                      controller: searchController,

                      onChanged: (String value) {
//                        _searchGoods(value);
                      },
                      style: TextStyle(fontSize: 14),
                      maxLines: 1,
                      decoration: InputDecoration(
                          hintText: 'Tìm kiếm sản phẩm.',
                          prefixIcon: Icon(Icons.search, size: 20),
                          contentPadding: EdgeInsets.only(top: 8),
                          border: InputBorder.none))),
            ),
            InkWell(
              child: Container(
                margin: EdgeInsets.only(right: 10),
                child: Text('Đóng',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ));
  }
}
