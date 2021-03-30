import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:trans/api/params/FileParams.dart';
import 'package:trans/api/request/ChangeInfoRequest.dart';
import 'package:trans/api/request/FileUploadRequest.dart';
import 'package:trans/api/result/Result.dart';
import 'package:trans/api/result/User.dart';
import 'package:trans/api/result/Error.dart';
import 'package:trans/base/screen/BaseScreen.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/components/button/ButtonComponent.dart';
import 'package:trans/components/textinput/TextInputComponent.dart';
import 'package:trans/dialog/datetime/DateTimeDialog.dart';
import 'package:trans/dialog/loading/LoadingDialog.dart';
import 'package:trans/dialog/message/MessageDialog.dart';
import 'package:trans/dialog/takephoto/TakePhotoDialog.dart';
import 'package:trans/preferences/Preferences.dart';
import 'package:trans/screens/personal/PersonalScreen.dart';
import 'package:trans/screens/personal/widgets/PersonalHeaderWidget.dart';
import 'package:trans/extension/DateTimeExtension.dart';
import 'package:trans/extension/StringExtension.dart';
import 'package:trans/utils/image/ImageNetworkUtil.dart';
import 'package:path_provider/path_provider.dart';

class ChangeInfoSupport {
  final String name;
  final String avatar;
  final String postCode;
  final String phone;
  final String dob;
  final String address;

  ChangeInfoSupport(
      {this.name,
      this.avatar,
      this.postCode,
      this.phone,
      this.dob,
      this.address});
}

class ChangeInfoScreen extends BaseScreen {
  Map args = Map();
  User user;
  String postCode = '';
  String phoneNumber = '';
  String avatar;
  DateTime dobSelected;
  String dateSendToServer;
  String token;
  File _file;
  String path;

  /// Request API
  ChangeInfoRequest changeInfoRequest = ChangeInfoRequest();
  FileUploadRequest fileUploadRequest = FileUploadRequest();

  /// Init controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController decsController = TextEditingController();

  /// Timestamp for name of image
  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  @override
  void initState() {
    super.initState();

    /// Init data
    initData();
  }

  initData() async {
    /// Get arguments
    getArguments();

    /// Init user
    String value = await Preferences.getUser();
    if (value == null || value.isEmpty) {
      return;
    }

    user = User.fromJson(jsonDecode(value));
    nameController.text = _initText(user.data.displayName);
    postCode = _initText(user.data.postCode);
    phoneNumber = _initText(user.data.phone);
    avatar = _initText(user.data.avatar);
    addressController.text = _initText(user.data.address);
    if (user.data != null &&
        user.data.birthday != null &&
        user.data.birthday.isNotEmpty) {
      dobSelected = user.data.birthday.toDateTimeServerToLocal();
    }

    if (!mounted) {
      return;
    }

    /// Update new data
    setState(() {});

    /// Get token
    this.token = await Preferences.getToken();
    String path = await Preferences.getPath();
    if (path == null || path.isEmpty) {
      return;
    }

    this.path = path;
  }

  String _initText(String value) {
    if (value == null || value.isEmpty) {
      return '';
    }
    return value;
  }

  getArguments() {
    args = widget.arguments;
    user = args[PersonalConstants.USER_DATA];
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    addressController.dispose();
    decsController.dispose();
  }

  _handleCamera() async {
    final file = await ImagePicker.pickImage(source: ImageSource.camera);
    if (file == null) {
      return;
    }

    /// Get path
    _getPath(file);
  }

  _getPath(File file) async {
    this.path = file.path;
    this._file = file;

    /// Update new path
    setState(() {});
  }

  _handleGallery() async {
    final file = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (file == null) {
      return;
    }

    /// Get path
    _getPath(file);
  }

