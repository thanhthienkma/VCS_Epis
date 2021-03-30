import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:trans/helpers/wordpress.dart';
import 'package:trans/models/category_model.dart';
import 'package:trans/widgets/category.dart';
import 'package:trans/widgets/deco_appbar.dart';
import 'package:trans/widgets/deco_news_drawer.dart';
import 'package:trans/widgets/loading.dart';

import '../posts/single_category_screen.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  bool isLoading = true;
  List<CategoryModel> categories = [];
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    /// load list of categories
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

    double deviceWidth = MediaQuery.of(context).size.width;
    int widgetsInRow = 2;

    if (deviceWidth > 1100) {
      widgetsInRow = 4;
    } else if (deviceWidth > 768) {
      widgetsInRow = 3;
    }

    /// grid view of categories
    return GridView.count(
      crossAxisCount: widgetsInRow,
      children: categories
          .map((CategoryModel category) => Category(
                category,
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SingleCategoryScreen(category),
                )),
              ))
          .toList(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      padding: EdgeInsets.all(10),
    );
  }

  /// load list of categories
  _loadData() async {
    Response response = await WordPress.fetchCategories();

    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          /// create category models from loaded categories
          (json.decode(response.body) as List)
              .map((data) => categories.add(new CategoryModel.fromJson(data)))
              .toList();

          /// disable loading animations
          isLoading = false;
        });
      }
    } else {
      throw Exception('Failed to load data');
    }
  }
}
