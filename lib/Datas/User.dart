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
  Map<String, String> lastRefreshMap = Map();
  static const RATE_LIMIT_MINUTES = 5;

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
    try {
      color = Color(json["color"]);
    } catch (e) {
      color = Color(0);
    }
    try {
      lastRefreshMap = json["lastRefreshMap"] ?? Map();
    } catch (e) {
      print(e);
    }
  }

  bool isSelected() => id == globals.selectedUser.id;

  bool getRecentlyRefreshed(String request) {
    if (lastRefreshMap != null)
      if (lastRefreshMap.containsKey(request))
        return DateTime.now().difference(DateTime.parse(
            lastRefreshMap[request])
        ).inMinutes < RATE_LIMIT_MINUTES;

    return false;
  }

  void setRecentlyRefreshed(String request) {
    lastRefreshMap.update(request, (String s) => DateTime.now().toIso8601String(), ifAbsent: () => DateTime.now().toIso8601String());
  }

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
      "color": color != null ? color.value : 0,
      "lastRefreshMap": lastRefreshMap,
    };

    return userMap;
  }
}