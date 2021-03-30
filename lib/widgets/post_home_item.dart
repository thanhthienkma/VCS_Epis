import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/models/post_home_model.dart';
import 'package:trans/widgets/cached_image.dart';
import '../deco_news_icons.dart';

class PostHomeItem extends StatefulWidget {
  final PostHomeModel item;

  PostHomeItem(this.item);

  @override
  _PostHomeItemState createState() => _PostHomeItemState();
}

class _PostHomeItemState extends State<PostHomeItem> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 220.0,
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3.0)),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              blurRadius: 5,
              offset: Offset(0, 0),
            ),
          ],
          color: isDark ? Color(0xFF1B1E28) : Color(0xFFFFFFFF),
        ),
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.bottomLeft,
              children: <Widget>[
                _getImage(),
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
        ));
  }

  /// Returns widget title
  Widget _getTitle() {
    return Text(
      widget.item.title,
      style: TextStyle(
        fontSize: 14,
        color: isDark ? Colors.white : Color(0xff1B1E28),
      ),
      maxLines: 3,
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
            widget.item.category.name.toUpperCase(),
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
        Container(
          margin: marginLeft5,
          child: Text(
            initDateTimeToString(),
            style: TextStyle(
              color: Color(0xff7F7E96),
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  /// Returns widget image
  Widget _getImage() {
    return Container(
      height: 120,
      width: double.maxFinite,
      child: Hero(
          tag: 'news-image-a' + widget.item.id.toString(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: CachedImageWidget(widget.item.image),
          )),
    );
  }

  DateTime initStringToDateTime(String value) {
    if (value.isEmpty) {
      return null;
    }

    return DateTime.parse(value);
  }

  String initDateTimeToString() {
    DateTime dateTime = initStringToDateTime(widget.item.date);
    if (dateTime == null) {
      return "";
    }
    DateFormat dateFormat = DateFormat('d MMM yy');
    return dateFormat.format(dateTime);
  }
}
