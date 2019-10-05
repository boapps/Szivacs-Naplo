import 'dart:async';

import 'package:e_szivacs/generated/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../Datas/Student.dart';
import '../Datas/User.dart';
import '../Dialog/AbsentDialog.dart';
import '../GlobalDrawer.dart';
import '../Utils/StringFormatter.dart';
import '../globals.dart' as globals;

void main() {
  runApp(
      new MaterialApp(home: new AbsentsScreen(),
        localizationsDelegates: const <
            LocalizationsDelegate<WidgetsLocalizations>>[
          S.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
    onGenerateTitle: (BuildContext context) =>
    S
        .of(context)
        .title,
  ));
}

class AbsentsScreen extends StatefulWidget {
  @override
  AbsentsScreenState createState() => new AbsentsScreenState();
}

class AbsentsScreenState extends State<AbsentsScreen> {
  Map<String, List<Absence>> absents = new Map();

  List<User> users;
  User selectedUser;

  bool hasOfflineLoaded = false;
  bool hasLoaded = true;

  void initSelectedUser() async {
    setState(() {
      selectedUser = globals.selectedUser;
    });
  }

  @override
  void initState() {
    super.initState();
    initSelectedUser();
    setState(() {
      _getOffline();
      //_onRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () {
          globals.screen = 0;
          Navigator.pushReplacementNamed(context, "/main");
        },
        child: Scaffold(
            drawer: GDrawer(),
            appBar: new AppBar(
              title: new Text(S
                  .of(context)
                  .absent_title),
              actions: <Widget>[
                Tooltip(child: new IconButton(
                    icon: new Icon(Icons.info),
                    onPressed: () {
                      return showDialog(
                            barrierDismissible: true,
                            context: context,
                            builder: (BuildContext context) {
                              return new AbsentDialog();
                            },
                          ) ??
                          false;
                    }),
                  message: S
                      .of(context)
                      .statistics,
                ),
              ],
            ),
            body: new Container(
                child: hasOfflineLoaded
                    ? new Column(children: <Widget>[
                !hasLoaded
                ? Container(
                child: new LinearProgressIndicator(
                  value: null,
                ),
              height: 3,
            )
              : Container(
          height: 3,
        ),
        new Expanded(
          child: new RefreshIndicator(
                            child: new ListView.builder(
                              itemBuilder: _itemBuilder,
                              itemCount: absents.length,
                            ),
                            onRefresh: _onRefresh),
                      )])
                    : new Center(child: new CircularProgressIndicator()))));
  }

  Future<Null> _onRefresh() async {
    setState(() {
      hasLoaded = false;
    });

    Completer<Null> completer = new Completer<Null>();

    await globals.selectedAccount.refreshStudentString(false);
    absents = globals.selectedAccount.absents;

    if (mounted)
      setState(() {
        hasLoaded = true;
        completer.complete();
      });

    return completer.future;
  }

  Future<Null> _getOffline() async {
    setState(() {
      hasOfflineLoaded = false;
    });

    Completer<Null> completer = new Completer<Null>();

    await globals.selectedAccount.refreshStudentString(true);
    absents = globals.selectedAccount.absents;

    if (mounted)
      setState(() {
        hasOfflineLoaded = true;
        completer.complete();
      });

    return completer.future;
  }

  Future<Null> absenceDialog(Absence absence) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(absence.TypeName),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text(S
                    .of(context)
                    .mode + absence.ModeName),
                new Text(S
                    .of(context)
                    .subject + absence.Subject),
                new Text(S
                    .of(context)
                    .teacher + absence.Teacher),
                new Text(S
                    .of(context)
                    .absence_time +
                    dateToHuman(absence.LessonStartTime)),
                new Text(S
                    .of(context)
                    .administration_time +
                    dateToHuman(absence.CreatingTime)),
                new Text(
                    S
                        .of(context)
                        .justification_state + absence.JustificationStateName),
                new Text(S
                    .of(context)
                    .justification_mode + absence.JustificationTypeName),
                absence.DelayTimeMinutes != 0
                    ? new Text(
                    S
                        .of(context)
                        .delay_mins + absence.DelayTimeMinutes.toString() +
                        " perc")
                    : new Container(),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  IconData iconifyState(String state) {
    switch (state) {
      case Absence.UNJUSTIFIED:
        return Icons.clear;
        break;
      case Absence.JUSTIFIED:
        return Icons.check;
        break;
      case Absence.BE_JUSTIFIED:
        return Icons.person;
        break;
      default:
        return Icons.help;
        break;
    }
  }

  Color colorifyState(String state) {
    switch (state) {
      case Absence.UNJUSTIFIED:
        return Colors.red;
        break;
      case Absence.JUSTIFIED:
        return Colors.green;
        break;
      case Absence.BE_JUSTIFIED:
        return Colors.blue;
        break;
      default:
        return Colors.black;
        break;
    }
  }

  Widget _itemBuilder(BuildContext context, int index) {
    List<Widget> children = new List();
    List<Absence> thisAbsence = absents[absents.keys.toList()[index]];

    bool unjust = false;
    bool just = false;
    bool bejust = false;

    for (Absence absence in thisAbsence)
      children.add(new ListTile(
        leading: new Icon(absence.DelayTimeMinutes == 0 ? iconifyState(
            absence.JustificationState) : (Icons.watch_later),
            color: colorifyState(absence.JustificationState)),
        title: new Text(absence.Subject),
        subtitle: new Text(absence.Teacher),
        trailing: new Text(
            dateToHuman(absence.LessonStartTime)),
        onTap: () {
          absenceDialog(absence);
        },
      ));

    for (Absence absence in thisAbsence) {
      if (absence.isUnjustified()) unjust = true;
      else if (absence.isJustified()) just = true;
      else if (absence.isBeJustified()) bejust = true;
    }

    String state = "";
    if (unjust && !just && !bejust) state = Absence.UNJUSTIFIED;
    else if (!unjust && just && !bejust) state = Absence.JUSTIFIED;
    else if (!unjust && !just && bejust) state = Absence.BE_JUSTIFIED;

    Widget title = new Container(
      child: new Row(
        children: <Widget>[
          new Icon(
            iconifyState(state),
            color: colorifyState(state),
          ),
          new Container(
            padding: EdgeInsets.all(10),
            child: new Text(dateToHuman(thisAbsence[0].LessonStartTime) +
                dateToWeekDay(thisAbsence[0].LessonStartTime) + " " +
                "(" +
                thisAbsence.length.toString() +
                " db)"),
          ),
        ],
      ),
    );

    return new ExpansionTile(
      title: title,
      children: children,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}

