import 'package:flutter/material.dart';
import '../models/category_model.dart';

class Category extends StatelessWidget {
  final CategoryModel cat;
  final VoidCallback onTap;

  Category(this.cat, {this.onTap});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              blurRadius: 5,
              offset: Offset(0, 0),
            )
          ],
        ),
        child: AspectRatio(
          aspectRatio: 1.0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(3)),
              color: isDark ? Color(0xFF1B1E28) : Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  cat.name,
                  style: TextStyle(
                    color: isDark ? Colors.white : Color(0xFF1B1E28),
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  cat.count.toString() + ' Posts',
                  style: TextStyle(
                    color: Color(0xFF7F7E96),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
