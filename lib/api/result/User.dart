class User {
  int code;
  String token;
  Data data;

  User({this.code, this.token, this.data});

  User.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    token = json['token'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['token'] = this.token;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String sId;
  String postCode;
  String phone;
  String avatar;
  String created;
  int iV;
  String displayName;
  String address;
  String birthday;
  String description;

  Data(
      {this.sId,
      this.postCode,
      this.phone,
      this.avatar,
      this.created,
      this.iV,
      this.displayName,
      this.address,
      this.birthday,
      this.description});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    postCode = json['postCode'];
    phone = json['phone'];
    avatar = json['avatar'];
    created = json['created'];
    iV = json['__v'];
    displayName = json['displayName'];
    address = json['address'];
    birthday = json['birthday'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['postCode'] = this.postCode;
    data['phone'] = this.phone;
    data['avatar'] = this.avatar;
    data['created'] = this.created;
    data['__v'] = this.iV;
    data['displayName'] = this.displayName;
    data['address'] = this.address;
    data['birthday'] = this.birthday;
    data['description'] = this.description;
    return data;
  }
}
