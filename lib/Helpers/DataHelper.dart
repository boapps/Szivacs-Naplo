import 'dart:async';
import 'dart:convert' show utf8, json;
import '../Datas/Evaluation.dart';
import '../Datas/Absence.dart';
import '../Datas/User.dart';
import '../Utils/AccountManager.dart';
import '../Utils/Saver.dart';
import '../globals.dart' as globals;
import 'RequestHelper.dart';
import '../Helpers/AbsentHelper.dart';
import '../Helpers/EvaluationHelper.dart';



void refreshOnline() async {
  List<Evaluation> global_evals = new List();
  Map<String, List<Absence>> global_absents = new Map();

  for (User user in globals.users){
    String student_string = await RequestHelper().getStudentString(user);
    await EvaluationHelper().getEvaluationsFrom(student_string, user).then((List<Evaluation> evs){
      global_evals.addAll(evs);
    });
    await AbsentHelper().getAbsentsFrom(student_string, user).then((Map<String, List<Absence>> abs){
      global_absents.addAll(abs);
    });
  }

  globals.global_evals = global_evals;
  globals.global_absents = global_absents;
}

Future<void> refreshOffline() async {
  List<Evaluation> global_evals = new List();
  Map<String, List<Absence>> global_absents = new Map();

  print(globals.global_evals.length);
  print(globals.global_evals);

    global_evals = await EvaluationHelper().getEvaluationsOffline();
    global_absents = await AbsentHelper().getAbsentsOffline();

  globals.global_evals = global_evals;
  globals.global_absents = global_absents;
}

List<Evaluation> get normalEvals => globals.global_evals.where((Evaluation e) => e.type == "MidYear").toList();
List<Evaluation> get normalEvalsSingle => globals.global_evals.where((Evaluation e) => e.type == "MidYear" && e.owner.id == globals.selectedUser.id).toList();

Map<String, List<Absence>> get absentsSingle {
  Map<String, List<Absence>> global_absents = new Map();
  globals.global_absents.forEach((String s, List<Absence> ab){
    if (ab[0].owner.id==globals.selectedUser.id)
      global_absents.putIfAbsent(s, () => ab);
  });

  return global_absents;
}