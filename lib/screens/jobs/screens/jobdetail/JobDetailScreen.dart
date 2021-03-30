import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:trans/api/request/BaseRequest.dart';
import 'package:trans/api/request/JobDetailRequest.dart';
import 'package:trans/api/result/JobDetail.dart';
import 'package:trans/api/result/Result.dart';
import 'package:trans/base/screen/BaseScreen.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/dialog/loading/LoadingDialog.dart';
import 'package:trans/dialog/message/MessageDialog.dart';
import 'package:trans/screens/jobs/JobsScreen.dart';
import 'package:trans/screens/jobs/widgets/FavoriteWidget.dart';
import 'package:trans/screens/jobs/widgets/JobHeaderWidget.dart';
import 'package:trans/utils/image/ImageNetworkUtil.dart';
import 'package:trans/widgets/admob_widget.dart';
import 'package:trans/widgets/divider_widget.dart';
import 'package:trans/api/result/Job.dart' as job;
import 'package:url_launcher/url_launcher.dart';

class JobDetailScreen extends BaseScreen {
  /// Args
  Map args = Map();

  /// Request API
  JobDetailRequest jobDetailRequest = JobDetailRequest();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  job.Data jobItem;

  Data data;

  @override
  void initState() {
    super.initState();

    /**
     * / Get arguments
     */
    getArguments();

    /**
     * Get job detail
     */
    getJobDetail();
  }

  getArguments() {
    args = widget.arguments;
    jobItem = args[JobsConstants.JOB_ITEM];
  }

  _navigateSupportVCS() async {
    const url = 'https://www.facebook.com/vcs.vietnamese/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget onInitBody(BuildContext context) {
    if (data == null) {
      return Container();
    }

    return Column(
      children: <Widget>[
        /// Job header widget
        JobHeaderWidget('Chi tiết công việc',
            leftCallback: () => popScreen(context),
            rightIcon: Icon(Icons.message, size: 20),
            rightCallback: () {
              _navigateSupportVCS();
            }),

        Expanded(
            child: ListView(
          children: <Widget>[
            /// Create expires on widget
            _createExpiresOnWidget(),

            /// Create job title
            _createJobTitle(),

            /// Create location widget
            _createLocationWidget(),

            /// Create require skills widget
            _createRequireSkillsWidget(),

            /// Create job type widget
            _createJobTypeWidget(),

            /// Create company info widget
            _createCompanyInfoWidget(),

            /// Create describe job widget
            _createDescribeJobWidget(),

            /// Create sponsor widget
            _createSponsorWidget(),
          ],
        )),

        /// Create save job widget
//        _createSaveJobWidget(),
      ],
    );
  }

