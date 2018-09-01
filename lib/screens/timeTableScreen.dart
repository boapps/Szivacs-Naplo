import 'dart:async';
import 'dart:convert' show utf8, json;

import 'package:flutter/material.dart';

import '../Datas/User.dart';
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

  void _initWeek() async {
    DateTime startDate = new DateTime.now();
    startDate = startDate.add(new Duration(days: (-1 * startDate.weekday + 1)));
    lessonsWeek = await getWeek(startDate, true);
    lessonsWeek = await getWeek(startDate, false);
  }

  User selectedUser;
  List<User> users;

  void initSelectedUser() async {

    users = await AccountManager().getUsers();
    setState(() {
    selectedUser = users[0];
    });

  }

  void _onSelect(User user) async {
    setState(() {
      selectedUser = user;
    });
    DateTime startDate = new DateTime.now();
    startDate = startDate.add(new Duration(days: (-1 * startDate.weekday + 1)));
    lessonsWeek = await getWeek(startDate, true);
    lessonsWeek = await getWeek(startDate, false);
  }

  @override
  void initState() {
    super.initState();
    initSelectedUser();

    startDateText = new DateTime.now();
    startDateText = startDateText.add(new Duration(days: (-1 * startDateText.weekday + 1)));

    _initWeek();
    setState(() {lessonsWeek;});

    _tabController = new TabController(vsync: this, length: 7);
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
            drawer: GlobalDrawer(context),
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
                      /*new Container(
                  color: Colors.deepOrange,
                  child: new Column(
                    children: <Widget>[
                      new Text("asd"),
                      new Container(
                        width: 400.0,
                        height: 518.0,
                        child: new ListView.builder(
                          itemBuilder: _itemBuilderTuesday,
                          itemCount: lessonsWeek!=null ? lessonsWeek.tuesday.length:0,
                        ),
                      ),
                    ],
                  )
                ),*/

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
                            tooltip: 'Previous choice',
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              _nextPage(-1);
                            },
                          ),
                          new TabPageSelector(controller: _tabController),
                          selectedUser != null && globals.multiAccount ? new PopupMenuButton<User>(
                            child: new Container(
                              child: new Row(
                                children: <Widget>[
                                  new Text(selectedUser.name, style: new TextStyle(color: Colors.white, fontSize: 17.0),),
                                  new Icon(Icons.arrow_drop_down, color: Colors.white,),
                                ],
                              ),
                              padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 2.0),
                            ),
                            onSelected: _onSelect,
                            itemBuilder: (BuildContext context) {
                              return users.map((User user) {
                                return new PopupMenuItem<User>(
                                  value: user,
                                  child: new Text(user.name),
                                );
                              }).toList();
                            },
                          ):new Container(),
                          new IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            tooltip: 'Next choice',
                            onPressed: () {
                              setState(() {
                                _nextPage(1);
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
      title: new Text(lessonsWeek.monday[index].subject),
      subtitle: new Text(lessonsWeek.monday[index].theme),
      trailing: new Text(lessonsWeek.monday[index].room),
      onTap: () {print(index);},
    );
  }
  Widget _itemBuilderTuesday(BuildContext context, int index) {
    return new ListTile(
      leading: new Text(lessonsWeek.tuesday[index].count.toString(), textScaleFactor: 2.0,),
      title: new Text(lessonsWeek.tuesday[index].subject),
      subtitle: new Text(lessonsWeek.tuesday[index].theme),
      trailing: new Text(lessonsWeek.tuesday[index].room),
      onTap: () {print(index);},
    );
  }
  Widget _itemBuilderWednesday(BuildContext context, int index) {
    return new ListTile(
      leading: new Text(lessonsWeek.wednesday[index].count.toString(), textScaleFactor: 2.0,),
      title: new Text(lessonsWeek.wednesday[index].subject),
      subtitle: new Text(lessonsWeek.wednesday[index].theme),
      trailing: new Text(lessonsWeek.wednesday[index].room),
      onTap: () {print(index);},
    );
  }
  Widget _itemBuilderThursday(BuildContext context, int index) {
    return new ListTile(
      leading: new Text(lessonsWeek.thursday[index].count.toString(), textScaleFactor: 2.0,),
      title: new Text(lessonsWeek.thursday[index].subject),
      subtitle: new Text(lessonsWeek.thursday[index].theme),
      trailing: new Text(lessonsWeek.thursday[index].room),
      onTap: () {print(index);},
    );
  }
  Widget _itemBuilderFriday(BuildContext context, int index) {
    return new ListTile(
      leading: new Text(lessonsWeek.friday[index].count.toString(), textScaleFactor: 2.0,),
      title: new Text(lessonsWeek.friday[index].subject),
      subtitle: new Text(lessonsWeek.friday[index].theme),
      trailing: new Text(lessonsWeek.friday[index].room),
      onTap: () {print(index);},
    );
  }
  Widget _itemBuilderSaturday(BuildContext context, int index) {
    return new ListTile(
      leading: new Text(lessonsWeek.saturday[index].count.toString(), textScaleFactor: 2.0,),
      title: new Text(lessonsWeek.saturday[index].subject),
      subtitle: new Text(lessonsWeek.saturday[index].theme),
      trailing: new Text(lessonsWeek.saturday[index].room),
      onTap: () {print(index);},
    );
  }
  Widget _itemBuilderSunday(BuildContext context, int index) {
    return new ListTile(
      leading: new Text(lessonsWeek.sunday[index].count.toString(), textScaleFactor: 2.0,),
      title: new Text(lessonsWeek.sunday[index].subject),
      subtitle: new Text(lessonsWeek.sunday[index].theme),
      trailing: new Text(lessonsWeek.sunday[index].room),
      onTap: () {print(index);},
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

class Lesson {

  int id;
  int count;
  int oraszam;
  DateTime date;
  DateTime start;
  DateTime end;
  String subject;
  String subjectName;
  String room;
  String group;
  String teacher;
  String depTeacher;
  String state;
  String stateName;
  String presence;
  String presenceName;
  String theme;
  String homework;
  String calendarOraType;

  Lesson(this.id, this.count, this.oraszam, this.date, this.start, this.end,
      this.subject, this.subjectName, this.room, this.group, this.teacher,
      this.depTeacher, this.state, this.stateName, this.presence,
      this.presenceName, this.theme, this.homework, this.calendarOraType);

  Lesson.fromJson(Map json) {
    this.id = json["LessonId"];
    this.count = json["Count"];
    this.oraszam = 0;
    this.date = DateTime.parse(json["Date"]);
    this.start = DateTime.parse(json["StartTime"]);
    this.end = DateTime.parse(json["EndTime"]);
    this.subject = json["Subject"];
    this.subjectName = json["SubjectCategoryName"];
    this.room = json["ClassRoom"];
    this.group = json["ClassGroup"];
    this.teacher = json["Teacher"];
    this.depTeacher = json["DeputyTeacher"];
    this.state = json["State"];
    this.stateName = json["StateName"];
    this.presence = json["PresenceType"];
    this.presenceName = json["PresenceTypeName"];
    this.theme = json["Theme"];
    this.homework = json["Homework"];
    this.calendarOraType = json["CalendarOraType"];
  }
}