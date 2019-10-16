import 'dart:async';
import 'dart:convert' show utf8, json;

import 'RequestHelper.dart';


class UserInfoHelper {
//todo refactor this file

  Future<Map<String, String>> getInfo(String instCode, String userName, String password) async {
    Map<String, dynamic> evaluationsMap;

    evaluationsMap = await _getEvaluationlist(instCode, userName, password);

    print(evaluationsMap);
    String StudentId = evaluationsMap["StudentId"].toString();
    if (StudentId == null)
      StudentId = "";
    String StudentName = evaluationsMap["Name"].toString();
    if (StudentName == null)
      StudentName = "";
//    String ParentId;
//    String ParentName;
//    if (evaluationsMap["Tutelary"]==null) {
//      ParentId = "";
//      ParentName = "";
//    } else {
//      ParentId = evaluationsMap["Tutelary"]["TutelaryId"].toString();
//      ParentName = evaluationsMap["Tutelary"]["TutelaryName"].toString();
//    }
//
//    String TeacherId;
//    String TeacherName;
//    if (evaluationsMap["FormTeacher"]==null) {
//      TeacherId = "";
//      TeacherName = "";
//    } else {
//      TeacherId = evaluationsMap["FormTeacher"]["TeacherId"].toString();
//      TeacherName = evaluationsMap["FormTeacher"]["Name"].toString();
//    }
//

    Map<String, String> infoMap = {
      "StudentId": StudentId,
      "StudentName": StudentName,
//      "ParentId": ParentId,
//      "ParentName": ParentName,
//      "TeacherId": TeacherId,
//      "TeacherName": TeacherName,
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

    print(code);
    String evaluationsString =
        (await RequestHelper().getEvaluations(code, instCode));
    print(evaluationsString);
    Map<String, dynamic> evaluationsMap = json.decode(evaluationsString);

    return evaluationsMap;
  }
}