import 'dart:ui';
import 'package:flutter/material.dart';
import '../GlobalDrawer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Helpers/LocaleHelper.dart';
import '../globals.dart' as globals;
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(new MaterialApp(
    home: new AboutScreen(),
    localizationsDelegates: [
      AppLocalizationsDelegate(),
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate
    ],
    supportedLocales: [Locale("hu"), Locale("en")],
    onGenerateTitle: (BuildContext context) =>
    AppLocalizations.of(context).title,
  ));
}

class AboutScreen extends StatefulWidget {
  @override
  AboutScreenState createState() => new AboutScreenState();
}

class AboutScreenState extends State<AboutScreen> {

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () {
          globals.screen = 0;
          Navigator.pushReplacementNamed(context, "/settings");
        },
        child: Scaffold(
            drawer: GDrawer(),
        appBar: new AppBar(
          backgroundColor: globals.isDark ? Color.fromARGB(255, 25, 25, 25) : Colors.blue[700],
          title: new Text(AppLocalizations.of(context).title),
          actions: <Widget>[
          ],
        ),
        body:
            new Center(
              child: Container(
                child: new ListView(
                  padding: EdgeInsets.all(20),
                  children: <Widget>[
                    new Container(
                      child: new Text(
                        AppLocalizations.of(context).title,
                        style: new TextStyle(fontSize: 28.0,),
                        textAlign: TextAlign.center,
                      ),
                      padding: EdgeInsets.only(bottom: 30.0),
                    ),
                    new Row(
                      children: <Widget>[
                        new Text(
                          AppLocalizations.of(context).version,
                          style: new TextStyle(fontSize: 22.0, ),
                        ),
                        new Text(AppLocalizations.of(context).version_number,
                          style: new TextStyle(fontSize: 22.0, color: Colors.blue),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    Container(
                      child: new Row(
                        children: <Widget>[
                          new Text(
                            AppLocalizations.of(context).made_by,
                            style: new TextStyle(fontSize: 22.0, ),
                          ),
                          new Text(AppLocalizations.of(context).boa,
                            style: new TextStyle(fontSize: 22.0, color: Colors.blue),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    ),
                    new Row(
                      children: <Widget>[
                        new Text(
                          AppLocalizations.of(context).made_with,
//                                    style: Theme.of(context).textTheme.title,
                          style: new TextStyle(fontSize: 22.0, ),
                        ),
                        new Text(AppLocalizations.of(context).flutter,
                          style: new TextStyle(fontSize: 22.0, color: Colors.blue),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    new FlatButton(onPressed: _launchYoutubeURL,
                        child: new Row(
                          children: <Widget>[
                            new Container(
                              child: new Icon(IconData(0xf5c3, fontFamily: "Material Design Icons"),
                                color: Colors.red, size: 20.0,),
                              padding: EdgeInsets.all(5.0),
                            ),
                            new Text(
                              AppLocalizations.of(context).youtube, style: new TextStyle(color: Colors.red, fontSize: 20.0,),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                    ),
                    new FlatButton(onPressed: _launchTelegramURL,
                        child: new Row(
                          children: <Widget>[
                            new Container(
                              child: new Icon(IconData(0xf501, fontFamily: "Material Design Icons"), color: Colors.blue, size: 20.0,),
                              padding: EdgeInsets.all(5.0),
                            ),
                            new Text(
                              AppLocalizations.of(context).telegram, style: new TextStyle(color: Colors.blue, fontSize: 20.0,),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        )
                    ),
                    new FlatButton(onPressed: _launchGmailURL,
                        child: new Row(
                          children: <Widget>[
                            new Container(
                              child: new Icon(IconData(0xf2ab, fontFamily: "Material Design Icons"), color: Colors.red, size: 20.0,),
                              padding: EdgeInsets.all(5.0),
                            ),
                            new Text(
                              AppLocalizations.of(context).email,
                              style: new TextStyle(
                                color: Colors.red,
                                fontSize: 20.0,),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        )
                    ),
                    new FlatButton(onPressed: _launchGithubURL,
                        child: new Row(
                          children: <Widget>[
                            new Container(
                              child: new Icon(IconData(0xf2a4, fontFamily: "Material Design Icons"), color: Colors.black, size: 20.0,),
                              padding: EdgeInsets.all(5.0),
                            ),
                            new Text(
                              AppLocalizations.of(context).github, style: new TextStyle(fontSize: 20.0,),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        )
                    ),
                    new FlatButton(onPressed: _launchInstagramURL,
                        child: new Row(
                          children: <Widget>[
                            new Container(
                              child: new Icon(IconData(0xf2fe,
                                  fontFamily: "Material Design Icons"),
                                color: Colors.pink, size: 20.0,),
                              padding: EdgeInsets.all(5.0),
                            ),
                            new Text(
                              AppLocalizations.of(context).instagram, style: new TextStyle(
                              color: Colors.pink, fontSize: 20.0,),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        )
                    ),
                  ],
                ),
              ),
            ),
        )
    );
  }

  _launchYoutubeURL() async {
    const url = 'https://www.youtube.com/channel/UC1V9Sdq4RlYjzZEkB9bzwrA';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  _launchTelegramURL() async {
    const url = 'https://t.me/eSzivacs';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  _launchGmailURL() async {
    const url = 'mailto:eSzivacs@gmail.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  _launchGithubURL() async {
    const url = 'https://github.com/boapps/e-Szivacs-2';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchInstagramURL() async {
    const url = 'https://www.instagram.com/e_szivacs/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
