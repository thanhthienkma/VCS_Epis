import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trans/identifiers/Screens.dart';
import 'package:trans/api/local/Note.dart';
import 'package:trans/api/local/Package.dart';
import 'package:trans/api/local/PackageFee.dart';
import 'package:trans/api/local/Payment.dart';
import 'package:trans/api/local/PrepareOrderSupport.dart';
import 'package:trans/api/request/PrepareOrderRequest.dart';
import 'package:trans/api/result/PrepareOrder.dart' as pre;
import 'package:trans/api/result/Province.dart' as p;
import 'package:trans/api/result/District.dart' as d;
import 'package:trans/api/result/Result.dart';
import 'package:trans/api/result/Ward.dart' as w;
import 'package:trans/api/local/ReceiverAddress.dart';
import 'package:trans/api/local/SenderAddress.dart';
import 'package:trans/api/result/User.dart';
import 'package:trans/api/result/WareHouse.dart' as wh;
import 'package:trans/base/screen/BaseScreen.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/dialog/district/DistrictDialog.dart';
import 'package:trans/dialog/loading/LoadingDialog.dart';
import 'package:trans/dialog/message/MessageDialog.dart';
import 'package:trans/dialog/province/ProvinceDialog.dart';
import 'package:trans/dialog/ward/WardDialog.dart';
import 'package:trans/preferences/Preferences.dart';
import 'package:trans/screens/transport/TransportScreen.dart';
import 'package:trans/screens/transport/widgets/NoteWidget.dart';
import 'package:trans/screens/transport/widgets/PackageFeeWidget.dart';
import 'package:trans/screens/transport/widgets/ReceiverWidget.dart';
import 'package:trans/screens/transport/widgets/SenderWidget.dart';
import 'package:trans/screens/transport/widgets/TransportHeaderWidget.dart';
import 'package:trans/screens/transport/widgets/WareHouseWidget.dart';
import 'package:trans/widgets/divider_widget.dart';

class PrepareOrderScreen extends BaseScreen {
  /// Init receiver controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  /// Init package fee controllers
  TextEditingController massController = TextEditingController();
  TextEditingController size1Controller = TextEditingController();
  TextEditingController size2Controller = TextEditingController();
  TextEditingController size3Controller = TextEditingController();

  /// Init note controller
  TextEditingController noteController = TextEditingController();
  String shipText;

  /// Args
  Map args = Map();

  /// Map zone
  Map mapZone = Map();

  /// Map callback
  Map mapCallback = Map();

  /// Objects save local
  SenderAddress _senderAddress;
  ReceiverAddress _receiverAddress;
  PackageFee _packageFee;
  Note _note;
  wh.Result _wareHouse;

  /// Local objects
  p.Result _currentCity;
  d.Result _currentDistrict;
  w.Result _currentWard;

  /// Init list
  List<Package> _packages;

  List<String> stringList = [
    'Không cho xem hàng',
    'Cho xem hàng, không cho thử',
    'Cho thử hàng',
  ];
  bool checked = false;
  bool enable = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Payment payment;
  User _currentUser;

  PrepareOrderRequest _prepareOrderRequest = PrepareOrderRequest();

  @override
  void initState() {
    super.initState();

    /**
     * Init data
     */
    initData();
  }

  @override
  void dispose() {
    super.dispose();
    noteController.dispose();
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
  }

  void initData() async {
    /// Get current user
    getCurrentUser();

    /// Get prepare support
    getPrepareOrderSupport();

    /// Senders callback
    sendersCallback();

    /// Receivers callback
    receiversCallback();

    /// Packages callback
    packageFeeCallback();

    /// Warehouse callback
    warehouseCallback();

    /// Handle note widget
    handleNoteWidget();
  }

  handleNoteWidget() {
    mapCallback[TransportConstants.SHIP_CALLBACK] = () {
      /// Show ship note
      _showShipNote();
    };

    mapCallback[TransportConstants.PAYMENT_CALLBACK] = (Payment payment) {
      this.payment = payment;
    };
  }

  getCurrentUser() async {
    String user = await Preferences.getUser();
    if (user == null || user.isEmpty) {
      return;
    }
    _currentUser = User.fromJson(jsonDecode(user));

    print('TOKEN : ${_currentUser.token}');
  }

