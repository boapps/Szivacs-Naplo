import 'package:flutter/material.dart';
import '../Datas/Absence.dart';
import '../globals.dart' as globals;

class AbsenceCard extends StatelessWidget {
  List<Absence> absence;
  int db = 0;
  String state = "";
  Color color;

  AbsenceCard(List<Absence> absence){
    this.absence = absence;
    db = absence.length;

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

  @override
  Widget build(BuildContext context) {
    return  new Card(
      child: new Column(
        children: <Widget>[

          new Container(
            child: new Row(
              children: <Widget>[
                  new Text("$db db", style: new TextStyle(fontSize: 18.0, color: color),),
                  new Text(" hiányzás, ", style: new TextStyle(fontSize: 18.0,)),
                  new Text(" $state", style: new TextStyle(fontSize: 18.0, color: color)),
                  new Text(". ", style: new TextStyle(fontSize: 18.0,)),

              ],
            ),
            padding: EdgeInsets.all(10.0),
          ),
          globals.multiAccount ? new Container(
            child: new Text(absence[0].startTime.substring(0, 10), style: new TextStyle(fontSize: 16.0, color: Colors.black)),
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
                    !globals.multiAccount ? new Expanded(
                      child: new Container(
                      child: new Text(absence[0].startTime.substring(0, 10), style: new TextStyle(fontSize: 18.0,)),
                      alignment: Alignment(1.0, 0.0),
                    )) : new Container(),
                    globals.multiAccount ? new Expanded(
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
    );
  }
}
