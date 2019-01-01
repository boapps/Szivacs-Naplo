import 'dart:async';
import 'dart:convert' show utf8, json;
import '../Datas/Average.dart';
import '../Datas/User.dart';
import '../Utils/AccountManager.dart';
import '../Utils/Saver.dart';
import 'RequestHelper.dart';


class AverageHelper {

  Future<List<Average>> getAverages() async {
    List<Map<String, dynamic>> evaluationsMap = new List<Map<String, dynamic>>();
    List<Average> avers = new List<Average>();

    evaluationsMap = await getEvaluationlist();
    avers.clear();
      evaluationsMap.forEach((Map<String,dynamic> e) {
        Average average = Average.fromJson(e);
        average.owner=e["user"];
        avers.add(average);

      });
    avers.sort((Average a, Average b) => a.owner.name.compareTo(b.owner.name));

    return avers;
  }

  Future<List<Average>> getAveragesOffline() async {
    List<Map<String, dynamic>> evaluationsMap = new List<Map<String, dynamic>>();
    List<Average> avers = new List<Average>();
    List<User> users = await AccountManager().getUsers();
    for (User user in users) {
      Map<String, User> userProperty = <String, User>{"user": user};
      Map<String, dynamic> evaluationsMapUser = await readEvaluations(user);
      List<Map<String, dynamic>> evs = new List<Map<String, dynamic>>();
      for (dynamic d in evaluationsMapUser["SubjectAverages"])
        evs.add(d as Map<String, dynamic>);
      evs.forEach((Map<String, dynamic> e) => e.addAll(userProperty));
      evaluationsMap.addAll(evs);
    }
    avers.clear();
    if (evaluationsMap!=null)
      for (int n = 0; n < evaluationsMap.length; n++) {
        Average average = new Average.fromJson(evaluationsMap[n]);
        average.owner = evaluationsMap[n]["user"];
        avers.add(average);
      }
    avers.sort((Average a, Average b) => a.owner.name.compareTo(b.owner.name));

    return avers;
  }
  Future <List<Map<String, dynamic>>> getEvaluationlist() async{
    List<Map<String, dynamic>> evaluationsMap = new List<Map<String, dynamic>>();
    List<User> users = await AccountManager().getUsers();

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

      String evaluationsString =
          (await RequestHelper().getEvaluations(code, instCode));
      saveEvaluations(evaluationsString, user);

      Map<String, dynamic> evaluationsMapUser = json.decode(evaluationsString);

      Map<String, User> userProperty = <String, User>{"user": user};

      List<Map<String, dynamic>> evs = new List<Map<String, dynamic>>();
      for (dynamic d in evaluationsMapUser["SubjectAverages"])
        evs.add(d as Map<String, dynamic>);

      evs.forEach((Map<String, dynamic> e) => e.addAll(userProperty));

      evaluationsMap.addAll(evs);
    }

    return evaluationsMap;
  }

}