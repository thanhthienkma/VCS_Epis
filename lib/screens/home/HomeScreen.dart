import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:trans/identifiers/Screens.dart';
import 'package:trans/api/request/BaseRequest.dart';
import 'package:trans/api/request/JobCategoryRequest.dart';
import 'package:trans/api/result/JobCategory.dart';
import 'package:trans/api/result/MyPost.dart';
import 'package:trans/api/result/Result.dart';
import 'package:trans/api/result/User.dart';
import 'package:trans/base/screen/BaseScreen.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/dialog/loading/LoadingDialog.dart';
import 'package:trans/dialog/message/MessageDialog.dart';
import 'package:trans/preferences/Preferences.dart';
import 'package:trans/screens/home/widgets/BottomWidget.dart';
import 'package:trans/screens/home/widgets/IOSWidget.dart';
import 'package:trans/screens/home/widgets/MyPostWidget.dart';
import 'package:trans/screens/home/widgets/TopWidget.dart';
import 'package:trans/screens/jobs/JobsScreen.dart';
import 'package:trans/screens/main/MainScreen.dart';
import 'package:trans/utils/image/ImageNetworkUtil.dart';
import 'package:trans/widgets/admob_widget.dart';

class HomeConstants {
  static const TRANSPORT_CALLBACK = 'transport callback';
  static const TOUR_CALLBACK = 'tour callback';
  static const JOB_CALLBACK = 'job callback';
  static const LANDLORD_CALLBACK = 'landlord callback';
  static const EARN_MONEY_CALLBACK = 'earn money callback';
  static const SHOPPING_CALLBACK = 'shopping callback';
}

class HomeScreen extends BaseScreen {
  Function(int value) shoppingCallback;
  StreamController bottomStream;
  String greeting = '';

  List<MyPost> myPosts = List();

  bool loading = false;
  bool disconnect = false;
  JobCategoryRequest jobCategoryRequest = JobCategoryRequest();
  JobCategory jobCategory;

  /// Args
  Map<String, dynamic> args = Map();

  /// Map callback
  Map mapCallback = Map();

  User _currentUser;

  @override
  void initState() {
    super.initState();

    /**
     * Get arguments
     */
    getArguments();

    /**
     * Handle map callback
     */
    _handleMapCallback();

    /**
     * Get posts
     */
    _getPosts();
  }

  getArguments() async {
    args = widget.arguments;
    bottomStream = args[MainConstants.BOTTOM_STREAM];
    shoppingCallback = args[MainConstants.SHOPPING_CALLBACK];

    String value = await Preferences.getUser();
    if (value == null || value.isEmpty) {
      return;
    }
    _currentUser = User.fromJson(jsonDecode(value));
    if (!mounted) {
      return;
    }

    /// Update new data
    setState(() {});
  }

  _checkAuthorize({Function requiredCallback}) {
    Preferences.getToken().then((token) {
      if (token == null || token.isEmpty) {
        pushScreen(
            BaseWidget(
                screen: Screens.PHONE, arguments: MainConstants.HOME_KEY),
            Screens.PHONE);
        return;
      }
      requiredCallback();
    });
  }

  _handleMapCallback() {
    mapCallback[HomeConstants.TRANSPORT_CALLBACK] = () {
      print('TRANSPORT_CALLBACK');
      _checkAuthorize(requiredCallback: () {
        pushScreen(BaseWidget(screen: Screens.TRANSPORT), Screens.TRANSPORT);
      });

//      pushScreen(BaseWidget(screen: Screens.COMING_SOON), Screens.COMING_SOON);
    };
    mapCallback[HomeConstants.TOUR_CALLBACK] = () {
      print('TOUR_CALLBACK');
      pushScreen(BaseWidget(screen: Screens.COMING_SOON), Screens.COMING_SOON);
    };
    mapCallback[HomeConstants.JOB_CALLBACK] = () {
      print('JOB_CALLBACK');
      /**
       * Get job categories
       */
      getJobCategories();
    };
    mapCallback[HomeConstants.LANDLORD_CALLBACK] = () {
      print('LANDLORD_CALLBACK');
      pushScreen(BaseWidget(screen: Screens.COMING_SOON), Screens.COMING_SOON);
    };
    mapCallback[HomeConstants.SHOPPING_CALLBACK] = () {
      print('SHOPPING_CALLBACK');

      /// Update highlight bottom
      bottomStream.sink.add(MainConstants.SHOPPING_KEY);

      /// Shopping callback
      shoppingCallback(2);
    };
    mapCallback[HomeConstants.EARN_MONEY_CALLBACK] = () {
      print('EARN_CALLBACK');
      _checkAuthorize(requiredCallback: () {
        pushScreen(BaseWidget(screen: Screens.EARN_MONEY), Screens.EARN_MONEY);
      });
    };
  }

  @override
  Widget onInitBody(BuildContext context) {
    return Column(
      children: <Widget>[
        /// Create header widget
        _createHeaderWidget(),

        /// Create services widget
        _createServicesWidget(),

        /// Create my posts widget
        _createMyPostsWidget(),
      ],
    );
  }

