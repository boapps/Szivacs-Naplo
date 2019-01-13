import 'dart:async';
import 'dart:convert' show utf8, json;

import 'package:flutter/material.dart';

import '../Datas/User.dart';
import '../Datas/Lesson.dart';
import '../GlobalDrawer.dart';
import '../Helpers/RequestHelper.dart';
import '../Utils/AccountManager.dart';
import '../Utils/Saver.dart';
import '../main.dart';
import '../globals.dart' as globals;
import '../Utils/ModdedTabs.dart' as MT;
import 'package:flutter_localizations/flutter_localizations.dart';
import '../Helpers/LocaleHelper.dart';

void main() {
  runApp(new MaterialApp(home: new TimeTableScreen()));
}

class TimeTableScreen extends StatefulWidget {
  @override
  TimeTableScreenState createState() => new TimeTableScreenState();

}

class TimeTableScreenState extends State<TimeTableScreen> with SingleTickerProviderStateMixin{
  TabController _tabController;

  DateTime startDateText;
  Week lessonsWeek;

  int tabLength = 7;

  int relativeWeek = 0;

  void _initWeek() async {
    DateTime startDate = new DateTime.now();
    startDate = startDate.add(new Duration(days: (-1 * startDate.weekday + 1)));
    lessonsWeek = await getWeek(startDate, true);
    lessonsWeek = await getWeek(startDate, false);
  }

  void nextWeek() async {
    relativeWeek++;
    _tabController.animateTo(0);
    DateTime startDate = new DateTime.now();
    startDate = startDate.add(
        new Duration(days: (-1 * startDate.weekday + 1 + 7 * relativeWeek)));
    setState(() {
      startDateText = startDate;
    });
    lessonsWeek = await getWeek(startDate, true);
    lessonsWeek = await getWeek(startDate, false);
  }

  void previousWeek() async {
    _tabController.animateTo(0);
    relativeWeek--;
    DateTime startDate = new DateTime.now();
    startDate = startDate.add(
        new Duration(days: (-1 * startDate.weekday + 1 + 7 * relativeWeek)));
    setState(() {
      startDateText = startDate;
    });
    lessonsWeek = await getWeek(startDate, true);
    lessonsWeek = await getWeek(startDate, false);
  }

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

    startDateText = new DateTime.now();
    startDateText = startDateText.add(new Duration(
        days: (-1 * startDateText.weekday + 1 + 7 * relativeWeek)));

    _initWeek();
    setState(() {lessonsWeek;});

    _tabController = new TabController(vsync: this, length: 7, initialIndex: new DateTime.now().weekday - 1);

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
//              leading:
              actions: <Widget>[
              ],
//              bottom: ,
              title: new Text(AppLocalizations.of(context).timetable + ((" (" + startDateText.month.toString() + ". " + startDateText.day.toString() + ". - " + startDateText.add(new Duration(days: 6)).month.toString() + ". " + startDateText.add(new Duration(days: 6)).day.toString() + ".)")??"")),
            ),
            body: new Column(
              children: <Widget>[
                new Expanded(
                  child: new TabBarView(
                    controller: _tabController,
                    children: (lessonsWeek != null) ?
                        lessonsWeek.dayList().map((List<Lesson> lessonList){
                          print("lessonList.length");
                          print(lessonList.length);
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
//                  height: 100.0,

          ),
                /*new PreferredSize(
                  preferredSize: const Size.fromHeight(48.0),
                  child: new Theme(
                    data: Theme.of(context).copyWith(accentColor: Colors.white),
                    child: */
                new Container(
                      height: 54.0,
//                      alignment: Alignment.center,
                color: Colors.blue,
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
                          ),
                          new IconButton(
                            tooltip: AppLocalizations.of(context).prev_day,
                            icon: const Icon(Icons.keyboard_arrow_left, size: 20,color: Colors.white,),
                            onPressed: () {
                              _nextPage(-1);
                            },
                          ),
                          new MT.TabPageSelector(
                            controller: _tabController,
                            indicatorSize: 26,
                            selectedColor: Colors.black54,
                            color: Colors.black26,
                            days: lessonsWeek.dayStrings(context),
                          ),
                          new IconButton(
                            icon: const Icon(Icons.keyboard_arrow_right, size: 20,color: Colors.white,),
                            tooltip: AppLocalizations.of(context).next_day,
                            onPressed: () {
                              setState(() {
                                _nextPage(1);
                              });
                            },
                          ),
                          new IconButton(
                            icon: const Icon(Icons.skip_next, size: 20,color: Colors.white,),
                            tooltip: AppLocalizations.of(context).next_week,
                            onPressed: () {
                              setState(() {
                                nextWeek();
                              });
                            },
                          ),

                        ],

                        crossAxisAlignment: CrossAxisAlignment.center,
                      ),
                    ),
//                  ),
//                )

              ],
//              mainAxisAlignment: MainAxisAlignment.start,
//                verticalDirection: VerticalDirection.up,
            )
          ),
        ),
    );
  }

  Widget _itemBuilderLessonList(BuildContext context, int index, List<Lesson> lessonList) {
    return new ListTile(
      leading: new Text(lessonList[index].count.toString(), textScaleFactor: 2.0,),
      title: new Text(lessonList[index].subject +
          (lessonList[index].state == "Missed" ?
          " (${AppLocalizations.of(context).missed})" : ""),
        style: TextStyle(color: lessonList[index].state == "Missed"
            ? Colors.red
            : null),),
      subtitle: new Text(lessonList[index].theme),


      trailing: new Column(
        crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
    new Text(lessonList[index].room),
    new Text(lessonList[index].start.hour.toString().padLeft(2, "0") + ":" +
        lessonList[index].start.minute.toString().padLeft(2, "0") + "-" + lessonList[index].end.hour.toString().padLeft(2, "0") + ":" +
        lessonList[index].end.minute.toString().padLeft(2, "0")),
    ],
      ) ,
      onTap: () {
        _lessonDialog(lessonList[index]);
      },
    );
  }

  Future <List <Lesson>> getLessons(DateTime from, DateTime to) async {
    if (selectedUser==null)
      selectedUser = (await AccountManager().getUsers())[0];
    String instCode = selectedUser.schoolCode;
    userName = selectedUser.username;
    password = selectedUser.password;
    String jsonBody = "institute_code=" +
        instCode +
        "&userName=" +
        userName +
        "&password=" +
        password +
        "&grant_type=password&client_id=919e0c1c-76a2-4646-a2fb-7085bbbf3c56";
    Map<String, dynamic> bearerMap =
    json.decode((await RequestHelper().getBearer(jsonBody, instCode)).body);
    String code = bearerMap.values.toList()[0];
    String timetableString = (await RequestHelper().getTimeTable(from.toIso8601String().substring(0, 10), to.toIso8601String().substring(0, 10), code, instCode));
    List<dynamic> ttMap =
    json.decode(timetableString);
    saveTimetable(timetableString, from.year.toString()+"-"+from.month.toString()+"-"+from.day.toString()+"_"+to.year.toString()+"-"+to.month.toString()+"-"+to.day.toString(), selectedUser);
    List<Lesson> lessons = new List();
    for (dynamic d in ttMap){
      lessons.add(Lesson.fromJson(d));
    }
    return lessons;
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
                    lesson.start.hour.toString().padLeft(2, "0") + ":" +
                    lesson.start.minute.toString().padLeft(2, "0")),
                new Text(AppLocalizations.of(context).lesson_end + lesson.end.hour.toString().padLeft(2, "0") +
                    ":" + lesson.end.minute.toString().padLeft(2, "0")),
                lesson.state == "Missed" ? new Text(
                    AppLocalizations.of(context).state + lesson.stateName) : new Container(),
                lesson.depTeacher != ""
                    ? new Text(AppLocalizations.of(context).dep_teacher + lesson.depTeacher)
                    : new Container(),
                (lesson.theme != "" && lesson.theme!= null)
                    ? new Text(AppLocalizations.of(context).theme + lesson.theme)
                    : new Container(),

