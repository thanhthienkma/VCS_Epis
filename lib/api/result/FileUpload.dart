class FileUpload {
  int code;
  List<Data> data;

  FileUpload({this.code, this.data});

  FileUpload.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String fieldname;
  int fileSize;
  String mimetype;
  String link;
  String createdTime;

  Data(
      {this.fieldname,
        this.fileSize,
        this.mimetype,
        this.link,
        this.createdTime});

  Data.fromJson(Map<String, dynamic> json) {
    fieldname = json['fieldname'];
    fileSize = json['fileSize'];
    mimetype = json['mimetype'];
    link = json['link'];
    createdTime = json['createdTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fieldname'] = this.fieldname;
    data['fileSize'] = this.fileSize;
    data['mimetype'] = this.mimetype;
    data['link'] = this.link;
    data['createdTime'] = this.createdTime;
    return data;
  }
}