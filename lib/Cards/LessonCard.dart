import 'package:e_szivacs/generated/i18n.dart';
import 'package:flutter/material.dart';

import '../Datas/Lesson.dart';

class LessonCard extends StatelessWidget {
  List<Lesson> lessons;
  int numOfAbsences;
  BuildContext context;
  DateTime now;

  LessonCard(List<Lesson> lessons, BuildContext context, DateTime now) {
    this.now = now;
    this.lessons = lessons;
    lessons.removeWhere((Lesson l) => l.start.day != now.day);
    numOfAbsences = lessons.length;
    this.context = context;
  }

  @override
  Key get key => new Key(getDate());

  String getDate() {
    return "c";
  }

  Lesson getNext() {
    for (Lesson l in lessons) {
      if (l.start.isAfter(now)) {
        return l;
      }
    }
  }

  String getDurToNext() {
    return getNext().start
        .difference(now)
        .inMinutes
        .toString();
  }

  String progress() {
    int n = 0;
    for (Lesson lesson in lessons)
      if (lesson.start.day == now.day) n++;
    return (lessons.indexWhere((Lesson l) => l.id==getNext().id) + 1).toString() + "/" + n.toString();
  }

  void openDialog() {
    _lessonsDialog(lessons);
  }

  Future<Null> _lessonsDialog(List<Lesson> lessons) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return new SimpleDialog(
          children: <Widget>[
            new SingleChildScrollView(
              child: new ListBody(
                children: lessons.map((Lesson l){
                  return new Column(
                      children: <Widget>[
                        new ListTile(
                          title: new Text(l.subject, style: new TextStyle(
                              color: (l.end.isBefore(now))
                                  ? Colors.grey
                                  : null),),
                          enabled: true,
                          onTap: null,
                          subtitle: new Text(l.teacher, style: new TextStyle(
                              color: (l.end.isBefore(now))
                                  ? Colors.grey
                                  : null),),
                          leading: new Container(child: new Text(
                            l.count.toString(), style: new TextStyle(
                              color: (l.end.isBefore(now)) ? Colors.grey : null,
                              fontSize: 21),),
                            alignment: Alignment(0, 1),
                            height: 40,
                            width: 20,),
                        ),
                        new Container(child: new Text(l.room,
                          style: new TextStyle(color: (l.end.isBefore(now))
                              ? Colors.grey
                              : null),), alignment: Alignment(1, 0),),
                        new Divider(color: Colors.blueGrey,),
                      ]);
                }).toList()
              ),
            ),
          ],
          title: Text("Órák"),
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
              child: Wrap(
                children: <Widget>[
                  new Text(
                    S
                        .of(context)
                        .next_lesson,
                    style: new TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  new Text(getNext().subject??"error",
                      style: new TextStyle(
                          fontSize: 18.0, color: Colors.blueAccent)),
                  new Text(", ",
                      style: new TextStyle(
                        fontSize: 18.0,
                      )),
                  Container(
                    padding: EdgeInsets.only(right: 5),
                    child: new Text(getDurToNext() + " " + S
                        .of(context)
                        .minute,
                        style: new TextStyle(
                            fontSize: 18.0, color: Colors.blueAccent)),
                  ),
                  new Text(
                    S
                        .of(context)
                        .later,
                    style: new TextStyle(
                      fontSize: 18.0,
                    ),
                    softWrap: false,
                    maxLines: 2,
                  ),
                ],
                alignment: WrapAlignment.start,
              ),
              alignment: Alignment(-1, 0),
              padding: EdgeInsets.all(10.0),
            ),
            new Divider(
              height: 1.0,
            ),
            new Container(
                padding: EdgeInsets.all(10.0),
                child: new Padding(
                  padding: new EdgeInsets.all(0.0),
                  child: new Row(
                    children: <Widget>[
                      new Text(getNext().room??"error",
                          style: new TextStyle(
                              fontSize: 18.0, color: Colors.blueAccent)),
                      new Expanded(
                          child: new Container(
                        child: new Text(progress(),
                            style: new TextStyle(
                                fontSize: 18.0, color: Colors.blueAccent)),
                        alignment: Alignment(1.0, 0.0),
                      ))
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
