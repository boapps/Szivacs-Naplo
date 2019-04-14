import 'dart:ui';
import 'package:flutter/material.dart';
import '../GlobalDrawer.dart';
import 'dart:async';
import '../Helpers/SettingsHelper.dart';
import '../globals.dart' as globals;
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:background_fetch/background_fetch.dart';
import '../Datas/Evaluation.dart';
import '../Helpers/LocaleHelper.dart';
import '../Helpers/TimetableHelper.dart';
import '../Utils/StringFormatter.dart';
import '../Utils/AccountManager.dart';
import '../Datas/User.dart';
import '../Datas/Account.dart';
import '../Datas/Note.dart';
import '../Datas/Lesson.dart';
import '../Datas/Absence.dart';
import '../main.dart' as Main;
import '../Utils/ColorManager.dart';

void main() {
  runApp(new MaterialApp(home: new SettingsScreen()));
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

class SettingsScreen extends StatefulWidget {
  @override
  SettingsScreenState createState() => new SettingsScreenState();

}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

Future<int> getGrades() async {
  List<User> users = await AccountManager().getUsers();
  globals.accounts = List();
  for (User user in users)
    globals.accounts.add(Account(user));

  for (Account account in globals.accounts) {
    await account.refreshEvaluations(true, true);
    await account.refreshNotes(false, true);
    await account.refreshAbsents(false, true);
    List<Evaluation> offlineEvals = account.evaluations;
    List<Note> offlineNotes = account.notes;
    Map<String, List<Absence>> offlineAbsences = account.absents;
    await account.refreshEvaluations(true, false);
    await account.refreshNotes(false, false);
    await account.refreshAbsents(false, false);
    List<Note> notes = account.notes;
    List<Evaluation> evals = account.evaluations;
    Map<String, List<Absence>> absences = account.absents;

    for (Evaluation e in evals) {
      bool exist = false;
      for (Evaluation o in offlineEvals)
        if (e.id == o.id)
          exist = true;
      if (!exist) {
        var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
            'evaluations', 'jegyek', 'értesítések a jegyekről',
            importance: Importance.Max, priority: Priority.High, color: Colors.blue);
        var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
        var platformChannelSpecifics = new NotificationDetails(
            androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
        flutterLocalNotificationsPlugin.show(
            e.id,
            e.subject + " - " +
                (e.numericValue != 0 ? e.numericValue.toString() : e.value),
            e.owner.name + ", " + (e.theme ?? ""), platformChannelSpecifics,
            payload: e.id.toString());
      }

      //todo jegyek változása
      //todo új házik
      //todo ha óra elmarad/helyettesítés
    }

  for (Note n in notes) {
    bool exist = false;
    for (Note o in offlineNotes)
      if (n.id == o.id)
        exist = true;
    if (!exist) {
      var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
          'notes', 'feljegyzések', 'értesítések a feljegyzésekről',
          importance: Importance.Max, priority: Priority.High, style: AndroidNotificationStyle.BigText, color: Colors.blue);
      var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
      var platformChannelSpecifics = new NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
      flutterLocalNotificationsPlugin.show(
          n.id,
          n.title + " - " + n.type,
          n.content, platformChannelSpecifics,
          payload: n.id.toString());
    }
  }

  if(absences!=null)
  absences.forEach((String s, List<Absence> absenceList){
    for (Absence a in absenceList) {
      bool exist = false;
      offlineAbsences.forEach((String s2, List<Absence> absenceList2){
        for (Absence o in absenceList2)
          if (a.id == o.id)
            exist = true;
      });
      if (!exist) {
        var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
            'absences', 'mulasztások', 'értesítések a hiányzásokról',
            importance: Importance.Max, priority: Priority.High, color: Colors.blue, groupKey: account.user.id.toString() + a.type,);
        var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
        var platformChannelSpecifics = new NotificationDetails(
            androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
        flutterLocalNotificationsPlugin.show(
            a.id,
            a.subject + " " + a.typeName,
            a.owner.name + (a.delayMinutes != 0 ? (", " + a.delayMinutes.toString() + " perc késés"):""), platformChannelSpecifics,
            payload: a.id.toString(),);
      }
      }
  });

    DateTime startDate = new DateTime.now();
    startDate = startDate.add(
        new Duration(days: (-1 * startDate.weekday + 1)));

    List<Lesson> lessonsOffline = await getLessonsOffline(startDate, startDate.add(new Duration(days: 7)), account.user);
    List<Lesson> lessons = await getLessons(startDate, startDate.add(new Duration(days: 7)), account.user);

    for (Lesson lesson in lessons) {
      bool exist = false;
      for (Lesson offlineLesson in lessonsOffline){
        exist = (lesson.id == offlineLesson.id && ((lesson.isMissed && !offlineLesson.isMissed) || (lesson.isSubstitution && !offlineLesson.isSubstitution)));
      }
      if (exist) {
        var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
            'lessons', 'órák', 'értesítések elmaradt/helyettesített órákról',
            importance: Importance.Max, priority: Priority.High, style: AndroidNotificationStyle.BigText, color: Colors.blue);
        var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
        var platformChannelSpecifics = new NotificationDetails(
            androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
        flutterLocalNotificationsPlugin.show(
            lesson.id,
            lesson.subject + " " + lesson.date.toIso8601String().substring(0, 10) + " (" + dateToWeekDay(lesson.date) + ")",
            lesson.stateName + " " + lesson.depTeacher, platformChannelSpecifics,
            payload: lesson.id.toString());
      }
    }
  }
      return 0;
}

