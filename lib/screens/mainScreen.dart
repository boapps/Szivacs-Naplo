import 'dart:async';

import 'package:flutter/material.dart';

import '../Cards/AbsenceCard.dart';
import '../Cards/EvaluationCard.dart';
import '../Cards/NoteCard.dart';
import '../Datas/Absence.dart';
import '../Datas/Evaluation.dart';
import '../Datas/Note.dart';
import '../GlobalDrawer.dart';
import '../globals.dart' as globals;
import '../Helpers/AbsentHelper.dart';
import '../Utils/AccountManager.dart';
import '../Helpers/EvaluationHelper.dart';
import '../Helpers/NotesHelper.dart';
import '../Helpers/PushNotificationHelper.dart';
import '../Helpers/SettingsHelper.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

void main() {
  runApp(new MaterialApp(home: new MainScreen()));
}

class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() => new MainScreenState();
}

class MainScreenState extends State<MainScreen> {

  Map<String, List<Absence>> absents = new Map();
  bool isColor;

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
      widgets.add(new AbsenceCard(absents[s]));
//      SettingsHelper().getColoredMainPage().then(
//            (bool isColor) {
     for (Evaluation e in evals /*.sublist(0, SHOW_ITEMS)*/)
                widgets.add(new EvaluationCard(e, isColor));

//            }
//    );
    for (Note n in notes)
      widgets.add(new NoteCard(n));

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
      drawer: GlobalDrawer(context),
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
                  evals.isNotEmpty&&isColor!=null ? new Container(
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
    absents = await AbsentHelper().getAbsents();
    notes = await NotesHelper().getNotes();
    evals = await EvaluationHelper().getEvaluations();

    Completer<Null> completer = new Completer<Null>();
    if (mounted) {
      setState(() {
        completer.complete();
      });
    }
    return completer.future;
  }

  Future<Null> _onRefreshOffline() async {
    absents = await AbsentHelper().getAbsentsOffline();
    notes = await NotesHelper().getNotesOffline();
    evals = await EvaluationHelper().getEvaluationsOffline();

    Completer<Null> completer = new Completer<Null>();
    if (mounted)
      setState(() {
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