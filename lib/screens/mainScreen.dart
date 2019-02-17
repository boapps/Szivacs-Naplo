import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

import '../Cards/AbsenceCard.dart';
import '../Cards/EvaluationCard.dart';
import '../Cards/NoteCard.dart';
import '../Cards/LessonCard.dart';
import '../Cards/ChangedLessonCard.dart';
import '../Datas/Absence.dart';
import '../Datas/Evaluation.dart';
import '../Datas/Note.dart';
import '../Datas/Account.dart';
import '../GlobalDrawer.dart';
import '../globals.dart' as globals;
import '../Helpers/SettingsHelper.dart';
import '../Datas/Lesson.dart';
import '../Helpers/TimetableHelper.dart';

import '../Helpers/LocaleHelper.dart';

void main() {
  runApp(new MaterialApp(
    home: new MainScreen(),
  ));
}

class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() => new MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  List<Evaluation> evaluations = new List();
  Map<String, List<Absence>> absents = new Map();
  List<Note> notes = new List();
  List<Lesson> lessons = new List();

  DateTime startDate = DateTime.now();

  bool hasOfflineLoaded = false;
  bool hasLoaded = false;

  int SHOW_ITEMS = 50;

  void _initSettings() async {
    DynamicTheme.of(context).setBrightness(await SettingsHelper().getDarkTheme()
        ? Brightness.dark
        : Brightness.light);
  }

  @override
  void initState() {
    _initSettings();
    super.initState();
    _onRefreshOffline();
    _onRefresh();
  }

  List<Widget> feedItems() {
    List<Widget> widgets = new List();
    for (String day in absents.keys.toList())
      widgets.add(new AbsenceCard(absents[day], globals.isSingle, context));
    for (Evaluation evaluation in evaluations)
      widgets.add(
          new EvaluationCard(evaluation, globals.isColor, globals.isSingle, context));
    for (Note note in notes)
      widgets.add(new NoteCard(note, globals.isSingle, context));
    bool rem = false;

    for (Lesson l in lessons.where((Lesson lesson) =>
        (lesson.state == "Missed" || lesson.depTeacher != "") &&
        lesson.date.isAfter(DateTime.now())))
      widgets.add(ChangedLessonCard(l, context));
    List realLessons = lessons.where((Lesson l) => l.state != "Missed").toList();
    for (Lesson l in realLessons)
      if (l.start.isAfter(DateTime.now()) && l.start.day == DateTime.now().day)
        rem = true;
    if (realLessons.length > 0 && rem)
      widgets.add(new LessonCard(realLessons, context));
    widgets.sort((Widget a, Widget b) {
      return b.key.toString().compareTo(a.key.toString());
    });

    if (SHOW_ITEMS > widgets.length) SHOW_ITEMS = widgets.length;
    return widgets.sublist(0, SHOW_ITEMS);
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text(AppLocalizations.of(context).sure),
            content: new Text(AppLocalizations.of(context).confirm_close),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(AppLocalizations.of(context).no),
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: new Text(AppLocalizations.of(context).yes),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            drawer: GDrawer(),
            appBar: new AppBar(
              backgroundColor: globals.isDark ? Color.fromARGB(255, 25, 25, 25) : Colors.blue[700],
              title: new Text(AppLocalizations.of(context).title),
              actions: <Widget>[
                //todo search maybe?
              ],
            ),
            body: new Container(
                child: hasOfflineLoaded && globals.isColor != null
                    ? new Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: new RefreshIndicator(
                            child: new ListView(
                              children: feedItems(),
                            ),
                            onRefresh: _onRefresh),
                      )
                    : new Center(child: new CircularProgressIndicator()))));
  }

  Future<Null> _onRefresh() async {
    List<Evaluation> tempEvals = new List();
    Map<String, List<Absence>> tempAbsents = new Map();
    List<Note> tempNotes = new List();
    setState(() {
      hasLoaded = false;
    });

    if (globals.isSingle){
      try {
        await globals.selectedAccount.refreshEvaluations(true, false);
        tempEvals.addAll(globals.selectedAccount.evaluations);
      } catch (exception) {
        print(exception);
      }

      try {
        await globals.selectedAccount.refreshAbsents(false, false);
        tempAbsents.addAll(globals.selectedAccount.absents);
      } catch (exception) {
        print(exception);
      }

      try {
        await globals.selectedAccount.refreshNotes(false, false);
        tempNotes.addAll(globals.selectedAccount.notes);
      } catch (exception) {
        print(exception);
      }
    } else {
      for (Account account in globals.accounts) {
        try {
          await account.refreshEvaluations(true, false);
          tempEvals.addAll(account.evaluations);
        } catch (exception) {
          print(exception);
        }

        try {
          await account.refreshAbsents(false, false);
          tempAbsents.addAll(account.absents);
        } catch (exception) {
          print(exception);
        }

        try {
          await account.refreshNotes(false, false);
          tempNotes.addAll(account.notes);
        } catch (exception) {
          print(exception);
        }
      }
    }
    if (tempEvals.length > 0)
      evaluations = tempEvals;
    if (tempAbsents.length > 0)
      absents = tempAbsents;
    if (tempNotes.length > 0)
      notes = tempNotes;

    startDate = DateTime.now();
    startDate = startDate.add(new Duration(days: (-1 * startDate.weekday + 1)));
    try {
      lessons = await getLessons(startDate, startDate.add(Duration(days: 7)));
    } catch (exception) {
      print(exception);
    }

    if (lessons.length > 0)
      globals.lessons = lessons;

    Completer<Null> completer = new Completer<Null>();
    hasLoaded = true;
    hasOfflineLoaded = true;
    if (mounted) {
      setState(() {
        completer.complete();
      });
    }
    return completer.future;
  }

  Future<Null> _onRefreshOffline() async {
    List<Evaluation> tempEvals = new List();
    Map<String, List<Absence>> tempAbsents = new Map();
    List<Note> tempNotes = new List();
    setState(() {
      hasOfflineLoaded = false;
    });

    //todo singleuser
    for (Account account in globals.accounts) {
      try {
        await account.refreshEvaluations(false, true);
        tempEvals.addAll(account.evaluations);
      } catch (exception) {
        print(exception);
      }

      try {
        await account.refreshAbsents(false, true);
        tempAbsents.addAll(account.absents);
      } catch (exception) {
        print(exception);
      }

      try {
        await account.refreshNotes(false, true);
        tempNotes.addAll(account.notes);
      } catch (exception) {
        print(exception);
      }
    }

    if (tempEvals.length > 0)
      evaluations = tempEvals;
    if (tempAbsents.length > 0)
      absents = tempAbsents;
    if (tempNotes.length > 0)
      notes = tempNotes;

    startDate = DateTime.now();
    startDate = startDate.add(new Duration(days: (-1 * startDate.weekday + 1)));

    if (globals.lessons.length > 0) {
      print("true");
      lessons.addAll(globals.lessons);
    } else {
      print("false");
      try {
        lessons = await getLessonsOffline(startDate, startDate.add(Duration(days: 7)));
      } catch (exception) {
        print(exception);
      }
      if (lessons.length > 0)
        globals.lessons.addAll(lessons);
    }
    print(lessons.length);

    Completer<Null> completer = new Completer<Null>();
    hasOfflineLoaded = true;
    if (mounted) setState(() => completer.complete());
    return completer.future;
  }

  @override
  void dispose() {
    super.dispose();
  }
}