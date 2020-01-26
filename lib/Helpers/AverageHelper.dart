import 'dart:async';
import 'dart:convert' show json;
import '../Datas/Average.dart';
import '../Datas/User.dart';

class AverageHelper {
  Future<List<Average>> getAveragesFrom(String studentString, User user) async {
    List<Average> averageList = new List<Average>();

    Map<String, dynamic> studentMap = json.decode(studentString);

    List<Map<String, dynamic>> jsonAverageList = new List<Map<String, dynamic>>();
    for (dynamic jsonAverage in studentMap["SubjectAverages"])
      jsonAverageList.add(jsonAverage as Map<String, dynamic>);

    jsonAverageList.forEach((Map<String,dynamic> jsonAverage) {averageList.add(Average.fromJson(jsonAverage));});

    return averageList;
  }
}