import 'dart:async';
import 'dart:convert';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trans/identifiers/Screens.dart';
import 'package:trans/api/request/BaseRequest.dart';
import 'package:trans/api/request/JobsRequest.dart';
import 'package:trans/api/result/Job.dart';
import 'package:trans/api/result/Result.dart';
import 'package:trans/api/result/User.dart' as u;
import 'package:trans/base/pullscreen/BasePullScreen.dart';
import 'package:trans/base/screen/BaseScreen.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/dialog/message/MessageDialog.dart';
import 'package:trans/preferences/Preferences.dart';
import 'package:trans/screens/jobs/items/category/CategoryItem.dart';
import 'package:trans/screens/jobs/items/job/JobItem.dart';
import 'package:trans/screens/main/MainScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:trans/api/result/JobCategory.dart' as cat;

class JobsConstants {
  static const JOB_ITEM = 'job item';
  static const JOB_CATEGORY = 'job category';
}

class JobsScreen extends BasePullScreen {
  /// Request API
  JobsRequest jobRequest = JobsRequest();

  StreamController filterStream = StreamController<cat.Data>.broadcast();
  TextEditingController searchController = TextEditingController();
  cat.JobCategory jobCategory;
  Job job;

  String catId = '';
  String searching;
  bool _isTapped = false;

  /// Greeting time
  String greeting = '';

  /// Args
  Map args = Map();

  /// Current usser
  u.User _currentUser;

  @override
  void initState() {
    super.initState();

    /// Get arguments
    getArguments();

    /// Get current user
    _getCurrentUser();
  }

  _getCurrentUser() async {
    String user = await Preferences.getUser();
    if (user == null || user.isEmpty) {
      return;
    }
    _currentUser = u.User.fromJson(jsonDecode(user));
  }

  @override
  void dispose() {
    super.dispose();
    filterStream.close();
    searchController.dispose();
  }

  getArguments() {
    args = widget.arguments;
    jobCategory = args[JobsConstants.JOB_CATEGORY];
  }

