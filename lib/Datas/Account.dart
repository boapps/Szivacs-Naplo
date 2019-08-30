import 'dart:convert' show utf8, json;

import 'User.dart';
import 'Note.dart';
import 'Average.dart';
import 'Student.dart';
import '../globals.dart';
import '../Helpers/DBHelper.dart';
import '../Helpers/RequestHelper.dart';
import '../Helpers/AbsentHelper.dart';
import '../Helpers/AverageHelper.dart';
import '../Helpers/NotesHelper.dart';
import '../Utils/Saver.dart';

class Account {
  Student student;

  User user;
  Map _studentJson;
  String _eventsString;
  Map<String, List<Absence>> absents;
  List<Note> notes;
  List<Average> averages;

  //todo add a Bearer token here

  Account(User user) {
    this.user = user;
  }

  Future<void> refreshStudentString(bool isOffline) async {
    if (isOffline && _studentJson == null) {
      try {
        _studentJson = await DBHelper().getStudentJson(user);
      } catch (e) {
        print(e);
      }
    } else if (!isOffline) {
      _studentJson = json.decode(await RequestHelper().getStudentString(user));
      await DBHelper().addStudentJson(_studentJson, user);
    }

    student = Student.fromMap(_studentJson, user);
    absents = await AbsentHelper().getAbsentsFrom(student.Absences);
    await _refreshEventsString(isOffline);
    notes = await NotesHelper().getNotesFrom(
        _eventsString, json.encode(_studentJson), user);
    averages =
    await AverageHelper().getAveragesFrom(json.encode(_studentJson), user);
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