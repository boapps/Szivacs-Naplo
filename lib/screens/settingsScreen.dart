import 'dart:async';
import 'dart:ui';

import 'package:background_fetch/background_fetch.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:e_szivacs/generated/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../GlobalDrawer.dart';
import '../Helpers/BackgroundHelper.dart';
import '../Helpers/SettingsHelper.dart';
import '../Utils/ColorManager.dart';
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
  bool nextLesson;
  String _lang = "auto";
  static const List<String> LANG_LIST = ["auto", "en", "hu"];

  final List<int> refreshArray = [15, 30, 60, 120, 360];
  int _refreshNotification;
  int _theme;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

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
    nextLesson = await SettingsHelper().getNextLesson();

    setState(() {});
  }

  @override
  void initState() {
    setState(() {
      _initSet();
    });
    BackgroundHelper().configure();
    super.initState();
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('notification_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<bool> get canSyncOnData async =>
      await SettingsHelper().getCanSyncOnData();

  void _setNextLesson(bool value) async {
    setState(() {
      nextLesson = value;
      SettingsHelper().setNextLesson(nextLesson);
      flutterLocalNotificationsPlugin.cancel(0);
    });
  }

  void _setLang(String value) {
    setState(() {
      _lang = value;
      SettingsHelper().setLang(_lang);
      runApp(Main.MyApp());
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
        Fluttertoast.showToast(
            msg: S.of(context).success,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }).catchError((e) {
        Fluttertoast.showToast(
            msg: S.of(context).notification_failed,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
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
      S
          .of(context)
          .color_lightgreen,
      S
          .of(context)
          .yellow,
      S
          .of(context)
          .orange,
      S
          .of(context)
          .grey,
      S
          .of(context)
          .color_pink,
      S
          .of(context)
          .color_purple,
      S
          .of(context)
          .color_teal
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
                SwitchListTile(
                  title: new Text(
                    S.of(context).colorful_mainpage,
                    style: TextStyle(fontSize: 20.0),
                  ),
                  activeColor: Theme.of(context).accentColor,
                  value: _isColor,
                  onChanged: _isColorChange,
                  secondary: new Icon(IconData(0xf266,
                      fontFamily: "Material Design Icons")),
                ),
                SwitchListTile(
                  title: new Text(
                    S.of(context).singleuser_mainpage,
                    style: TextStyle(fontSize: 20.0),
                  ),
                  activeColor: Theme.of(context).accentColor,
                  value: _isSingleUser,
                  onChanged: _isSingleUserChange,
                  secondary: new Icon(Icons.person),
                ),
                SwitchListTile(
                  title: new Text(
                    S.of(context).dark_theme,
                    style: TextStyle(fontSize: 20.0),
                  ),
                  activeColor: Theme.of(context).accentColor,
                  value: _isDark,
                  onChanged: _isDarkChange,
                  secondary: new Icon(IconData(0xf50e, fontFamily: "Material Design Icons")),
                ),
                SwitchListTile(
                  title: new Text(
                    "Amoled",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  activeColor: Theme.of(context).accentColor,
                  value: _isDark ? _amoled : false,
                  onChanged: _isDark ? _setAmoled : null,
                  secondary: new Icon(IconData(0xf301,
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
                  leading: new Icon(Icons.color_lens),
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
                SwitchListTile(
                  title: new Text(
                    S.of(context).notification,
                    style: TextStyle(fontSize: 20.0),
                  ),
                  activeColor: Theme.of(context).accentColor,
                  value: _isNotification,
                  onChanged: _isNotificationChange,
                  secondary: new Icon(IconData(0xf09a,
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
/*
                SwitchListTile(
                  title: new Text(
                    "Következő óra",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  value: nextLesson,
                  activeColor: Theme
                      .of(context)
                      .accentColor,
                  onChanged: _isNotification ? _setNextLesson : null,
                  secondary: new Icon(Icons.access_time),
                ),
*/
                _isNotification
                    ? new PopupMenuButton<int>(
                  child: new ListTile(
                    title: new Text(
                      S.of(context).sync_frequency(
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
                    S.of(context).sync_frequency(
                        _refreshNotification.toString()),
                    style: TextStyle(fontSize: 20.0),
                  ),
                  enabled: false,
                  leading: new Icon(IconData(0xf4e6,
                      fontFamily: "Material Design Icons")),
                ),
                SwitchListTile(
                  title: new Text(
                    S
                        .of(context)
                        .logo_menu,
                    style: TextStyle(fontSize: 20.0),
                  ),
                  onChanged: _isLogoChange,
                  value: _isLogo,
                  activeColor: Theme.of(context).accentColor,
                  secondary: new Icon(IconData(0xf6fb,
                      fontFamily: "Material Design Icons"),
                  ),
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
