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
          Navigator.pushReplacementNamed(context, "/main");
        },
        child: Scaffold(
        drawer: GlobalDrawer(context),
        appBar: new AppBar(
          title: new Text("e-Szivacs 2"),
          actions: <Widget>[
          ],
          /* bottom: new PreferredSize(
              child: new LinearProgressIndicator(
                value: 0.7,
              ),
              preferredSize: null),*/
        ),
        body: new Stack(
          children: <Widget>[
            new ConstrainedBox(
                constraints: const BoxConstraints.expand(),
                child: Image.asset("assets/noise.webp",fit: BoxFit.fill,),
            ),

            new Container(
              child: new Center(
                child: new Container(
                  color: Colors.white12,
                  child: new BackdropFilter(
                    filter: new ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                    child: new Container(
                      decoration: new BoxDecoration(
                          color: Colors.white30.withOpacity(0.5)
                      ),
                      child: new Center(
                        
                        child: new SingleChildScrollView(
                        padding: EdgeInsets.all(40.0),
                          child: new Container(
                          child: new Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new Container(
                                child: new Text(
                                  'e-Szivacs',
                                  style: new TextStyle(fontSize: 22.0, color: Colors.black87),
                                ),
                                padding: EdgeInsets.only(bottom: 30.0),
                              ),
                              new Row(
                                children: <Widget>[
                                  new Text(
                                    'verzió: ',
                                    style: new TextStyle(fontSize: 22.0, color: Colors.black87),
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
                                    style: new TextStyle(fontSize: 22.0, color: Colors.black87),
                                  ),
                                  new Text(' BoA',
                                    style: new TextStyle(fontSize: 22.0, color: Colors.blue),
                                  ),
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                                color: Colors.white,
                              ),
                              new Row(
                                children: <Widget>[
                                  new Text(
                                    'made with: ',
//                                    style: Theme.of(context).textTheme.title,
                                    style: new TextStyle(fontSize: 22.0, color: Colors.black87),
                                  ),
                                  new Text(' Flutter',
                                    style: new TextStyle(fontSize: 22.0, color: Colors.blue),
                                  ),
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
//                              new Container(
//                                padding: EdgeInsets.only(top: 20.0),
//                                child: new Row(
//                                  children: <Widget>[
//                                    new Icon(Icons.live_tv, color: Colors.red,),
//                                    new FlatButton(onPressed: emailPressed, child: new Text("YouTube", style: new TextStyle(color: Colors.red, fontSize: 20.0,),)),
//                                  ],
//                                  crossAxisAlignment: CrossAxisAlignment.center,
//                                  mainAxisAlignment: MainAxisAlignment.center,
//                                ),
//                                alignment: new Alignment(0.0, 0.0),
//                              ),
//                              new Container(
//                                child: new Row(
//                                  children: <Widget>[
//                                    new Icon(Icons.email, color: Colors.green,),
//                                    new FlatButton(onPressed: emailPressed, child: new Text("e-szivacs@gmail.com", style: new TextStyle(color: Colors.green, fontSize: 20.0,),)),
//                                  ],
//                                  crossAxisAlignment: CrossAxisAlignment.center,
//                                  mainAxisAlignment: MainAxisAlignment.center,
//                                ),
//                              ),
                              new FlatButton(onPressed: _launchYTURL,
                                        child: new Row(
                                           children: <Widget>[
                                             new Container(
//                                               child: new Icon(Icons.message, color: Colors.blue, size: 20.0,),
                                               child: new Icon(IconData(0xf5c3, fontFamily: "Material Design Icons"), color: Colors.red, size: 20.0,),
                                               padding: EdgeInsets.all(5.0),
                                             ),
                                             new Text(
                                               "YouTube", style: new TextStyle(color: Colors.red, fontSize: 20.0,),
                                             ),
                                           ],
                                          mainAxisAlignment: MainAxisAlignment.center,
                                        )
                                    ),
                              new FlatButton(onPressed: _launchTelURL,
                                  child: new Row(
                                    children: <Widget>[
                                      new Container(
//                                               child: new Icon(Icons.message, color: Colors.blue, size: 20.0,),
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
//                                               child: new Icon(Icons.message, color: Colors.blue, size: 20.0,),
                                               child: new Icon(IconData(0xf2ab, fontFamily: "Material Design Icons"), color: Colors.red, size: 20.0,),
                                               padding: EdgeInsets.all(5.0),
                                             ),
                                             new Text(
                                               "e-szivacs@gmail.com", style: new TextStyle(color: Colors.red, fontSize: 20.0,),
                                             ),
                                           ],
                                          mainAxisAlignment: MainAxisAlignment.center,
                                        )
                                    ),
                              new FlatButton(onPressed: _launchGithubURL,
                                        child: new Row(
                                           children: <Widget>[
                                             new Container(
//                                               child: new Icon(Icons.message, color: Colors.blue, size: 20.0,),
                                               child: new Icon(IconData(0xf2a4, fontFamily: "Material Design Icons"), color: Colors.black, size: 20.0,),
                                               padding: EdgeInsets.all(5.0),
                                             ),
                                             new Text(
                                               "GitHub", style: new TextStyle(color: Colors.black, fontSize: 20.0,),
                                             ),
                                           ],
                                          mainAxisAlignment: MainAxisAlignment.center,
                                        )
                                    ),
//                                alignment: Alignment(0.0, 0.0),

                            ],
//                            crossAxisAlignment: CrossAxisAlignment.center,
                        ),
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),color: Colors.white, boxShadow: [
                              new BoxShadow(
                                color: Colors.black26,
                                blurRadius: 25.0,
                              ),
                            ]),

                          ),
                      ),
                    ),
                    ),
                  ),
                  ),
              ),
              ),
    ]
        )

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
}
