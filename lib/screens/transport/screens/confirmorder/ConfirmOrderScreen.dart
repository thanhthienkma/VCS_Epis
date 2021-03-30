import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trans/api/request/PrepareOrderRequest.dart';
import 'package:trans/api/result/Result.dart';
import 'package:trans/api/result/User.dart';
import 'package:trans/api/result/PrepareOrder.dart' as pre;
import 'package:trans/base/screen/BaseScreen.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/components/button/ButtonComponent.dart';
import 'package:trans/dialog/confirm/ConfirmDialog.dart';
import 'package:trans/dialog/loading/LoadingDialog.dart';
import 'package:trans/dialog/message/MessageDialog.dart';
import 'package:trans/identifiers/Screens.dart';
import 'package:trans/preferences/Preferences.dart';
import 'package:trans/screens/transport/widgets/TransportHeaderWidget.dart';
import 'package:trans/widgets/divider_widget.dart';

class ConfirmOrderScreen extends BaseScreen {
  pre.PrepareOrder _prepareOrder;
  User _currentUser;
  PrepareOrderRequest _prepareOrderRequest = PrepareOrderRequest();

  Map args = Map();

  @override
  void initState() {
    super.initState();

    /**
     * Get arguments
     */
    _getArguments();
  }

  _getArguments() {
    args = widget.arguments;
    _prepareOrder = args['prepare_order'];
    _currentUser = args['user'];
  }

  _initText(String text) {
    if (text == null || text.isEmpty) {
      return '';
    }
    return text;
  }

  @override
  Widget onInitBody(BuildContext context) {
    return Column(
      children: [
        /// Transport header widget
        TransportHeaderWidget('Xác nhận đơn hàng',
            textAlign: TextAlign.center,
            leftCallback: () => popScreen(context)),

        /// Create info widget
        _createInfoWidget(),

        /// Create confirm order widget
        _createConfirmOrderWidget(),
      ],
    );
  }

