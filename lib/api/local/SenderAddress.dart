import 'package:trans/api/result/WareHouse.dart';

class SenderAddress {
  String phone;
  String name;
  String address;
  String latitude;
  String longitude;
  String postCode;
  String warehouseID;
  Result result;

  SenderAddress({
    this.phone,
    this.name,
    this.address,
    this.latitude,
    this.longitude,
    this.postCode,
    this.result,
    this.warehouseID = '',
  });

  SenderAddress.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    postCode = json['postCode'];
    warehouseID = json['warehouseID'];
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['postCode'] = this.postCode;
    data['warehouseID'] = this.warehouseID;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}
