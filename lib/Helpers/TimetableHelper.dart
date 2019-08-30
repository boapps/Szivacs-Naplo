import 'dart:async';

import '../Utils/Saver.dart';
import 'dart:convert' show utf8, json;

import '../globals.dart' as globals;
import '../Datas/Lesson.dart';
import '../Helpers/RequestHelper.dart';
import '../Helpers/DBHelper.dart';
import '../main.dart';
import '../Datas/User.dart';

Future <List <Lesson>> getLessonsOffline(DateTime from, DateTime to, User user) async {
  List<dynamic> ttMap;
  try {
    ttMap = await DBHelper().getTimetableMap(
        from.year.toString() + "-" + from.month.toString() + "-" +
            from.day.toString() + "_" + to.year.toString() + "-" +
            to.month.toString() + "-" + to.day.toString(),
        user
    );
  } catch (e) {
    print(e);
  }

  List<Lesson> lessons = new List();

  try {
    for (dynamic d in ttMap)
      lessons.add(Lesson.fromJson(d));
  } catch (e) {
    print(e);
  }

  return lessons;
}


Future<String> getLessonsJson(DateTime from, DateTime to, User user) async {
  String instCode = user.schoolCode;
  userName = user.username;
  password = user.password;

  String jsonBody =
      "institute_code=" + instCode +
          "&userName=" + userName +
          "&password=" + password +
          "&grant_type=password&client_id=919e0c1c-76a2-4646-a2fb-7085bbbf3c56";

  Map<String, dynamic> bearerMap = json.decode(
      (await RequestHelper().getBearer(jsonBody, instCode))
          .body);
  String code = bearerMap.values.toList()[0];

  String timetableString = await RequestHelper().getTimeTable(
      from.toIso8601String().substring(0, 10),
      to.toIso8601String().substring(0, 10),
      code, instCode
  );

  return timetableString;
}


Future <List <Lesson>> getLessons(DateTime from, DateTime to, User user) async {
  String instCode = user.schoolCode;
  userName = user.username;
  password = user.password;

  String jsonBody =
      "institute_code=" + instCode +
      "&userName=" + userName +
      "&password=" + password +
      "&grant_type=password&client_id=919e0c1c-76a2-4646-a2fb-7085bbbf3c56";

  Map<String, dynamic> bearerMap = json.decode(
        (await RequestHelper().getBearer(jsonBody, instCode))
            .body);
  String code = bearerMap.values.toList()[0];

  String timetableString = await RequestHelper().getTimeTable(
      from.toIso8601String().substring(0, 10),
      to.toIso8601String().substring(0, 10),
      code, instCode
  );

  List<dynamic> ttMap = json.decode(timetableString);

  await DBHelper().saveTimetableMap(
      from.year.toString() + "-" + from.month.toString() + "-" +
          from.day.toString() + "_" + to.year.toString() + "-" +
          to.month.toString() + "-" + to.day.toString(), user, ttMap);

  List<Lesson> lessons = new List();
  for (dynamic d in ttMap){
    lessons.add(Lesson.fromJson(d));
  }
  return lessons;
}