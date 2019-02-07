import 'package:flutter/material.dart';
import '../globals.dart' as globals;

class User {
  int id;
  String username;
  String password;
  String name;
  String schoolCode;
  String schoolUrl;
  String schoolName;
  String parentName;
  String parentId;
  Color color;

  User(this.id, this.username, this.password, this.name,
      this.schoolCode, this.schoolUrl, this.schoolName, this.parentName,
      this.parentId);

  User.fromJson(Map json) {
    id = json["id"];
    username = json["username"];
    password = json["password"];
    name = json["name"];
    schoolCode = json["schoolCode"];
    schoolUrl = json["schoolUrl"];
    schoolName = json["schoolName"];
    parentName = json["parentName"];
    parentId = json["parentId"];
  }

  bool isSelected() => id == globals.selectedUser.id;

  Map<String, dynamic> toMap() {
    var userMap = {
      "id": id,
      "username": username,
      "password": password,
      "name": name,
      "schoolCode": schoolCode,
      "schoolUrl": schoolUrl,
      "schoolName": schoolName,
      "parentName": parentName,
      "parentId": parentId,
    };
    return userMap;
  }
}