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
import '../Helpers/EvaluationHelper.dart';
import '../Datas/Evaluation.dart';

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
  List<Evaluation> offlineEvals = await EvaluationHelper()
      .getEvaluationsOffline();
  List<Evaluation> evals = await EvaluationHelper().getEvaluations();

  for (Evaluation e in evals) {
    bool exist = false;
    for (Evaluation o in offlineEvals)
      if (e.id == o.id)
        exist = true;
    if (!exist) {
      var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
          'evaluations', 'jegyek', 'értesítések a jegyekről',
          importance: Importance.Max, priority: Priority.High);
      var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
      var platformChannelSpecifics = new NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          e.id,
          e.subject + " - " + e.numericValue.toString(),
          e.owner.name, platformChannelSpecifics,
          payload: e.id.toString());
    }
  }

  return 0;
}

void backgroundFetchHeadlessTask() async {
  var initializationSettingsAndroid =
  new AndroidInitializationSettings('icon');
  var initializationSettingsIOS = new IOSInitializationSettings();
  var initializationSettings = new InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(initializationSettings);

  print('[BackgroundFetch] Headless event received.');
  print("working2");
  await getGrades().then((int finished) {
    BackgroundFetch.finish();
  });
}

class SettingsScreenState extends State<SettingsScreen> {
  bool _isColor;
  bool _isDark;
  bool _isNotification;
  bool _isLogo;

  final List<int> refreshArray = [15, 30, 60, 120, 360];
  int _refreshNotification;

  void _initSet() async {

    _isColor = await SettingsHelper().getColoredMainPage();
    _isDark = await SettingsHelper().getDarkTheme();
    _isNotification = await SettingsHelper().getNotification();
    _isLogo = await SettingsHelper().getLogo();
    _refreshNotification = await SettingsHelper().getRefreshNotification();

    setState(() {
      _isColor;
      _isDark;
      _isNotification;
      _isLogo;
      _refreshNotification;
    });

    initPlatformState();
  }

  Future<void> initPlatformState() async {
    BackgroundFetch.configure(BackgroundFetchConfig(
      minimumFetchInterval: _refreshNotification,
      stopOnTerminate: false,
      forceReload: true,
      enableHeadless: true,
      startOnBoot: true,
    ), () {
      backgroundFetchHeadlessTask();
    });
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
      SettingsHelper().setColoredMainPage(_isColor);
    });
  }

  void _isLogoChange(bool value) {
    setState(() {
      _isLogo = value;
      SettingsHelper().setLogo(_isLogo);
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
      forceReload: true,
      enableHeadless: true,
      startOnBoot: true,
    ), () {
      backgroundFetchHeadlessTask();
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

  void _isDarkChange(bool value) {
    setState(() {
      _isDark = value;
      SettingsHelper().setDarkTheme(_isDark);
    });
    DynamicTheme.of(context).setBrightness(value ? Brightness.dark: Brightness.light);
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () {
          globals.screen = 0;
          Navigator.pushReplacementNamed(context, "/main");
        },
        child: Scaffold(
          drawer: GDrawer(),
          appBar: new AppBar(
              title: new Text("Beállítások"),
            ),
          body: new Container(
            child: _isColor != null ? new ListView(
              children: <Widget>[
                ListTile(
                  title: new Text("Színes főoldal",
                    style: TextStyle(
                        fontSize: 20.0
                    ),
                  ),
                  trailing: new Switch(
                    activeColor: Colors.blueAccent,
                    value: _isColor,
                    onChanged: _isColorChange,
                  ),
                  leading: new Icon(IconData(0xf266, fontFamily: "Material Design Icons")),
                ),
                ListTile(
                  title: new Text("Sötét téma",
                    style: TextStyle(
                        fontSize: 20.0
                    ),
                  ),
                  trailing: new Switch(
                    activeColor: Colors.blueAccent,
                    value: _isDark,
                    onChanged: _isDarkChange,
                  ),
                  leading: new Icon(IconData(0xf50e, fontFamily: "Material Design Icons")),
                ),
                ListTile(
                  title: new Text("Értesítés",
                    style: TextStyle(
                        fontSize: 20.0
                    ),
                  ),
                  trailing: new Switch(
                    activeColor: Colors.blueAccent,
                    value: _isNotification,
                    onChanged: _isNotificationChange,
                  ),
                  leading: new Icon(
                      IconData(0xf09a, fontFamily: "Material Design Icons")),
                ),
                _isNotification ? new PopupMenuButton<int>(
                  child: new ListTile(
                    title: new Text("Szinkronizálás gyakorisága: " +
                        _refreshNotification.toString() + " perc",
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
                              new Text(integer.toString() + " perc"),
                            ],
                          )
                      );
                    }).toList();
                  },
                ) : new ListTile(
                  title: new Text("Szinkronizálás gyakorisága: " +
                      _refreshNotification.toString() + " perc",
                    style: TextStyle(
                        fontSize: 20.0
                    ),
                  ),
                  enabled: false,
                  leading: new Icon(
                      IconData(0xf4e6, fontFamily: "Material Design Icons")),
                ),
                ListTile(
                  title: new Text("Logó a menüben",
                    style: TextStyle(
                        fontSize: 20.0
                    ),
                  ),
                  trailing: new Switch(
                    activeColor: Colors.blueAccent,
                    value: _isLogo,
                    onChanged: _isLogoChange,
                  ),
                  leading: new Icon(
                      IconData(0xf6fb, fontFamily: "Material Design Icons")),
                ),
                ListTile(
                  title: new Text("Changelog (még nem működik)",
                    style: TextStyle(
                        fontSize: 20.0
                    ),
                  ),
                  leading: new Icon(
                      IconData(0xf2da, fontFamily: "Material Design Icons")),
                ),
                new ListTile(
                  leading: new Icon(Icons.info),
                  title: new Text("Infó"),
                  onTap: () {
                    Navigator.pushNamed(context, "/about");
                  },
                ),
              ],
            ):new Container(),
            padding: EdgeInsets.all(10.0),
          ),
      )
    );
    }
}