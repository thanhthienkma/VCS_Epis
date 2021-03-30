import 'package:flutter/material.dart';
import 'package:trans/api/local/ReceiverAddress.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/screens/transport/TransportScreen.dart';

class ReceiverWidget extends StatefulWidget {
  final Map mapZone;
  final Map mapCallback;
  final ReceiverAddress receiverAddress;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;

  ReceiverWidget(
      {this.mapZone,
      this.mapCallback,
      this.receiverAddress,
      this.nameController,
      this.phoneController,
      this.addressController});

  @override
  State<StatefulWidget> createState() => _ReceiverWidgetState();
}

class _ReceiverWidgetState extends State<ReceiverWidget> {
  bool expanded = true;

  @override
  void initState() {
    super.initState();

    if (widget.receiverAddress == null) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: paddingAll20,
      child: Column(
        children: [
          /// Collapse
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Bên nhận',
                  style: TextStyle(
                      color: Colors.orange,
                      fontSize: font16,
                      fontWeight: FontWeight.bold)),
              GestureDetector(
                  onTap: () {
                    /// Handle collapse
                    handleCollapse();
                  },
                  child: Row(
                    children: [
                      expanded ? Text('Thu gọn') : Text('Mở rộng'),
                      expanded
                          ? Icon(Icons.keyboard_arrow_up)
                          : Icon(Icons.keyboard_arrow_down),
                    ],
                  )),
            ],
          ),

          expanded
              ?

              /// Info
              Card(
                  margin: EdgeInsets.zero,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Container(
                    margin: EdgeInsets.only(
                        left: margin15, right: margin15, bottom: margin15),
                    child: Column(
                      children: [
                        /// Name
                        _createItemWidget('Họ tên ', 'Vui lòng nhập họ tên',
                            textEditingController: widget.nameController),

                        /// Phone number
                        _createItemWidget(
                            'Số điện thoại ', 'Vui lòng nhập số điện thoại',
                            textEditingController: widget.phoneController,
                            isNumber: false),

                        /// Address
                        _createItemWidget('Địa chỉ ', 'Vui lòng nhập địa chỉ',
                            textEditingController: widget.addressController),

                        /// Province

                        _createDropdownWidget(
                            'Tỉnh - Thành ',
                            messageRequire(
                                widget.mapZone[TransportConstants.CITY],
                                required: 'Vui lòng chọn tỉnh - thành'),
                            callback: () {
                          var provinceCallback = widget.mapCallback[
                              TransportConstants.PROVINCE_CALLBACK];
                          provinceCallback();
                        }),

                        /// District
                        _createDropdownWidget(
                            'Quận - Huyện ',
                            messageRequire(
                                widget.mapZone[TransportConstants.DISTRICT],
                                required: 'Vui lòng chọn quận - huyện'),
                            callback: () {
                          var districtCallback = widget.mapCallback[
                              TransportConstants.DISTRICT_CALLBACK];
                          districtCallback();
                        }),

                        /// Ward
                        _createDropdownWidget(
                            'Phường - Xã ',
                            messageRequire(
                                widget.mapZone[TransportConstants.WARD],
                                required: 'Vui lòng chọn phường - xã'),
                            callback: () {
                          var wardCallback = widget
                              .mapCallback[TransportConstants.WARD_CALLBACK];
                          wardCallback();
                        }),
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  String messageRequire(String text, {@required String required}) {
    return text ?? required;
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
      {bool isNumber = true, TextEditingController textEditingController}) {
    return Container(
        margin: marginTop15,
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
                    keyboardType:
                        isNumber ? TextInputType.text : TextInputType.number,
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

  void handleCollapse() {
    if (expanded) {
      expanded = false;
    } else {
      expanded = true;
    }

    setState(() {});
  }
}
