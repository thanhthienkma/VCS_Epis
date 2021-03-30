class JobDetail {
  int status;
  String message;
  Data data;

  JobDetail({this.status, this.message, this.data});

  JobDetail.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
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
  String companyName;
  String companyEmailApplyJob;
  String companyPhone;
  String companyDescription;
  String jobApplyType;
  List<Skills> skills;
  List<String> sectorCat;
  String jobDescription;

  Data(
      {this.iD,
        this.title,
        this.publishDate,
        this.expiryDate,
        this.thumbnailSrc,
        this.location,
        this.companyName,
        this.companyEmailApplyJob,
        this.companyPhone,
        this.companyDescription,
        this.jobApplyType,
        this.skills,
        this.sectorCat,
        this.jobDescription});

  Data.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    title = json['title'];
    publishDate = json['publish_date'];
    expiryDate = json['expiry_date'];
    thumbnailSrc = json['thumbnail_src'];
    location = json['location'];
    companyName = json['company_name'];
    companyEmailApplyJob = json['company_email_apply_job'];
    companyPhone = json['company_phone'];
    companyDescription = json['company_description'];
    jobApplyType = json['job-apply-type'];
    if (json['skills'] != null) {
      skills = new List<Skills>();
      json['skills'].forEach((v) {
        skills.add(new Skills.fromJson(v));
      });
    }
    sectorCat = json['sector_cat'].cast<String>();
    jobDescription = json['job_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['title'] = this.title;
    data['publish_date'] = this.publishDate;
    data['expiry_date'] = this.expiryDate;
    data['thumbnail_src'] = this.thumbnailSrc;
    data['location'] = this.location;
    data['company_name'] = this.companyName;
    data['company_email_apply_job'] = this.companyEmailApplyJob;
    data['company_phone'] = this.companyPhone;
    data['company_description'] = this.companyDescription;
    data['job-apply-type'] = this.jobApplyType;
    if (this.skills != null) {
      data['skills'] = this.skills.map((v) => v.toJson()).toList();
    }
    data['sector_cat'] = this.sectorCat;
    data['job_description'] = this.jobDescription;
    return data;
  }
}

class Skills {
  String name;

  Skills({this.name});

  Skills.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}