void backgroundFetchHeadlessTask() async {
  var initializationSettingsAndroid =
  new AndroidInitializationSettings('notification_icon');
  var initializationSettingsIOS = new IOSInitializationSettings();
  var initializationSettings = new InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await getGrades().then((int finished) {
    BackgroundFetch.finish();
  });
}

class SettingsScreenState extends State<SettingsScreen> {
  bool _isColor;
  bool _isDark;
  bool _amoled;
  bool _isNotification;
  bool _isLogo;
  bool _isSingleUser;
  String _lang = "auto";
  static const List<String> LANG_LIST = ["auto", "en", "hu"];

  final List<int> refreshArray = [15, 30, 60, 120, 360];
  int _refreshNotification;
  int _theme;

  void _initSet() async {

    _isColor = await SettingsHelper().getColoredMainPage();
    _isDark = await SettingsHelper().getDarkTheme();
    _isNotification = await SettingsHelper().getNotification();
    _isLogo = await SettingsHelper().getLogo();
    _refreshNotification = await SettingsHelper().getRefreshNotification();
    _isSingleUser = await SettingsHelper().getSingleUser();
    _lang = await SettingsHelper().getLang();
    _theme = await SettingsHelper().getTheme();
    _amoled = await SettingsHelper().getAmoled();

    setState(() {});
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    BackgroundFetch.configure(BackgroundFetchConfig(
      minimumFetchInterval: _refreshNotification,
      stopOnTerminate: false,
      forceReload: false,
      enableHeadless: true,
      startOnBoot: true,
    ), backgroundFetchHeadlessTask);
    if (!mounted) return;
  }

  @override
  void initState() {
    setState(() {
      _initSet();
    });
    super.initState();
  }

  void _isColorChange(bool value) {
    setState(() {
      _isColor = value;
      globals.isColor = value;
      SettingsHelper().setColoredMainPage(_isColor);
    });
  }

  void _isLogoChange(bool value) {
    setState(() {
      _isLogo = value;
      globals.isLogo = value;
      SettingsHelper().setLogo(_isLogo);
    });
  }

  void _setLang(String value) {
    setState(() {
      _lang = value;
      SettingsHelper().setLang(_lang);
      Main.main();
    });
  }

  void _refreshNotificationChange(int value) {
    setState(() {
      _refreshNotification = value;
      SettingsHelper().setRefreshNotification(_refreshNotification);
    });

    BackgroundFetch.configure(BackgroundFetchConfig(
      minimumFetchInterval: _refreshNotification,
      stopOnTerminate: false,
      forceReload: false,
      enableHeadless: true,
      startOnBoot: true,
    ), backgroundFetchHeadlessTask);
  }

