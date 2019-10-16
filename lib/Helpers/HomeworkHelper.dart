import 'dart:async';
import 'dart:convert' show json;
import '../Datas/User.dart';
import '../Datas/Homework.dart';
import '../Utils/AccountManager.dart';
import '../Utils/Saver.dart';
import 'RequestHelper.dart';

class HomeworkHelper {
  Future<List<Homework>> getHomeworks(int time) async {
    List<Map<String, dynamic>> evaluationsMap =
        new List<Map<String, dynamic>>();
    List<Homework> homeworks = new List<Homework>();

    evaluationsMap = await getHomeworkList(time);
    homeworks.clear();
    evaluationsMap.forEach((Map<String, dynamic> e) {
      Homework average = Homework.fromJson(e);
      average.owner = e["user"];
      homeworks.add(average);
    });
    homeworks
        .sort((Homework a, Homework b) => a.owner.name.compareTo(b.owner.name));

    return homeworks;
  }

  Future<List<Homework>> getHomeworksOffline(int time) async {
    List<Map<String, dynamic>> evaluationsMap =
        new List<Map<String, dynamic>>();
    List<Homework> homeworks = new List<Homework>();
    List<User> users = await AccountManager().getUsers();
    for (User user in users) {
      Map<String, User> userProperty = <String, User>{"user": user};
      List<Map<String, dynamic>> evaluationsMapUser = await readHomework(user);
      evaluationsMapUser
          .forEach((Map<String, dynamic> e) => e.addAll(userProperty));
      evaluationsMap.addAll(evaluationsMapUser);
    }
    homeworks.clear();
    if (evaluationsMap != null)
      for (int n = 0; n < evaluationsMap.length; n++) {
        Homework homework = new Homework.fromJson(evaluationsMap[n]);
        homework.owner = evaluationsMap[n]["user"];
        homeworks.add(homework);
      }
    homeworks
        .sort((Homework a, Homework b) => a.owner.name.compareTo(b.owner.name));

    return homeworks;
  }

  Future<List<Map<String, dynamic>>> getHomeworkList(int time) async {
    List<Map<String, dynamic>> homeworkMap = new List<Map<String, dynamic>>();
    List<User> users = await AccountManager().getUsers();

    for (User user in users) {
      String code = await RequestHelper().getBearerToken(user);

      DateTime startDate = new DateTime.now();
      DateTime from = startDate.subtract(new Duration(days: time));
      DateTime to = startDate;

      String timetableString = (await RequestHelper().getTimeTable(
              from.toIso8601String().substring(0, 10),
              to.toIso8601String().substring(0, 10),
              code,
              user.schoolCode));
      List<dynamic> ttMap = json.decode(timetableString);
      List<Map<String, dynamic>> hwmapuser = new List();

      for (dynamic d in ttMap) {
        if (d["TeacherHomeworkId"] != null) {
          String homeworkString = (await RequestHelper()
                  .getHomework(code, user.schoolCode, d["TeacherHomeworkId"]));
          if (homeworkString == "[]")
            homeworkString = "[" +
                (await RequestHelper().getHomeworkByTeacher(
                        code, user.schoolCode, d["TeacherHomeworkId"])) + "]";
          String ctargy = d["Subject"];
          List<dynamic> evaluationsMapUser = json.decode(homeworkString);
          for (dynamic d in evaluationsMapUser) {
            Map<String, String> lessonProperty = <String, String>{
              "subject": ctargy
            };

            (d as Map<String, dynamic>).addAll(lessonProperty);
            hwmapuser.add(d as Map<String, dynamic>);
          }
        }
      }

      Map<String, User> userProperty = <String, User>{"user": user};
      saveHomework(json.encode(hwmapuser), user);
      hwmapuser.forEach((Map<String, dynamic> e) => e.addAll(userProperty));
      homeworkMap.addAll(hwmapuser);
      hwmapuser.clear();
    }
    return homeworkMap;
  }
}
