import 'dart:async';
import 'dart:convert' show utf8, json;
import '../Datas/Test.dart';
import '../Datas/User.dart';

class TestHelper {
  List<dynamic> testsMap;

  Future<List<Test>> getTestsFrom(String testsString, User user) async {
    List<Test> testsList = List();
    try {
      List<dynamic> dynamicTestsList = json.decode(testsString);

      for (dynamic d in dynamicTestsList) {
        testsList.add(Test.fromJson(d));
      }

      testsList.forEach((Test test) => test.owner = user);
    } catch (e) {
      print(e);
    }

    return testsList;
  }
}
