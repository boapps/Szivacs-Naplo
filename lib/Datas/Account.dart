import 'dart:convert' show json;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Helpers/AbsentHelper.dart';
import '../Helpers/AverageHelper.dart';
import '../Helpers/DBHelper.dart';
import '../Helpers/MessageHelper.dart';
import '../Helpers/NotesHelper.dart';
import '../Helpers/RequestHelper.dart';
import '../Utils/Saver.dart';
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
  Map<String, List<Absence>> absents;
  List<Note> notes;
  List<Average> averages;
  List<Message> messages;

  //todo add a Bearer token here

  Account(User user) {
    this.user = user;
  }

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