  @override
  Widget onInitBody(BuildContext context) {
    return Column(
      children: <Widget>[
        /// Personal header widget
        PersonalHeaderWidget(
          title: 'Thay đổi thông tin cá nhân',
          isBack: true,
          leftCallback: () {
            popScreen(context);
          },
        ),

        Expanded(
            child: Padding(
          padding: paddingAll20,
          child: ListView(
            children: [
              /// Create avatar widget
              _createAvatarWidget(),

              /// Name
              TextInputComponent(
                  labelText: 'Họ và tên',
                  textEditingController: nameController,
                  onChanged: (String text) {}),

              /// Create phone widget
              _createPhoneWidget(postCode, phoneNumber),

              /// Create birthday widget
              _createBirthdayWidget(() {
                /// Handle dob
                _handleDOB();
              }),

              /// Address
              TextInputComponent(
                  labelText: 'Địa chỉ hiện tại',
                  textEditingController: addressController,
                  onChanged: (String text) {}),

              /// Create desc widget
//              _createDecsWidget(),
            ],
          ),
        )),

        /// Update
        Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: ButtonComponent(
              text: 'Cập nhật thông tin',
              margin: 0,
              color: primaryColor,
              onClick: () async {
                final Directory extDir =
                    await getApplicationDocumentsDirectory();
                final String dirPath = '${extDir.path}/Pictures';
                await Directory(dirPath).create(recursive: true);
                final String targetPath = '$dirPath/${timestamp()}.jpg';

                /// Save path
                Preferences.savePath(targetPath);

                await compress(_file, targetPath);

                /// Upload file
                uploadFile(targetPath);
              },
            )),
      ],
    );
  }

  Widget _createAvatarWidget() {
    if (avatar == null) {
      return Container();
    }
    return Column(
      children: <Widget>[
        GestureDetector(
            onTap: () {
              /// Show take photo dialog
              TakePhotoDialog.instance.showTakePhotoDialog(
                  context, 'Chọn ảnh avatar.',
                  cameraCallback: () async => await _handleCamera(),
                  libraryCallback: () async => await _handleGallery());
            },
            child: _getAvatar())
      ],
    );
  }

  Widget _getAvatar() {
    Widget _image;
    if (_file != null) {
      /// Load from file
      _image = ClipOval(
          child: Image.file(_file, fit: BoxFit.cover, width: 100, height: 100));
    } else if (avatar == null || avatar.isEmpty) {
      /// Load from asset
      _image = Image.asset('assets/images/avatar_empty.png', height: 100);
    } else {
      /// Load from link
      _image = Container(
          width: 100,
          height: 100,
          child: ImageNetworkUtil.loadImageAllCorner(
              'http://18.191.111.162:3000/$avatar', 50.0,
              failLink: 'assets/images/avatar_empty.png'));
    }
    return _image;
  }

  _handleDOB() async {
    /// Show date time dialog
    DateTime selected;
    if (dobSelected == null) {
      selected = DateTime(1980, 1, 1).toUtc();
    } else {
      selected = dobSelected;
    }

    DateTime dateTime =
        await DateTimeDialog().showDateDialog(context, selected);

    if (dateTime == null) {
      return;
    }
    dateSendToServer = dateTime.toStringObj("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    dobSelected = dateTime;
    if (!mounted) {
      return;
    }

    /// Update new data
    setState(() {});
  }

  Widget _createBirthdayWidget(Function callback) {
    return GestureDetector(
        onTap: () {
          callback();
        },
        child: Container(
            margin: marginTop20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ngày sinh', style: TextStyle(color: loginBaseColor)),
                Container(
                    margin: marginTop5,
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    child: Row(
                      children: [
                        Container(
                            margin: marginLeft10,
                            child: Icon(Icons.date_range)),
                        Container(
                            margin: marginLeft10,
                            height: 20,
                            color: Colors.black,
                            width: 1),
                        Container(
                            padding: paddingAll15,
                            child: Text(dobSelected == null
                                ? 'Ngày sinh chưa cập nhật'
                                : DateFormat('yyyy-MM-dd')
                                    .format(dobSelected))),
                      ],
                    )),
              ],
            )));
  }

  Widget _createPhoneWidget(String postCode, String phoneNumber) {
    return Container(
        margin: marginTop20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Số điện thoại', style: TextStyle(color: loginBaseColor)),
            Container(
                margin: marginTop5,
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                child: Row(
                  children: [
                    Container(margin: marginLeft10, child: Text(postCode)),
                    Container(
                        margin: marginLeft10,
                        height: 20,
                        color: Colors.black,
                        width: 1),
                    Container(
                      padding: paddingAll15,
                      child: Text(phoneNumber),
                    ),
                  ],
                )),
          ],
        ));
  }

  Widget _createDecsWidget() {
    return Container(
        margin: marginTop20,
        decoration: BoxDecoration(
            border: Border.all(width: 0.5, color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: TextField(
            controller: decsController,
            maxLines: 5,
            maxLength: 100,
            textAlignVertical: TextAlignVertical.top,
            onChanged: (String text) {},
            decoration: InputDecoration(
              labelText: 'Dòng miêu tả(tối đa 120 từ).',
              alignLabelWithHint: true,
              counterText: '',
              labelStyle: TextStyle(
                  color: loginDefaultUnderlineColor, fontSize: font14),
              contentPadding: EdgeInsets.only(left: margin10),
              border: InputBorder.none,
            )));
  }

  void _uploadInfoAccount(ChangeInfoSupport value) async {
    Map<String, dynamic> headers = Map();
    headers['Authorization'] = 'Bearer ${this.token}';

    Map<String, String> data = Map();
    data['postCode'] = value.postCode;
    data['phone'] = value.phone;
    data['displayName'] = value.name;
    data['avatar'] = value.avatar;
    data['address'] = value.address;
    data['birthday'] = value.dob;
    Result<dynamic> result = await changeInfoRequest.callRequest(context,
        data: data, headers: headers);
    print(result);
    await LoadingDialog.instance.dismissLoading();
    if (result.isSuccess()) {
      MessageDialog.instance.showMessageOkDialog(
          context, '', 'Cập nhật thành công.', 'assets/images/success.png',
          callback: () {
        /// Save user as json string
        user = result.data;
        Preferences.saveUser(jsonEncode(user.toJson()));
        popScreen(context, data: user);
      });
    } else {
      Error error = result.error;
      MessageDialog.instance.showMessageOkDialog(
          context, '', error.message, 'assets/images/failure.png');
    }
  }

  /// Compress image
  Future<File> compress(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, targetPath,
        quality: 50);
    return result;
  }

  void uploadFile(String path) async {
    LoadingDialog.instance.showLoadingDialog(context);
    Map<String, dynamic> headers = Map();
    headers['Content-Type'] = 'multipart/form-data';
    FileParams fileParams = FileParams();
    fileParams.name = 'file1';
    fileParams.path = path;
    Result<dynamic> result = await fileUploadRequest.callRequest(context,
        fileParams: [fileParams], headers: headers);
    print(result);
    if (result.isSuccess()) {
      ChangeInfoSupport data = ChangeInfoSupport(
          name: nameController.text,
          avatar: result.data.data[0].link,
          postCode: postCode,
          phone: phoneNumber,
          dob: dateSendToServer,
          address: addressController.text);

      /// Upload info account
      _uploadInfoAccount(data);
    } else {
      await LoadingDialog.instance.dismissLoading();
      Error error = result.error;
      MessageDialog.instance.showMessageOkDialog(
          context, '', error.message, 'assets/images/failure.png');
    }
  }

  @override
  BoxDecoration onInitBackground(BuildContext context) {
    return BoxDecoration(color: Color(0xffFAFAFA));
  }
}