  void _isNotificationChange(bool value) {
    setState(() {
      _isNotification = value;
      SettingsHelper().setNotification(_isNotification);
    });

    if (value) {
      BackgroundFetch.start().then((int status) {
        print('[BackgroundFetch] start success: $status');
      }).catchError((e) {
        print('[BackgroundFetch] start FAILURE: $e');
      });
    } else {
      BackgroundFetch.stop().then((int status) {
        print('[BackgroundFetch] stop success: $status');
      });
    }
  }

  void _isDarkChange(bool value) async {
    setState(() {
      _isDark = value;
      SettingsHelper().setDarkTheme(_isDark);
    });
    globals.isDark = _isDark;
    await DynamicTheme.of(context).setBrightness(value ? Brightness.dark: Brightness.light);
  }

  void _setAmoled(bool value) {
    setState(() {
      _amoled = value;
      SettingsHelper().setAmoled(_amoled);
    });
    globals.isAmoled = _amoled;
    DynamicTheme.of(context).setThemeData(ColorManager().getTheme(Theme.of(context).brightness));
  }

  void _themChange(int value) {
    setState(() {
      _theme = value;
      SettingsHelper().setTheme(_theme);
    });
    globals.themeID = _theme;
    DynamicTheme.of(context).setThemeData(ColorManager().getTheme(Theme.of(context).brightness));
  }

