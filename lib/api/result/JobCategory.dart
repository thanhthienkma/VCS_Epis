
class JobCategory {
  int status;
  List<Data> data;

  JobCategory({this.status, this.data});

  JobCategory.fromJson(Map<String, dynamic> json) {
    status = json['status'];
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
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int idCat;
  String name;
  String imageThumb;
  Data({this.idCat, this.name, this.imageThumb});

  Data.fromJson(Map<String, dynamic> json) {
    idCat = json['id_cat'];
    name = json['name'];
    imageThumb = json['image_thumb'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_cat'] = this.idCat;
    data['name'] = this.name;
    data['image_thumb'] = this.imageThumb;
    return data;
  }
}

