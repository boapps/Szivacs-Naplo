import 'dart:async';

import 'package:path_provider/path_provider.dart';

import '../Datas/User.dart';
import '../globals.dart';

class DBHelper {
  String dbPath = 'szivacs.db';

  Future<String> get localFolder async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path + "/";
  }

  Future<void> saveUsersJson(List<User> users) async {
    List<Map<String, dynamic>> userMap = new List();
    for (User user in users)
      userMap.add(user.toMap());
    await store.record('users_json').put(db, userMap);
  }

  Future<List<Map<String, dynamic>>> getUserJson() async {
    List<Map<String, dynamic>> userMap = new List();
    try {
      List<dynamic> userList = await store.record('users_json').get(db) as List;
      for (dynamic d in userList)
        userMap.add(d as Map<String, dynamic>);
    } catch (e) {}
    return userMap;
  }

  Future<void> addStudentJson(Map json, User user) async {
    Map studentJson;
    try {
      studentJson = await getStudentJson(user);
    } catch (e) {
      print(e);
    }

    if (studentJson == null)
      await store.record(user.id.toString() + '_student_json').add(db, json);
    else
      await store.record(user.id.toString() + '_student_json').update(db, json);
  }

  Future<Map> getStudentJson(User user) async {
    return await store.record(user.id.toString() + '_student_json').get(
        db) as Map;
  }

  Future<void> addMessagesJson(List json, User user) async {
    List studentJson;
    try {
      studentJson = await getMessagesJson(user);
    } catch (e) {
      print(e);
    }

    if (studentJson == null)
      await store.record(user.id.toString() + '_messages_json').add(db, json);
    else
      await store.record(user.id.toString() + '_messages_json').update(db, json);
  }

  Future<List> getMessagesJson(User user) async {
    return await store.record(user.id.toString() + '_messages_json').get(
        db) as List;
  }

  Future<void> addMessageByIdJson(int id, Map<String, dynamic> json, User user) async {
    Map<String, dynamic> studentJson;
    try {
      studentJson = await getMessageByIdJson(id, user);
    } catch (e) {
      print(e);
    }

    String name = user.id.toString() + "-" + id.toString() + '_message_json';

    if (studentJson == null)
      await store.record(name).add(db, json);
    else
      await store.record(name).update(db, json);
  }

  Future<Map<String, dynamic>> getMessageByIdJson(int id, User user) async {
    String name = user.id.toString() + "-" + id.toString() + '_message_json';

    return await store.record(name).get(db) as Map<String, dynamic>;
  }


  Future<void> saveSettingsMap(Map json) async {
    Map settingsMap;
    try {
      settingsMap = await getSettingsMap();
    } catch (e) {
      print(e);
    }

    if (settingsMap == null)
      await store.record('settings').add(db, json);
    else
      await store.record('settings').update(db, json);
  }

  Future<Map> getSettingsMap() async {
    return await store.record('settings').get(db) as Map;
  }

  Future<void> saveTimetableMap(String time, User user,
      List<dynamic> json) async {
    List<dynamic> timetableMap;
    try {
      timetableMap = await getTimetableMap(time, user);
    } catch (e) {
      print(e);
    }

    if (timetableMap == null)
      await store.record('timetable_' + time + user.id.toString()).add(
          db, json);
    else
      await store.record('timetable_' + time + user.id.toString()).update(
          db, json);
  }

  Future<List<dynamic>> getTimetableMap(String time, User user) async {
    return await store.record('timetable_' + time + user.id.toString()).get(
        db) as List<dynamic>;
  }
}
