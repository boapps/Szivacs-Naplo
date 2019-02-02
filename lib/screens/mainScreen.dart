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
import '../Datas/User.dart';
import '../GlobalDrawer.dart';
import '../globals.dart' as globals;
import '../Helpers/AbsentHelper.dart';
import '../Helpers/EvaluationHelper.dart';
import '../Helpers/NotesHelper.dart';
import '../Helpers/SettingsHelper.dart';
import '../Datas/Lesson.dart';
import '../Helpers/TimetableHelper.dart';
import '../Helpers/RequestHelper.dart';

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
  List<Evaluation> evals = new List();
  Map<String, List<Absence>> absents = new Map();
  List<Note> notes = new List();
  List <Lesson> lessons = new List();

  DateTime startDate = DateTime.now();

  bool hasOfflineLoaded = false;
  bool hasLoaded = false;

  int SHOW_ITEMS = 50;

  void _initSettings() async {
    DynamicTheme.of(context).setBrightness(await SettingsHelper().getDarkTheme() ? Brightness.dark : Brightness.light);
  }

  @override
  void initState() {
    _initSettings();
    super.initState();
    _onRefreshOffline();
    _onRefresh();
  }

  List<Widget> feedItems(){
    List<Widget> widgets = new List();
    for (String s in absents.keys.toList())
      widgets.add(new AbsenceCard(absents[s], globals.isSingle, context));
    for (Evaluation e in evals)
      widgets.add(new EvaluationCard(e, globals.isColor, globals.isSingle, context));
    for (Note n in notes)
      widgets.add(new NoteCard(n, globals.isSingle, context));
    bool rem = false;

    for (Lesson l in lessons.where((Lesson lesson) =>
    (lesson.state == "Missed" || lesson.depTeacher != "")
        && lesson.date.isAfter(DateTime.now())))
      widgets.add(ChangedLessonCard(l, context));

    lessons.removeWhere((Lesson l) => l.state == "Missed");
    for (Lesson l in lessons)
      if (l.start.isAfter(DateTime.now()) && l.start.day == DateTime.now().day)
        rem = true;

    if (lessons.length > 0 && rem)
      widgets.add(new LessonCard(lessons, context));

    widgets.sort((Widget a, Widget b){
      return b.key.toString().compareTo(a.key.toString());
    });

    if(SHOW_ITEMS > widgets.length)
      SHOW_ITEMS = widgets.length;

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
    ) ?? false;
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
            child:
            hasOfflineLoaded && globals.isColor != null ? new Container(
              width: double.infinity,
              height: double.infinity,
              child: new RefreshIndicator(
                  child: new ListView(
                    children: feedItems(),
                  ),
                  onRefresh: _onRefresh),
            ) :
            new Center(child: new CircularProgressIndicator())
        )
        )
    );
  }

  Future<Null> _onRefresh() async {
    //todo a lot of optimization

    setState(() {
      hasLoaded = false;
    });


    notes = await NotesHelper().getNotes();
    globals.notes = notes;
    if (globals.isSingle)
      notes.removeWhere((Note note) => note.owner.id != globals.selectedUser.id);

    startDate = DateTime.now();
    startDate = startDate.add(new Duration(days: (-1 * startDate.weekday + 1)));
    lessons = await getLessons(startDate, startDate.add(Duration(days: 7)));
    globals.lessons = lessons;

    Completer<Null> completer = new Completer<Null>();
    refreshStudent().then((bool b){
      hasLoaded = true;
      hasOfflineLoaded = true;

      if (mounted) {
        setState(() {
          completer.complete();
        });
      }

    });

    return completer.future;
  }

  Future<bool> refreshStudent() async {
    evals = new List();
    absents = new Map();
    globals.global_evals = new List();
    globals.global_absents = new Map();

    for (User user in globals.users){
      String student_string = await RequestHelper().getStudentString(user);

      await EvaluationHelper().getEvaluationsFrom(student_string, user).then((List<Evaluation> evs){
        evals.addAll(evs);
        globals.global_evals.addAll(evs);
      });

      await AbsentHelper().getAbsentsFrom(student_string, user).then((Map<String, List<Absence>> abs){
        absents.addAll(abs);
        globals.global_absents.addAll(abs);
      });
    }

    evals.removeWhere((Evaluation evaluation) => evaluation.type != "MidYear" );
    if (globals.isSingle)
      absents.removeWhere((String s, List<Absence> absence) => absence[0].owner.id != globals.selectedUser.id);
    if (globals.isSingle)
      evals.removeWhere((Evaluation evaluation) => evaluation.owner.id != globals.selectedUser.id || evaluation.type != "MidYear" );

    return true;
  }

  Future<Null> _onRefreshOffline() async {
    setState(() {
      hasOfflineLoaded = false;
    });

    if(globals.global_absents.length > 0)
      absents = globals.global_absents;
    else {
      absents = await AbsentHelper().getAbsentsOffline();
      globals.global_absents = absents;
    }
    if (globals.isSingle)
      absents.removeWhere((String s, List<Absence> absence) => absence[0].owner.id != globals.selectedUser.id);

    if(globals.notes.length > 0)
      notes = globals.notes;
    else {
      notes = await NotesHelper().getNotesOffline();
      globals.notes = notes;
    }
    if (globals.isSingle)
      notes.removeWhere((Note note) => note.owner.id != globals.selectedUser.id);
/*
    if (globals.avers.length > 0)
      avers = globals.avers;
    else {
      avers = await AverageHelper().getAveragesOffline();
      globals.avers = avers;
    }
*/
    if (globals.global_evals.length > 0)
      evals = globals.global_evals;
    else {
      evals = await EvaluationHelper().getEvaluationsOffline();
      globals.global_evals = evals;
    }
    evals.sort((a, b) => b.creationDate.compareTo(a.creationDate));

    if (globals.isSingle)
      evals.removeWhere((Evaluation evaluation) => evaluation.owner.id != globals.selectedUser.id || evaluation.type != "MidYear" );
    evals.removeWhere((Evaluation evaluation) => evaluation.type != "MidYear" );

    startDate = DateTime.now();
    startDate = startDate.add(new Duration(days: (-1 * startDate.weekday + 1)));

    if (globals.lessons.length > 0)
      lessons = globals.lessons;
    else {
      lessons =
      await getLessonsOffline(startDate, startDate.add(Duration(days: 7)));
      globals.lessons = lessons;
    }

    Completer<Null> completer = new Completer<Null>();

    hasOfflineLoaded = true;

    if (mounted)
      setState(() => completer.complete());
    return completer.future;
  }

  @override
  void dispose() {
    super.dispose();
  }
}