class Package {
  int categoryId;
  String name;
  String type;
  String amount;
  bool deleted;

  Package(
      {this.categoryId,
      this.type,
      this.name,
      this.amount,
      this.deleted = false});

  Package.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    type = json['type'];
    amount = json['amount'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['type'] = this.type;
    data['name'] = this.name;
    data['category_id'] = this.categoryId;
    return data;
  }
}
