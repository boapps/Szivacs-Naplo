import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../Datas/Absence.dart';
import '../GlobalDrawer.dart';
import '../Helpers/LocaleHelper.dart';
import '../Datas/User.dart';
import '../globals.dart' as globals;
import '../Dialog/AbsentDialog.dart';

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
              backgroundColor: globals.isDark ? Color.fromARGB(255, 25, 25, 25) : Colors.blue[700],
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

    await globals.selectedAccount.refreshAbsents(false, false);
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

    await globals.selectedAccount.refreshAbsents(false, true);
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
    super.dispose();
  }
}

