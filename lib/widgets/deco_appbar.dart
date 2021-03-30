import 'package:flutter/material.dart';

class DecoNewsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final double elevation;
  final PreferredSizeWidget bottom;
  final Function() menuCallback;
  final bool isChangeIcon;

  DecoNewsAppBar(
      {Key key,
      this.title = 'VCS Tin tức 24h',
      this.centerTitle = true,
      this.isChangeIcon = true,
      this.elevation = 2.0,
      this.menuCallback,
      this.bottom})
      : preferredSize = Size.fromHeight(
            kToolbarHeight + (bottom?.preferredSize?.height ?? 0.0)),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
      elevation: elevation,
      leading: GestureDetector(
        onTap: () => menuCallback(),
        child: isChangeIcon ? Icon(Icons.menu) : Icon(Icons.arrow_back),
      ),
      iconTheme: IconThemeData(color: Color(0xFFAAB2B7)),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
        ),
      ),
      bottom: bottom,
    );
  }
}
