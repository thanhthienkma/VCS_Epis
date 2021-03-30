import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/helpers/wordpress.dart';
import 'package:trans/models/category_model.dart';
import 'package:trans/models/post_model.dart';
import 'package:trans/widgets/admob_widget.dart';
import 'package:trans/widgets/carousel.dart';
import 'package:trans/widgets/loading.dart';
import 'package:trans/widgets/loading_infinite.dart';
import 'package:trans/widgets/news.dart';
import 'package:trans/widgets/slider_news.dart';
import 'single_post.dart';

class SingleCategorySliderScreen extends StatefulWidget {
  final CategoryModel category;

  SingleCategorySliderScreen(this.category);

  @override
  _SingleCategorySliderScreenState createState() =>
      _SingleCategorySliderScreenState();
}

class _SingleCategorySliderScreenState extends State<SingleCategorySliderScreen>
    with AutomaticKeepAliveClientMixin {
  bool isLoading = true;
  bool loadingMore = false;
  bool canLoadMore = true;
  int page = 1;
  List<PostModel> posts = List();
  List<PostModel> featured = List();

  void initState() {
    super.initState();

    /// load posts
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    double deviceWidth = MediaQuery.of(context).size.width;
    int widgetsInRow = 2;

    if (deviceWidth > 1200) {
      widgetsInRow = 4;
    } else if (deviceWidth > 768) {
      widgetsInRow = 3;
    }

    double aspectRatio =
        (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 230;

    /// show loading message
    if (isLoading) {
      return Loading();
    }

    /// add pull to refresh
    return RefreshIndicator(
      onRefresh: () => _loadData(clear: true),
      color: Color(0xFF1B1E28),
      child: NotificationListener(
        onNotification: (ScrollNotification scroll) {
          bool shouldLoadMore =
              scroll.metrics.pixels == scroll.metrics.maxScrollExtent &&
                  !this.loadingMore &&
                  this.canLoadMore;

          if (shouldLoadMore) {
            _loadData();
            return true;
          }

          return false;
        },
        child: SingleChildScrollView(
          // padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              this.featured.length == 0
                  ? Container()
                  : Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Featured News',
                            style: TextStyle(
                                fontSize: 18.0,
                                color:
                                    isDark ? Colors.white : Color(0xFF1B1E28)),
                          ),
                        ),
                      ],
                    ),

              /// Carousel widget
              featured.length == 0
                  ? Container()
                  : Container(
                      height: 235,
                      child: Carousel(
                        showIndicator: false,
                        pages: featured
                            .map((PostModel post) => SliderNews(
                                  post,
                                  onTap: () {
                                    int index = featured.indexOf(post);
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          SinglePost(featured[index]),
                                    ));
                                  },
                                ))
                            .toList(),
                      ),
                    ),

              Row(
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, bottom: 10, left: 10),
                    child: Text(
                      this.widget.category.name,
                      style: TextStyle(
                          fontSize: 18.0,
                          color: isDark ? Colors.white : Color(0xFF1B1E28)),
                    ),
                  ),
                ],
              ),

              GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: padding10),
                  itemCount: posts.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: widgetsInRow,
                      crossAxisSpacing: double10,
                      childAspectRatio: aspectRatio),
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 2 || index == 7) {
                      return AdmobWidget();
                    }
                    return News(
                      posts[index],
                      horizontal: false,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SinglePost(
                            posts[index],
                          ),
                        ));
                      },
                    );
                  }),

              LoadingInfinite(canLoadMore),
            ],
          ),
        ),
      ),
    );
  }

  /// load posts
  _loadData({clear = false}) async {
    if (page > 1) {
      setState(() {
        loadingMore = true;
      });
    }

    if (clear) {
      page = 1;
    }

    /// Fetch posts and bookmarks
    var data = await Future.wait([
      WordPress.fetchPosts(category: this.widget.category.id, page: page),
      WordPress.getBookmarkedPostIDs()
    ]);

    Response response = data[0];
    List bookmarks = data[1];

    if (response.statusCode == 200) {
      int totalPosts = int.parse(response.headers['x-wp-total'].toString());

      if (mounted) {
        setState(() {
          /// on refreshing page need to clean up
          if (clear) {
            posts.clear();
          }

          /// create post models from loaded posts
          List<PostModel> loadedPosts = (json.decode(response.body) as List)
              .map((data) => new PostModel.fromJson(data, this.widget.category,
                  bookmarks: bookmarks))
              .toList();

          /// update featured posts
          if (page == 1) {
            featured = loadedPosts.sublist(0, 2);
            loadedPosts = loadedPosts.sublist(1);
          }

          /// append loaded posts to existing list
          posts = List.from(posts)..addAll(loadedPosts);

          /// disable loading animations
          isLoading = false;
          loadingMore = false;

          /// allow loading more if category have more posts then loaded
          canLoadMore = (posts.length + featured.length) < totalPosts;

          /// increase page count
          page += 1;
        });
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  bool get wantKeepAlive => true;
}
