import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

import '../Cards/AbsenceCard.dart';
import '../Cards/EvaluationCard.dart';
import '../Cards/NoteCard.dart';
import '../Cards/LessonCard.dart';
import '../Datas/Absence.dart';
import '../Datas/Evaluation.dart';
import '../Datas/Note.dart';
import '../GlobalDrawer.dart';
import '../globals.dart' as globals;
import '../Helpers/AbsentHelper.dart';
import '../Helpers/EvaluationHelper.dart';
import '../Helpers/NotesHelper.dart';
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
    print("hello world!");
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

    absents = await AbsentHelper().getAbsents();
    if (globals.isSingle)
      absents.removeWhere((String s, List<Absence> absence) => absence[0].owner.id != globals.selectedUser.id);

    notes = await NotesHelper().getNotes();
    if (globals.isSingle)
      notes.removeWhere((Note note) => note.owner.id != globals.selectedUser.id);

    evals = await EvaluationHelper().getEvaluations();
    globals.evals = evals;
    if (globals.isSingle)
      evals.removeWhere((Evaluation evaluation) => evaluation.owner.id != globals.selectedUser.id || evaluation.type != "MidYear" );
    evals.removeWhere((Evaluation evaluation) => evaluation.type != "MidYear" );

    startDate = DateTime.now();
    startDate = startDate.add(new Duration(days: (-1 * startDate.weekday + 1)));
    lessons = await getLessons(startDate, startDate.add(Duration(days: 7)));

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
    setState(() {
      hasOfflineLoaded = false;
    });

    absents = await AbsentHelper().getAbsentsOffline();
    if (globals.isSingle)
      absents.removeWhere((String s, List<Absence> absence) => absence[0].owner.id != globals.selectedUser.id);

    notes = await NotesHelper().getNotesOffline();
    if (globals.isSingle)
      notes.removeWhere((Note note) => note.owner.id != globals.selectedUser.id);

    evals = await EvaluationHelper().getEvaluationsOffline();
    globals.evals = evals;
    if (globals.isSingle)
      evals.removeWhere((Evaluation evaluation) => evaluation.owner.id != globals.selectedUser.id || evaluation.type != "MidYear" );
    evals.removeWhere((Evaluation evaluation) => evaluation.type != "MidYear" );
    startDate = DateTime.now();
    startDate = startDate.add(new Duration(days: (-1 * startDate.weekday + 1)));

    lessons = await getLessonsOffline(startDate, startDate.add(Duration(days: 7)));

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