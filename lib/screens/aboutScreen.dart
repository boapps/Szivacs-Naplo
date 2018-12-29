import 'dart:ui';
import 'package:flutter/material.dart';
import '../GlobalDrawer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../globals.dart' as globals;
import 'package:dynamic_theme/dynamic_theme.dart';

void main() {
  runApp(new MaterialApp(home: new AboutScreen()));
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
          title: new Text("e-Szivacs 2"),
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
                        'e-Szivacs',
                        style: new TextStyle(fontSize: 28.0,),
                        textAlign: TextAlign.center,
                      ),
                      padding: EdgeInsets.only(bottom: 30.0),
                    ),
                    new Row(
                      children: <Widget>[
                        new Text(
                          'verzió: ',
                          style: new TextStyle(fontSize: 22.0, ),
                        ),
                        new Text(' 2.0',
                          style: new TextStyle(fontSize: 22.0, color: Colors.blue),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    Container(
                      child: new Row(
                        children: <Widget>[
                          new Text(
                            'készítette: ',
                            style: new TextStyle(fontSize: 22.0, ),
                          ),
                          new Text(' BoA',
                            style: new TextStyle(fontSize: 22.0, color: Colors.blue),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    ),
                    new Row(
                      children: <Widget>[
                        new Text(
                          'made with: ',
//                                    style: Theme.of(context).textTheme.title,
                          style: new TextStyle(fontSize: 22.0, ),
                        ),
                        new Text(' Flutter',
                          style: new TextStyle(fontSize: 22.0, color: Colors.blue),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    new FlatButton(onPressed: _launchYTURL,
                        child: new Row(
                          children: <Widget>[
                            new Container(
                              child: new Icon(IconData(0xf5c3, fontFamily: "Material Design Icons"), color: Colors.red, size: 20.0,),
                              padding: EdgeInsets.all(5.0),
                            ),
                            new Text(
                              "YouTube", style: new TextStyle(color: Colors.red, fontSize: 20.0,),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                    ),
                    new FlatButton(onPressed: _launchTelURL,
                        child: new Row(
                          children: <Widget>[
                            new Container(
                              child: new Icon(IconData(0xf501, fontFamily: "Material Design Icons"), color: Colors.blue, size: 20.0,),
                              padding: EdgeInsets.all(5.0),
                            ),
                            new Text(
                              "Telegram", style: new TextStyle(color: Colors.blue, fontSize: 20.0,),
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
                              "eSzivacs@gmail.com",
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
                              "GitHub", style: new TextStyle(fontSize: 20.0,),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        )
                    ),
                    new FlatButton(onPressed: _launchIGURL,
                        child: new Row(
                          children: <Widget>[
                            new Container(
                              child: new Icon(IconData(0xf2fe,
                                  fontFamily: "Material Design Icons"),
                                color: Colors.pink, size: 20.0,),
                              padding: EdgeInsets.all(5.0),
                            ),
                            new Text(
                              "Instagram", style: new TextStyle(
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

  _launchYTURL() async {
    const url = 'https://www.youtube.com/channel/UC1V9Sdq4RlYjzZEkB9bzwrA';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  _launchTelURL() async {
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

  _launchIGURL() async {
    const url = 'https://www.instagram.com/e_szivacs/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
