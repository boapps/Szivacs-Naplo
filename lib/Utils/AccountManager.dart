import 'dart:async';
import 'dart:core';
import '../globals.dart' as globals;
import 'package:flutter/material.dart';
import '../Utils/Saver.dart';
import '../Datas/User.dart';

class AccountManager {
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
    try {
      List<User> users = await getUsers();
      for (User u in users)
        if (u.id == user.id)
          return;
      users.add(user);
      globals.users = users;
      saveUsers(users);
    } catch (e) {
      List<User> users = new List();
      users.add(user);
      globals.users = users;
      saveUsers(users);
    }
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