import 'package:trans/api/result/Province.dart' as p;
import 'package:trans/api/result/District.dart' as d;
import 'package:trans/api/result/Ward.dart' as w;

class ReceiverAddress {
  String phone;
  String name;
  String address;
  p.Result city;
  d.Result district;
  w.Result ward;

  ReceiverAddress(
      {this.phone,
      this.name,
      this.address,
      this.city,
      this.district,
      this.ward});

  ReceiverAddress.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    address = json['address'];
    city = json['city'] != null ? new   p.Result.fromJson(json['city']) : null;
    district = json['district'] != null
        ? new  d.Result.fromJson(json['district'])
        : null;
    ward = json['ward'] != null ? new  w.Result.fromJson(json['ward']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['address'] = this.address;
    if (this.city != null) {
      data['city'] = this.city.toJson();
    }
    if (this.district != null) {
      data['district'] = this.district.toJson();
    }
    if (this.ward != null) {
      data['ward'] = this.ward.toJson();
    }

    return data;
  }
}

