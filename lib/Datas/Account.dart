import 'dart:convert' show json;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Helpers/AbsentHelper.dart';
import '../Helpers/AverageHelper.dart';
import '../Helpers/DBHelper.dart';
import '../Helpers/MessageHelper.dart';
import '../Helpers/NotesHelper.dart';
import '../Helpers/RequestHelper.dart';
import '../Helpers/TestHelper.dart';
import '../Utils/Saver.dart';
import 'Average.dart';
import 'Message.dart';
import 'Note.dart';
import 'Student.dart';
import 'Test.dart';
import 'User.dart';

class Account {
  Student student;
  User user;

  String _eventsString;
  String testString;

  Map _studentJson;
  Map<String, List<Absence>> absents;

  List<Test> tests;
  List testJson;
  List<Note> notes;
  List<Average> averages;
  List<Message> messages;

  //todo add a Bearer token here

  Account(User user) {
    this.user = user;
  }

  String getStudentString() => json.encode(_studentJson);

  Map getStudentJson() => _studentJson;

  Future<void> refreshStudentString(bool isOffline, bool showErrors) async {
    if (!user.getRecentlyRefreshed("refreshStudentString")) {
      if (isOffline && _studentJson == null) {
        try {
          _studentJson = await DBHelper().getStudentJson(user);
        } catch (e) {
          Fluttertoast.showToast(
              msg: "Hiba a felhasználó olvasása közben",
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
        }
        messages = await MessageHelper().getMessagesOffline(user);
      } else if (!isOffline) {
        String studentString = await RequestHelper().getStudentString(
            user, showErrors);
        if (studentString != null) {
          _studentJson = json.decode(studentString);
          await DBHelper().addStudentJson(_studentJson, user);
        }
        messages = await MessageHelper().getMessages(user, showErrors);
      }

      student = Student.fromMap(_studentJson, user);
      absents = await AbsentHelper().getAbsentsFrom(student.Absences);
      await _refreshEventsString(isOffline, showErrors);
      notes = await NotesHelper().getNotesFrom(
          _eventsString, json.encode(_studentJson), user);
      averages =
      await AverageHelper().getAveragesFrom(json.encode(_studentJson), user);

      user.setRecentlyRefreshed("refreshStudentString");
    }
  }

  Future<void> refreshTests(bool isOffline, bool showErrors) async {
    if (!user.getRecentlyRefreshed("refreshTests")) {
      if (isOffline) {
        testJson = await DBHelper().getTestsJson(user);
        tests = await TestHelper().getTestsFrom(testJson, user);
      } else {
        testString = await RequestHelper().getTests(
            await RequestHelper().getBearerToken(user, showErrors),
            user.schoolCode);
        /*testString = """
[
  {
    "Uid": "1234",
    "Id": 1234,
    "Datum": "2019-10-27T00:00:00Z",
    "HetNapja": "Kedd",
    "Oraszam": 4,
    "Tantargy": "kémia",
    "Tanar": "Xxxxxx Xxxxxx",
    "SzamonkeresMegnevezese": "xxxxxxxxx",
    "SzamonkeresModja": "Írásbeli röpdolgozat",
    "BejelentesDatuma": "2019-10-27T00:00:00Z"
  }
]
      """;*/
        testJson = json.decode(testString);
        tests = await TestHelper().getTestsFrom(testJson, user);
        DBHelper().addTestsJson(testJson, user);
      }
      user.setRecentlyRefreshed("refreshTests");
    }
  }

  Future<void> _refreshEventsString(bool isOffline, bool showErrors) async {
    if (!user.getRecentlyRefreshed("_refreshEventsString")) {
      if (isOffline)
        _eventsString = await readEventsString(user);
      else
        _eventsString =
        await RequestHelper().getEventsString(user, showErrors);
      user.setRecentlyRefreshed("_refreshEventsString");
    }
  }

  List<Evaluation> get midyearEvaluations =>
      student.Evaluations.where(
              (Evaluation evaluation) => evaluation.isMidYear()).toList();
}