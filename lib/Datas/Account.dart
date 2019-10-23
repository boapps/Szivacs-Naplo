import 'dart:convert' show json;

import 'package:e_szivacs/globals.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Helpers/TestHelper.dart';
import '../Helpers/AbsentHelper.dart';
import '../Helpers/AverageHelper.dart';
import '../Helpers/DBHelper.dart';
import '../Helpers/MessageHelper.dart';
import '../Helpers/NotesHelper.dart';
import '../Helpers/RequestHelper.dart';
import '../Utils/Saver.dart';
import 'Test.dart';
import 'Average.dart';
import 'Message.dart';
import 'Note.dart';
import 'Student.dart';
import 'User.dart';

class Account {
  Student student;

  User user;
  Map _studentJson;
  String _eventsString;
  String testString;
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

  Future<void> refreshStudentString(bool isOffline, {bool showErrors=true}) async {
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
      _studentJson = json.decode(await RequestHelper().getStudentString(user, showErrors: showErrors));
      await DBHelper().addStudentJson(_studentJson, user);
      messages = await MessageHelper().getMessages(user);
    }

    student = Student.fromMap(_studentJson, user);
    absents = await AbsentHelper().getAbsentsFrom(student.Absences);
    await _refreshEventsString(isOffline);
    notes = await NotesHelper().getNotesFrom(
        _eventsString, json.encode(_studentJson), user);
    averages =
    await AverageHelper().getAveragesFrom(json.encode(_studentJson), user);
  }

  Future<void> refreshTests(bool isOffline) async {
    if (isOffline) {
      testJson = await DBHelper().getTestsJson(user);
      tests = await TestHelper().getTestsFrom(testJson, user);
    } else {
      testString = await RequestHelper().getTests(
          await RequestHelper().getBearerToken(user), user.schoolCode);
      testString = """
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
      """;
      testJson = json.decode(testString);
      tests = await TestHelper().getTestsFrom(testJson, user);
      DBHelper().addTestsJson(testJson, user);
    }
  }


    Future<void> _refreshEventsString(bool isOffline) async {
    if (isOffline)
      _eventsString = await readEventsString(user);
    else
      _eventsString = await RequestHelper().getEventsString(user);
  }

  List<Evaluation> get midyearEvaluations =>
      student.Evaluations.where(
              (Evaluation evaluation) => evaluation.isMidYear()).toList();
}