  _navigateSupportVCS() async {
    const url = 'https://www.facebook.com/vcs.vietnamese/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _createJobsWidget() {
    if (this.job == null) {
      return Container();
    }

    return Container(
        child: Column(
      children: <Widget>[
        job.data.isEmpty
            ? Container(
                margin: EdgeInsets.only(top: 50),
                child: Column(
                  children: <Widget>[
                    Icon(Icons.date_range, color: Colors.grey),
                    Container(
                        margin: marginTop10,
                        child: Text(
                          'Danh mục không có việc làm.',
                          style: TextStyle(color: Colors.grey),
                        )),
                  ],
                ),
              )
            :

            /// Jobs
            ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: this.job.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return JobItem(
                    this.job.data[index],
                    jobCallback: (item) {
                      /**
                     * Handle job callback
                     */
                      _handleJobCallback(item);
                    },
                  );
                },
              )
      ],
    ));
  }

  _handleJobCallback(item) {
    args[JobsConstants.JOB_ITEM] = item;

    /// Go to job detail screen
    pushScreen(BaseWidget(screen: Screens.JOB_DETAIL, arguments: args),
        Screens.JOB_DETAIL);
  }

  String get _displayName {
    if (_currentUser == null) {
      return '';
    }
    return _currentUser.data.displayName;
  }

  Widget _createGreetingWidget() {
    return Container(
        alignment: Alignment.topLeft,
        margin: EdgeInsets.only(left: 20, top: 10),
        child: Text(
            '$_greetings, $_displayName \nTìm công việc yêu thích của bạn tại Úc',
            style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontStyle: FontStyle.italic)));
  }

  Widget _createJobCategoriesWidget() {
    return Container(
        margin: EdgeInsets.only(top: 10, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            /// Job categories
            Container(
              height: 80,
              margin: marginTop10,
              child: ListView(
                cacheExtent: 10000,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: jobCategory.data.map((element) {
                  return CategoryItem(
                    element,
                    filterStream: this.filterStream,
                    callback: (item) {
                      /**
                       * Handle filter job
                       */

                      if (!_isTapped) {
                        filterStream.sink.add(item);
                        _handleCategoryCallback(item.idCat.toString());
                        _isTapped = true;
                      } else {
                        return;
                      }
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ));
  }

  _handleCategoryCallback(String value) {
    searchController.clear();
    this.catId = value;
    refreshController.requestRefresh();
  }

  Widget _createSearchWidget() {
    return Container(
        margin: EdgeInsets.only(top: margin10, left: margin20),
        child: Row(
          children: <Widget>[
            /// Search box
            Expanded(
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            bottomLeft: Radius.circular(24))),
                    child: TextField(
                        controller: searchController,
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(fontSize: 14),
                          hintText: 'Tìm công việc yêu thích',
                          contentPadding: EdgeInsets.only(left: 15),
                          border: InputBorder.none,
                        )))),

            /// Search icon
            Container(
              width: 50,
              margin: EdgeInsets.only(right: margin20),
              decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(24),
                      bottomRight: Radius.circular(24))),
              child: IconButton(
                icon: Icon(Icons.search, color: Colors.white, size: 20),
                onPressed: _handleSearchJob,
              ),
            ),
          ],
        ));
  }

  void _handleSearchJob() {
    searching = searchController.text;

    if (searching.isEmpty) {
      return;
    }

    refreshController.requestRefresh();
  }

  /// Set up greetings
  String get _greetings {
    DateTime now = DateTime.now().toLocal();
    String time = DateFormat.Hm().format(now);
    int hour = int.parse(time.substring(0, 2));

    if (hour > 6 && hour <= 11) {
      /// For morning
      setState(() {
        greeting = MainConstants.MORNING;
      });
    } else if (hour > 11 && hour <= 12) {
      /// For afternoon
      setState(() {
        greeting = MainConstants.AFTERNOON;
      });
    } else if (hour > 12 && hour <= 18) {
      /// For evening
      setState(() {
        greeting = MainConstants.EVENING;
      });
    } else {
      /// For night
      setState(() {
        greeting = MainConstants.NIGHT;
      });
    }
    return greeting;
  }

  Widget _createHeaderWidget() {
    final EdgeInsets padding = MediaQuery.of(context).padding;

    return Container(
        margin: EdgeInsets.only(top: 40, left: 20, right: 20),
        padding: EdgeInsets.only(bottom: padding.bottom / 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            BouncingWidget(
              child: Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey[200]),
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                  child: Icon(Icons.arrow_back, color: Colors.white, size: 20)),
              onPressed: () {
                popScreen(context);
              },
            ),
            BouncingWidget(
              child: Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey[200]),
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                  child: Icon(Icons.message, color: Colors.white, size: 20)),
              onPressed: () {
                _navigateSupportVCS();
              },
            ),
          ],
        ));
  }

  @override
  Widget createSubHeaderWidget() {
    return Container(
      constraints: BoxConstraints.expand(height: 300),
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 132, 205, 251),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50))),
      child: Container(
        child: Column(
          children: <Widget>[
            /// Create header widget
            _createHeaderWidget(),

            /// Create greeting widget
            _createGreetingWidget(),

            /// Create search widget
            _createSearchWidget(),

            /// Create job categories widget
            _createJobCategoriesWidget(),
          ],
        ),
      ),
    );
  }

  @override
  BoxDecoration onInitBackground(BuildContext context) {
    return BoxDecoration(color: Color.fromARGB(255, 248, 244, 240));
  }

  @override
  PreferredSize onInitAppBar(BuildContext context) {
    return null;
  }

  @override
  List<Widget> createListWidget() {
    List<Widget> widgetList = [
      /// Create jobs widget
      _createJobsWidget()
    ];
    return widgetList;
  }

  @override
  Future<void> handleLoading() async {
    Map<String, dynamic> data = Map();
    data['searchKey'] = searching;
    data['sortBy'] = 'publish_date';
    data['cat_id'] = catId;
    data['limit'] = 10;
    data['offset'] = offset + 1;
    Result<dynamic> result = await jobRequest.callRequest(context,
        queries: data, url: BaseRequest.baseUrlFindWork);
    print(result);
    if (result.isSuccess()) {
      List<Data> listJobs = result.data.data;
      if (listJobs.isNotEmpty) {
        job.data.addAll(listJobs);
        offset = offset + 1;
      }
      _isTapped = false;
    } else {
      MessageDialog.instance.showMessageOkDialog(
          context, '', 'Hệ thống lỗi.', 'assets/images/failure.png',
          callback: () {
        popScreen(context);
      });
    }
    return;
  }

  @override
  Future<void> handleRefresh() async {
    Map<String, dynamic> data = Map();
    data['searchKey'] = searching;
    data['sortBy'] = 'publish_date';
    data['cat_id'] = catId;
    data['limit'] = 10;
    data['offset'] = offset;
    Result<dynamic> result = await jobRequest.callRequest(context,
        queries: data, url: BaseRequest.baseUrlFindWork);

    print(result);
    if (result.isSuccess()) {
      job = result.data;
      _isTapped = false;
    } else {
      MessageDialog.instance.showMessageOkDialog(
          context,
          '',
          'Kết nối đương truyền không ổn định.',
          'assets/images/failure.png', callback: () {
        popScreen(context);
      });
    }
    return;
  }
}