//                new Text("óraszám: " + lesson.oraszam.toString()),
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


  Future <List <Lesson>> getLessonsOffline(DateTime from, DateTime to) async {
    if (selectedUser==null)
      selectedUser = (await AccountManager().getUsers())[0];

    List<dynamic> ttMap = await readTimetable(from.year.toString()+"-"+from.month.toString()+"-"+from.day.toString()+"_"+to.year.toString()+"-"+to.month.toString()+"-"+to.day.toString(), selectedUser);
    List<Lesson> lessons = new List();
    try {
      for (dynamic d in ttMap){
            lessons.add(Lesson.fromJson(d));
          }
    } catch (e) {
      print(e);
    }
    return lessons;
  }

  Future<Week> getWeek(DateTime startDate, bool offline) async {
    List<Lesson> list;
    if (offline)
      list = await getLessonsOffline(startDate, startDate.add(new Duration(days: 7)));
    else
      list = await getLessons(startDate, startDate.add(new Duration(days: 7)));

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
      return new Week(monday, tuesday, wednesday, thursday, friday, saturday, sunday, startDate);
  }
}

class Week {
  List<Lesson> monday;
  List<Lesson> tuesday;
  List<Lesson> wednesday;
  List<Lesson> thursday;
  List<Lesson> friday;
  List<Lesson> saturday;
  List<Lesson> sunday;
  DateTime startDay;


  List<List<Lesson>> dayList(){
    List<List<Lesson>> days = new List();
    if (monday.isNotEmpty)
      days.add(monday);
    if (tuesday.isNotEmpty)
      days.add(tuesday);
    if (wednesday.isNotEmpty)
      days.add(wednesday);
    if (thursday.isNotEmpty)
      days.add(thursday);
    if (friday.isNotEmpty)
      days.add(friday);
    if (saturday.isNotEmpty)
      days.add(saturday);
    if (sunday.isNotEmpty)
      days.add(sunday);
    return days;
  }

  List<String> dayStrings(BuildContext context){
    List<String> days = new List();
    if (monday.isNotEmpty)
      days.add(AppLocalizations.of(context).short_monday);
    if (tuesday.isNotEmpty)
      days.add(AppLocalizations.of(context).short_tuesday);
    if (wednesday.isNotEmpty)
      days.add(AppLocalizations.of(context).short_wednesday);
    if (thursday.isNotEmpty)
      days.add(AppLocalizations.of(context).short_thursday);
    if (friday.isNotEmpty)
      days.add(AppLocalizations.of(context).short_friday);
    if (saturday.isNotEmpty)
      days.add(AppLocalizations.of(context).short_saturday);
    if (sunday.isNotEmpty)
      days.add(AppLocalizations.of(context).short_sunday);
    return days;
  }

  Week(this.monday, this.tuesday, this.wednesday, this.thursday, this.friday,
      this.saturday, this.sunday, this.startDay);
}

