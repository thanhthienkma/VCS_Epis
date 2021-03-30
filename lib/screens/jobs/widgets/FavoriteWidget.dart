import 'package:flutter/material.dart';
import 'package:trans/base/style/BaseStyle.dart';

class FavoriteWidget extends StatefulWidget {
  final Function callback;

  FavoriteWidget({this.callback});

  @override
  State<StatefulWidget> createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => widget.callback(),
        child: Container(
          margin: marginAll20,
          padding: paddingAll10,
          decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.orange),
              borderRadius: BorderRadius.all(Radius.circular(4))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.favorite_border, color: Colors.orange),
              Container(
                margin: marginLeft5,
                child: Text('Yêu thích công việc này',
                    style: TextStyle(color: Colors.orange)),
              ),
            ],
          ),
        ));
  }
}
