import 'dart:async';

import 'package:flutter/material.dart';

import '../Datas/User.dart';
import '../Datas/Lesson.dart';
import '../Datas/Week.dart';
import '../GlobalDrawer.dart';
import '../Helpers/TimetableHelper.dart';
import '../globals.dart' as globals;
import '../Utils/ModdedTabs.dart' as MT;
import "../Utils/StringFormatter.dart";
import '../Helpers/LocaleHelper.dart';

void main() {
  runApp(new MaterialApp(home: new TimeTableScreen()));
}

class TimeTableScreen extends StatefulWidget {
  @override
  TimeTableScreenState createState() => new TimeTableScreenState();

}

class TimeTableScreenState extends State<TimeTableScreen> with
    SingleTickerProviderStateMixin{

  TabController _tabController;

  DateTime startDateText;
  Week lessonsWeek;

  int tabLength = 7;
  int relativeWeek = 0;

  User selectedUser;
  List<User> users;

  void nextWeek() {
    _tabController.animateTo(0);
    relativeWeek++;
    refreshWeek();
  }

  void previousWeek() {
    _tabController.animateTo(0);
    relativeWeek--;
    refreshWeek();
  }

  void refreshWeek() async {
    DateTime startDate = new DateTime.now();
    startDate = startDate.add(
        new Duration(days: (-1 * startDate.weekday + 1 + 7 * relativeWeek)));
    setState(() {
      startDateText = startDate;
    });

    lessonsWeek = await getWeek(startDate, true);
    lessonsWeek = await getWeek(startDate, false);
  }

  void initSelectedUser() async {
    setState(() {
      selectedUser = globals.selectedUser;
    });

  }

  @override
  void initState() {
    super.initState();
    initSelectedUser();
    startDateText = new DateTime.now();
    startDateText = startDateText.add(new Duration(
        days: (-1 * startDateText.weekday + 1 + 7 * relativeWeek)));
    refreshWeek();
    _tabController = new TabController(vsync: this, length: 7,
        initialIndex: new DateTime.now().weekday - 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _nextPage(int delta) {
    final int newIndex = _tabController.index + delta;
    if (newIndex < 0 || newIndex >= _tabController.length) return;
    _tabController.animateTo(newIndex);
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () {
            globals.screen = 0;
            Navigator.pushReplacementNamed(context, "/main");
          },
        child: new DefaultTabController(
          length: tabLength,
          child: new Scaffold(
              drawer: GDrawer(),
            appBar: new AppBar(
              title: new Text(AppLocalizations.of(context).timetable +
                  getTimetableText(startDateText)),
            ),
            body: new Column(
              children: <Widget>[
                new Expanded(
                  child: new TabBarView(
                    controller: _tabController,
                    children: (lessonsWeek != null) ?
                        lessonsWeek.dayList().map((List<Lesson> lessonList){
                          return lessonList.isNotEmpty ? new ListView.builder(
                            itemBuilder: (BuildContext context, int index){
                              return _itemBuilderLessonList(context, index, lessonList);
                              },
                            itemCount: lessonsWeek!=null ? lessonList.length:0,
                          )
                              :
                          new Container(
                            child: new Center(
                              child: new Text(AppLocalizations.of(context).no_lessons),
                            ),
                          );
                        }).toList()
                        :<Widget>[
                      new Container(child: new Center(child: new CircularProgressIndicator()), height: 20.0, width: 20.0),
                      new Container(child: new Center(child: new CircularProgressIndicator()), height: 20.0, width: 20.0),
                      new Container(child: new Center(child: new CircularProgressIndicator()), height: 20.0, width: 20.0),
                      new Container(child: new Center(child: new CircularProgressIndicator()), height: 20.0, width: 20.0),
                      new Container(child: new Center(child: new CircularProgressIndicator()), height: 20.0, width: 20.0),
                      new Container(child: new Center(child: new CircularProgressIndicator()), height: 20.0, width: 20.0),
                      new Container(child: new Center(child: new CircularProgressIndicator()), height: 20.0, width: 20.0),
                    ]
                ),
          ),
                new Container(
                      height: 54.0,
                color: Theme.of(context).primaryColor,
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new IconButton(
                            tooltip: AppLocalizations.of(context).prev_week,
                            icon: const Icon(Icons.skip_previous, size: 20,color: Colors.white,),
                            onPressed: () {
                              previousWeek();
                            },
                            padding: EdgeInsets.all(0),
                          ),
                          new IconButton(
                            tooltip: AppLocalizations.of(context).prev_day,
                            icon: const Icon(Icons.keyboard_arrow_left, size: 20,color: Colors.white,),
                            onPressed: () {
                              _nextPage(-1);
                            },
                            padding: EdgeInsets.all(0),
                          ),
                          new Flexible(
                            child: new SingleChildScrollView(
                              child: lessonsWeek != null ? new MT.TabPageSelector(
                                controller: _tabController,
                                indicatorSize: 25,
                                selectedColor: Colors.black54,
                                color: Colors.black26,
                                days: lessonsWeek.dayStrings(context),
                              ) : new Container(),
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.all(0),
                            ),
                            //alignment: Alignment(0, 0),
                            //padding: EdgeInsets.all(0),
                            //margin: EdgeInsets.all(0),
                          ),
                          new IconButton(
                            icon: const Icon(Icons.keyboard_arrow_right, size: 20,color: Colors.white,),
                            tooltip: AppLocalizations.of(context).next_day,
                            onPressed: () {
                              setState(() {
                                _nextPage(1);
                              });
                            },
                            padding: EdgeInsets.all(0),
                          ),
                          new IconButton(
                            icon: const Icon(Icons.skip_next, size: 20,color: Colors.white,),
                            tooltip: AppLocalizations.of(context).next_week,
                            onPressed: () {
                              setState(() {
                                nextWeek();
                              });
                            },
                            padding: EdgeInsets.all(0),
                          ),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.center,
                      ),
                    ),
              ],
            )
          ),
        ),
    );
  }

  Widget _itemBuilderLessonList(BuildContext context, int index, List<Lesson> lessonList) {
    return new ListTile(
      leading: lessonList[index].count >= 0 ? new Text(lessonList[index].count.toString(), textScaleFactor: 2.0,) : new Container(),
      title: new Text(lessonList[index].subject +
          (lessonList[index].isMissed ?
          " (${AppLocalizations.of(context).missed})" : "") + (lessonList[index].depTeacher != "" ? " (${lessonList[index].depTeacher})":""),
        style: TextStyle(color: lessonList[index].isMissed
            ? Colors.red
            : lessonList[index].depTeacher != "" ? Colors.deepOrange : null),),
      subtitle: new Text(lessonList[index].theme),
      trailing: new Column(
        crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
    new Text(lessonList[index].room),
    new Text(getLessonRangeText(lessonList[index])),
    ],
      ) ,
      onTap: () {
        _lessonDialog(lessonList[index]);
      },
    );
  }

  Future<Null> _lessonDialog(Lesson lesson) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(lesson.subjectName),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text(AppLocalizations.of(context).room + lesson.room),
                new Text(AppLocalizations.of(context).teacher + lesson.teacher),
                new Text(AppLocalizations.of(context).group + lesson.group),
                new Text(AppLocalizations.of(context).lesson_start +
                    getLessonStartText(lesson)),
                new Text(AppLocalizations.of(context).lesson_end +
                    getLessonEndText(lesson)),
                lesson.isMissed ? new Text(
                    AppLocalizations.of(context).state + lesson.stateName)
                    : new Container(),
                lesson.depTeacher != "" ? new Text(
                    AppLocalizations.of(context).dep_teacher + lesson.depTeacher)
                    : new Container(),
                (lesson.theme != "" && lesson.theme!= null)
                    ? new Text(AppLocalizations.of(context).theme + lesson.theme)
                    : new Container(),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(AppLocalizations.of(context).ok),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<Week> getWeek(DateTime startDate, bool offline) async {
    List<Lesson> list;
    if (offline)
      list = await getLessonsOffline(startDate, startDate.add(new Duration(days: 6)), globals.selectedUser);
    else
      list = await getLessons(startDate, startDate.add(new Duration(days: 6)), globals.selectedUser);

    List<Lesson> monday = new List();
    List<Lesson> tuesday = new List();
    List<Lesson> wednesday = new List();
    List<Lesson> thursday = new List();
    List<Lesson> friday = new List<Lesson>();
    List<Lesson> saturday = new List();
    List<Lesson> sunday = new List();

    setState(() {
      for (Lesson lesson in list){
        switch(lesson.date.weekday) {
          case 1:
            monday.add(lesson);
            break;
          case 2:
            tuesday.add(lesson);
            break;
          case 3:
            wednesday.add(lesson);
            break;
          case 4:
            thursday.add(lesson);
            break;
          case 5:
            friday.add(lesson);
            break;
          case 6:
            saturday.add(lesson);
            break;
          case 7:
            sunday.add(lesson);
            break;
        }
      }
    });

    monday.sort((Lesson a, Lesson b) => a.start.compareTo(b.start));
    tuesday.sort((Lesson a, Lesson b) => a.start.compareTo(b.start));
    wednesday.sort((Lesson a, Lesson b) => a.start.compareTo(b.start));
    thursday.sort((Lesson a, Lesson b) => a.start.compareTo(b.start));
    friday.sort((Lesson a, Lesson b) => a.start.compareTo(b.start));
    saturday.sort((Lesson a, Lesson b) => a.start.compareTo(b.start));
    sunday.sort((Lesson a, Lesson b) => a.start.compareTo(b.start));

    return new Week(monday, tuesday, wednesday, thursday, friday, saturday, sunday, startDate);
  }
}