  Widget _createInfoWidget() {
    return Expanded(
        child: ListView(
      children: [
        Card(
            margin: marginAll20,
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Container(
                padding: paddingAll10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Create sender info widget
                    _createSenderInfoWidget(),

                    /// Create receiver info widget
                    _createReceiverInfoWidget(),

                    /// Create order info widget
                    _createOrderInfoWidget(),

                    /// Create note info widget
                    _createNoteInfoWidget(),
                  ],
                ))),
      ],
    ));
  }

  Widget _createNoteInfoWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _createTitle('Ghi chú'),

        /// Note for shipping
        _createSubTitle('Lưu ý giao hàng',
            value: _initText(_prepareOrder.data.result.deliveryNote)),

        /// Payment
        _createSubTitle('Phương thức thanh toán',
            value: _initText(_prepareOrder.data.result.method)),

        /// Note for driver
        _createSubTitle('Ghi chú',
            value: _initText(_prepareOrder.data.result.note)),
      ],
    );
  }

  Widget _createOrderInfoWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _createTitle('Thông tin hàng hoá'),

        /// Mass of orders

        _createSubTitle('Khối lượng hàng hoá',
            value: '${_prepareOrder.data.result.mass}g '),

        /// Value of orders
        _createSubTitle('Giá trị hàng hoá',
            value: '${_prepareOrder.data.result.goodsMoney} \$ AUD'),

        /// Shipping fee
        _createSubTitle('Hàng có phụ phí',
            value: '${_prepareOrder.data.result.surcharge} \$ AUD'),

        /// Shipping fee
        _createSubTitle('Tiền ship ',
            value: '${_prepareOrder.data.result.shippingMoney} \$ AUD'),

        /// Total
        _createSubTitle('Tổng tiền ',
            value: '${_prepareOrder.data.result.totalMoney} \$ AUD'),

        /// List of packages
        Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: _prepareOrder.data.result.categories.length,
                physics: ClampingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return _itemWidget(
                      _prepareOrder.data.result.categories[index], index + 1);
                })),
      ],
    );
  }

  Widget _itemWidget(pre.Categories value, int index) {
    return Container(
        margin: marginTop10,
        child: Column(
          children: [
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(index.toString()),
                  Expanded(
                    child: Container(
                      margin: marginLeft10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(value.category.name),
                          ),
                          Container(
                            child: Text(value.name),
                          ),
                          Container(
                            child: Text('Sô lượng : ${value.amount}'),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            DividerWidget(margin: marginTop10),
          ],
        ));
  }

  Widget _createReceiverInfoWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _createTitle('Thông tin bên nhận'),

        /// Name
        _createSubTitle('Họ tên ',
            value: _initText(_prepareOrder.data.result.receiverName)),

        /// Phone
        _createSubTitle('Số điện thoại ',
            value: _initText(_prepareOrder.data.result.receiverPhone)),

        /// Address
        _createSubTitle('Địa chỉ nhận hàng ',
            value: _initText(_prepareOrder.data.result.receiverAddress)),

        /// Province - City
        _createSubTitle('Tỉnh - Thành ',
            value: _initText(_prepareOrder.data.result.province.name)),

        /// District
        _createSubTitle('Quận - Huyện ',
            value: _initText(_prepareOrder.data.result.district.name)),

        /// Ward
        _createSubTitle('Phường - Xã ',
            value: _initText(_prepareOrder.data.result.ward.name)),
      ],
    );
  }

  Widget _createSenderInfoWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _createTitle('Thông tin bên gửi'),

        /// Name
        _createSubTitle('Họ tên ',
            value: _initText(_prepareOrder.data.result.consigneeName)),

        /// Phone
        _createSubTitle('Số điện thoại ',
            value: _initText(_prepareOrder.data.result.consigneePhone)),

        /// Address
        _createSubTitle('Địa chỉ gửi ',
            value: _initText(_prepareOrder.data.result.consigneeAddress)),

        /// Warehouse

        _createSubTitle('Hàng gửi tại ',
            value: _initText(_prepareOrder.data.result.warehouse.address)),

        /// Transport code
        _createSubTitle('Code ',
            value: _initText(_prepareOrder.data.result.transportCode)),
      ],
    );
  }

  Widget _createSubTitle(String text, {String value}) {
    return Container(
        margin: EdgeInsets.only(left: 10, top: 5, right: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 120, child: Text(text)),
            Expanded(
                child: Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                value,
                style: TextStyle(color: Colors.black54),
              ),
            )),
          ],
        ));
  }

  Widget _createTitle(String text) {
    return Container(
        margin: EdgeInsets.only(left: 10, top: 10),
        child: Text(text,
            style: TextStyle(
                fontSize: 16,
                color: Colors.orange,
                fontWeight: FontWeight.bold)));
  }

  Widget _createConfirmOrderWidget() {
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: ButtonComponent(
          text: 'Xác nhận đơn hàng',
          margin: 0,
          color: Colors.orange,
          onClick: () {
            /**
             * Show dialog confirm order
             */
            ConfirmDialog.instance.showMessageYesNoDialog(
                context,
                '',
                'Xác nhận gửi đơn hàng ?',
                'assets/images/marker_box.png', yesCallback: () {
              Map<String, dynamic> data = Map();

              data['consignee_name'] = _prepareOrder.data.result.consigneeName;
              data['consignee_phone'] =
                  _prepareOrder.data.result.consigneePhone;
              data['consignee_address'] =
                  _prepareOrder.data.result.consigneeAddress;
              data['transport_code'] = _prepareOrder.data.result.transportCode;
              data['warehouse_id'] = _prepareOrder.data.result.warehouseId;

              data['lat'] = _prepareOrder.data.result.lat;
              data['long'] = _prepareOrder.data.result.long;
              data['receiver_name'] = _prepareOrder.data.result.receiverName;
              data['receiver_phone'] = _prepareOrder.data.result.receiverPhone;
              data['receiver_address'] =
                  _prepareOrder.data.result.receiverAddress;

              data['province_id'] = _prepareOrder.data.result.provinceId;
              data['district_id'] = _prepareOrder.data.result.districtId;
              data['ward_id'] = _prepareOrder.data.result.wardId;

              data['mass'] = int.tryParse(_prepareOrder.data.result.mass);
              data['size1'] = int.tryParse(_prepareOrder.data.result.size1);
              data['size2'] = int.tryParse(_prepareOrder.data.result.size2);
              data['size3'] = int.tryParse(_prepareOrder.data.result.size3);

              data['categories'] =
                  jsonEncode(_prepareOrder.data.result.categories);
              data['note'] = _prepareOrder.data.result.note;
              data['delivery_note'] = _prepareOrder.data.result.deliveryNote;
              data['method'] = _prepareOrder.data.result.payment;

//              data['in_warehouse'] = '1';
//              data['warehouse_id'] = warehouseID;

              data['save'] = '1';
              /**
               * Confirm order
               */

              confirmOrder(data);
            });
          },
        ));
  }

  @override
  BoxDecoration onInitBackground(BuildContext context) {
    return BoxDecoration(color: Color(0xffF8F8F8));
  }

  void confirmOrder(Map data) async {
    LoadingDialog.instance.showLoadingDialog(context);

    Map<String, dynamic> headers = Map();
    headers['Authorization'] = 'Bearer ${_currentUser.token}';
    Result<dynamic> result = await _prepareOrderRequest.callRequest(context,
        data: data, headers: headers, url: 'https://vanchuyen.etado.vn/api/v1');
    print(result);
    await LoadingDialog.instance.dismissLoading();
    if (result.isSuccess()) {
      MessageDialog.instance.showMessageOkDialog(
          context, '', 'Tạo đơn hàng thành công', 'assets/images/success.png',
          callback: () {
//        Preferences.removePrepareOrderSupport();

//        popScreen(context, data: true);
      });
    } else {
      MessageDialog.instance.showMessageOkDialog(context, '',
          'Kết nối đương truyền không ổn định.', 'assets/images/failure.png');
    }
  }
}
