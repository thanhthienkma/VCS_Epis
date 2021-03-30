import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:trans/helpers/wordpress.dart';
import 'package:trans/models/category_model.dart';
import 'package:trans/screens/news/screens/posts/single_category_slider_screen.dart';
import 'package:trans/utils/ModeUtil.dart';
import 'package:trans/widgets/deco_appbar.dart';
import 'package:trans/widgets/deco_news_drawer.dart';
import 'package:trans/widgets/loading.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  bool isLoading = true;
  List<CategoryModel> categories = List();
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    /// load list of categories
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    /// show loading message
    if (isLoading) {
      return Scaffold(appBar: DecoNewsAppBar(), body: Loading());
    }

    /// show tabs
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        key: _drawerKey,
        drawer: DecoNewsDrawer(),
        appBar: DecoNewsAppBar(
          /// Open menu
          menuCallback: () => _drawerKey.currentState.openDrawer(),
          bottom: TabBar(
              isScrollable: true,
              labelPadding: EdgeInsets.symmetric(horizontal: 20),
              labelColor: ModeUtil.instance.switchMode(isDark),
              indicatorColor: ModeUtil.instance.switchMode(isDark),
              tabs: categories
                  .map((category) => Tab(text: category.name))
                  .toList()),
        ),
        body: _emptyData(),
      ),
    );
  }

  Widget _emptyData() {
    Widget _view;
    if (categories.isEmpty) {
      _view = Center(child: Text('Page not found :('));
    } else {
      _view = TabBarView(
          children: categories
              .map((category) => SingleCategorySliderScreen(category))
              .toList());
    }
    return _view;
  }

  /// load list of categories
  _loadData() async {
    Response response = await WordPress.fetchCategories();
    print(response);
    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          /// set list of categories
          categories = (json.decode(response.body) as List)
              .map((data) => new CategoryModel.fromJson(data))
              .toList();

          /// disable loading
          isLoading = false;
        });
      }
    } else if (response.statusCode == 404) {
      setState(() {
        isLoading = false;
        categories = [];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }
}
