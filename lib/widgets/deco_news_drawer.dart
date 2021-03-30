import 'package:flutter/material.dart';
import 'package:trans/identifiers/Screens.dart';
import 'package:trans/base/screen/BaseScreen.dart';
import 'package:trans/screens/news/screens/bookmarks/BookmarksScreen.dart';
import 'package:trans/screens/news/screens/categories/CategoriesScreen.dart';
import '../deco_news_icons.dart';
import '../main.dart';

class DrawerItem {
  final String title;
  final Function pageCallback;
  final IconData icon;

  DrawerItem(this.title, this.icon, {this.pageCallback});
}

class DecoNewsDrawer extends StatefulWidget {


  @override
  State<StatefulWidget> createState() => _DecoNewsDrawerState();
}

class _DecoNewsDrawerState extends State<DecoNewsDrawer> {
  @override
  Widget build(BuildContext context) {
    int selectedIndex = DecoNews.of(context).getSelected();

    /// This is the list of items that will be shown in drawer
    List<DrawerItem> drawerItems = [
      DrawerItem('Tin tức', DecoNewsIcons.home_icon, pageCallback: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => BaseWidget(
                      screen: Screens.MAIN,
                      arguments: 'news',
                    )));
      }),
      DrawerItem('Danh Mục', DecoNewsIcons.categories_icon, pageCallback: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => CategoriesScreen()));
      }),
      DrawerItem('Yêu Thích', DecoNewsIcons.add_to_bookmark, pageCallback: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => BookmarksScreen()));
      }),
    ];
    return Drawer(
        child: Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          /// Header
          Container(
            padding: EdgeInsets.only(top: 60.0, bottom: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 15.0),
                  width: 60.0,
                  child: Image.asset('images/deco_logo.png'),
                ),
                Column(
                  children: <Widget>[
                    Text(
                      'VCS - Tin tức 24h',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    /*Text(
                        'WP + Flutter App',
                        style:
                            TextStyle(color: Color(0xFF7F7E96), fontSize: 14.0),
                      ),*/
                  ],
                ),
              ],
            ),
          ),

          /// Drawer items
          Expanded(
            child: Center(
              child: ListView(
                shrinkWrap: true,
                children: drawerItems.map((DrawerItem item) {
                  int index = drawerItems.indexOf(item);

                  return Container(
                    height: 50.0,
                    margin: EdgeInsets.only(right: 50.0),
                    decoration: BoxDecoration(
                      color: index == selectedIndex
                          ? Colors.grey[200]
                          : Colors.white,
                      borderRadius:
                          BorderRadius.horizontal(right: Radius.circular(25)),
                    ),
                    child: ListTile(
                      leading: Icon(
                        item.icon,
                        size: 20.0,
                        color: index == selectedIndex
                            ? Colors.black
                            : Color(0xFF7F7E96),
                      ),
                      title: Text(
                        item.title,
                        style: TextStyle(
                          color: index == selectedIndex
                              ? Colors.black
                              : Color(0xFF7F7E96),
                          fontSize: 16.0,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        DecoNews.of(context).setSelected(index);
                        item.pageCallback();
//                        Navigator.pushReplacement(
//                            context,
//                            PageRouteBuilder(
//                              pageBuilder: (context, anim1, anim2) =>
//                                  item.pageCallback(),
//                              transitionsBuilder: (context, anim1, anim2,
//                                      child) =>
//                                  FadeTransition(opacity: anim1, child: child),
//                              transitionDuration: Duration(milliseconds: 200),
//                            ));
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
