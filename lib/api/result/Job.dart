class Job {
  int status;
  String message;
  List<Data> data;

  Job({this.status, this.message, this.data});

  Job.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int iD;
  String title;
  String publishDate;
  String expiryDate;
  String thumbnailSrc;
  String location;
  String company;

  Data(
      {this.iD,
        this.title,
        this.publishDate,
        this.expiryDate,
        this.thumbnailSrc,
        this.location,
        this.company});

  Data.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    title = json['title'];
    publishDate = json['publish_date'];
    expiryDate = json['expiry_date'];
    thumbnailSrc = json['thumbnail_src'];
    location = json['location'];
    company = json['company'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['title'] = this.title;
    data['publish_date'] = this.publishDate;
    data['expiry_date'] = this.expiryDate;
    data['thumbnail_src'] = this.thumbnailSrc;
    data['location'] = this.location;
    data['company'] = this.company;
    return data;
  }
}

