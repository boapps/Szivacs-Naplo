import 'dart:async';
import 'dart:convert' show utf8, json;
import '../Datas/Evaluation.dart';
import '../Datas/User.dart';


class EvaluationHelper {

  Future<List<Evaluation>> getEvaluationsFrom(String evaluationsString, User user) async {
    List<Map<String, dynamic>> evaluationsMap = new List<Map<String, dynamic>>();
    List<Evaluation> evals = new List<Evaluation>();

    evaluationsMap = await getEvaluationlistFrom(evaluationsString, user);
      evals.clear();
      evaluationsMap.forEach((Map<String,dynamic> e) {evals.add(Evaluation.fromJson(e));});
    evals.sort((Evaluation a, Evaluation b) => b.date.compareTo(a.date));

    return evals;
  }

  Future <List<Map<String, dynamic>>> getEvaluationlistFrom(String evaluationsString, User user) async{
    List<Map<String, dynamic>> evaluationsMap = new List<Map<String, dynamic>>();

      Map<String, dynamic> evaluationsMapUser = json.decode(evaluationsString);

      Map<String, User> userProperty = <String, User>{"user": user};

      List<Map<String, dynamic>> evs = new List<Map<String, dynamic>>();
      for (dynamic d in evaluationsMapUser["Evaluations"])
        evs.add(d as Map<String, dynamic>);

      evs.forEach((Map<String, dynamic> e) => e.addAll(userProperty));

      evaluationsMap.addAll(evs);

    return evaluationsMap;
  }
}