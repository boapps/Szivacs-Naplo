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

  int relativeWeek = 0;

  void _initWeek() async {
    DateTime startDate = new DateTime.now();
    startDate = startDate.add(new Duration(days: (-1 * startDate.weekday + 1)));
    lessonsWeek = await getWeek(startDate, true);
    lessonsWeek = await getWeek(startDate, false);
  }

  void nextWeek() async {
    relativeWeek++;
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

    _tabController = new TabController(vsync: this, length: 7);
    _tabController.animateTo(new DateTime.now().weekday - 1);

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
          length: 7,
          child: new Scaffold(
              drawer: GDrawer(),
            appBar: new AppBar(
//              leading:
              actions: <Widget>[
              ],
//              bottom: ,
              title: new Text("Órarend " + (("(" + startDateText.month.toString() + ". " + startDateText.day.toString() + ". - " + startDateText.add(new Duration(days: 7)).month.toString() + ". " + startDateText.add(new Duration(days: 7)).day.toString() + ".)")??"")),
            ),
            body: new Column(
              children: <Widget>[
                new Expanded(
                  child: new TabBarView(
                    controller: _tabController,
                    children: (lessonsWeek != null) ? <Widget>[
                      lessonsWeek.monday.isNotEmpty ? new ListView.builder(
                        itemBuilder: _itemBuilderMonday,
                        itemCount: lessonsWeek!=null ? lessonsWeek.monday.length:0,
                      )
                          :
                      new Container(
                        child: new Center(
                          child: new Text("Úgy néz ki ezen a napon nincs órád :)"),
                        ),
                      ),

                      lessonsWeek.tuesday.isNotEmpty ? new ListView.builder(
                        itemBuilder: _itemBuilderTuesday,
                        itemCount: lessonsWeek!=null ? lessonsWeek.tuesday.length:0,
                      )
                          :
                      new Container(
                        child: new Center(
                          child: new Text("Úgy néz ki ezen a napon nincs órád :)"),
                        ),
                      ),


                      lessonsWeek.wednesday.isNotEmpty ? new ListView.builder(
                        itemBuilder: _itemBuilderWednesday,
                        itemCount: lessonsWeek!=null ? lessonsWeek.wednesday.length:0,
                      )
                          :
                      new Container(
                        child: new Center(
                          child: new Text("Úgy néz ki ezen a napon nincs órád :)"),
                        ),
                      ),


                      lessonsWeek.thursday.isNotEmpty ? new ListView.builder(
                        itemBuilder: _itemBuilderThursday,
                        itemCount: lessonsWeek!=null ? lessonsWeek.thursday.length:0,
                      )
                          :
                      new Container(
                        child: new Center(
                          child: new Text("Úgy néz ki ezen a napon nincs órád :)"),
                        ),
                      ),


                      lessonsWeek.friday.isNotEmpty ? new ListView.builder(
                        itemBuilder: _itemBuilderFriday,
                        itemCount: lessonsWeek!=null ? lessonsWeek.friday.length:0,
                      )
                          :
                      new Container(
                        child: new Center(
                          child: new Text("Úgy néz ki ezen a napon nincs órád :)"),
                        ),
                      ),


                      lessonsWeek.saturday.isNotEmpty ? new ListView.builder(
                        itemBuilder: _itemBuilderSaturday,
                        itemCount: lessonsWeek!=null ? lessonsWeek.saturday.length:0,
                      )
                          :
                      new Container(
                        child: new Center(
                          child: new Text("Úgy néz ki ezen a napon nincs órád :)"),
                        ),
                      ),


                      lessonsWeek.sunday.isNotEmpty ? new ListView.builder(
                        itemBuilder: _itemBuilderSunday,
                        itemCount: lessonsWeek!=null ? lessonsWeek.sunday.length:0,
                      )
                          :
                      new Container(
                        child: new Center(
                          child: new Text("Úgy néz ki ezen a napon nincs órád :)"),
                        ),
                      ),
                    ]:<Widget>[
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
                      height: 48.0,
//                      alignment: Alignment.center,
                      child: new Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new IconButton(
                            tooltip: 'előző hét',
                            icon: const Icon(Icons.skip_previous),
                            onPressed: () {
                              previousWeek();
                            },
                          ),
                          new IconButton(
                            tooltip: 'előző nap',
                            icon: const Icon(Icons.keyboard_arrow_left),
                            onPressed: () {
                              _nextPage(-1);
                            },
                          ),
                          new TabPageSelector(controller: _tabController),
                          new IconButton(
                            icon: const Icon(Icons.keyboard_arrow_right),
                            tooltip: 'következő nap',
                            onPressed: () {
                              setState(() {
                                _nextPage(1);
                              });
                            },
                          ),
                          new IconButton(
                            icon: const Icon(Icons.skip_next),
                            tooltip: 'következő hét',
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

  Widget _itemBuilderMonday(BuildContext context, int index) {
    return new ListTile(
      leading: new Text(lessonsWeek.monday[index].count.toString(), textScaleFactor: 2.0,),
      title: new Text(lessonsWeek.monday[index].subject +
          (lessonsWeek.monday[index].state == "Missed" ? " (Elmarad)" : ""),
        style: TextStyle(color: lessonsWeek.monday[index].state == "Missed"
            ? Colors.red
            : null),),
      subtitle: new Text(lessonsWeek.monday[index].theme),


      trailing: new Column(
        crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
    new Text(lessonsWeek.monday[index].room),
    new Text(lessonsWeek.monday[index].start.hour.toString().padLeft(2, "0") + ":" +
    lessonsWeek.monday[index].start.minute.toString().padLeft(2, "0") + "-" + lessonsWeek.monday[index].end.hour.toString().padLeft(2, "0") + ":" +
        lessonsWeek.monday[index].end.minute.toString().padLeft(2, "0")),
    ],
      ) ,
      onTap: () {
        _lessonDialog(lessonsWeek.monday[index]);
      },
    );
  }
  Widget _itemBuilderTuesday(BuildContext context, int index) {
    return new ListTile(
      leading: new Text(lessonsWeek.tuesday[index].count.toString(), textScaleFactor: 2.0,),
      title: new Text(lessonsWeek.tuesday[index].subject +
          (lessonsWeek.tuesday[index].state == "Missed" ? " (Elmarad)" : ""),
          style: TextStyle(color: lessonsWeek.tuesday[index].state == "Missed"
              ? Colors.red
              : null)),
      subtitle: new Text(lessonsWeek.tuesday[index].theme),
      trailing: new Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          new Text(lessonsWeek.tuesday[index].room),
          new Text(lessonsWeek.tuesday[index].start.hour.toString().padLeft(2, "0") + ":" +
              lessonsWeek.tuesday[index].start.minute.toString().padLeft(2, "0") + "-" + lessonsWeek.tuesday[index].end.hour.toString().padLeft(2, "0") + ":" +
              lessonsWeek.tuesday[index].end.minute.toString().padLeft(2, "0")),
        ],
      ) ,      onTap: () {
        _lessonDialog(lessonsWeek.tuesday[index]);
      },
    );
  }
  Widget _itemBuilderWednesday(BuildContext context, int index) {
    return new ListTile(
      leading: new Text(lessonsWeek.wednesday[index].count.toString(), textScaleFactor: 2.0,),
      title: new Text(lessonsWeek.wednesday[index].subject +
          (lessonsWeek.wednesday[index].state == "Missed" ? " (Elmarad)" : ""),
          style: TextStyle(color: lessonsWeek.wednesday[index].state == "Missed"
              ? Colors.red
              : null)),
      subtitle: new Text(lessonsWeek.wednesday[index].theme),
      trailing: new Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          new Text(lessonsWeek.wednesday[index].room),
          new Text(lessonsWeek.wednesday[index].start.hour.toString().padLeft(2, "0") + ":" +
              lessonsWeek.wednesday[index].start.minute.toString().padLeft(2, "0") + "-" + lessonsWeek.wednesday[index].end.hour.toString().padLeft(2, "0") + ":" +
              lessonsWeek.wednesday[index].end.minute.toString().padLeft(2, "0")),
        ],
      ) ,      onTap: () {
        _lessonDialog(lessonsWeek.wednesday[index]);
      },
    );
  }
  Widget _itemBuilderThursday(BuildContext context, int index) {
    return new ListTile(
      leading: new Text(lessonsWeek.thursday[index].count.toString(), textScaleFactor: 2.0,),
      title: new Text(lessonsWeek.thursday[index].subject +
          (lessonsWeek.thursday[index].state == "Missed" ? " (Elmarad)" : ""),
          style: TextStyle(color: lessonsWeek.thursday[index].state == "Missed"
              ? Colors.red
              : null)),
      subtitle: new Text(lessonsWeek.thursday[index].theme),
      trailing: new Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          new Text(lessonsWeek.thursday[index].room),
          new Text(lessonsWeek.thursday[index].start.hour.toString().padLeft(2, "0") + ":" +
              lessonsWeek.thursday[index].start.minute.toString().padLeft(2, "0") + "-" + lessonsWeek.thursday[index].end.hour.toString().padLeft(2, "0") + ":" +
              lessonsWeek.thursday[index].end.minute.toString().padLeft(2, "0")),
        ],
      ) ,      onTap: () {
        _lessonDialog(lessonsWeek.thursday[index]);
      },
    );
  }
  Widget _itemBuilderFriday(BuildContext context, int index) {
    return new ListTile(
      leading: new Text(lessonsWeek.friday[index].count.toString(), textScaleFactor: 2.0,),
      title: new Text(lessonsWeek.friday[index].subject +
          (lessonsWeek.friday[index].state == "Missed" ? " (Elmarad)" : ""),
          style: TextStyle(color: lessonsWeek.friday[index].state == "Missed"
              ? Colors.red
              : null)),
      subtitle: new Text(lessonsWeek.friday[index].theme),
      trailing: new Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          new Text(lessonsWeek.friday[index].room),
          new Text(lessonsWeek.friday[index].start.hour.toString().padLeft(2, "0") + ":" +
              lessonsWeek.friday[index].start.minute.toString().padLeft(2, "0") + "-" + lessonsWeek.friday[index].end.hour.toString().padLeft(2, "0") + ":" +
              lessonsWeek.friday[index].end.minute.toString().padLeft(2, "0")),
        ],
      ) ,      onTap: () {
        _lessonDialog(lessonsWeek.friday[index]);
      },
    );
  }
  Widget _itemBuilderSaturday(BuildContext context, int index) {
    return new ListTile(
      leading: new Text(lessonsWeek.saturday[index].count.toString(), textScaleFactor: 2.0,),
      title: new Text(lessonsWeek.saturday[index].subject +
          (lessonsWeek.saturday[index].state == "Missed" ? " (Elmarad)" : ""),
          style: TextStyle(color: lessonsWeek.saturday[index].state == "Missed"
              ? Colors.red
              : null)),
      subtitle: new Text(lessonsWeek.saturday[index].theme),
      trailing: new Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          new Text(lessonsWeek.saturday[index].room),
          new Text(lessonsWeek.saturday[index].start.hour.toString().padLeft(2, "0") + ":" +
              lessonsWeek.saturday[index].start.minute.toString().padLeft(2, "0") + "-" + lessonsWeek.saturday[index].end.hour.toString().padLeft(2, "0") + ":" +
              lessonsWeek.saturday[index].end.minute.toString().padLeft(2, "0")),
        ],
      ) ,      onTap: () {
        _lessonDialog(lessonsWeek.saturday[index]);
      },
    );
  }
  Widget _itemBuilderSunday(BuildContext context, int index) {
    return new ListTile(
      leading: new Text(lessonsWeek.sunday[index].count.toString(), textScaleFactor: 2.0,),
      title: new Text(lessonsWeek.sunday[index].subject +
          (lessonsWeek.sunday[index].state == "Missed" ? " (Elmarad)" : ""),
          style: TextStyle(color: lessonsWeek.sunday[index].state == "Missed"
              ? Colors.red
              : null)),
      subtitle: new Text(lessonsWeek.sunday[index].theme),
      trailing: new Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          new Text(lessonsWeek.sunday[index].room),
          new Text(lessonsWeek.sunday[index].start.hour.toString().padLeft(2, "0") + ":" +
              lessonsWeek.sunday[index].start.minute.toString().padLeft(2, "0") + "-" + lessonsWeek.sunday[index].end.hour.toString().padLeft(2, "0") + ":" +
              lessonsWeek.sunday[index].end.minute.toString().padLeft(2, "0")),
        ],
      ) ,      onTap: () {
        _lessonDialog(lessonsWeek.sunday[index]);
      },
    );
  }
  Future <List <Lesson>> getLessons(DateTime from, DateTime to) async {
    if (selectedUser==null)
      selectedUser = (await AccountManager().getUsers())[0];
    String instCode = selectedUser.schoolCode; //suli kódja
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
    String timetableString = (await RequestHelper().getTimeTable(from.toIso8601String().substring(0, 10), to.toIso8601String().substring(0, 10), code, instCode)).body;
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
                new Text("terem: " + lesson.room),
                new Text("tanár: " + lesson.teacher),
                new Text("osztály: " + lesson.group),
                new Text("Órakezdés: " +
                    lesson.start.hour.toString().padLeft(2, "0") + ":" +
                    lesson.start.minute.toString().padLeft(2, "0")),
                new Text("Vége: " + lesson.end.hour.toString().padLeft(2, "0") +
                    ":" + lesson.end.minute.toString().padLeft(2, "0")),
                lesson.state == "Missed" ? new Text(
                    "állapot: " + lesson.stateName) : new Container(),
                lesson.depTeacher != ""
                    ? new Text("helyettesítő tanár: " + lesson.depTeacher)
                    : new Container(),
                (lesson.theme != "" && lesson.theme!= null)
                    ? new Text("téma: " + lesson.theme)
                    : new Container(),

//                new Text("óraszám: " + lesson.oraszam.toString()),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('ok'),
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

  Week(this.monday, this.tuesday, this.wednesday, this.thursday, this.friday,
      this.saturday, this.sunday, this.startDay);
}

