import 'dart:ui';
import 'package:flutter/material.dart';
import '../GlobalDrawer.dart';
import '../Helpers/SettingsHelper.dart';
import '../Helpers/BackgroundHelper.dart';
import '../globals.dart' as globals;
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/services.dart';
import 'package:background_fetch/background_fetch.dart';
import '../Helpers/LocaleHelper.dart';
import '../main.dart' as Main;
import '../Utils/ColorManager.dart';

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
    await BackgroundHelper().configure();
  }


  @override
  void initState() {
    setState(() {
      _initSet();
    });
    super.initState();
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
    DynamicTheme.of(context).setThemeData(ColorManager().getTheme(Theme.of(context).brightness));
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
    await DynamicTheme.of(context).setBrightness(value ? Brightness.dark: Brightness.light);
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

  void _isCanSyncOnDataChange(bool value) {
    setState(() {
      _canSyncOnData = value;
      globals.canSyncOnData = value;
      SettingsHelper().setCanSyncOnData(_canSyncOnData);
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
                SwitchListTile(
                  title: new Text(AppLocalizations.of(context).sync_on_data,
                    style: TextStyle(
                        fontSize: 20.0
                    ),
                  ),
                  value: _canSyncOnData,
                  activeColor: Theme.of(context).accentColor,
                  onChanged: _isNotification ? _isCanSyncOnDataChange:null,
                  secondary: new Icon(
                      Icons.network_locked),
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