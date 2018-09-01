import 'dart:ui';
import 'package:flutter/material.dart';
import '../GlobalDrawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'dart:convert' show utf8, json;
import 'dart:io';
import '../Helpers/SettingsHelper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../globals.dart' as globals;
import 'package:dynamic_theme/dynamic_theme.dart';

void main() {
  runApp(new MaterialApp(home: new SettingsScreen()));
}

class SettingsScreen extends StatefulWidget {
  @override
  SettingsScreenState createState() => new SettingsScreenState();

}


class SettingsScreenState extends State<SettingsScreen> {

  bool _isColor;
  bool _isDark;

  void _initSet() async {
    _isColor = await SettingsHelper().getColoredMainPage();
    _isDark = await SettingsHelper().getDarkTheme();

    setState(() {
      _isColor;
      _isDark;
    });
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
          drawer: GlobalDrawer(context),
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
                    value: _isDark,
                    onChanged: _isDarkChange,
                  ),
                  leading: new Icon(IconData(0xf50e, fontFamily: "Material Design Icons")),
                ),
              ],
            ):new Container(),
            padding: EdgeInsets.all(10.0),
          ),
      )
    );
    }


}