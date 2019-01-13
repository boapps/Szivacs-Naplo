import 'dart:async';
import 'dart:core';
import 'dart:convert' show utf8, json;
import 'dart:io';
import '../globals.dart' as globals;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

import '../Datas/User.dart';

class AccountManager {
  Future<String> get _localFolder async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _userFile async {
    final path = await _localFolder;
    return new File('$path/users.json');
  }

  Future<File> saveUsers(List<User> users) async {
    final file = await _userFile;
    List<Map<String, dynamic>> userMap = new List();
    for (User user in users)
      userMap.add(user.toMap());
    // Write the file
    return file.writeAsString(json.encode(userMap));
  }

  Future<List<Map<String, dynamic>>> readUsers() async {
    List<Map<String, dynamic>> userMap = new List();
      final file = await _userFile;
      // Read the file
      String contents;
    List<dynamic> userlist = new List<dynamic>();
    try {
        contents = await file.readAsString();
        userlist = json.decode(contents);
      } catch (error) {
        contents = "";
      }

//    List<dynamic> userlist = json.decode(contents);
      for (dynamic d in userlist)
        userMap.add(d as Map<String, dynamic>);

      return userMap;
  }

  Future<List<User>> getUsers() async {
    List<Map<String, dynamic>> usersJson = await readUsers();
    List<User> users = new List();
    if (usersJson.isNotEmpty)
      for (Map<String, dynamic> m in usersJson)
        users.add(User.fromJson(m));
    List<Color> colors = [Colors.blue, Colors.green, Colors.red, Colors.black, Colors.brown, Colors.orange];
    Iterator<Color> cit = colors.iterator;
    for (User u in users) {
      cit.moveNext();
      u.color = cit.current;
    }

    return users;
  }


  void addUser(User user) async{
    List<User> users = await getUsers();
    for (User u in users)
      if (u.id == user.id)
        return;
    users.add(user);
    globals.users = users;
    saveUsers(users);
  }

  void removeUser(User user) async{

    List<User> users = await getUsers();
    List<User> newUsers = new List();
    for (User u in users)
      if (u.id!=user.id)
        newUsers.add(u);
    if (newUsers.length < 2)
      globals.multiAccount = false;
    globals.users = newUsers;
    saveUsers(newUsers);
  }

  void removeUserIndex(int index) async{
    List<User> users = await getUsers();
    users.removeAt(index);
    saveUsers(users);
  }
}