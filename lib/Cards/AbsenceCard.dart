import 'package:e_szivacs/generated/i18n.dart';
import 'package:flutter/material.dart';

import '../Datas/Student.dart';
import '../Utils/StringFormatter.dart';

class AbsenceCard extends StatelessWidget {
  List<Absence> absences;
  int numOfAbsences = 0;
  String state = "";
  Color color;
  BuildContext context;
  bool isSingle;

  AbsenceCard(List<Absence> absence, bool isSingle, BuildContext context){
    this.context = context;
    this.absences = absence;
    numOfAbsences = absence.length;
    
    this.isSingle = isSingle;

    bool unjust = false;
    bool just = false;
    bool bejust = false;

    for (Absence a in absence){
      if (a.JustificationState == "UnJustified")
        unjust = true;
      else if (a.JustificationState == "Justified")
        just = true;
      else if (a.JustificationState == "BeJustified")
        bejust = true;
    }

    if (unjust&&!just&&!bejust) {
      state = "igazolatlan";
      color = Colors.red;
    } else if (!unjust&&just&&!bejust) {
      state = "igazolt";
      color = Colors.green;
    } else if (!unjust&&!just&&bejust) {
      state = "igazolandó";
      color = Colors.blue;
    } else {
      state="vegyes";
      color = Colors.orange;
    }
    }

  @override
  Key get key => new Key(getDate());

  String getDate(){
    return absences[0].CreatingTime.toIso8601String();
  }

  void openDialog() {
    _absenceDialog(absences[0]);
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

  Future<Null> _absenceDialog(Absence absence) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return new SimpleDialog(
          children: <Widget>[
            new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  new Text(S
                      .of(context)
                      .lessons(numOfAbsences.toString())),
                  //new Text("mód: " + absence.modeName),
                  new Text(S
                      .of(context)
                      .absence_time +
                      dateToHuman(absence.LessonStartTime) +
                      dateToWeekDay(absence.LessonStartTime)),
                  new Text(S
                      .of(context)
                      .administration_time +
                      dateToHuman(absence.CreatingTime) +
                      dateToWeekDay(absence.LessonStartTime)),
                  new Text(S
                      .of(context)
                      .justification_state +
                      absence.JustificationStateName),
                  new Text(S
                      .of(context)
                      .justification_mode +
                      absence.JustificationTypeName),
                  absence.DelayTimeMinutes != 0
                      ? new Text(S
                      .of(context)
                      .delay_mins +
                      absence.DelayTimeMinutes.toString() + " perc")
                      : new Container(),
                ].followedBy(absences.map((Absence absence) {
                  return ListTile(
                    leading: new Icon(absence.DelayTimeMinutes == 0
                        ? iconifyState(absence.JustificationState)
                        : (Icons.watch_later),
                        color: colorifyState(absence.JustificationState)),
                    title: new Text(absence.Subject),
                    subtitle: new Text(dateToHuman(absence.LessonStartTime)),
                  );
                })).toList(),
              ),
            ),
          ],
          title: Text(absence.ModeName,),
          contentPadding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              style: BorderStyle.none,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: openDialog,
        child: new Card(
      child: new Column(
        children: <Widget>[

          new Container(
            child: new Row(
              children: <Widget>[
                  new Text("$numOfAbsences db ", style: new TextStyle(fontSize: 18.0, color: color),),
                new Text(S
                    .of(context)
                    .absence + ", ", style: new TextStyle(fontSize: 18.0,)),
                  new Text(" $state", style: new TextStyle(fontSize: 18.0, color: color)),
                  new Text(". ", style: new TextStyle(fontSize: 18.0,)),
              ],
            ),
            padding: EdgeInsets.all(10.0),
          ),
          !isSingle ? new Container(
            child: new Text(dateToHuman(absences[0].LessonStartTime) +
                dateToWeekDay(absences[0].LessonStartTime),
                style: new TextStyle(
                fontSize: 16.0,)),
            alignment: Alignment(1.0, -1.0),
            padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 2.0),
          ) : new Container(),

          new Divider(height: 1.0,),
          new Container(
              padding: EdgeInsets.all(10.0),
              child: new Padding(
                padding: new EdgeInsets.all(0.0),
                child: new Row(
                  children: <Widget>[
                    !!isSingle ? new Expanded(
                      child: new Container(
                        child: new Text(dateToHuman(
                            absences[0].LessonStartTime) + dateToWeekDay(
                            absences[0].LessonStartTime), style: new TextStyle(
                          fontSize: 18.0,)),
                      alignment: Alignment(1.0, 0.0),
                    )) : new Container(),
                    !isSingle ? new Expanded(
                      child: new Container(
                        child: new Text(
                            absences[0].owner.name, style: new TextStyle(
                            fontSize: 18.0, color: absences[0].owner.color)),
                      alignment: Alignment(1.0, 0.0),
                    )) : new Container(),
                  ],
                ),
              )
          )
        ],
      ),
        ),
    );
  }
}
