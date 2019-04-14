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

  void _initSettings() async {
    DynamicTheme.of(context).setBrightness(await SettingsHelper().getDarkTheme()
        ? Brightness.dark
        : Brightness.light);
  }

  @override
  void initState() {
    _initSettings();
    super.initState();
    _onRefresh(offline: true);
    _onRefresh(offline: false);
    //_onRefreshOffline();
  }

  List<Widget> feedItems() {
    int maximumFeedLength = 250;

    List<Widget> feedCards = new List();

    for (String day in absents.keys.toList())
      feedCards.add(new AbsenceCard(absents[day], globals.isSingle, context));
    for (Evaluation evaluation in evaluations)
      feedCards.add(new EvaluationCard(
          evaluation, globals.isColor, globals.isSingle, context));
    for (Note note in notes)
      feedCards.add(new NoteCard(note, globals.isSingle, context));
    bool rem = false;

    for (Lesson l in lessons.where((Lesson lesson) =>
        (lesson.isMissed || lesson.isSubstitution) &&
        lesson.date.isAfter(DateTime.now())))
      feedCards.add(ChangedLessonCard(l, context));

    List realLessons = lessons.where((Lesson l) => !l.isMissed).toList();

    for (Lesson l in realLessons)
      if (l.start.isAfter(DateTime.now()) && l.start.day == DateTime.now().day)
        rem = true;
    if (realLessons.length > 0 && rem)
      feedCards.add(new LessonCard(realLessons, context));
    feedCards.sort((Widget a, Widget b) {
      return b.key.toString().compareTo(a.key.toString());
    });

    if (maximumFeedLength > feedCards.length)
      maximumFeedLength = feedCards.length;
    return feedCards.sublist(0, maximumFeedLength);
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (BuildContext context) {
            return new AlertDialog(
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
            );
          },
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
                      onRefresh: (){
                        //_onRefresh(offline: true);
                        Completer<Null> completer = new Completer<Null>();
                        _onRefresh().then((bool b){
                          setState(() {
                            completer.complete();
                          });
                        });
                        return completer.future;
                        },
                      )
                )
                        : new Center(child: new CircularProgressIndicator()))));
  }

  Future<Null> _onRefresh({bool offline = false}) async {
    List<Evaluation> tempEvaluations = new List();
    Map<String, List<Absence>> tempAbsents = new Map();
    List<Note> tempNotes = new List();
    setState(() {
      if (offline)
        hasOfflineLoaded = false;
      else
        hasLoaded = false;
    });

    if (globals.isSingle) {
      try {
        await globals.selectedAccount.refreshEvaluations(true, offline);
        tempEvaluations.addAll(globals.selectedAccount.evaluations);
      } catch (exception) {
        print(exception);
      }

      try {
        await globals.selectedAccount.refreshAbsents(false, offline);
        tempAbsents.addAll(globals.selectedAccount.absents);
      } catch (exception) {
        print(exception);
      }

      try {
        await globals.selectedAccount.refreshNotes(false, offline);
        tempNotes.addAll(globals.selectedAccount.notes);
      } catch (exception) {
        print(exception);
      }
    } else {
      for (Account account in globals.accounts) {
        try {
          await account.refreshEvaluations(true, offline);
          tempEvaluations.addAll(account.evaluations);
        } catch (exception) {
          print(exception);
        }

        try {
          await account.refreshAbsents(false, offline);
          tempAbsents.addAll(account.absents);
        } catch (exception) {
          print(exception);
        }

        try {
          await account.refreshNotes(false, offline);
          tempNotes.addAll(account.notes);
        } catch (exception) {
          print(exception);
        }
      }
    }

    if (tempEvaluations.length > 0) evaluations = tempEvaluations;
    if (tempAbsents.length > 0) absents = tempAbsents;
    if (tempNotes.length > 0) notes = tempNotes;

    startDate = DateTime.now();
    startDate = startDate.add(new Duration(days: (-1 * startDate.weekday + 1)));

    if (offline) {
      if (globals.lessons.length > 0) {
        lessons.addAll(globals.lessons);
      } else {
        try {
          lessons = await getLessonsOffline(
              startDate, startDate.add(Duration(days: 6)),
              globals.selectedUser);
        } catch (exception) {
          print(exception);
        }
        if (lessons.length > 0) globals.lessons.addAll(lessons);
      }
    } else {
      try {
        lessons = await getLessons(
            startDate, startDate.add(Duration(days: 6)), globals.selectedUser);
      } catch (exception) {
        print(exception);
      }
    }
    lessons.sort((Lesson a, Lesson b) => a.start.compareTo(b.start));

    if (lessons.length > 0) globals.lessons = lessons;

    Completer<Null> completer = new Completer<Null>();
    if (!offline) hasLoaded = true;

    hasOfflineLoaded = true;
    if (mounted) {
      setState(() {
        completer.complete();
      });
    }
    return completer.future;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
