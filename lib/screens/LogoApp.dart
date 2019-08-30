import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import '../PageRouteBuilder.dart';
import 'package:e_szivacs/generated/i18n.dart';
import '../main.dart';
//todo refactor this
class LogoApp extends StatefulWidget {
  WelcomeNewUserState createState() => WelcomeNewUserState();
}

class WelcomeNewUserState extends State<LogoApp> with SingleTickerProviderStateMixin {
  Animation<double> animationFAB;
  Animation<double> animation;
  AnimationController controller;

  bool _visibility = false;

  initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween(begin: 0.0, end: 255.0).animate(controller)
      ..addListener(() {
        setState(() {
          if (animation.value == 255) _visibility = true;
        });
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
        body: new Center(
            child: new Container(
              child: Column(
                children: <Widget>[
                  new AspectRatio(
                    aspectRatio: 50,
                    child: new Container(
                      child: new Row(
                        children: <Widget>[
                          new Text(
                            S
                                .of(context)
                                .title,
                            style: TextStyle(
                                fontSize: 40.0,
                                color: Color.fromARGB(animation.value.toInt(), 0, 0, 0)),
                          ),
                          new Text(" " + S
                              .of(context)
                              .version_number,
                            style: TextStyle(
                                color:
                                Color.fromARGB(animation.value.toInt(), 68, 138, 255),
                                fontSize: 40.0),
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    ),
                  ),
                  new Container(
                    child: AnimatedOpacity(
                      opacity: _visibility ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 500),
                      child: new FloatingActionButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            SlideLeftRoute(widget: AcceptTermsState()),
                          );
                        },
                        backgroundColor: Color.fromARGB(255, 68, 138, 255),
                        child: new Icon(
                          Icons.navigate_next,
                          color: Colors.white,
                          size: 40.0,
                        ),
                      ),
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
            )));
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }
}

class AcceptTermsState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Center(
            child: new Column(
              children: <Widget>[
                new Container(
                  child: new FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        SlideLeftRoute(widget: LoginScreen()),
                      );
                    },
                    child: new Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 32.0,
                    ),
                    backgroundColor: Color.fromARGB(255, 68, 138, 255),
                  ),
                  padding: EdgeInsets.all(18.0),
                ),
                new Expanded(child:
                new Container(
                  alignment: Alignment(0, 0),
                  child: new SingleChildScrollView(
                    child: new Text(S
                        .of(context)
                        .disclaimer,
                      style: TextStyle(
                        fontSize: 21.0,
                      ),
                    ),
                    padding: EdgeInsets.all(40),
                  ),
                ),
                ),
              ],
              verticalDirection: VerticalDirection.up,
              mainAxisAlignment: MainAxisAlignment.end,
            )));
  }
}
