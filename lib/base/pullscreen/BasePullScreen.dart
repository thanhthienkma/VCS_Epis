import 'dart:async';

import 'package:trans/base/screen/BaseScreen.dart';
import 'package:trans/components/search/SearchComponent.dart';
import 'package:trans/components/search/support/SearchSupport.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BasePullConstants {
  static const int LIMIT = 50;
  static const int FILTER_IN_TOP = 0;
  static const int FILTER_IN_LIST = 1;
}

abstract class BasePullScreen<T> extends BaseScreen {
  /// Search support
  SearchSupport searchSupport;

  /// Scroll controller
  ScrollController scrollController;

  /// Refresh controller
  RefreshController refreshController;

  /// Offset
  int offset = 0;

  /// Status is first load
  bool isFirstLoad = true;

  /// List data
  List<T> listData = [];

  /// Data is selected
  List<T> listSelectedData = [];

  /// Status is searching
  bool isSearching = false;

  /// Buffer of text search
  List<String> buffer = [];

  /// Searching
  String searching;

  /// Filter
  String filter;

  /// True then show search widget
  bool isShowSearch = false;

  /// True then show filter widget
  bool isShowFilter = false;

  /// Status is load more
  bool isLoadingMore = true;

  /// Position of filter
  int positionFilter = BasePullConstants.FILTER_IN_TOP;

  /// Handle refresh
  Future<void> handleRefresh();

  /// Handle loading
  Future<void> handleLoading();

  /// Create list widget, it is implemented at child
  List<Widget> createListWidget();

  /// Create sub header widget
  Widget createSubHeaderWidget() {
    return Container();
  }

  /// Create sub header widget
  Widget createBottomWidget() {
    return Container();
  }

  /// Create filter widget
  Widget createFilterWidget() {
    return Container();
  }

  /// Handle search
  Future<void> handleSearch(String value) {
    return null;
  }

  @override
  void initState() {
    super.initState();

    /// Search support
    searchSupport = SearchSupport();

    /// Scroll controller
    scrollController = ScrollController();

    /// Refresh controller
    refreshController = RefreshController(initialRefresh: true);
  }

  /// Create refresh widget
  Widget createRefresherWidget() {
    return SmartRefresher(
      controller: refreshController,
      enablePullUp: !isFirstLoad && isLoadingMore,
      child: _createListWidget(),
      footer: createLoadClassicWidget(),
      header: createRefreshWaterDropWidget(),
      onRefresh: baseHandleRefresh,
      onLoading: baseHandleLoading,
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    refreshController.dispose();
    super.dispose();
  }

  /// Create search widget
  Widget createSearchWidget() {
    Map args = Map();
    args[SearchComConstants.CALLBACK] = (String value) {
      _baseHandleSearch(value);
    };
    args[SearchComConstants.SUPPORT] = searchSupport;
    return Container(
        margin: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: SearchComponent(arguments: args));
  }

  /// Base handle search
  void _baseHandleSearch(String value) async {
    if (isSearching) {
      buffer.add(value);
      return;
    }
    searching = value;
    isSearching = true;
    offset = 0;

    await handleSearch(value);
    print('Buffer len ${buffer.length}');

    isSearching = false;
    if (buffer.isNotEmpty) {
      String searchValue = buffer.last;
      buffer.clear();
      _baseHandleSearch(searchValue);
    }
  }

  /// Handle refresh
  void baseHandleRefresh() async {
    if (!mounted) {
      return;
    }
    offset = 0;
    isFirstLoad = false;

    await handleRefresh();

    if (!mounted) {
      return;
    }

    refreshController.refreshCompleted();

    /// Update UI.
    setState(() {});
  }

  /// Handle loading
  void baseHandleLoading() async {
    if (!mounted) {
      return;
    }
    await handleLoading();

    if (!mounted) {
      return;
    }
    refreshController.loadComplete();

    /// Update UI.
    setState(() {});
  }

  /// Create list widget
  Widget _createListWidget() {
    List<Widget> listWidget = createListWidget();
    if (listWidget == null) {
      listWidget = [];
    }

    /// Filter
    if (isShowFilter && positionFilter == BasePullConstants.FILTER_IN_TOP) {
      listWidget.insert(0, createFilterWidget());
    }
    return ListView(
        padding: EdgeInsets.all(0),
        cacheExtent: 10000,
        controller: scrollController,
        children: listWidget);
  }

  /// Handle data.
  void handleBack() {
    popScreen(context, data: listSelectedData);
  }

  @override
  Widget onInitBody(BuildContext context) {
    List<Widget> listWidget = [];

    /// Create sub header
    listWidget.add(createSubHeaderWidget());

    /// Create search.
    if (isShowSearch) {
      listWidget.add(createSearchWidget());
    }

    /// Filter
    if (isShowFilter && positionFilter == BasePullConstants.FILTER_IN_TOP) {
      listWidget.add(createFilterWidget());
    }

    /// Create body
    listWidget.add(Expanded(
      child: createRefresherWidget(),
    ));

    /// Create sub header
    listWidget.add(createBottomWidget());

    return Column(children: listWidget);
  }
}
