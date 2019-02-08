import 'dart:async';
import 'dart:convert' show utf8, json;
import '../Datas/Absence.dart';
import '../Datas/User.dart';
import '../Utils/AccountManager.dart';
import '../Utils/Saver.dart';
import 'RequestHelper.dart';

class AbsentHelper {

  Future<Map<String, List<Absence>>> getAbsentsFrom(String evaluationsString, User user) async {
    Map<String, List<Absence>> absents = new Map<String, List<Absence>>();
    List<Map<String, dynamic>> evaluationsMap = new List<Map<String, dynamic>>();
    Set<String> uniqueAbsence = new Set<String>();

    evaluationsMap = await getEvaluationlistForAbsentsFrom(evaluationsString, user);
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

  Future <List<Map<String, dynamic>>> getEvaluationlistForAbsentsFrom(String evaluationsString, User user) async{
    List<Map<String, dynamic>> listAbsencesAll = new List<Map<String, dynamic>>();

      Map<String, dynamic> evaluationsMap = json.decode(evaluationsString);

      Map<String, User> userProperty = <String, User>{"user": user};

      List<Map<String, dynamic>> listAbsences = new List();
      for (dynamic d in evaluationsMap["Absences"])
        listAbsences.add(d as Map<String, dynamic>);

      listAbsences.forEach((Map<String, dynamic> e) => e.addAll(userProperty));

      listAbsencesAll.addAll(listAbsences);

    return listAbsencesAll;
  }

}