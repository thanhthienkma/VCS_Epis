import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trans/base/screen/BaseScreen.dart';
import 'package:trans/base/selectedscreen/components/selecteditem/SelectedItemComponent.dart';
import 'package:trans/base/selectedscreen/components/selecteditem/support/SelectedItemSupport.dart';
import 'package:trans/components/search/SearchComponent.dart';

class BaseSelectedConstants {
  static const SUB_HEADER_COLOR = 'sub_header_color';
  static const SUB_HEADER_ICON = 'sub_header_icon';
  static const TITLE = 'title';
  static const SINGLE_CHOOSE = 'single_choose';
  static const int LIMIT = 5000;
}

abstract class BaseSelectedScreen<T> extends BaseScreen {
  /// Scroll controller
  ScrollController _scrollController = ScrollController();

  /// Refresh controller
  RefreshController _refreshController = RefreshController(initialRefresh: true);

  /// Update next button.
  StreamController<bool> _buttonUpdateStream = StreamController();
  /// Colors
  Map colors = Map();

  /// Icons
  Map icons = Map();

  /// Offset
  int offset = 0;

  /// Status is first load
  bool isFirstLoad = true;

  /// List data
  List<SelectedItemSupport<T>> listData = [];

  /// Data is selected
  List<SelectedItemSupport<T>> listSelectedData = [];

  /// Status is searching
  bool isSearching = false;

  /// Buffer of text search
  List<String> buffer = [];

  /// Searching
  String searching;

  /// Title
  String title;

  /// Single choose
  bool isSingleChoose = false;

  /// Handle search
  Future<void> handleSearch(String value);

  /// Handle refresh
  void handleRefresh();

  /// Handle loading
  void handleLoading();

  @override
  void dispose() {
    super.dispose();
    _buttonUpdateStream.close();
  }

  @override
  void initState() {
    super.initState();
//    dumpIconImageColor();
    title = widget.arguments[BaseSelectedConstants.TITLE];
    isSingleChoose = widget.arguments[BaseSelectedConstants.SINGLE_CHOOSE];
  }

  /// Create refresh widget
  Widget _createRefresherWidget() {
    return SmartRefresher(
      controller: _refreshController,
      enablePullUp: !isFirstLoad,
      child: _createListWidget(),
      footer: createLoadClassicWidget(),
      header: createRefreshWaterDropWidget(),
      onRefresh: baseHandleRefresh,
      onLoading: baseHandleLoading,
    );
  }

  /// Create search widget
  Widget _createSearchWidget() {
    Map args = Map();
    args[SearchComConstants.CALLBACK] = (String value) {
      _baseHandleSearch(value);
    };
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
      _refreshController.refreshCompleted();
      return;
    }
    offset = 0;
    isFirstLoad = false;

    handleRefresh();

    _refreshController.refreshCompleted();
  }

  /// Handle loading
  void baseHandleLoading() async {
    if (!mounted) {
      _refreshController.loadComplete();
      return;
    }
    handleLoading();
    _refreshController.loadComplete();
  }

  /// Create list widget
  Widget _createListWidget() {
    List<Widget> listWidget = [];
    if (listData == null || listData.isEmpty) {
      return ListView(children: listWidget);
    }

    listWidget = listData.map<Widget>((value) {
      Map args = Map();

      args[SelectedItemComConstants.CALLBACK] = handleCallback;
      value.isSingleChoose = isSingleChoose;
      args[SelectedItemComConstants.SUPPORT] = value;
      return SelectedItemComponent(arguments: args);
    }).toList();

    return ListView(
        padding: EdgeInsets.all(0),
        cacheExtent: 10000,
        controller: _scrollController,
        children: listWidget);
  }

  /// Handle callback data from item
  void handleCallback(SelectedItemSupport<T> data) {

    if (data.isSelected) {
      listSelectedData.add(data);
    }else {
      var foundIndex = -1;
      for (int index = 0; index < listSelectedData.length; index++) {
        SelectedItemSupport item = listSelectedData[index];
        if (item.id == data.id) {
          foundIndex = index;
          break;
        }
      }
      if (foundIndex != -1) {
        listSelectedData.removeAt(foundIndex);
      }
    }
    /// If single choose, we back to previous screen.
    if(isSingleChoose){
      handleBack();
      return;
    }

    /// Update button.
    if(listSelectedData.isEmpty){
      _buttonUpdateStream.sink.add(false);
    }else{
      _buttonUpdateStream.sink.add(true);
    }
  }

  /// Handle data.
  void handleBack(){
    popScreen(context, data:listSelectedData);
  }

  @override
  Widget onInitBody(BuildContext context) {
    List<Widget> listWidget = [];
    /// Create sub header
//    listWidget.add(_createSubHeaderWidget());
    /// Create search.
    listWidget.add(_createSearchWidget());
    /// Create body
    listWidget.add( Expanded(
      child: _createRefresherWidget(),
    ));

    if(!isSingleChoose){
//      listWidget.add(_createSubmitWidget());
    }

    return Column(children:listWidget);
  }

  /// Create submit widget
//  Widget _createSubmitWidget(){
//
//    Map buttonColor = Map();
//    buttonColor[ButtonComConstant.BACKGROUND_ENABLE_COLOR] = '#2F80ED';
//    buttonColor[ButtonComConstant.TEXT_ENABLE_COLOR] = '';
//    buttonColor[ButtonComConstant.BACKGROUND_DISABLE_COLOR] = '';
//    buttonColor[ButtonComConstant.TEXT_DISABLE_COLOR] = '';
//
//    Map args = Map();
//    args[ButtonComConstant.CALLBACK] = ()async{
//      handleBack();
//    };
//    args[ButtonComConstant.ENABLE] = false;
//    args[ButtonComConstant.UPDATE] = _buttonUpdateStream;
//    args[ButtonComConstant.TEXT] = 'Submit';
//
//    Widget widget = ButtonComponent(arguments: args, colors: buttonColor);
//
//    return Container(
//        margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
//        child: widget);
//  }

  /// Dump icon, image and color
//  void dumpIconImageColor() {
//    Map subHeaderColor = Map();
//    subHeaderColor[SubHeaderComConstant.BACKGROUND_COLOR] = '';
//    colors[BaseSelectedConstants.SUB_HEADER_COLOR] = subHeaderColor;
//
//    Map subHeaderIcons = Map();
//    subHeaderIcons[SubHeaderComConstant.BACK_ICON] = '';
//    icons[BaseSelectedConstants.SUB_HEADER_ICON] = subHeaderIcons;
//  }
//
//  /// Create sub header widget
//  Widget _createSubHeaderWidget() {
//    Map args = Map();
//    args[SubHeaderComConstant.LEFT_CALLBACK] = () {
//      popScreen(context);
//    };
//    args[SubHeaderComConstant.TITLE] = title;
//    Map argIcons = icons[BaseSelectedConstants.SUB_HEADER_ICON];
//    Map argColors = colors[BaseSelectedConstants.SUB_HEADER_COLOR];
//    return SubHeaderComponent(arguments: args, icons: argIcons, colors: argColors);
//  }
}
