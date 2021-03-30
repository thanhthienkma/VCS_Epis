import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:trans/helpers/wordpress.dart';
import 'package:trans/models/category_model.dart';
import 'package:trans/models/post_model.dart';
import 'package:trans/widgets/deco_appbar.dart';
import 'package:trans/widgets/deco_news_drawer.dart';
import 'package:trans/widgets/loading.dart';
import 'package:trans/widgets/news.dart';
import 'package:trans/widgets/no_data.dart';

import '../posts/single_post.dart';

class BookmarksScreen extends StatefulWidget {
  @override
  _BookmarksScreenState createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  bool isLoading = true;
  List<PostModel> posts = [];
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    /// load bookmarked posts
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _drawerKey,
        appBar: DecoNewsAppBar(
          menuCallback: () {
            _drawerKey.currentState.openDrawer();
          },
        ),
        drawer: DecoNewsDrawer(),
        body: _buildBody());
  }

  _buildBody() {
    /// show loading message
    if (isLoading) {
      return Loading();
    }

    /// show no data message
    if (posts.length == 0) {
      return NoData('Add something to bookmarks by taping on bookmark icon');
    }

    bool isDark = Theme.of(context).brightness == Brightness.dark;

    /// list of posts
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 10, top: 10, right: 10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                child: Text(
                  'Bookmarked News',
                  style: TextStyle(
                      fontSize: 18.0,
                      color: isDark ? Colors.white : Color(0xFF1B1E28)),
                ),
              ),
              FlatButton(
                onPressed: () {
                  setState(() {
                    posts.clear();
                    WordPress.clearBookmarks();
                  });
                },
                child: Text(
                  'Clear all',
                  style: TextStyle(
                    color: isDark ? Colors.white : Color(0xFF1B1E28),
                  ),
                ),
              ),
            ],
          ),
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: posts.length,
              itemBuilder: (BuildContext context, int index) {
                /// news widget
                return News(
                  posts[index],
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SinglePost(posts[index]),
                    ));
                  },
                );
              }),
        ],
      ),
    );
  }

  /// Loads bookmarks
  _loadData() async {
    /// get list of bookmarks
    List<int> bookmarks = await WordPress.getBookmarkedPostIDs();

    if (bookmarks.length > 0) {
      /// Fetch posts and categories
      var data = await Future.wait([
        WordPress.fetchPostsFromList(bookmarks),
        WordPress.fetchCategories()
      ]);

      Response postsResponse = data[0];
      Response categoriesResponse = data[1];

      if (postsResponse.statusCode == 200 &&
          categoriesResponse.statusCode == 200) {
        if (mounted) {
          setState(() {
            var decodedCategories =
                json.decode(categoriesResponse.body) as List;

            /// create post models from loaded posts
            posts = (json.decode(postsResponse.body) as List).map((data) {
              /// find post category
              var categoryID = data['categories'].first;
              var category = decodedCategories
                  .firstWhere((category) => category['id'] == categoryID);

              return new PostModel.fromJson(
                  data, new CategoryModel.fromJson(category),
                  bookmarks: bookmarks);
            }).toList();

            /// disable loading animations
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }
}