  Widget _createSponsorWidget() {
    return Container(
        margin: marginTop10,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            DividerWidget(color: Colors.grey[300]),
            Container(margin: marginTop10, child: Text('Nhà tài trợ')),
            AdmobWidget(height: 200),
          ],
        ));
  }

  Widget _createSaveJobWidget() {
    return FavoriteWidget(callback: () {});
  }

  Widget _createDescribeJobWidget() {
    return Container(
        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(Icons.star),
                Container(
                    margin: marginLeft10,
                    child: Text('Mô tả công việc ',
                        style: TextStyle(
                            fontSize: font16, fontWeight: FontWeight.w500)))
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 10, left: 20),
              child: Html(data: data.jobDescription),
            ),
          ],
        ));
  }

  Widget _createCompanyInfoWidget() {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(top: 20, left: 10),
            child: Text('Thông tin về công ty',
                style:
                    TextStyle(fontSize: font16, fontWeight: FontWeight.w500))),
        Container(
          padding: paddingAll15,
          margin: marginTop10,
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /// Company logo
              Container(
                  height: 80,
                  width: 80,
                  child: ImageNetworkUtil.loadImage(data.thumbnailSrc)),

              /// Company info
              Expanded(
                  child: Container(
                      margin: marginLeft10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(initText(data.companyName), maxLines: 2),
                          Container(
                              margin: marginTop5,
                              child: Text(initText(data.companyEmailApplyJob))),
                          Container(
                              margin: marginTop5,
                              child: InkWell(
                                  onTap: () async {
                                    await _dialCall(data.companyPhone);
                                  },
                                  child: Row(children: <Widget>[
                                    Icon(Icons.phone,
                                        size: 18, color: primaryColor),
                                    Container(
                                        margin: marginLeft5,
                                        child:
                                            Text(initText(data.companyPhone)))
                                  ]))),
                          Container(
                              margin: marginTop5,
                              child: Text(initText(data.companyDescription))),
                        ],
                      ))),
            ],
          ),
        ),
      ],
    ));
  }

  _dialCall(String number) async {
    if (number == null || number.isEmpty || number.length < 3) {
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text('Cuộc gọi không thể thực hiện !')));
      return;
    }

    await launch("tel://$number");
  }

  Widget _createJobTypeWidget() {
    return Container(
        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Thể loại công việc ',
                style:
                    TextStyle(fontSize: font16, fontWeight: FontWeight.w500)),
            Container(
                margin: EdgeInsets.only(top: 10, left: 20),
                child: _getSectors()),
          ],
        ));
  }

  Widget _getSectors() {
    if (data.sectorCat == null || data.sectorCat.isEmpty) {
      return Text('Không yêu cầu.');
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: data.sectorCat.length,
      physics: ClampingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Container(
            margin: marginTop5, child: Text(data.sectorCat[index]));
      },
    );
  }

  Widget _createRequireSkillsWidget() {
    return Container(
        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Những kỹ năng yêu cầu  ',
                style:
                    TextStyle(fontSize: font16, fontWeight: FontWeight.w500)),
            Container(
                margin: EdgeInsets.only(top: 10, left: 20),
                child: _getRequiredSkills()),
          ],
        ));
  }

  Widget _getRequiredSkills() {
    if (data.skills == null || data.skills.isEmpty) {
      return Text('Không yêu cầu.');
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: data.skills.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
            margin: marginTop5, child: Text(data.skills[index].name));
      },
    );
  }

  void _takeDirection(String address) async {
    String query = Uri.encodeComponent(address);
    String googleUrl = "https://www.google.com/maps/search/?api=1&query=$query";
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    }
  }

  Widget _createLocationWidget() {
    return InkWell(
        onTap: () {
          _takeDirection(data.location);
        },
        child: Container(
            margin: EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.location_on, color: primaryColor, size: 20),
                Expanded(
                    child: Text(
                  initText(data.location),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
                Icon(
                  Icons.navigate_next,
                  color: primaryColor,
                  size: 20,
                ),
              ],
            )));
  }

  Widget _createJobTitle() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Text(data.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
    );
  }

  Widget _createExpiresOnWidget() {
    return Container(
      margin: marginTop20,
      alignment: Alignment.center,
      child: Text('Hết hạn vào : ${initText(data.expiryDate)}',
          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
    );
  }

  @override
  BoxDecoration onInitBackground(BuildContext context) {
    return BoxDecoration(color: Color(0xffFAFAFA));
  }

  void getJobDetail() async {
    LoadingDialog.instance.showLoadingDialog(context);
    Map<String, String> data = Map();
    data['jobID'] = jobItem.iD.toString();
    Result<dynamic> result = await jobDetailRequest.callRequest(context,
        data: data, url: BaseRequest.baseUrlFindWork);
    print(result);
    await LoadingDialog.instance.dismissLoading();
    if (result.isSuccess()) {
      if (!mounted) {
        return;
      }
      this.data = result.data.data;

      /// Update new data
      setState(() {});
    } else {
      MessageDialog.instance.showMessageOkDialog(
          context,
          '',
          'Kết nối đương truyền không ổn định.',
          'assets/images/failure.png', callback: () {
        popScreen(context);
      });
    }
  }

  String initText(String value) {
    if (value == null || value.isEmpty) {
      return 'Chưa cập nhật';
    }
    return value;
  }

  @override
  Key onInitKey(BuildContext context) {
    return _scaffoldKey;
  }
}
