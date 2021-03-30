import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trans/api/result/MyPost.dart';
import 'package:trans/deco_news_icons.dart';

class MyPostWidget extends StatefulWidget {
  final MyPost item;

  MyPostWidget(this.item);

  @override
  _MyPostWidgetState createState() => _MyPostWidgetState();
}

class _MyPostWidgetState extends State<MyPostWidget> {
  @override
  Widget build(BuildContext context) {
    return _getVerticalLayout();
  }

  /// Builds widget horizontal layout
  Widget _getVerticalLayout() {
    return Card(
      margin: EdgeInsets.only(top: 20),
      elevation: 4,
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.bottomLeft,
              children: <Widget>[
                _getImage(width: double.infinity),
                _getCategory(),
              ],
            ),
            Expanded(
              child: Container(
//                  height: 120.0,
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _getTitle(),
                    _getDate(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Returns widget title
  Widget _getTitle() {
    return Text(
      this.widget.item.title,
      style: TextStyle(fontSize: 14),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Returns category name
  Widget _getCategory() {
    return Container(
      width: 120,
      padding: EdgeInsets.all(10),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          padding: EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            color: Color(0xffCB0000),
            borderRadius: BorderRadius.all(
              Radius.circular(3),
            ),
          ),
          child: Text(
            this.widget.item.categoryName.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  /// Returns widget date
  Widget _getDate() {
    return Row(
      children: <Widget>[
        Icon(
          DecoNewsIcons.date,
          color: Color(0xffCCCBDA),
          size: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Text(
//            this.widget.item.date,
            formattedDate,
            style: TextStyle(
              color: Color(0xff7F7E96),
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  String get formattedDate {
    DateTime dateTime = DateTime.parse(widget.item.date);

    return DateFormat('dd EEE yyyy').format(dateTime);
  }

  /// Returns widget image
  Widget _getImage({double width: 120.0}) {
    return Hero(
      tag: 'news-image-' + this.widget.item.id.toString(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
//          child: FadeInImage(
//            placeholder: AssetImage('assets/images/post_placeholder.png'),
//            image: this.widget.item.image,
//            width: width,
//            height: 120.0,
//            fit: BoxFit.cover,
//          ),
        child: Image.network(
          this.widget.item.image,
          width: width,
          height: 120,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