  void _isSingleUserChange(bool value) {
    setState(() {
      _isSingleUser = value;
      globals.isSingle = value;
      SettingsHelper().setSingleUser(_isSingleUser);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> themes = [AppLocalizations.of(context).blue, AppLocalizations.of(context).red, AppLocalizations.of(context).green, AppLocalizations.of(context).yellow, AppLocalizations.of(context).orange, AppLocalizations.of(context).grey];

    return new WillPopScope(
        onWillPop: () {
          globals.screen = 0;
          Navigator.pushReplacementNamed(context, "/main");
        },
        child: Scaffold(
          drawer: GDrawer(),
          appBar: new AppBar(
            title: new Text(AppLocalizations.of(context).settings),
            ),
          body: new Container(
            child: _isColor != null ? new ListView(
              children: <Widget>[
                ListTile(
                  title: new Text(AppLocalizations.of(context).colorful_mainpage,
                    style: TextStyle(
                        fontSize: 20.0
                    ),
                  ),
                  trailing: new Switch(
                    activeColor: Theme.of(context).accentColor,
                    value: _isColor,
                    onChanged: _isColorChange,
                  ),
                  leading: new Icon(IconData(0xf266, fontFamily: "Material Design Icons")),
                ),
                ListTile(
                  title: new Text(AppLocalizations.of(context).singleuser_mainpage,
                    style: TextStyle(
                        fontSize: 20.0
                    ),
                  ),
                  trailing: new Switch(
                    activeColor: Theme.of(context).accentColor,
                    value: _isSingleUser,
                    onChanged: _isSingleUserChange,
                  ),
                  leading: new Icon(Icons.person),
                ),
                ListTile(
                  title: new Text(AppLocalizations.of(context).dark_theme,
                    style: TextStyle(
                        fontSize: 20.0
                    ),
                  ),
                  trailing: new Switch(
                    activeColor: Theme.of(context).accentColor,
                    value: _isDark,
                    onChanged: _isDarkChange,
                  ),
                  leading: new Icon(IconData(0xf50e, fontFamily: "Material Design Icons")),
                ),
                ListTile(
                  title: new Text("Amoled",
                    style: TextStyle(
                        fontSize: 20.0
                    ),
                  ),
                  enabled: _isDark,
                  trailing: new Switch(
                    activeColor: Theme.of(context).accentColor,
                    value: _amoled,
                    onChanged: _isDark ? _setAmoled : null,
                  ),
                  leading: new Icon(IconData(0xf301, fontFamily: "Material Design Icons")),
                ),
                ListTile(
                  title: new PopupMenuButton<int>(
                    child: new ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: new Text(AppLocalizations.of(context).color + ": " + themes[_theme],
                        style: TextStyle(
                            fontSize: 20.0
                        ),
                      ),
                    ),
                    onSelected: _themChange,
                    itemBuilder: (BuildContext context) {
                      return [0, 1, 2, 3, 4, 5].map((int integer) {
                        return new PopupMenuItem<int>(
                            value: integer,
                            child: new Row(
                              children: <Widget>[
                                new Text(themes[integer]),
                                new Container(decoration: ShapeDecoration(shape: CircleBorder(), color: ColorManager().getColorSample(integer)),height: 16, width: 16, margin: EdgeInsets.only(left: 4),)
                              ],
                            )
                        );
                      }).toList();
                    },
                  ),
                  leading: new Icon(Icons.color_lens),
                ),

                ListTile(
                  title: new Text(AppLocalizations.of(context).notification,
                    style: TextStyle(
                        fontSize: 20.0
                    ),
                  ),
                  trailing: new Switch(
                    activeColor: Theme.of(context).accentColor,
                    value: _isNotification,
                    onChanged: _isNotificationChange,
                  ),
                  leading: new Icon(
                      IconData(0xf09a, fontFamily: "Material Design Icons")),
                ),
                _isNotification ? new PopupMenuButton<int>(
                  child: new ListTile(
                    title: new Text(AppLocalizations.of(context).sync_frequency(_refreshNotification),
                      style: TextStyle(
                          fontSize: 20.0
                      ),
                    ),
                    leading: new Icon(
                        IconData(0xf4e6, fontFamily: "Material Design Icons")),
                  ),
                  onSelected: _refreshNotificationChange,
                  itemBuilder: (BuildContext context) {
                    return refreshArray.map((int integer) {
                      return new PopupMenuItem<int>(
                          value: integer,
                          child: new Row(
                            children: <Widget>[
                              new Text(integer.toString() + " " + AppLocalizations.of(context).minute),
                            ],
                          )
                      );
                    }).toList();
                  },
                ) : new ListTile(
                  title: new Text(AppLocalizations.of(context).sync_frequency(_refreshNotification),
                    style: TextStyle(
                        fontSize: 20.0
                    ),
                  ),
                  enabled: false,
                  leading: new Icon(
                      IconData(0xf4e6, fontFamily: "Material Design Icons")),
                ),
                ListTile(
                  title: new Text(AppLocalizations.of(context).logo_menu,
                    style: TextStyle(
                        fontSize: 20.0
                    ),
                  ),
                  trailing: new Switch(
                    activeColor: Theme.of(context).accentColor,
                    value: _isLogo,
                    onChanged: _isLogoChange,
                  ),
                  leading: new Icon(
                      IconData(0xf6fb, fontFamily: "Material Design Icons")),
                ),
                ListTile(
                  title: new Text(AppLocalizations.of(context).language,
                    style: TextStyle(
                        fontSize: 20.0
                    ),
                  ),
                  trailing: new Container(child: new DropdownButton<String>(items: LANG_LIST.map((String l){
                    return DropdownMenuItem<String>(child: Text(l, textAlign: TextAlign.end,), value: l,);
                  }).toList(), onChanged: _setLang,value: _lang,),height: 50, width: 120,alignment: Alignment(1, 0),),
                  leading: new Icon(
                      IconData(0xf1e7, fontFamily: "Material Design Icons")),
                ),
                new ListTile(
                  leading: new Icon(Icons.info),
                  title: new Text(AppLocalizations.of(context).info),
                  onTap: () {
                    Navigator.pushNamed(context, "/about");
                  },
                ),
                new ListTile(
                  leading: new Icon(Icons.import_export),
                  title: new Text("Export"),
                  onTap: () {
                    Navigator.pushNamed(context, "/export");
                  },
                ),
              ],
              padding: EdgeInsets.all(10),
            ):new Container(),
          ),
      )
    );
    }
}