  String get _displayName {
    if (_currentUser == null) {
      return '$greetings,';
    }
    return '$greetings, ${_currentUser.data.displayName}';
  }

  Widget _createHeaderWidget() {
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Row(
          children: <Widget>[
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _displayName,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Chào Mừng Bạn Đến ',
                          style: TextStyle(
                              fontSize: 16, fontStyle: FontStyle.italic),
                        ),
                        Text(
                          'VCS ',
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    )),
              ],
            )),
            _currentUser == null
                ? Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        shape: BoxShape.circle),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.person_pin, color: Colors.grey),
                        Container(
                          child: Text('No image',
                              style: TextStyle(
                                  fontSize: 8,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey)),
                        ),
                      ],
                    ))
                : Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: primaryColor),
                        shape: BoxShape.circle),
                    child: ImageNetworkUtil.loadImageAllCorner(
                        'http://18.191.111.162:3000/${_currentUser.data.avatar}',
                        30,
                        failLink: 'assets/images/avatar.empty.png')),
          ],
        ));
  }

  Widget _createServicesWidget() {
    return Card(
        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
        elevation: 4,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Column(
          children: <Widget>[
            /// Top Widget
            TopWidget(
                leftText: 'Giao Vận',
                leftPath: 'assets/images/transportation.jpg',
                midText: 'Du lịch',
                midPath: 'assets/images/tour_guide.png',
                rightText: 'Tìm việc',
                rightPath: 'assets/images/job.png',
                mapCallback: this.mapCallback),

            /// Middle Widget
            BottomWidget(
                leftText: 'Tìm nhà',
                leftPath: 'assets/images/house.png',
                midText: 'Kiếm tiền',
                midPath: 'assets/images/earn_money.png',
                rightText: 'Mua sắm',
                rightPath: 'assets/images/shopping.png',
                mapCallback: this.mapCallback),

            /// IOS Widget
//            IOSWidget(
//                leftText: 'Tìm việc',
//                leftPath: 'assets/images/job.png',
//                midText: 'Kiếm tiền',
//                midPath: 'assets/images/earn_money.png',
//                rightText: 'Mua sắm',
//                rightPath: 'assets/images/shopping.png',
//                mapCallback: this.mapCallback),
          ],
        ));
  }

  Widget _createMyPostsWidget() {
    double deviceWidth = MediaQuery.of(context).size.width;
    int widgetsInRow = 2;

    if (deviceWidth > 1200) {
      widgetsInRow = 4;
    } else if (deviceWidth > 768) {
      widgetsInRow = 3;
    }

    double aspectRatio =
        (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 230;

    if (!loading) {
      return Container(
          margin: EdgeInsets.only(top: 40),
          child: SpinKitCircle(size: 40, color: primaryColor));
    }

    return disconnect
        ? Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 40),
            child: Text('Không có kết nối mang :(',
                style: TextStyle(color: Colors.grey)),
          )
        : Expanded(
            child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: padding10),
                itemCount: myPosts.length,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: widgetsInRow,
                    crossAxisSpacing: double10,
                    childAspectRatio: aspectRatio),
                itemBuilder: (BuildContext context, int index) {
                  if (index == 2 || index == 7) {
                    return AdmobWidget();
                  }
                  return MyPostWidget(myPosts[index]);
                }));
  }

  void getJobCategories() async {
    LoadingDialog.instance.showLoadingDialog(context);

    Result<dynamic> result = await jobCategoryRequest.callRequest(context,
        url: BaseRequest.baseUrlFindWork);
    print(result);
    await LoadingDialog.instance.dismissLoading();
    if (result.isSuccess()) {
      jobCategory = result.data;
      Map<String, dynamic> args = Map();
      args[JobsConstants.JOB_CATEGORY] = jobCategory;

      /// Go to job screen
      pushScreen(
          BaseWidget(screen: Screens.JOBS, arguments: args), Screens.JOBS);
    } else {
      MessageDialog.instance.showMessageOkDialog(context, '',
          'Kết nối đương truyền không ổn định.', 'assets/images/failure.png');
    }
  }

  @override
  PreferredSize onInitAppBar(BuildContext context) {
    return null;
  }

  /// Set up greetings
  String get greetings {
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

  _getPosts() async {
    try {
      Response response = await Dio()
          .get('https://vcs-vn.com.au/wp-json/vcsvn/v1/latest-posts/31');
      print(response);
      for (var item in response.data) {
        int _id = item['id'];
        String _title = item['title'];
        String _categoryName = item['category']['name'];
        String _body = item['body'];

        String _image = item['image'] == false
            ? 'https://s1cdn.vnecdn.net/vnexpress/restruct/i/v341/v2_2019/pc/graphics/no-thumb-5x3.jpg'
            : item['image'];
        String _date = item['date'];
        String _link = item['link'];

        MyPost myPost = MyPost(
            id: _id,
            title: _title,
            categoryName: _categoryName,
            body: _body,
            image: _image,
            date: _date,
            link: _link);

        myPosts.add(myPost);
      }
    } catch (e) {
      disconnect = true;
      print(e);
    }

    loading = true;
    if (!mounted) {
      return;
    }

    setState(() {});
  }
}
