import 'dart:convert';

import 'package:flutter/services.dart';

class Type {
  String text;
  bool selected;

  Type({this.text, this.selected});

  Type.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    selected = json['selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['selected'] = this.selected;
    return data;
  }

  /// Init data
  Future<List<Type>> getTypes() async {
    List<Type> _list = List();
    String wardJson = await rootBundle.loadString('assets/files/type.json');
    final data = json.decode(wardJson);
    for (var item in data) {
      Type value = Type.fromJson(item);
      _list.add(value);
    }
    return _list;
  }
}
