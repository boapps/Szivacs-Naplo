import 'dart:async';
import 'dart:ui';

import 'package:background_fetch/background_fetch.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:e_szivacs/generated/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../Datas/Account.dart';
import '../Datas/Lesson.dart';
import '../Datas/Note.dart';
import '../Datas/Student.dart';
import '../Datas/User.dart';
import '../GlobalDrawer.dart';
import '../Helpers/BackgroundHelper.dart';
import '../Helpers/SettingsHelper.dart';
import '../Helpers/TimetableHelper.dart';
import '../Utils/AccountManager.dart';
import '../Utils/ColorManager.dart';
import '../Utils/StringFormatter.dart';
import '../globals.dart' as globals;
import '../main.dart' as Main;

void main() {
  runApp(new MaterialApp(home: new SettingsScreen()));
  BackgroundHelper().register();
}

class SettingsScreen extends StatefulWidget {
  @override
  SettingsScreenState createState() => new SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  bool _isColor;
  bool _isDark;
  bool _amoled;
  bool _isNotification;
  bool _isLogo;
  bool _isSingleUser;
  bool _canSyncOnData;
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
    _canSyncOnData = await SettingsHelper().getCanSyncOnData();

    setState(() {});
  }

  @override
  void initState() {
    setState(() {
      _initSet();
    });
    BackgroundHelper().configure();
    super.initState();
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  new FlutterLocalNotificationsPlugin();

  void backgroundFetchHeadlessTask() async {
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('notification_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    await backgroundTask().then((int finished) {
      BackgroundFetch.finish();
    });
  }

  Future<bool> get canSyncOnData async =>
      await SettingsHelper().getCanSyncOnData();

  void doEvaluations(Account account) async {
    await account.refreshStudentString(true);
    List<Evaluation> offlineEvals = account.student.Evaluations;
    await account.refreshStudentString(false);
    List<Evaluation> evals = account.student.Evaluations;

    for (Evaluation e in evals) {
      bool exist = false;
      for (Evaluation o in offlineEvals)
        if (e.trueID() == o.trueID()) exist = true;
      if (!exist) {
        var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
            'evaluations', 'jegyek', 'értesítések a jegyekről',
            importance: Importance.Max,
            priority: Priority.High,
            color: Colors.blue);
        var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
        var platformChannelSpecifics = new NotificationDetails(
            androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
        flutterLocalNotificationsPlugin.show(
            e.trueID(),
            e.Subject +
                " - " +
                (e.NumberValue != 0 ? e.NumberValue.toString() : e.Value),
            e.owner.name + ", " + (e.Theme ?? ""),
            platformChannelSpecifics,
            payload: e.trueID().toString());
      }

      //todo jegyek változása
      //todo új házik
      //todo ha óra elmarad/helyettesítés
    }
  }

  void doNotes(Account account) async {
    await account.refreshStudentString(true);
    List<Note> offlineNotes = account.notes;
    await account.refreshStudentString(false);
    List<Note> notes = account.notes;

    for (Note n in notes) {
      bool exist = false;
      for (Note o in offlineNotes)
        if (n.id == o.id) exist = true;
      if (!exist) {
        var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
            'notes', 'feljegyzések', 'értesítések a feljegyzésekről',
            importance: Importance.Max,
            priority: Priority.High,
            style: AndroidNotificationStyle.BigText,
            color: Colors.blue);
        var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
        var platformChannelSpecifics = new NotificationDetails(
            androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
        flutterLocalNotificationsPlugin.show(
            n.id, n.title + " - " + n.type, n.content, platformChannelSpecifics,
            payload: n.id.toString());
      }
    }
  }

  void doAbsences(Account account) async {
    await account.refreshStudentString(true);
    Map<String, List<Absence>> offlineAbsences = account.absents;
    await account.refreshStudentString(false);
    Map<String, List<Absence>> absences = account.absents;

    if (absences != null)
      absences.forEach((String date, List<Absence> absenceList) {
        for (Absence absence in absenceList) {
          bool exist = false;
          offlineAbsences
              .forEach((String dateOffline, List<Absence> absenceList2) {
            for (Absence offlineAbsence in absenceList2)
              if (absence.AbsenceId == offlineAbsence.AbsenceId) exist = true;
          });
          if (!exist) {
            var androidPlatformChannelSpecifics =
            new AndroidNotificationDetails(
              'absences',
              'mulasztások',
              'értesítések a hiányzásokról',
              importance: Importance.Max,
              priority: Priority.High,
              color: Colors.blue,
              groupKey: account.user.id.toString() + absence.Type,
            );
            var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
            var platformChannelSpecifics = new NotificationDetails(
                androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
            flutterLocalNotificationsPlugin.show(
              absence.AbsenceId,
              absence.Subject + " " + absence.TypeName,
              absence.owner.name +
                  (absence.DelayTimeMinutes != 0
                      ? (", " +
                      absence.DelayTimeMinutes.toString() +
                      " perc késés")
                      : ""),
              platformChannelSpecifics,
              payload: absence.AbsenceId.toString(),
            );
          }
        }
      });
  }

  void doLessons(Account account) async {
    DateTime startDate = new DateTime.now();
    startDate = startDate.add(new Duration(days: (-1 * startDate.weekday + 1)));

    List<Lesson> lessonsOffline = await getLessonsOffline(
        startDate, startDate.add(new Duration(days: 7)), account.user);
    List<Lesson> lessons = await getLessons(
        startDate, startDate.add(new Duration(days: 7)), account.user);

    for (Lesson lesson in lessons) {
      bool exist = false;
      for (Lesson offlineLesson in lessonsOffline) {
        exist = (lesson.id == offlineLesson.id &&
            ((lesson.isMissed && !offlineLesson.isMissed) ||
                (lesson.isSubstitution && !offlineLesson.isSubstitution)));
      }
      if (exist) {
        var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
            'lessons', 'órák', 'értesítések elmaradt/helyettesített órákról',
            importance: Importance.Max,
            priority: Priority.High,
            style: AndroidNotificationStyle.BigText,
            color: Colors.blue);
        var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
        var platformChannelSpecifics = new NotificationDetails(
            androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
        flutterLocalNotificationsPlugin.show(
            lesson.id,
            lesson.subject +
                " " +
                lesson.date.toIso8601String().substring(0, 10) +
                " (" +
                dateToWeekDay(lesson.date) +
                ")",
            lesson.stateName + " " + lesson.depTeacher,
            platformChannelSpecifics,
            payload: lesson.id.toString());
      }
    }
  }

  void doBackground() async {
    try {
      List accounts = List();
      for (User user in await AccountManager().getUsers())
        accounts.add(Account(user));
      for (Account account in globals.accounts) {
        doEvaluations(account);
        doNotes(account);
        doAbsences(account);
        doLessons(account);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<int> backgroundTask() async {
    await Connectivity()
        .checkConnectivity()
        .then((ConnectivityResult result) async {
      if (result == ConnectivityResult.mobile && await canSyncOnData ||
          result == ConnectivityResult.wifi) doBackground();
    });

    return 0;
  }

  void _setLang(String value) {
    setState(() {
      _lang = value;
      SettingsHelper().setLang(_lang);
      Main.main();
    });
  }

  void _setAmoled(bool value) {
    setState(() {
      _amoled = value;
      SettingsHelper().setAmoled(_amoled);
    });
    globals.isAmoled = _amoled;
    DynamicTheme.of(context)
        .setThemeData(ColorManager().getTheme(Theme
        .of(context)
        .brightness));
  }

  void _refreshNotificationChange(int value) async {
    setState(() {
      _refreshNotification = value;
      SettingsHelper().setRefreshNotification(_refreshNotification);
    });

    await BackgroundHelper().configure();
  }

  void _isLogoChange(bool value) {
    setState(() {
      _isLogo = value;
      globals.isLogo = value;
      SettingsHelper().setLogo(_isLogo);
    });
  }

  void _isColorChange(bool value) {
    setState(() {
      _isColor = value;
      globals.isColor = value;
      SettingsHelper().setColoredMainPage(_isColor);
    });
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
    await DynamicTheme.of(context)
        .setBrightness(value ? Brightness.dark : Brightness.light);
  }

  void _themChange(int value) {
    setState(() {
      _theme = value;
      SettingsHelper().setTheme(_theme);
    });
    globals.themeID = _theme;
    DynamicTheme.of(context)
        .setThemeData(ColorManager().getTheme(Theme
        .of(context)
        .brightness));
  }

  void _isSingleUserChange(bool value) {
    setState(() {
      _isSingleUser = value;
      globals.isSingle = value;
      SettingsHelper().setSingleUser(_isSingleUser);
    });
  }

  void _isCanSyncOnDataChange(bool value) {
    setState(() {
      _canSyncOnData = value;
      globals.canSyncOnData = value;
      SettingsHelper().setCanSyncOnData(_canSyncOnData);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> themes = [
      S
          .of(context)
          .blue,
      S
          .of(context)
          .red,
      S
          .of(context)
          .green,
      "világosabb zöld",
      S
          .of(context)
          .yellow,
      S
          .of(context)
          .orange,
      S
          .of(context)
          .grey,
      "rózsaszín",
      "lila",
      "kékeszöld"
    ];

    return new WillPopScope(
        onWillPop: () {
          globals.screen = 0;
          Navigator.pushReplacementNamed(context, "/main");
        },
        child: Scaffold(
          drawer: GDrawer(),
          appBar: new AppBar(
            title: new Text(S
                .of(context)
                .settings),
          ),
          body: new Container(
            child: _isColor != null
                ? new ListView(
              children: <Widget>[
                ListTile(
                  title: new Text(
                    S
                        .of(context)
                        .colorful_mainpage,
                    style: TextStyle(fontSize: 20.0),
                  ),
                  trailing: new Switch(
                    activeColor: Theme
                        .of(context)
                        .accentColor,
                    value: _isColor,
                    onChanged: _isColorChange,
                  ),
                  leading: new Icon(IconData(0xf266,
                      fontFamily: "Material Design Icons")),
                ),
                ListTile(
                  title: new Text(
                    S
                        .of(context)
                        .singleuser_mainpage,
                    style: TextStyle(fontSize: 20.0),
                  ),
                  trailing: new Switch(
                    activeColor: Theme
                        .of(context)
                        .accentColor,
                    value: _isSingleUser,
                    onChanged: _isSingleUserChange,
                  ),
                  leading: new Icon(Icons.person),
                ),
                ListTile(
                  title: new Text(
                    S
                        .of(context)
                        .dark_theme,
                    style: TextStyle(fontSize: 20.0),
                  ),
                  trailing: new Switch(
                    activeColor: Theme
                        .of(context)
                        .accentColor,
                    value: _isDark,
                    onChanged: _isDarkChange,
                  ),
                  leading: new Icon(IconData(0xf50e,
                      fontFamily: "Material Design Icons")),
                ),
                ListTile(
                  title: new Text(
                    S
                        .of(context)
                        .color + " (" + S
                        .of(context)
                        .evaluations + ")",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, "/evalcolor");
                  },
                  leading: new Icon(IconData(0xf50e,
                      fontFamily: "Material Design Icons")),
                ),
                ListTile(
                  title: new Text(
                    "Amoled",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  enabled: _isDark,
                  trailing: new Switch(
                    activeColor: Theme
                        .of(context)
                        .accentColor,
                    value: _amoled,
                    onChanged: _isDark ? _setAmoled : null,
                  ),
                  leading: new Icon(IconData(0xf301,
                      fontFamily: "Material Design Icons")),
                ),
                ListTile(
                  title: new PopupMenuButton<int>(
                    child: new ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: new Text(
                        S
                            .of(context)
                            .color + ": " + themes[_theme],
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    onSelected: _themChange,
                    itemBuilder: (BuildContext context) {
                      return [0, 1, 2, 3, 4, 5, 6, 7, 8, 9].map((int integer) {
                        return new PopupMenuItem<int>(
                            value: integer,
                            child: new Row(
                              children: <Widget>[
                                new Container(
                                  decoration: ShapeDecoration(
                                      shape: CircleBorder(),
                                      color: ColorManager()
                                          .getColorSample(integer)),
                                  height: 16,
                                  width: 16,
                                  margin: EdgeInsets.only(right: 4),
                                ),
                                new Text(themes[integer]),
                              ],
                            ));
                      }).toList();
                    },
                  ),
                  leading: new Icon(Icons.color_lens),
                ),
                ListTile(
                  title: new Text(
                    S
                        .of(context)
                        .notification,
                    style: TextStyle(fontSize: 20.0),
                  ),
                  trailing: new Switch(
                    activeColor: Theme
                        .of(context)
                        .accentColor,
                    value: _isNotification,
                    onChanged: _isNotificationChange,
                  ),
                  leading: new Icon(IconData(0xf09a,
                      fontFamily: "Material Design Icons")),
                ),
                SwitchListTile(
                  title: new Text(
                    S
                        .of(context)
                        .sync_on_data,
                    style: TextStyle(fontSize: 20.0),
                  ),
                  value: _canSyncOnData,
                  activeColor: Theme
                      .of(context)
                      .accentColor,
                  onChanged:
                  _isNotification ? _isCanSyncOnDataChange : null,
                  secondary: new Icon(Icons.network_locked),
                ),
                _isNotification
                    ? new PopupMenuButton<int>(
                  child: new ListTile(
                    title: new Text(
                      S
                          .of(context)
                          .sync_frequency
                          .replaceFirst(
                          "{{ mins }}",
                          _refreshNotification.toString()),
                      style: TextStyle(fontSize: 20.0),
                    ),
                    leading: new Icon(IconData(0xf4e6,
                        fontFamily: "Material Design Icons")),
                  ),
                  onSelected: _refreshNotificationChange,
                  itemBuilder: (BuildContext context) {
                    return refreshArray.map((int integer) {
                      return new PopupMenuItem<int>(
                          value: integer,
                          child: new Row(
                            children: <Widget>[
                              new Text(integer.toString() +
                                  " " +
                                  S
                                      .of(context)
                                      .minute),
                            ],
                          ));
                    }).toList();
                  },
                )
                    : new ListTile(
                  title: new Text(
                    S
                        .of(context)
                        .sync_frequency
                        .replaceFirst(
                        "{{ mins }}",
                        _refreshNotification.toString()),
                    style: TextStyle(fontSize: 20.0),
                  ),
                  enabled: false,
                  leading: new Icon(IconData(0xf4e6,
                      fontFamily: "Material Design Icons")),
                ),
                ListTile(
                  title: new Text(
                    S
                        .of(context)
                        .logo_menu,
                    style: TextStyle(fontSize: 20.0),
                  ),
                  trailing: new Switch(
                    activeColor: Theme
                        .of(context)
                        .accentColor,
                    value: _isLogo,
                    onChanged: _isLogoChange,
                  ),
                  leading: new Icon(IconData(0xf6fb,
                      fontFamily: "Material Design Icons")),
                ),
                ListTile(
                  title: new Text(
                    S
                        .of(context)
                        .language,
                    style: TextStyle(fontSize: 20.0),
                  ),
                  trailing: new Container(
                    child: new DropdownButton<String>(
                      items: LANG_LIST.map((String l) {
                        return DropdownMenuItem<String>(
                          child: Text(
                            l,
                            textAlign: TextAlign.end,
                          ),
                          value: l,
                        );
                      }).toList(),
                      onChanged: _setLang,
                      value: _lang,
                    ),
                    height: 50,
                    width: 120,
                    alignment: Alignment(1, 0),
                  ),
                  leading: new Icon(IconData(0xf1e7,
                      fontFamily: "Material Design Icons")),
                ),
                new ListTile(
                  leading: new Icon(Icons.info),
                  title: new Text(S
                      .of(context)
                      .info),
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
            )
                : new Container(),
          ),
        ));
  }
}
