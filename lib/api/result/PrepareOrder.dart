class PrepareOrder {
  int status;
  bool success;
  Data data;

  PrepareOrder({this.status, this.success, this.data});

  PrepareOrder.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String message;
  Result result;

  Data({this.message, this.result});

  Data.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class Result {
  String receiverName;
  String receiverPhone;
  String receiverAddress;
  String provinceId;
  String districtId;
  String wardId;
  String consigneeName;
  String consigneePhone;
  String consigneeAddress;
  String transportCode;
  String lat;
  String long;
  String mass;
  String size1;
  String size2;
  String size3;
  String note;
  String deliveryNote;
  String method;
  String warehouseId;
  int type;
  int status;
  String goodsMoney;
  String shippingMoney;
  String totalMoney;
  String surcharge;
  int adminId;
  String updatedAt;
  String createdAt;
  int id;
  String code;
  bool payment;
  List<Categories> categories;
  User user;
  Province province;
  District district;
  Ward ward;
  Warehouse warehouse;

  Result(
      {this.receiverName,
        this.receiverPhone,
        this.receiverAddress,
        this.provinceId,
        this.districtId,
        this.wardId,
        this.consigneeName,
        this.consigneePhone,
        this.consigneeAddress,
        this.transportCode,
        this.lat,
        this.long,
        this.mass,
        this.size1,
        this.size2,
        this.size3,
        this.note,
        this.deliveryNote,
        this.method,
        this.warehouseId,
        this.type,
        this.status,
        this.goodsMoney,
        this.shippingMoney,
        this.totalMoney,
        this.surcharge,
        this.adminId,
        this.updatedAt,
        this.createdAt,
        this.id,
        this.code,
        this.payment,
        this.categories,
        this.user,
        this.province,
        this.district,
        this.ward,
        this.warehouse});

  Result.fromJson(Map<String, dynamic> json) {
    receiverName = json['receiver_name'];
    receiverPhone = json['receiver_phone'];
    receiverAddress = json['receiver_address'];
    provinceId = json['province_id'];
    districtId = json['district_id'];
    wardId = json['ward_id'];
    consigneeName = json['consignee_name'];
    consigneePhone = json['consignee_phone'];
    consigneeAddress = json['consignee_address'];
    transportCode = json['transport_code'];
    lat = json['lat'];
    long = json['long'];
    mass = json['mass'];
    size1 = json['size1'];
    size2 = json['size2'];
    size3 = json['size3'];
    note = json['note'];
    deliveryNote = json['delivery_note'];
    method = json['method'];
    warehouseId = json['warehouse_id'];
    type = json['type'];
    status = json['status'];
    goodsMoney = json['goods_money'];
    shippingMoney = json['shipping_money'];
    totalMoney = json['total_money'];
    surcharge = json['surcharge'];
    adminId = json['admin_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
    code = json['code'];
    payment = json['payment'];
    if (json['categories'] != null) {
      categories = new List<Categories>();
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    province = json['province'] != null
        ? new Province.fromJson(json['province'])
        : null;
    district = json['district'] != null
        ? new District.fromJson(json['district'])
        : null;
    ward = json['ward'] != null ? new Ward.fromJson(json['ward']) : null;
    warehouse = json['warehouse'] != null
        ? new Warehouse.fromJson(json['warehouse'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['receiver_name'] = this.receiverName;
    data['receiver_phone'] = this.receiverPhone;
    data['receiver_address'] = this.receiverAddress;
    data['province_id'] = this.provinceId;
    data['district_id'] = this.districtId;
    data['ward_id'] = this.wardId;
    data['consignee_name'] = this.consigneeName;
    data['consignee_phone'] = this.consigneePhone;
    data['consignee_address'] = this.consigneeAddress;
    data['transport_code'] = this.transportCode;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['mass'] = this.mass;
    data['size1'] = this.size1;
    data['size2'] = this.size2;
    data['size3'] = this.size3;
    data['note'] = this.note;
    data['delivery_note'] = this.deliveryNote;
    data['method'] = this.method;
    data['warehouse_id'] = this.warehouseId;
    data['type'] = this.type;
    data['status'] = this.status;
    data['goods_money'] = this.goodsMoney;
    data['shipping_money'] = this.shippingMoney;
    data['total_money'] = this.totalMoney;
    data['surcharge'] = this.surcharge;
    data['admin_id'] = this.adminId;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['code'] = this.code;
    data['payment'] = this.payment;
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.province != null) {
      data['province'] = this.province.toJson();
    }
    if (this.district != null) {
      data['district'] = this.district.toJson();
    }
    if (this.ward != null) {
      data['ward'] = this.ward.toJson();
    }
    if (this.warehouse != null) {
      data['warehouse'] = this.warehouse.toJson();
    }
    return data;
  }
}

class Categories {
  int id;
  int orderId;
  int categoryId;
  int amount;
  String name;
  String createdAt;
  String updatedAt;
  Category category;

  Categories(
      {this.id,
        this.orderId,
        this.categoryId,
        this.amount,
        this.name,
        this.createdAt,
        this.updatedAt,
        this.category});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    categoryId = json['category_id'];
    amount = json['amount'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['category_id'] = this.categoryId;
    data['amount'] = this.amount;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    return data;
  }
}

class Category {
  int id;
  String name;
  String slug;
  String description;
  int surcharge;
  int status;
  int type;
  String createdAt;
  String updatedAt;

  Category(
      {this.id,
        this.name,
        this.slug,
        this.description,
        this.surcharge,
        this.status,
        this.type,
        this.createdAt,
        this.updatedAt});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    description = json['description'];
    surcharge = json['surcharge'];
    status = json['status'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['description'] = this.description;
    data['surcharge'] = this.surcharge;
    data['status'] = this.status;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class User {
  int id;
  String name;
  String code;
  String email;
  String phone;
  String address;
  Null birthday;
  int status;
  int position;
  int gender;
  Null information;
  Null rememberToken;
  String createdAt;
  String updatedAt;
  Null deletedAt;
  String avatar;

  User(
      {this.id,
        this.name,
        this.code,
        this.email,
        this.phone,
        this.address,
        this.birthday,
        this.status,
        this.position,
        this.gender,
        this.information,
        this.rememberToken,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.avatar});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    birthday = json['birthday'];
    status = json['status'];
    position = json['position'];
    gender = json['gender'];
    information = json['information'];
    rememberToken = json['remember_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['birthday'] = this.birthday;
    data['status'] = this.status;
    data['position'] = this.position;
    data['gender'] = this.gender;
    data['information'] = this.information;
    data['remember_token'] = this.rememberToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['avatar'] = this.avatar;
    return data;
  }
}

class Province {
  int id;
  String name;
  String gsoId;
  String createdAt;
  String updatedAt;

  Province({this.id, this.name, this.gsoId, this.createdAt, this.updatedAt});

  Province.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    gsoId = json['gso_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['gso_id'] = this.gsoId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class District {
  int id;
  String name;
  String gsoId;
  int provinceId;
  String createdAt;
  String updatedAt;

  District(
      {this.id,
        this.name,
        this.gsoId,
        this.provinceId,
        this.createdAt,
        this.updatedAt});

  District.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    gsoId = json['gso_id'];
    provinceId = json['province_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['gso_id'] = this.gsoId;
    data['province_id'] = this.provinceId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Ward {
  int id;
  String name;
  String gsoId;
  int districtId;
  String createdAt;
  String updatedAt;

  Ward(
      {this.id,
        this.name,
        this.gsoId,
        this.districtId,
        this.createdAt,
        this.updatedAt});

  Ward.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    gsoId = json['gso_id'];
    districtId = json['district_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['gso_id'] = this.gsoId;
    data['district_id'] = this.districtId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Warehouse {
  int id;
  String name;
  String address;
  String info;
  String lat;
  String long;
  int status;
  String createdAt;
  String updatedAt;

  Warehouse(
      {this.id,
        this.name,
        this.address,
        this.info,
        this.lat,
        this.long,
        this.status,
        this.createdAt,
        this.updatedAt});

  Warehouse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    info = json['info'];
    lat = json['lat'];
    long = json['long'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['info'] = this.info;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

