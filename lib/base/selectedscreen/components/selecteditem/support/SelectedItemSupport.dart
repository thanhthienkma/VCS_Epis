
import 'package:flutter/material.dart';

class SelectedItemSupport<T>{
  String avatar;
  String name;
  String email;
  String id;
  bool isSelected = false;
  bool isSingleChoose = false;
  T data;

  Color selectedBackgroundColor = Color(0xff367DF1);
  Color backgroundColor = Colors.white;

  Color nameColor = Colors.black;
  Color selectedNameColor = Colors.white;

  Color emailColor = Color(0xffA7B2BF);
  Color selectedEmailColor = Colors.white;

  /// Get name value
  String getNameValue(){
    if(name == null){
      return '';
    }
    return name;
  }

  /// Get email value
  String getEmailValue(){
    if(email == null){
      return '';
    }
    return email;
  }
}