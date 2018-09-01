import 'dart:async';
import 'dart:convert' show utf8, json;
import '../Datas/Absence.dart';
import '../Datas/User.dart';
import '../Utils/AccountManager.dart';
import '../Utils/Saver.dart';
import 'RequestHelper.dart';

class AbsentHelper {

  Future<Map<String, List<Absence>>> getAbsents() async {
    Map<String, List<Absence>> absents = new Map<String, List<Absence>>();
    List<Map<String, dynamic>> evaluationsMap = new List<Map<String, dynamic>>();
    Set<String> uniqueAbsence = new Set<String>();

    evaluationsMap = await getEvaluationlistForAbsents();
      absents.clear();
      List<Absence> absences = new List();
      for (int n = 0; n < evaluationsMap.length; n++) {
        absences.add(new Absence.fromJson(evaluationsMap[n]));
        absences[n].owner=evaluationsMap[n]["user"];
      }
      absences.sort( (Absence a, Absence b) {
        return b.startTime.compareTo(a.startTime);
      });

      for (Absence a in absences) {
        uniqueAbsence.add(a.startTime.substring(0, 10)+a.owner.id.toString());
      }
      for (String s in uniqueAbsence){
        List<Absence> theseAbsences = new List();
        for (Absence a in absences)
          if (a.startTime.substring(0,10)+a.owner.id.toString()==s)
            theseAbsences.add(a);
        absents.putIfAbsent(s, () => theseAbsences);
      }
    return absents;
  }

  Future<Map<String, List<Absence>>> getAbsentsOffline() async {
    Map<String, List<Absence>> absents = new Map<String, List<Absence>>();
    Map<String, dynamic> evaluationsMap = new Map<String, dynamic>();
    Set<String> uniqueAbsence = new Set<String>();
    List<User> users = await AccountManager().getUsers();
    List<Absence> absences = new List<Absence>();

    for (User user in users) {
      evaluationsMap = await readEvaluations(user);
      absents.clear();
      if (evaluationsMap.isNotEmpty)
        for (int n = 0; n < evaluationsMap["Absences"].length; n++) {
          Absence absence = (new Absence.fromJson(evaluationsMap["Absences"][n]));
          absence.owner=user;
          absences.add(absence);
        }
    }
      absences.sort( (Absence a, Absence b) {
        return b.startTime.compareTo(a.startTime);
      });
      for (Absence a in absences)
        uniqueAbsence.add(a.startTime.substring(0,10)+a.owner.id.toString());
      for (String s in uniqueAbsence){
        List<Absence> theseAbsences = new List();
        for (Absence a in absences)
          if (a.startTime.substring(0,10)+a.owner.id.toString()==s)
            theseAbsences.add(a);
        absents.putIfAbsent(s, () => theseAbsences);
      }
    return absents;
  }

  Future <List<Map<String, dynamic>>> getEvaluationlistForAbsents() async{
    List<User> users = await AccountManager().getUsers();

    List<Map<String, dynamic>> listAbsencesAll = new List<Map<String, dynamic>>();

    for (User user in users) {
      String instCode = user.schoolCode; //suli kódja
      String userName = user.username;
      String password = user.password;

      String jsonBody = "institute_code=" +
          instCode +
          "&userName=" +
          userName +
          "&password=" +
          password +
          "&grant_type=password&client_id=919e0c1c-76a2-4646-a2fb-7085bbbf3c56";

      Map<String, dynamic> bearerMap =
      json.decode((await RequestHelper().getBearer(jsonBody, instCode)).body);

      String code = bearerMap.values.toList()[0];

      String evaluationsString = (await RequestHelper().getEvaluations(
          code, instCode)).body;
      saveEvaluations(evaluationsString, user);
      Map<String, dynamic> evaluationsMap = json.decode(evaluationsString);

      Map<String, User> userProperty = <String, User>{"user": user};

      List<Map<String, dynamic>> listAbsences = new List();
      for (dynamic d in evaluationsMap["Absences"])
        listAbsences.add(d as Map<String, dynamic>);

      listAbsences.forEach((Map<String, dynamic> e) => e.addAll(userProperty));

      listAbsencesAll.addAll(listAbsences);
    }
    return listAbsencesAll;
  }
}