import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trans/api/result/Ward.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/widgets/divider_widget.dart';

class WardWidget extends StatefulWidget {
  final Function(Result value) callback;

  WardWidget({this.callback});

  @override
  State<StatefulWidget> createState() => _WardWidgetState();
}

class _WardWidgetState extends State<WardWidget> {
  TextEditingController searchController = TextEditingController();
  List<Result> list = List();
  List<Result> searchList = List();
  bool loading = false;
  bool disconnect = false;

  @override
  void initState() {
    super.initState();

    /**
     * Get wards
     */
    getWards();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: Stack(
        children: <Widget>[
          /// Ward List Widget
          _wardListWidget((String value) {
            /// Search district
            searchWard(value);
          }),

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

  Widget _wardListWidget(Function(String value) callback) {
    return Container(
      height: 300,
      padding: paddingAll10,
      margin: EdgeInsets.only(top: 13.0, right: 8.0),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
              margin: marginTop10,
              decoration: BoxDecoration(
                  color: colorGray,
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              child: TextField(
                  controller: searchController,
                  onChanged: (String value) {
                    callback(value);
                  },
                  style: TextStyle(fontSize: font14),
                  maxLines: 1,
                  decoration: InputDecoration(
                      hintText: 'Tìm kiếm phường - xã.',
                      contentPadding: paddingLeft10,
                      border: InputBorder.none))),
          disconnect
              ? Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 40),
                  child: Text('Không có kết nối mang :(',
                      style: TextStyle(color: Colors.grey)),
                )
              :

              /// Wards
              Expanded(
                  child: !loading
                      ? SpinKitCircle(color: Colors.orange, size: 35)
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: searchList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _createItemWidget(searchList[index],
                                callback: (Result value) {
                              widget.callback(value);
                            });
                          }),
                ),
        ],
      ),
    );
  }

  Widget _createItemWidget(Result value, {Function(Result value) callback}) {
    return Container(
        key: Key(value.id.toString()),
        child: InkWell(
            onTap: () {
              callback(value);
            },
            child: Container(
                margin: marginTop5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    /// Name
                    Container(padding: paddingAll10, child: Text(value.name)),

                    /// Divider widget
                    DividerWidget(),
                  ],
                ))));
  }

  void searchWard(String value) {
    if (value.isEmpty) {
      searchList = list;
    } else {
      /// Clone list
      searchList = list.where((element) {
        var wardName = element.name;
        if (wardName == null) {
          wardName = '';
        }
        if (wardName.toLowerCase().contains(value.toLowerCase())) {
          return true;
        } else {
          return false;
        }
      }).toList();
      if (!mounted) {
        return;
      }

      /// Update new list
      setState(() {});
    }
  }

  getWards() async {
    try {
      Response response =
          await Dio().get('https://vanchuyen.etado.vn/api/v1/wards?');
      print(response);
      final data = response.data['data']['result'];
      for (var item in data) {
        Result obj = Result.fromJson(item);
        list.add(obj);
      }
    } catch (e) {
      print(e);
      disconnect = true;
    }
    loading = true;

    searchList = list;
    if (!mounted) {
      return;
    }

    /// Update new data
    setState(() {});
  }
}
