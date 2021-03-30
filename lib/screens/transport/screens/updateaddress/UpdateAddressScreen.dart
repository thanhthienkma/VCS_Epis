import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:trans/api/local/SenderAddress.dart';
import 'package:trans/api/result/User.dart';
import 'package:trans/api/result/WareHouse.dart';
import 'package:trans/base/screen/BaseScreen.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/components/button/ButtonComponent.dart';
import 'package:trans/preferences/Preferences.dart';
import 'package:trans/screens/transport/TransportScreen.dart';
import 'package:trans/screens/transport/widgets/TransportHeaderWidget.dart';
import 'package:trans/screens/transport/widgets/WareHouseWidget.dart';

class UpdateAddressScreen extends BaseScreen {
  /// Init controllers
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController postcodeController = TextEditingController();
  Result _result;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  SenderAddress _senderAddress;
  User currentUser;
  final Geolocator _geolocator = Geolocator();

  /// Map callback
  Map mapCallback = Map();

  @override
  void initState() {
    super.initState();

    /**
     * Init data
     */
    initData();

    /**
     * Handle map callback
     */
    handleMapCallback();
  }

  initData() {
    Map args = widget.arguments;
    _senderAddress = args[TransportConstants.SENDER_ADDRESS];
    if (_senderAddress == null) {
      return;
    }
    nameController.text = this._senderAddress.name;
    phoneController.text = this._senderAddress.phone;
    addressController.text = this._senderAddress.address;
    postcodeController.text = this._senderAddress.postCode;
    _result = this._senderAddress.result;
  }

  handleMapCallback() {
    mapCallback[TransportConstants.WARE_HOUSE_CALLBACK] = (Result item) {
      print('WARE_HOUSE_CALLBACK');
      _result = item;

      if (!mounted) {
        return;
      }

      /// Update new address
      setState(() {});
    };

    mapCallback[TransportConstants.DISMISS_CALLBACK] = (bool value) {
      print('DISMISS_CALLBACK');
    };
  }

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
    nameController.dispose();
    addressController.dispose();
    postcodeController.dispose();
  }

  Future<Placemark> _findLatLng(String address) async {
    bool connection = await checkConnection();
    if (connection) {
      _showMessageSnackBar('Kết nối đường truyền để lấy vị trí người gửi.');
      return null;
    }

    Placemark data;
    final List<Placemark> placemarks =
        await Future(() => _geolocator.placemarkFromAddress(address))
            .catchError((onError) {
      return Future.value(List<Placemark>());
    });

    if (placemarks != null && placemarks.isNotEmpty) {
      final Placemark pos = placemarks[0];
      data = pos;
    }
    return data;
  }

  String initText(String value) {
    if (value == null || value.isEmpty) {
      return 'chưa cập nhật';
    }
    return value;
  }

  Future<bool> checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
      return false;
    } on SocketException catch (_) {
      print('not connected');
      return true;
    }
  }

  @override
  Widget onInitBody(BuildContext context) {
    return Column(
      children: [
        /// Transport header widget
        TransportHeaderWidget(
          'Cập nhật địa chỉ lấy hàng',
          textAlign: TextAlign.center,
          leftCallback: () {
            popScreen(context);
          },
        ),
        Expanded(
          child: Container(
            padding: paddingAll15,
            child: ListView(
              children: [
                /// Name
                _createItemWidget('Họ tên', 'Vui lòng nhập họ tên',
                    textEditingController: nameController),

                /// Phone number
                _createItemWidget(
                    'Số điện thoại', 'Vui lòng nhập số điện thoại',
                    textEditingController: phoneController, isNumber: false),

                /// Address
                _createItemWidget(
                    'Địa chỉ gửi', '( VD : 361 kent, sydney, 2000 )',
                    textEditingController: addressController),

                _createDropdownWidget('Gửi tại kho',
                    _result == null ? 'Chọn kho để gửi hàng' : _result.address,
                    callback: () {
                  /// Show  ware houses
                  _showWareHouses();
                }),

                /// Post code
                _createItemWidget('Postcode', 'Vui lòng nhập postcode',
                    textEditingController: postcodeController, isNumber: false),

                /// Button component
                ButtonComponent(
                  text: 'Cập nhật',
                  color: Colors.orange[600],
                  margin: 30,
                  onClick: () async {
                    if (validate()) {
                      return;
                    }

                    Placemark placeMark =
                        await _findLatLng(addressController.text);

                    if (placeMark == null) {
                      _showMessageSnackBar('Địa chỉ nhập không hợp lệ.');
                      return;
                    }

                    SenderAddress object = SenderAddress(
                        phone: phoneController.text,
                        name: nameController.text,
                        address: addressController.text,
                        latitude: placeMark.position.latitude.toString(),
                        longitude: placeMark.position.longitude.toString(),
                        result: _result,
                        postCode: postcodeController.text);

                    popScreen(context, data: object);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _createDropdownWidget(String title, String content,
      {Function() callback}) {
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
                          child: Text(
                            content,
                            style: TextStyle(color: Colors.black54),
                          )),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }

  Widget _createItemWidget(String title, String content,
      {TextEditingController textEditingController, bool isNumber = true}) {
    return Container(
        margin: marginTop20,
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

            /// Box
            Container(
                margin: marginTop5,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: TextField(
                    controller: textEditingController,
                    keyboardType:
                        isNumber ? TextInputType.text : TextInputType.number,
                    style: TextStyle(fontSize: font14),
                    maxLines: 1,
                    onChanged: (String text) {},
                    decoration: InputDecoration(
                      hintText: content,
                      contentPadding: paddingLeft10,
                      border: InputBorder.none,
                    ))),
          ],
        ));
  }

  void _showWareHouses() {
    print('_showWareHouses');

    showModalBottomSheet(
        context: context,
        isDismissible: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8))),
        builder: (BuildContext bc) {
          return WareHouseWidget(mapCallback: this.mapCallback);
        });
  }

  bool validate() {
    if (nameController.text.isEmpty) {
      _showMessageSnackBar('Vui lòng thêm họ tên.');
      return true;
    }
    if (phoneController.text.isEmpty) {
      _showMessageSnackBar('Vui lòng thêm số điện thoại.');
      return true;
    }

    if (addressController.text.isEmpty) {
      _showMessageSnackBar('Vui lòng thêm địa chỉ.');
      return true;
    }
    if (_result == null) {
      _showMessageSnackBar('Vui lòng chọn kho gửi hàng.');
      return true;
    }
    if (postcodeController.text.isEmpty) {
      _showMessageSnackBar('Vui lòng thêm post code.');
      return true;
    }
    return false;
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
