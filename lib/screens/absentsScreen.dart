import 'dart:async';

import 'package:flutter/material.dart';

import '../Datas/Absence.dart';
import '../GlobalDrawer.dart';
import '../Helpers/AbsentHelper.dart';
import '../Utils/AccountManager.dart';
import '../Datas/User.dart';
import '../globals.dart' as globals;
void main() {
  runApp(new MaterialApp(home: new AbsentsScreen()));
}

class AbsentsScreen extends StatefulWidget {
  @override
  AbsentsScreenState createState() => new AbsentsScreenState();
}


class AbsentsScreenState extends State<AbsentsScreen> {
  Map<String, List<Absence>> absents = new Map();

  User selectedUser;
  List<User> users;

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

  bool hasOfflineLoaded = false;
  bool hasLoaded = false;

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
          title: new Text("Hiányzások / Késések"),
          actions: <Widget>[
            new IconButton(icon: new Icon(Icons.info), onPressed: () {
              return showDialog(
                barrierDismissible: true,
                context: context,
                builder: (BuildContext context) {
                  return new AbsentDialog();
                },
              ) ??
                  false;
            }
            )

          ],
         /* bottom: new PreferredSize(
              child: new LinearProgressIndicator(
                value: 0.7,
              ),
              preferredSize: null),*/
        ),
        body: new Container(
              child:
              hasOfflineLoaded ? new Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: new RefreshIndicator(
                        child: new ListView.builder(
                          itemBuilder: _itemBuilder,
                          itemCount: absents.length,
                    ),

                        onRefresh: _onRefresh),
                  ) :
                  new Center(child: new CircularProgressIndicator())

         )
        )
        );
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

  void absenceDialog(Absence absence) {
    _lessonDialog(absence);
  }

  Future<Null> _lessonDialog(Absence absence) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(absence.typeName),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text("mód: " + absence.modeName),
                new Text("tárgy: " + absence.subject),
                new Text("tanár: " + absence.teacher),
                new Text("hiányzás ideje: " + absence.startTime.substring(0, 11)
                    .replaceAll("-", '. ')
                    .replaceAll("T", ". ")),
                new Text("naplózás ideje: " +
                    absence.creationTime.substring(0, 16)
                        .replaceAll("-", ". ")
                        .replaceAll("T", ". ")),
                new Text(
                    "igazolás állapota: " + absence.justificationStateName),
                new Text("igazolás módja: " + absence.justificationTypeName),
                absence.delayMinutes != 0
                    ? new Text(
                    "késés mértéke: " + absence.delayMinutes.toString())
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

  IconData iconifyState(String state){
    switch (state){
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
  Color colorifyState(String state){
    switch (state){
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
//    return new ExpansionPanel(headerBuilder: null, body: null);

  List<Widget> children = new List();

  List<Absence> thisAbsence = absents[absents.keys.toList()[index]];

  for (Absence absence in thisAbsence)
  children.add(new ListTile(
    leading: new Icon(iconifyState(absence.justificationState),
        color: colorifyState(absence.justificationState)),
    title: new Text(absence.subject),
    subtitle: new Text(absence.teacher),
    trailing: new Text(absence.startTime.substring(0,10)),
    onTap: () {
      absenceDialog(absence);
    },
  ));

  bool unjust = false;
  bool just = false;
  bool bejust = false;

  for (Absence absence in thisAbsence){
    if (absence.justificationState == "UnJustified")
      unjust = true;
    else if (absence.justificationState == "Justified")
      just = true;
    else if (absence.justificationState == "BeJustified")
      bejust = true;
  }

  String state = "";
  if (unjust&&!just&&!bejust)
    state="UnJustified";
  else if (!unjust&&just&&!bejust)
    state="Justified";
  else if (!unjust&&!just&&bejust)
    state="BeJustified";

  Widget title = new Container(
    child: new Row(
      children: <Widget>[
        new Icon(iconifyState(state), color: colorifyState(state),),
        new Text(thisAbsence[0].startTime.substring(0,10)),
      ],
    ),
  );

  return new ExpansionTile(title: title, children: children,);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    absents.clear();
    super.dispose();
  }
  }

class AbsentDialog extends StatefulWidget {
//  List newList;
  const AbsentDialog();

  @override
  AbsentDialogState createState() => new AbsentDialogState();
}

class AbsentDialogState extends State<AbsentDialog> {
  int prnt = 0;

  User selectedUser;
  List<User> users;
  Map<String, List<Absence>> absents = new Map();

  void initSelectedUser() async {
    users = await AccountManager().getUsers().then((List value) {
      absents = globals.absents;

      setState(() {
        prnt = 0;
        selectedUser = users[0];
        AbsentsScreenState().absents.forEach((String key, List<Absence> value) {
          if (value[0].justificationType == "Parental" &&
              value[0].owner == selectedUser)
            prnt++;
        });
      });
    });
  }

  void _onSelect(User user) async {
    selectedUser = user;
    prnt = 0;
    absents = globals.absents;
    absents.forEach((String key, List<Absence> value) {
      if (value[0].justificationType == "Parental" &&
          (value[0].owner.id == selectedUser.id))
        prnt++;
    });

    setState(() {
      prnt;
      print(prnt);
    });
  }


  Widget build(BuildContext context) {
    return new SimpleDialog(
        title: new Text("Statisztikák"),
        contentPadding: const EdgeInsets.all(10.0),
        children: <Widget>[
          new Text("Szülői igazolás: " + prnt.toString(),
            style: TextStyle(fontSize: 20.0),),
        ]
    );
  }
}
