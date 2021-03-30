import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:trans/api/local/Package.dart';
import 'package:trans/api/local/PrepareOrderSupport.dart';
import 'package:trans/api/local/ReceiverAddress.dart';
import 'package:trans/api/local/SenderAddress.dart';
import 'package:trans/base/screen/BaseScreen.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/preferences/Preferences.dart';
import 'package:trans/screens/transport/items/package/PackageItem.dart';
import 'package:trans/widgets/divider_widget.dart';

class OrderDraftScreen extends BaseScreen {
  PrepareOrderSupport prepareOrderSupport;

  @override
  void initState() {
    super.initState();

    /// Init data
    initData();
  }

  initData() async {
    String value = await Preferences.getPrepareOrderSupport();
    if (value == null || value.isEmpty) {
      return;
    }
    prepareOrderSupport = PrepareOrderSupport.fromJson(jsonDecode(value));

    /// Update new data
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  @override
  Widget onInitBody(BuildContext context) {
    if (prepareOrderSupport == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/images/empty_box.png', height: 50, width: 50),
          Container(
            margin: marginTop10,
            alignment: Alignment.center,
            child:
                Text('Chưa có đơn hàng.', style: TextStyle(color: Colors.grey)),
          ),
        ],
      );
    }

    return ListView(children: <Widget>[
      Card(
        margin: marginAll20,
        elevation: 8,
        child: Container(
          width: double.maxFinite,
          padding: paddingAll20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /// Create sender
              createSender(prepareOrderSupport.senderAddress),

              /// Line
              DividerWidget(margin: marginTop10),

              /// Create receiver
              createReceiver(prepareOrderSupport.receiverAddress),

              Container(
                margin: marginTop10,
                alignment: Alignment.center,
                child: Text('Danh sách hàng hoá',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold)),
              ),

              /// Create packages
              createPackages(prepareOrderSupport.packageFee.packages),

              /// Create note
              createNote(prepareOrderSupport.note.noteText),
            ],
          ),
        ),
      )
    ]);
  }

  Widget createSender(SenderAddress sender) {
    if (sender == null) {
      return Container(child: Text('chưa cập nhật'));
    }

    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Người gửi : ${initText(sender.name)}'),
        Text('Số điện thoại : ${initText(sender.phone)}'),
        Text('Địa chi gửi : ${initText(sender.address)}'),
        Text('Hàng gửi tại : ${initText(sender.result.address ?? '')}'),
      ],
    ));
  }

  Widget createReceiver(ReceiverAddress receiver) {
    return Container(
        margin: marginTop10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Người nhận : ${initText(receiver.name)}'),
            Text('Số điện thoại : ${initText(receiver.phone)}'),
            Text(
                'Địa chỉ : ${initText(receiver.address)} -  ${initText(receiver.city.name)} -  ${initText(receiver.district.name)} - ${initText(receiver.ward.name)}'),
          ],
        ));
  }

  Widget createPackages(List<Package> list) {
    if (list == null || list.isEmpty) {
      return Container(child: Text('chưa cập nhật'));
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        return PackageItem(list[index], index + 1, hideDeleted: false);
      },
    );
  }

  Widget createNote(String text) {
    return Container(
        margin: marginTop20, child: Text('Ghi chú : ${initText(text)}'));
  }

  String initText(String value) {
    if (value == null || value.isEmpty) {
      return 'chưa cập nhật';
    }
    return value;
  }
}
