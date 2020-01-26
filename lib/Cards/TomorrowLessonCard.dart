import 'package:e_szivacs/Dialog/HomeworkDialog.dart';
import 'package:e_szivacs/generated/i18n.dart';
import 'package:flutter/material.dart';

import '../Datas/Lesson.dart';

class TomorrowLessonCard extends StatelessWidget {
  List<Lesson> lessons;
  int numOfAbsences;
  BuildContext context;
  DateTime now;

  TomorrowLessonCard(List<Lesson> lessons, BuildContext context, DateTime now) {
    this.now = now;
    this.lessons = lessons;
    lessons.removeWhere(
        (Lesson l) => l.start.day != now.add(Duration(days: 1)).day);
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

  void openDialog() {
    _lessonsDialog(lessons);
  }

  Future<Null> _lessonInfoDialog(Lesson lesson) async {
    return showDialog(
          barrierDismissible: true,
          context: context,
          builder: (BuildContext context) {
            return new HomeworkDialog(lesson);
          },
        ) ??
        false;
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
                  children: lessons.map((Lesson lesson) {
                return new Column(children: <Widget>[
                  new ListTile(
                    title: new Text(
                      lesson.subject,
                      style: new TextStyle(
                          color:
                              (lesson.end.isBefore(now)) ? Colors.grey : null),
                    ),
                    enabled: true,
                    onTap: () {
                      _lessonInfoDialog(lesson);
                    },
                    subtitle: new Text(
                      lesson.teacher,
                      style: new TextStyle(
                          color:
                              (lesson.end.isBefore(now)) ? Colors.grey : null),
                    ),
                    leading: new Container(
                      child: new Text(
                        lesson.count != -1 ? lesson.count.toString() : "+",
                        style: new TextStyle(
                            color:
                                (lesson.end.isBefore(now)) ? Colors.grey : null,
                            fontSize: 21),
                      ),
                      alignment: Alignment(0, 1),
                      height: 40,
                      width: 20,
                    ),
                  ),
                  new Row(
                    //Bottom row containing room number and a house icon if there is homework set for the lesson.
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          lesson.homework != null ? "⌂" : "",
                        ),
                      ),
                      Expanded(
                        child: Text(
                          lesson.room,
                          style: new TextStyle(
                              color: (lesson.end.isBefore(now))
                                  ? Colors.grey
                                  : null),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  new Divider(
                    color: Colors.blueGrey,
                  ),
                ]);
              }).toList()),
            ),
          ],
          title: Text("Holnapi órák"), //todo fordítási adatbázisból!
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
        margin: EdgeInsets.all(6.0),
        child: new Column(
          children: <Widget>[
            new Container(
              child: Wrap(
                children: <Widget>[
                  new Text(
                    S.of(context).tomorrow,
                    style: new TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 5, left: 5),
                    child: new Text(lessons.length.toString(),
                        style: new TextStyle(
                            fontSize: 18.0, color: Colors.blueAccent)),
                  ),
                  new Text(
                    S.of(context).tomorrow_lessons,
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
          ],
        ),
      ),
    );
  }
}
