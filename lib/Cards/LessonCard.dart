import 'package:flutter/material.dart';
import '../Datas/Lesson.dart';
import '../globals.dart' as globals;

class LessonCard extends StatelessWidget {
  List<Lesson> lessons;
  int db;

  LessonCard(List<Lesson> lessons){
    this.lessons = lessons;
    db = lessons.length;

    }

  @override
  Key get key => new Key(getDate());

  String getDate(){
    return lessons[0].start.toIso8601String();
  }

  Lesson getNext() {
    for (Lesson l in lessons) {
      print(l.start.compareTo(DateTime.now()));
      print(l.start.difference(DateTime.now()));
      print(l.start);
      if (l.start.isAfter(DateTime.now())) {
        print("köv: " + l.subject);
        return l;
      }
    }
  }

  String getDurToNext() {
    return getNext().start.difference(DateTime.now()).inMinutes.toString();
  }

  String progress() {
    int n = 0;
    for (Lesson l in lessons)
      if (l.start.day == DateTime.now().day)
        n++;
    return getNext().count.toString() + "/" + n.toString();
  }

  void openDialog() {

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
                  new Text("Következő óra: ", style: new TextStyle(fontSize: 18.0,),),
                  new Text(getNext().subject, style: new TextStyle(fontSize: 18.0, color: Colors.blueAccent)),
                  new Text(", ", style: new TextStyle(fontSize: 18.0, )),
                  new Text(getDurToNext() + " perc", style: new TextStyle(fontSize: 18.0, color: Colors.blueAccent)),
                  new Text(" múlva.", style: new TextStyle(fontSize: 18.0, ), softWrap: true,),
              ],
            ),
            padding: EdgeInsets.all(10.0),
          ),
          /*
          globals.multiAccount ? new Container(
            child: new Text(absence[0].startTime.substring(0, 10), style: new TextStyle(fontSize: 16.0, color: Colors.black)),
            alignment: Alignment(1.0, -1.0),
            padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 2.0),
          ) : new Container(),
*/
          new Divider(height: 1.0,),
          new Container(
              padding: EdgeInsets.all(10.0),
              child: new Padding(
                padding: new EdgeInsets.all(0.0),
                child: new Row(
                  children: <Widget>[
                    /*
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
*/
                    new Text(getNext().room, style: new TextStyle(fontSize: 18.0, color: Colors.blueAccent)),
                    new Expanded(
                        child: new Container(
                          child: new Text(progress(), style: new TextStyle(fontSize: 18.0, color: Colors.blueAccent)),
                          alignment: Alignment(1.0, 0.0),
                        ))
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
