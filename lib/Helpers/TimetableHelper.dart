import 'dart:async';

import 'dart:convert' show utf8, json;

import '../Datas/Lesson.dart';
import '../Helpers/RequestHelper.dart';
import '../Helpers/DBHelper.dart';
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

  String code = await RequestHelper().getBearerToken(user);

  String timetableString = await RequestHelper().getTimeTable(
      from.toIso8601String().substring(0, 10),
      to.toIso8601String().substring(0, 10),
      code, user.schoolCode
  );

  return timetableString;
}


Future <List <Lesson>> getLessons(DateTime from, DateTime to, User user) async {
  String code = await RequestHelper().getBearerToken(user);

  String timetableString = await RequestHelper().getTimeTable(
      from.toIso8601String().substring(0, 10),
      to.toIso8601String().substring(0, 10),
      code, user.schoolCode
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