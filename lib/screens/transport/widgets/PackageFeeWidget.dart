import 'package:flutter/material.dart';
import 'package:trans/api/local/Package.dart';
import 'package:trans/api/local/PackageFee.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/screens/transport/TransportScreen.dart';
import 'package:trans/screens/transport/items/package/PackageItem.dart';

class PackageFeeWidget extends StatefulWidget {
  final Map mapCallback;
  final PackageFee packageFee;
  final List<Package> packages;
  final TextEditingController massController;
  final TextEditingController size1Controller;
  final TextEditingController size2Controller;
  final TextEditingController size3Controller;

  PackageFeeWidget(
      {this.mapCallback,
      this.packageFee,
      this.packages,
      this.massController,
      this.size1Controller,
      this.size2Controller,
      this.size3Controller});

  @override
  State<StatefulWidget> createState() => _PackageFeeWidgetState();
}

class _PackageFeeWidgetState extends State<PackageFeeWidget> {
  bool expanded = true;

  @override
  void initState() {
    super.initState();

    if (widget.packageFee == null || widget.packages == null) {
      return;
    }
  }

  String get _checkLength {
    if (widget.packages == null) {
      return '0';
    }
    return widget.packages.length.toString();
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
              Text('Hàng hoá - Cước phí',
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
                    padding: paddingAll10,
                    child: Column(
                      children: [
                        /// Mass
                        _createItemWidget(
                            'Khối lượng - gram', 'Vui lòng nhập khối lượng',
                            isNumber: false,
                            textEditingController: widget.massController),

                        /// Package size

                        _packageSize(),

                        /// Package name

                        _packageName(),

                        /// Valuable
//                        _createItemWidget('Giá trị hàng hoá - vnđ', '0',
//                            isNumber: false),

                        /// Terms
                        _terms(),
                      ],
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  Widget _terms() {
    return GestureDetector(
      onTap: () {
        var termCallback = widget.mapCallback[TransportConstants.TERM_CALLBACK];
        termCallback();
      },
      child: Container(
        margin: EdgeInsets.only(left: margin10, top: margin10),
        child: Row(
          children: [
            Text('Quy trình',
                style: TextStyle(
                    color: Colors.orange,
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.underline)),
            Text(' & ', style: TextStyle(color: Colors.grey)),
            Text('Chính sách xử lí đến bù',
                style: TextStyle(
                    color: Colors.orange,
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.underline)),
          ],
        ),
      ),
    );
  }

  Widget _packageName() {
    return Container(
      margin: marginTop15,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(
          children: [
            Text('Tên hàng hoá'),
            Text(
              '*',
              style: TextStyle(color: Colors.orange),
            )
          ],
        ),
        Container(
            child: Row(
          children: [
            /// Add package
            Expanded(
                child: GestureDetector(
              onTap: () {
                var addOrderCallback =
                    widget.mapCallback[TransportConstants.ADD_ORDER_CALLBACK];
                addOrderCallback();
              },
              child: Row(
                children: [
                  Icon(Icons.add_circle),
                  Container(
                    margin: EdgeInsets.only(left: margin10),
                    child: Text('Thêm hàng hoá'),
                  ),
                ],
              ),
            )),

            /// Count quantity
            Expanded(
              child: Text(
                '$_checkLength order (s)',
                textAlign: TextAlign.end,
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ],
        )),
        widget.packages == null
            ? Container()
            :

            /// Packages added
            ListView.builder(
                shrinkWrap: true,
                itemCount: widget.packages.length,
                physics: ClampingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  int count = index + 1;
                  return PackageItem(widget.packages[index], count,
                      hideDeleted: false);
                }),
      ]),
    );
  }

  Widget _packageSize() {
    return Container(
        margin: marginTop15,
        child: Column(
          children: [
            Row(
              children: [
                Text('Kích thước - cm'),
                Text(
                  '*',
                  style: TextStyle(color: Colors.orange),
                )
              ],
            ),
            Container(
              margin: marginTop5,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: TextField(
                            controller: widget.size1Controller,
                            style: TextStyle(fontSize: font14),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            textInputAction: TextInputAction.next,
                            onSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            // move focus to next
                            keyboardType: TextInputType.number,
                            onChanged: (String text) {},
                            decoration: InputDecoration(
                              hintText: '0',
                              border: InputBorder.none,
                            ))),
                  ),
                  Expanded(
                      child: Text('X',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey))),
                  Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: TextField(
                            controller: widget.size2Controller,
                            style: TextStyle(fontSize: font14),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            textInputAction: TextInputAction.next,
                            onSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            //
                            keyboardType: TextInputType.number,
                            onChanged: (String text) {},
                            decoration: InputDecoration(
                              hintText: '0',
                              contentPadding: paddingLeft10,
                              border: InputBorder.none,
                            ))),
                  ),
                  Expanded(
                      child: Text('X',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey))),
                  Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: TextField(
                            controller: widget.size3Controller,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: font14),
                            maxLines: 1,
                            keyboardType: TextInputType.number,
                            onChanged: (String text) {},
                            decoration: InputDecoration(
                                hintText: '0',
                                contentPadding: paddingLeft10,
                                border: InputBorder.none))),
                  ),
                ],
              ),
            ),
//            Container(
//              margin: marginTop5,
//              alignment: Alignment.centerLeft,
//              child: Text(
//                'Khối lượng quy đổi : 0.675 kg = 675g',
//                style: TextStyle(color: Colors.grey),
//              ),
//            ),
          ],
        ));
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
