import 'dart:async';

import 'package:flutter/material.dart';
import '../Utils/Saver.dart';
import 'dart:convert' show utf8, json;

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
import '../Utils/AccountManager.dart';
import '../Helpers/EvaluationHelper.dart';
import '../Helpers/NotesHelper.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import '../Helpers/SettingsHelper.dart';
import '../Datas/Lesson.dart';
import '../Helpers/RequestHelper.dart';
import '../main.dart';

void main() {
  runApp(new MaterialApp(home: new MainScreen()));
}

class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() => new MainScreenState();
}

class MainScreenState extends State<MainScreen> {


  Map<String, List<Absence>> absents = new Map();
  List <Lesson> lessons = new List();
  bool isColor;
  DateTime startDate = DateTime.now();

  bool hasOfflineLoaded = false;
  bool hasLoaded = false;

  void _initSettings() async {
    DynamicTheme.of(context).setBrightness(await SettingsHelper().getDarkTheme() ? Brightness.dark : Brightness.light);
    isColor = await SettingsHelper().getColoredMainPage();
  }

  @override
  void initState() {
//        .then((_) {...use the important variable...});

    _initSettings();
//    isColor = await SettingsHelper().getColoredMainPage();
    super.initState();


    _initAccountsType();
//    PushNotificationHelper().enablePushNotification();
    _onRefreshOffline();
    _onRefresh();
  }

  int SHOW_ITEMS = 100;

  void _initAccountsType() async {
    globals.multiAccount = (await AccountManager().readUsers()).length != 1;
  }

  List<Widget> feedItems(){
    List<Widget> widgets = new List();


    for (String s in absents.keys.toList())
      widgets.add(new AbsenceCard(absents[s], context));
    for (Evaluation e in evals /*.sublist(0, SHOW_ITEMS)*/)
      widgets.add(new EvaluationCard(e, isColor, context));
    for (Note n in notes)
      widgets.add(new NoteCard(n, context));
    bool rem = false;
    for (Lesson l in lessons)
      if (l.start.isAfter(DateTime.now()) && l.start.day == DateTime.now().day)
        rem = true;

    if (lessons.length > 0 && rem)
      widgets.add(new LessonCard(lessons, context));

    widgets.sort((Widget a, Widget b){
      return b.key.toString().compareTo(a.key.toString());
    });

    if(SHOW_ITEMS>widgets.length)
      SHOW_ITEMS=widgets.length;

    return widgets.sublist(0, SHOW_ITEMS);
  }

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      child: new AlertDialog(
        title: new Text('Biztos?'),
        content: new Text('Be akarod zárni az alkalmazást?'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('Nem'),
          ),
          new FlatButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: new Text('Igen'),
          ),
        ],
      ),
    ) ?? false;
  }



  List<Evaluation> evals = new List();
  List<Note> notes = new List();

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            drawer: GDrawer(),
        appBar: new AppBar(
          title: new Text("e-Szivacs 2"),
          actions: <Widget>[

          ],
         /* bottom: new PreferredSize(
              child: new LinearProgressIndicator(
                value: 0.7,
              ),
              preferredSize: null),*/
        ),
        body: new Container(
            child:
            hasOfflineLoaded && isColor != null ? new Container(
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

  Future <List <Lesson>> getLessonsOffline(DateTime from, DateTime to) async {

    List<dynamic> ttMap = await readTimetable(from.year.toString()+"-"+from.month.toString()+"-"+from.day.toString()+"_"+to.year.toString()+"-"+to.month.toString()+"-"+to.day.toString(), globals.selectedUser);
    List<Lesson> lessons = new List();
    try {
      for (dynamic d in ttMap){
        lessons.add(Lesson.fromJson(d));
      }
    } catch (e) {
      print(e);
    }
    return lessons;
  }

  Future <List <Lesson>> getLessons(DateTime from, DateTime to) async {
    String instCode = globals.selectedUser.schoolCode; //suli kódja
    userName = globals.selectedUser.username;
    password = globals.selectedUser.password;
    String jsonBody = "institute_code=" +
        instCode +
        "&userName=" +
        userName +
        "&password=" +
        password +
        "&grant_type=password&client_id=919e0c1c-76a2-4646-a2fb-7085bbbf3c56";
    Map<String, dynamic> bearerMap =
    json.decode((await RequestHelper().getBearer(jsonBody, instCode)).body);
    String code = bearerMap.values.toList()[0];
    String timetableString = (await RequestHelper().getTimeTable(from.toIso8601String().substring(0, 10), to.toIso8601String().substring(0, 10), code, instCode));
    print(timetableString);
    List<dynamic> ttMap =
    json.decode(timetableString);
    saveTimetable(timetableString, from.year.toString()+"-"+from.month.toString()+"-"+from.day.toString()+"_"+to.year.toString()+"-"+to.month.toString()+"-"+to.day.toString(), globals.selectedUser);
    List<Lesson> lessons = new List();
    for (dynamic d in ttMap){
      lessons.add(Lesson.fromJson(d));
      print("add");
    }
    return lessons;
  }

  Future<Null> _onRefresh() async {
    setState(() {
      hasLoaded = false;
    });
    hasLoaded = false;
    absents = await AbsentHelper().getAbsents();
    notes = await NotesHelper().getNotes();
    evals = await EvaluationHelper().getEvaluations();

    startDate = DateTime.now();
    startDate = startDate.add(new Duration(days: (-1 * startDate.weekday + 1)));
    lessons = await getLessons(startDate, startDate.add(Duration(days: 7)));

    print("tt:" + lessons.length.toString());

    Completer<Null> completer = new Completer<Null>();
    if (mounted) {
      setState(() {
        hasLoaded = true;
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
    notes = await NotesHelper().getNotesOffline();
    evals = await EvaluationHelper().getEvaluationsOffline();
    startDate = DateTime.now();
    startDate = startDate.add(new Duration(days: (-1 * startDate.weekday + 1)));
    lessons = await getLessonsOffline(startDate, startDate.add(Duration(days: 7)));

    print("tt:" + lessons.length.toString());

    Completer<Null> completer = new Completer<Null>();
    if (mounted)
      setState(() {
        print('hasOfflineLoaded');
        hasOfflineLoaded = true;
        completer.complete();
      });
    return completer.future;
  }

  void evalDialog(int index){
    print("tapped " + index.toString());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    evals.clear();
    super.dispose();
  }
}