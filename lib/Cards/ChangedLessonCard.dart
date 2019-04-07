import 'package:flutter/material.dart';
import '../Datas/Lesson.dart';
import '../Utils/StringFormatter.dart';
import '../Helpers/LocaleHelper.dart';

class ChangedLessonCard extends StatelessWidget {
  Lesson lesson;
  BuildContext context;

  ChangedLessonCard(Lesson lesson, BuildContext context) {
    this.lesson = lesson;
    this.context = context;
  }

  @override
  Key get key => new Key(getDate());

  String getDate() {
    return lesson.start.toIso8601String();
  }

  bool get isSubstitution => lesson.depTeacher.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
//      onTap: openDialog,
      child: new Card(
        child: new Column(
          children: <Widget>[
            new Container(
              child: Wrap(
                children: <Widget>[
                  new Text((isSubstitution ? AppLocalizations().dep : AppLocalizations().missed) + ": ",
                      style: new TextStyle(
                          fontSize: 18.0, )),
                  new Text(lesson.subject,
                      style: new TextStyle(
                        fontSize: 18.0, color: Colors.blueAccent
                      )),
                  isSubstitution ? new Text(" " + lesson.depTeacher, style: new TextStyle(
                      fontSize: 18.0, color: Colors.green
                  )):null,
                ].where((Widget w)=>w!=null).toList(),
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
                      new Text(lesson.count.toString() + ". " + AppLocalizations().lesson,
                          style: new TextStyle(
                              fontSize: 18.0,)),
                      new Expanded(
                          child: new Container(
                            child: new Text(lessonToHuman(lesson) + dateToWeekDay(lesson.date),
                                style: new TextStyle(
                                    fontSize: 18.0,)),
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
