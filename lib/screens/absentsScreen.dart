import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../Datas/Absence.dart';
import '../GlobalDrawer.dart';
import '../Helpers/AbsentHelper.dart';
import '../Helpers/LocaleHelper.dart';
import '../Utils/AccountManager.dart';
import '../Datas/User.dart';
import '../globals.dart' as globals;

void main() {
  runApp(
      new MaterialApp(home: new AbsentsScreen(),
    localizationsDelegates: [
      AppLocalizationsDelegate(),
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate
    ],
    supportedLocales: [Locale("hu"), Locale("en")],
    onGenerateTitle: (BuildContext context) =>
    AppLocalizations.of(context).title,
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

  bool hasLoaded = false;
  bool hasOfflineLoaded = false;

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
      _onRefresh();
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
              title: new Text(AppLocalizations.of(context).absent_title),
              actions: <Widget>[
                new IconButton(
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
                    })
              ],
            ),
            body: new Container(
                child: hasOfflineLoaded
                    ? new Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: new RefreshIndicator(
                            child: new ListView.builder(
                              itemBuilder: _itemBuilder,
                              itemCount: absents.length,
                            ),
                            onRefresh: _onRefresh),
                      )
                    : new Center(child: new CircularProgressIndicator()))));
  }

  Future<Null> _onRefresh() async {
    setState(() {
      hasLoaded = false;
    });

    Completer<Null> completer = new Completer<Null>();

    absents = await AbsentHelper().getAbsents();
    absents.removeWhere((String s, List<Absence> a) =>
        a[0].owner.id != globals.selectedUser.id);

    globals.absents = absents;

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

    absents = await AbsentHelper().getAbsentsOffline();
    absents.removeWhere((String s, List<Absence> a) =>
        a[0].owner.id != globals.selectedUser.id);

    globals.absents = absents;

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
          title: new Text(absence.typeName),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text(AppLocalizations.of(context).mode + absence.modeName),
                new Text(AppLocalizations.of(context).subject + absence.subject),
                new Text(AppLocalizations.of(context).teacher + absence.teacher),
                new Text(AppLocalizations.of(context).absence_time +
                    absence.startTime
                        .substring(0, 11)
                        .replaceAll("-", '. ')
                        .replaceAll("T", ". ")),
                new Text(AppLocalizations.of(context).administration_time +
                    absence.creationTime
                        .substring(0, 16)
                        .replaceAll("-", ". ")
                        .replaceAll("T", ". ")),
                new Text(
                    AppLocalizations.of(context).justification_state + absence.justificationStateName),
                new Text(AppLocalizations.of(context).justification_mode + absence.justificationTypeName),
                absence.delayMinutes != 0
                    ? new Text(
                    AppLocalizations.of(context).delay_mins + absence.delayMinutes.toString())
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
      case "UnJustified":
        return Icons.clear;
        break;
      case "Justified":
        return Icons.check;
        break;
      case "BeJustified":
        return Icons.person;
        break;
      default:
        return Icons.help;
        break;
    }
  }

  Color colorifyState(String state) {
    switch (state) {
      case "UnJustified":
        return Colors.red;
        break;
      case "Justified":
        return Colors.green;
        break;
      case "BeJustified":
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
        leading: new Icon(absence.delayMinutes == 0 ? iconifyState(absence.justificationState) : (Icons.watch_later),
            color: colorifyState(absence.justificationState)),
        title: new Text(absence.subject),
        subtitle: new Text(absence.teacher),
        trailing: new Text(
            absence.startTime.substring(0, 10).replaceAll("-", ". ") + ". "),
        onTap: () {
          absenceDialog(absence);
        },
      ));

    for (Absence absence in thisAbsence) {
      if (absence.justificationState == "UnJustified")
        unjust = true;
      else if (absence.justificationState == "Justified")
        just = true;
      else if (absence.justificationState == "BeJustified") bejust = true;
    }

    String state = "";
    if (unjust && !just && !bejust)
      state = "UnJustified";
    else if (!unjust && just && !bejust)
      state = "Justified";
    else if (!unjust && !just && bejust) state = "BeJustified";

    Widget title = new Container(
      child: new Row(
        children: <Widget>[
          new Icon(
            iconifyState(state),
            color: colorifyState(state),
          ),
          new Container(
            padding: EdgeInsets.all(10),
            child: new Text(thisAbsence[0]
                    .startTime
                    .substring(0, 10)
                    .replaceAll("-", ". ") +
                ". (" +
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
    absents.clear();
    super.dispose();
  }
}

class AbsentDialog extends StatefulWidget {
  const AbsentDialog();

  @override
  AbsentDialogState createState() => new AbsentDialogState();
}

class AbsentDialogState extends State<AbsentDialog> {
  int prnt = 0;
  int ossz = 0;
  int delayMins = 0;

  List<User> users;
  Map<String, List<Absence>> absents = new Map();

  void initSelectedUser() async {
    absents = globals.absents;
    ossz = 0;
    prnt = 0;
    delayMins = 0;

    setState(() {
      absents.forEach((String key, List<Absence> value) {
        if (value[0].justificationType == "Parental" &&
            value[0].owner.id == globals.selectedUser.id) {
          prnt++;
        }
        if (value[0].owner.id == globals.selectedUser.id) {
          print(value[0].mode);
          for (Absence a in value)
            if (a.delayMinutes == 0)
              ossz++;
            else
              delayMins += a.delayMinutes;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initSelectedUser();
  }

  Widget build(BuildContext context) {
    return new SimpleDialog(
        title: new Text(AppLocalizations.of(context).statistics),
        contentPadding: const EdgeInsets.all(5.0),
        children: <Widget>[
          new Text(
            AppLocalizations.of(context).parental_justification(prnt),
            style: TextStyle(fontSize: 16.0),
          ),
          new Text(
            AppLocalizations.of(context).all_absences(ossz),
            style: TextStyle(fontSize: 16.0),
          ),
          new Text(
            AppLocalizations.of(context).all_delay(delayMins),
            style: TextStyle(fontSize: 16.0),
          ),
        ]);
  }
}
