import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/api/result/Job.dart';
import 'package:trans/utils/image/ImageNetworkUtil.dart';

class JobItem extends StatefulWidget {
  final Data item;
  final Function(Data item) jobCallback;

  JobItem(this.item, {this.jobCallback});

  @override
  State<StatefulWidget> createState() => _JobItemState();
}

class _JobItemState extends State<JobItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          widget.jobCallback(widget.item);
        },
        child: Container(
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            padding: paddingAll10,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(6)),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 239, 241, 254).withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 5,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    /// Create image
                    _createImage(),

                    /// Create info
                    _createInfo(),
                  ],
                ),
              ],
            )));
  }

  Widget _createInfo() {
    return Expanded(
        child: Container(
            margin: marginLeft10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  initText(widget.item.title),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: primaryColor, fontWeight: FontWeight.w600),
                ),
                Container(
                    margin: marginTop5,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.location_on, color: primaryColor, size: 18),
                        Expanded(
                            child: Text(
                          initText(widget.item.location),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))
                      ],
                    )),
                Container(
                    margin: marginTop5,
                    child: Text(
                      'Thời hạn : ${initText(widget.item.publishDate)} - ${initText(widget.item.expiryDate)}',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    )),
              ],
            )));
  }

  Widget _createImage() {
    return Container(
        width: 80,
        height: 80,
        child: ImageNetworkUtil.loadImage(widget.item.thumbnailSrc));
  }

  String initText(String value) {
    if (value == null || value.isEmpty) {
      return 'Chưa cập nhật';
    }
    return value;
  }
}