  getPrepareOrderSupport() async {
    String value = await Preferences.getPrepareOrderSupport();

    if (value == null || value.isEmpty) {
      return;
    }
    var support = PrepareOrderSupport.fromJson(jsonDecode(value));

    if (support == null) {
      return;
    }

    if (support.senderAddress == null) {
      return;
    }

    /// Get warehouse
    _wareHouse = support.wareHouse;
    if (_wareHouse.address.contains('+')) {
      checked = true;
    }

    /// Get sender
    _senderAddress = support.senderAddress;

    if (support.receiverAddress == null) {
      return;
    }

    /// Get receiver
    _receiverAddress = support.receiverAddress;
    this.nameController.text = _receiverAddress.name;
    this.phoneController.text = _receiverAddress.phone;
    this.addressController.text = _receiverAddress.address;
    mapZone[TransportConstants.CITY] = _receiverAddress.city.name;
    mapZone[TransportConstants.DISTRICT] = _receiverAddress.district.name;
    mapZone[TransportConstants.WARD] = _receiverAddress.ward.name;

    _currentCity = _receiverAddress.city;
    _currentDistrict = _receiverAddress.district;
    _currentWard = _receiverAddress.ward;

    if (support.packageFee == null) {
      return;
    }

    /// Get package fee
    _packageFee = support.packageFee;

    massController.text = _packageFee.mass;
    size1Controller.text = _packageFee.size1;
    size2Controller.text = _packageFee.size2;
    size3Controller.text = _packageFee.size3;
    _packages = _packageFee.packages;

    if (support.note == null) {
      return;
    }

    /// Get note
    _note = support.note;
    this.noteController.text = _note.noteText;
    this.shipText = _note.shipText;

    if (!mounted) {
      return;
    }

    /// Update whole data
    setState(() {});
  }

  warehouseCallback() {
    mapCallback[TransportConstants.DISMISS_CALLBACK] = (bool value) {
      print('DISMISS_CALLBACK');
      setState(() {
        checked = value;
      });
    };

    mapCallback[TransportConstants.WARE_HOUSE_CALLBACK] = (wh.Result item) {
      print('WARE_HOUSE_CALLBACK');
      _senderAddress.address = item.address;
      _wareHouse = item;

      /// Update new address
      setState(() {});
    };
  }

  receiversCallback() {
    mapCallback[TransportConstants.PROVINCE_CALLBACK] = () {
      ProvinceDialog().showProvinceDialog(context, callback: (p.Result value) {
        print('Province : $value ');
        _currentCity = value;
        setState(() {
          mapZone[TransportConstants.CITY] = value.name;
        });
      });
    };
    mapCallback[TransportConstants.DISTRICT_CALLBACK] = () {
      DistrictDialog().showDistrictDialog(context, callback: (d.Result value) {
        print('District : $value');
        _currentDistrict = value;
        setState(() {
          mapZone[TransportConstants.DISTRICT] = value.name;
        });
      });
    };
    mapCallback[TransportConstants.WARD_CALLBACK] = () {
      WardDialog().showWardDialog(context, callback: (w.Result value) {
        print('Ward : $value');
        _currentWard = value;
        setState(() {
          mapZone[TransportConstants.WARD] = value.name;
        });
      });
    };
  }

  sendersCallback() {
    mapCallback[TransportConstants.WAREHOUSE_CALLBACK] = (bool value) {
      if (_senderAddress == null ||
          _senderAddress.address == null ||
          _senderAddress.address.isEmpty) {
        _showMessageSnackBar(
            'Hãy điền thông tin người nhận trước khi chọn ware house.');
        return;
      }

      setState(() {
        checked = value;
      });

      /// Show  ware houses
      _showWareHouses();
    };
    mapCallback[TransportConstants.UPDATE_ADDRESS_CALLBACK] = () async {
      args[TransportConstants.SENDER_ADDRESS] = this._senderAddress;

      /// Go to add update address screen
      var result = await pushScreen(
          BaseWidget(screen: Screens.UPDATE_ADDRESS, arguments: args),
          Screens.UPDATE_ADDRESS);

      if (result == null) {
        return;
      }
      _senderAddress = result;
      if (_senderAddress.address.contains('+')) {
        checked = true;
      } else {
        checked = false;
      }

      if (!mounted) {
        return;
      }

      /// Update new data
      setState(() {});
    };
  }

