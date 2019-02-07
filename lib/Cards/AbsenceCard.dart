import 'package:flutter/material.dart';
import '../Helpers/LocaleHelper.dart';
import '../Datas/Absence.dart';

class AbsenceCard extends StatelessWidget {
  List<Absence> absence;
  int numOfAbsences = 0;
  String state = "";
  Color color;
  BuildContext context;
  bool isSingle;

  AbsenceCard(List<Absence> absence, bool isSingle, BuildContext context){
    this.context = context;
    this.absence = absence;
    numOfAbsences = absence.length;
    
    this.isSingle = isSingle;

    bool unjust = false;
    bool just = false;
    bool bejust = false;

    for (Absence a in absence){
      if (a.justificationState == "UnJustified")
        unjust = true;
      else if (a.justificationState == "Justified")
        just = true;
      else if (a.justificationState == "BeJustified")
        bejust = true;
    }

    if (unjust&&!just&&!bejust) {
      state = "igazolatlan óra :(";
      color = Colors.red;
    } else if (!unjust&&just&&!bejust) {
      state = "igazolt";
      color = Colors.green;
    } else if (!unjust&&!just&&bejust) {
      state = "igazolandó";
      color = Colors.blue;
    } else {
      state="vegyes";
      color = Colors.black;
    }
    }

  @override
  Key get key => new Key(getDate());

  String getDate(){
    return absence[0].creationTime;
  }

  void openDialog() {
    _absenceDialog(absence[0]);
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
                  new Text(AppLocalizations.of(context).lessons(numOfAbsences)),
                  //new Text("mód: " + absence.modeName),
                  new Text(AppLocalizations.of(context).absence_time +
                      absence.startTime.substring(0, 11)
                      .replaceAll("-", '. ')
                      .replaceAll("T", ". ")),
                  new Text(AppLocalizations.of(context).administration_time +
                      absence.creationTime.substring(0, 11)
                          .replaceAll("-", ". ")
                          .replaceAll("T", ". ")),
                  new Text(AppLocalizations.of(context).justification_state +
                      absence.justificationStateName),
                  new Text(AppLocalizations.of(context).justification_mode +
                      absence.justificationTypeName),
                  absence.delayMinutes != 0
                      ? new Text(AppLocalizations.of(context).delay_mins +
                      absence.delayMinutes.toString())
                      : new Container(),
                ],
              ),
            ),
          ],
          title: Text(absence.modeName, ),
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
                  new Text(AppLocalizations.of(context).absence + ", ", style: new TextStyle(fontSize: 18.0,)),
                  new Text(" $state", style: new TextStyle(fontSize: 18.0, color: color)),
                  new Text(". ", style: new TextStyle(fontSize: 18.0,)),

              ],
            ),
            padding: EdgeInsets.all(10.0),
          ),
          !isSingle ? new Container(
            child: new Text(absence[0].startTime.substring(0, 10)
                .replaceAll("-", ". ") + ". ", style: new TextStyle(
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
                      child: new Text(absence[0].startTime.substring(0, 10).replaceAll("-", ". ") + ". ", style: new TextStyle(fontSize: 18.0,)),
                      alignment: Alignment(1.0, 0.0),
                    )) : new Container(),
                    !isSingle ? new Expanded(
                      child: new Container(
                      child: new Text(absence[0].owner.name, style: new TextStyle(fontSize: 18.0, color: absence[0].owner.color)),
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
