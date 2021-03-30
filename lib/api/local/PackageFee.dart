import 'package:trans/api/local/Package.dart';

class PackageFee {
  String mass;
  String size1;
  String size2;
  String size3;
  List<Package> packages;

  PackageFee({this.mass, this.size1, this.size2, this.size3, this.packages});

  PackageFee.fromJson(Map<String, dynamic> json) {
    mass = json['mass'];
    size1 = json['size1'];
    size2 = json['size2'];
    size3 = json['size3'];
    if (json['packages'] != null) {
      packages = new List<Package>();
      json['packages'].forEach((v) {
        packages.add(new Package.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mass'] = this.mass;
    data['size1'] = this.size1;
    data['size2'] = this.size2;
    data['size3'] = this.size3;
    if (this.packages != null) {
      data['packages'] = this.packages.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
