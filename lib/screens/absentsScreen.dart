import 'dart:async';

import 'package:flutter/material.dart';

import '../Datas/Absence.dart';
import '../GlobalDrawer.dart';
import '../Helpers/AbsentHelper.dart';
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

  @override
  void initState() {
    super.initState();
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
      drawer: GlobalDrawer(context),
        appBar: new AppBar(
          title: new Text("Hiányzások"),
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
              absents.isNotEmpty ? new Container(
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
    Completer<Null> completer = new Completer<Null>();
    absents = await AbsentHelper().getAbsents();

    if (mounted)
      setState(() {
      completer.complete();
    });
    return completer.future;
  }

  Future<Null> _getOffline() async {
    Completer<Null> completer = new Completer<Null>();
    absents = await AbsentHelper().getAbsentsOffline();

    if (mounted)
      setState(() {
      completer.complete();
    });
    return completer.future;
  }

  void evalDialog(int index){
    print("tapped " + index.toString());
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
    leading: new Icon(iconifyState(absence.justificationState)),
    title: new Text(absence.subject),
    subtitle: new Text(absence.teacher),
    trailing: new Text(absence.startTime.substring(0,10)),
    onTap: () {evalDialog(index);},
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
        globals.multiAccount ? new Text(" - ") : new Text(" "),
        globals.multiAccount ? new Text(thisAbsence[0].owner.name, style: new TextStyle(color: thisAbsence[0].owner.color),) : new Text(""),
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