import 'dart:async';
import 'dart:convert' show utf8, json;
import 'package:shared_preferences/shared_preferences.dart';
import '../Datas/Evaluation.dart';
import '../Utils/Saver.dart';
import 'RequestHelper.dart';


class UserInfoHelper {

  Future<Map<String, String>> getInfo(String instCode, String userName, String password) async {
    Map<String, dynamic> evaluationsMap;

    evaluationsMap = await _getEvaluationlist(instCode, userName, password);

    Map<String, String> infoMap = {
      "StudentId": evaluationsMap["StudentId"].toString(),
      "StudentName": evaluationsMap["Name"].toString(),
      "ParentId": evaluationsMap["Tutelary"]["TutelaryId"].toString(),
      "ParentName": evaluationsMap["Tutelary"]["TutelaryName"].toString(),
      "TeacherId": evaluationsMap["FormTeacher"]["TeacherId"].toString(),
      "TeacherName": evaluationsMap["FormTeacher"]["Name"].toString(),
    };

    return infoMap;
  }

  Future <Map<String, dynamic>> _getEvaluationlist(String instCode, String userName, String password) async{

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
        (await RequestHelper().getEvaluations(code, instCode)).body;
    Map<String, dynamic> evaluationsMap = json.decode(evaluationsString);

    return evaluationsMap;
  }
}