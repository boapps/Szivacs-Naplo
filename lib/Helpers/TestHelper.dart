import 'dart:async';
import 'dart:convert' show utf8, json;
import '../Datas/Test.dart';
import '../Datas/User.dart';

class TestHelper {
  List<dynamic> testsMap;

  Future<List<Test>> getTestsFrom(List testsJson, User user) async {
    List<Test> testsList = List();
    try {
      for (dynamic d in testsJson) {
        testsList.add(Test.fromJson(d));
      }

      testsList.forEach((Test test) => test.owner = user);
    } catch (e) {
      print(e);
    }

    return testsList;
  }
}
