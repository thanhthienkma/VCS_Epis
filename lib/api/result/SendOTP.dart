class SendOTP {
  int code;
  Data data;

  SendOTP({this.code, this.data});

  SendOTP.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String requestId;
  String status;
  String errorText;

  Data({this.requestId, this.status, this.errorText});

  Data.fromJson(Map<String, dynamic> json) {
    requestId = json['request_id'];
    status = json['status'];
    errorText = json['error_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['request_id'] = this.requestId;
    data['status'] = this.status;
    data['error_text'] = this.errorText;
    return data;
  }
}