  packageFeeCallback() {
    mapCallback[TransportConstants.ADD_ORDER_CALLBACK] = () async {
      args[TransportConstants.PACKAGE_LIST] = _packages;

      /// Go to add order screen
      var result = await pushScreen(
          BaseWidget(screen: Screens.ADD_ORDER, arguments: args),
          Screens.ADD_ORDER);

      if (result == null) {
        return;
      }

      /// Update new data
      setState(() {
        _packages = result;
      });
    };
    mapCallback[TransportConstants.TERM_CALLBACK] = () {
      /// Go to terms screen
      pushScreen(BaseWidget(screen: Screens.TERMS), Screens.TERMS);
    };
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

  void _showShipNote() {
    print('_showShipNote');

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
              height: 200,
              child: ListView.builder(
                  itemCount: stringList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                        onTap: () {
                          setState(() {
                            this.shipText = stringList[index];
                          });
                          popScreen(context);
                        },
                        child: Column(
                          children: <Widget>[
                            Container(
                                padding: paddingAll15,
                                child: Text(stringList[index])),
                            DividerWidget(),
                          ],
                        ));
                  }));
        });
  }

  @override
  Widget onInitBody(BuildContext context) {
    return Column(
      children: [
        /// Transport header widget
        TransportHeaderWidget('Lên đơn hàng',
            textAlign: TextAlign.center,
            leftCallback: () => popScreen(context, data: true)),

        Expanded(
          child: ListView(
            children: [
              /// Create sender widget
              _createSenderWidget(),

              /// Create receiver widget
              _createReceiverWidget(),

              /// Package fee widget
              _createPackageFeeWidget(),

              /// Create note widget
              _createNoteWidget(),
            ],
          ),
        ),

        /// Create bottom widget
        _createBottomWidget(),
      ],
    );
  }

  Widget _createSenderWidget() {
    return SenderWidget(checked,
        mapCallback: this.mapCallback, senderAddress: this._senderAddress);
  }

  Widget _createReceiverWidget() {
    String key = phoneController.text;

    return Container(
        key: Key(key),
        child: ReceiverWidget(
            nameController: this.nameController,
            phoneController: this.phoneController,
            addressController: this.addressController,
            receiverAddress: this._receiverAddress,
            mapZone: this.mapZone,
            mapCallback: this.mapCallback));
  }

  Widget _createPackageFeeWidget() {
    return PackageFeeWidget(
        massController: this.massController,
        size1Controller: this.size1Controller,
        size2Controller: this.size2Controller,
        size3Controller: this.size3Controller,
        packageFee: this._packageFee,
        packages: this._packages,
        mapCallback: this.mapCallback);
  }

  Widget _createNoteWidget() {
    return NoteWidget(
        shipText: this.shipText,
        textEditingController: this.noteController,
        mapCallback: this.mapCallback);
  }

  Widget _createBottomWidget() {
    return Card(
      elevation: 10,
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 20),
            child: Row(
              children: [
                /// Create save draft widget
                _createSaveDraftWidget(() {
                  /**
                   * Handle save draft
                   */
                  _handleSaveDraft();
                }),

                /// Create line widget
                _createLineWidget(),

                /// Create order widget
                _createOrderWidget(() {
//                  /**
//                   * Show confirm order dialog
//                   */
//                  _showConfirmOrderDialog(pressOk: () {
//                    /**
//                     * Handle create order
//                     */
//                    _handleCreateOrder();
//                  });

                  _handleCreateOrder();
                })
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _createSaveDraftWidget(Function callback) {
    return Expanded(
        child: GestureDetector(
      onTap: () {
        callback();
      },
      child: Container(
        color: Colors.grey[300],
        padding: paddingAll15,
        alignment: Alignment.center,
        child: Text(
          'Lưu nháp',
          style: TextStyle(color: Colors.white, fontSize: font16),
        ),
      ),
    ));
  }

  Widget _createLineWidget() {
    return Container(color: Colors.white, height: 20, width: 1);
  }

  Widget _createOrderWidget(Function callback) {
    return Expanded(
        child: GestureDetector(
      onTap: () {
        callback();
      },
      child: Container(
        color: Colors.orange,
        padding: paddingAll15,
        alignment: Alignment.center,
        child: Text('Tạo đơn hàng',
            style: TextStyle(color: Colors.white, fontSize: font16)),
      ),
    ));
  }

  _handleSaveDraft() {
    /**
     * Map data into object
     */
    _mapDataIntoObject();

    /// Support
    PrepareOrderSupport support = PrepareOrderSupport(
        senderAddress: _senderAddress,
        receiverAddress: _receiverAddress,
        packageFee: _packageFee,
        note: _note,
        wareHouse: _wareHouse);
    print(support);

    /// Save support to local
    Preferences.savePrepareOrderSupport(jsonEncode(support.toJson()));

    /// Show message snack bar
    _showMessageSnackBar('Lưu nháp thành công.');
  }

  _mapDataIntoObject() {
    _receiverAddress = ReceiverAddress(
        name: this.nameController.text,
        phone: this.phoneController.text,
        address: this.addressController.text,
        city: _currentCity,
        district: _currentDistrict,
        ward: _currentWard);

    _note = Note(shipText: this.shipText, noteText: this.noteController.text);
    _packageFee = PackageFee(
        mass: this.massController.text,
        size1: this.size1Controller.text,
        size2: this.size2Controller.text,
        size3: this.size3Controller.text,
        packages: _packages);
  }

  _handleCreateOrder() {
    /**
     * Map data into object
     */
    _mapDataIntoObject();
    /**
     * Validate input
     */
    if (validate()) {
      return;
    }
    Map<String, dynamic> data = Map();

    /// Sender
    data['consignee_name'] = _senderAddress.name;
    data['consignee_phone'] = _senderAddress.phone;
    data['consignee_address'] = _senderAddress.address;
    data['transport_code'] = _senderAddress.postCode;
    data['lat'] = _senderAddress.latitude;
    data['long'] = _senderAddress.longitude;

    /// Receiver
    data['receiver_name'] = _receiverAddress.name;
    data['receiver_phone'] = _receiverAddress.phone;
    data['receiver_address'] = _receiverAddress.address;
    _currentCity = _receiverAddress.city;
    data['province_id'] = _currentCity.id;
    _currentDistrict = _receiverAddress.district;
    data['district_id'] = _currentDistrict.id;
    _currentWard = _receiverAddress.ward;
    data['ward_id'] = _currentWard.id;

    /// Package fee
    data['mass'] = int.tryParse(_packageFee.mass);
    data['size1'] = int.tryParse(_packageFee.size1);
    data['size2'] = int.tryParse(_packageFee.size2);
    data['size3'] = int.tryParse(_packageFee.size3);
    data['categories'] = jsonEncode(_packages);

    /// Note
    data['note'] = _note.noteText;
    data['delivery_note'] = _note.shipText;
    data['method'] = payment == null ? '0' : payment.code;
    data['save'] = '0';

    /// @checked {true : shipper takes order to ware house, false : user brings order to ware house}
    if (checked) {
      data['in_warehouse'] = '1';
      data['warehouse_id'] = _wareHouse.id;
    } else {
      data['warehouse_id'] = _senderAddress.result.id;
    }

    /**
     * Call API submit order
     */

    submitOrder(data);
  }

  bool validate() {
    if (_senderAddress == null) {
      _showMessageSnackBar('Thông tin người gửi chưa có !');
      return true;
    }

    if (_receiverAddress == null ||
        nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty ||
        mapZone[TransportConstants.CITY].isEmpty ||
        mapZone[TransportConstants.DISTRICT].isEmpty ||
        mapZone[TransportConstants.WARD].isEmpty) {
      _showMessageSnackBar('Thông tin người nhận chưa có hoặc chưa đầy đủ !');
      return true;
    }

    if (_packageFee == null ||
        _packages == null ||
        _packages.isEmpty ||
        massController.text.isEmpty ||
        size1Controller.text.isEmpty ||
        size2Controller.text.isEmpty ||
        size3Controller.text.isEmpty) {
      _showMessageSnackBar('Thông tin hàng hoá chưa có hoặc chưa đầy đủ !');

      return true;
    }
    return false;
  }

  void _showMessageSnackBar(String text) {
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text(text), duration: Duration(milliseconds: 2000)));
  }

  @override
  BoxDecoration onInitBackground(BuildContext context) {
    return BoxDecoration(color: Color(0xffF8F8F8));
  }

  @override
  Key onInitKey(BuildContext context) {
    return _scaffoldKey;
  }

  void submitOrder(Map data) async {
    LoadingDialog.instance.showLoadingDialog(context);

    Map<String, dynamic> headers = Map();
    headers['Authorization'] = 'Bearer ${_currentUser.token}';
    Result<dynamic> result = await _prepareOrderRequest.callRequest(context,
        data: data, headers: headers, url: 'https://vanchuyen.etado.vn/api/v1');
    print(result);
    await LoadingDialog.instance.dismissLoading();
    if (result.isSuccess()) {
      pre.PrepareOrder prepareOrder = result.data;
      Map<String, dynamic> args = Map();
      args['prepare_order'] = prepareOrder;
      args['user'] = _currentUser;

      pushScreen(BaseWidget(screen: Screens.CONFIRM_ORDER, arguments: args),
          Screens.CONFIRM_ORDER);
    } else if (result.code == 500) {
      MessageDialog.instance.showMessageOkDialog(
          context,
          '',
          'Đơn hàng không thể tạo do bạn đã đăng nhập tài khoản này ở thiết bị khác.'
              ' Đăng nhập lại để thực hiện chức năng này, hãy nhớ lưu nháp đơn hàng. ',
          'assets/images/failure.png');
    } else {
      MessageDialog.instance.showMessageOkDialog(context, '',
          'Kết nối đương truyền không ổn định.', 'assets/images/failure.png');
    }
  }
}
