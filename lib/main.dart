import 'dart:convert' show utf8, json;
import 'dart:io';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:background_fetch/background_fetch.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'PageRouteBuilder.dart';
import 'Datas/Institution.dart';
import 'Datas/User.dart';
import 'Helpers/RequestHelper.dart';
import 'Helpers/UserInfoHelper.dart';
import 'Helpers/LocaleHelper.dart';
import 'Helpers/SettingsHelper.dart';
import 'Utils/AccountManager.dart';
import 'globals.dart' as globals;
import 'screens/accountsScreen.dart';
import 'screens/aboutScreen.dart';
import 'screens/absentsScreen.dart';
import 'screens/evaluationsScreen.dart';
import 'screens/homeworkScreen.dart';
import 'screens/mainScreen.dart';
import 'screens/notesScreen.dart';
import 'screens/settingsScreen.dart';
import 'screens/statisticsScreen.dart';
import 'screens/timeTableScreen.dart';
import 'Utils/Saver.dart' as Saver;
import 'Datas/Account.dart';

bool isNew = true;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey(
    debugLabel: "Main Navigator");

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => new ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.blue[700],
          accentColor: Colors.blueAccent,
//          primarySwatch: Color.fromARGB(255, 25, 117, 208),
          brightness: brightness,
          fontFamily: 'Quicksand',
        ),
        themedWidgetBuilder: (context, theme) {
          return new MaterialApp(
            localizationsDelegates: [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
            supportedLocales: [Locale("hu"), Locale("en")],
            locale: globals.lang != "auto" ? Locale(globals.lang) : null,
            onGenerateTitle: (BuildContext context) =>
            AppLocalizations.of(context).title,
            title: "e-Szivacs 2",
            theme: theme,
            routes: <String, WidgetBuilder>{
              '/main': (_) => new MainScreen(),
              '/accept': (_) => new WelcomeAcceptState(),
              '/login': (_) => new LoginScreen(),
              '/about': (_) => new AboutScreen(),
              '/timetable': (_) => new TimeTableScreen(),
              '/homework': (_) => new HomeworkScreen(),
              '/evaluations': (_) => new EvaluationsScreen(),
              '/notes': (_) => new NotesScreen(),
              '/absents': (_) => new AbsentsScreen(),
              '/accounts': (_) => new AccountsScreen(),
              '/settings': (_) => new SettingsScreen(),
              '/statistics': (_) => new StatisticsScreen(),
            },
            navigatorKey: navigatorKey,
            home: isNew ? new LogoApp() : MainScreen(),
          );
        }
    );
  }
}

void main() async {
  List<User> users = await AccountManager().getUsers();
  isNew = (users.isEmpty);
  globals.isLogo = await SettingsHelper().getLogo();
  globals.isSingle = await SettingsHelper().getSingleUser();
  globals.lang = await SettingsHelper().getLang();

  if (!isNew) {
    BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
    SettingsHelper().getRefreshNotification().then((int integer) {
      BackgroundFetch.configure(BackgroundFetchConfig(
        minimumFetchInterval: integer,
        stopOnTerminate: false,
        forceReload: false,
        enableHeadless: true,
        startOnBoot: true,
      ), backgroundFetchHeadlessTask);
    });

    globals.isColor = await SettingsHelper().getColoredMainPage();
    globals.isSingle = await SettingsHelper().getSingleUser();
    globals.multiAccount = (await Saver.readUsers()).length != 1;
    globals.users = users;
    globals.accounts = List();
    for (User user in users)
      globals.accounts.add(Account(user));
    globals.selectedAccount = globals.accounts[0];
    globals.selectedUser = users[0];
  }

  runApp(MyApp());
}

class LogoApp extends StatefulWidget {
  _LogoAppState createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
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
                    "e-Szivacs",
                    style: TextStyle(
                        fontSize: 40.0,
                        color: Color.fromARGB(animation.value.toInt(), 0, 0, 0)),
                  ),
                  new Text(
                    " 2",
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
                    SlideLeftRoute(widget: WelcomeAcceptState()),
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

class WelcomeAcceptState extends StatelessWidget {
  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
        body: new Center(
            child: new Column(
      children: <Widget>[

        new Container(
          child: new FloatingActionButton(
            onPressed: () {
              Navigator.push(
                ctxt,
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
            child: new Text(
              "Ez egy nonprofit kliens alkalmazás az e-Kréta rendszerhez. \n\nMivel az appot nem az eKRÉTA Informatikai Zrt. készítette, ha ötleted van az appal kapcsolatban, kérlek ne az ő ügyfélszolgálatukat terheld, inkább írj nekünk egy e-mailt: \n\neszivacs@gmail.com\n",
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

LoginScreenState loginScreenState = new LoginScreenState();

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => loginScreenState;
}

Icon helpIconSwitch = new Icon(
  Icons.help,
  color: Colors.white12,
);
bool helpSwitch = false;

void helpToggle() {
  helpSwitch = !helpSwitch;
  if (helpSwitch) {
    helpIconSwitch = new Icon(
      Icons.help,
      color: Colors.white,
    );
  } else {
    helpIconSwitch = new Icon(
      Icons.help,
      color: Colors.white12,
    );
  }
}

void showToggle() {
  showSwitch = !showSwitch;
  if (showSwitch) {
    showIconSwitch = new Icon(
      Icons.remove_red_eye,
      color: Colors.white,
    );
  } else {
    showIconSwitch = new Icon(
      Icons.remove_red_eye,
      color: Colors.white12,
    );
  }
}

Icon showIconSwitch = new Icon(
  Icons.remove_red_eye,
  color: Colors.white12,
);
bool showSwitch = false;

String userName = "";
String password = "";

String userError;
String passwordError;
bool schoolSelected = true;

double kbSize = null;

bool isDialog = false;

bool loggingIn = false;

final userNameController = new TextEditingController();
final passwordController = new TextEditingController();

class LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    loggingIn = false;
    super.initState();
  }


  void initJson() async {
    final String data =
        await DefaultAssetBundle.of(context).loadString("assets/data.json");

    globals.jsonres = json.decode(data);

    globals.jsonres.sort((dynamic a, dynamic b) {
      return a["Name"].toString().compareTo(b["Name"].toString());
    });

    globals.searchres = json.decode(data);

    globals.searchres.sort((dynamic a, dynamic b) {
      return a["Name"].toString().compareTo(b["Name"].toString());
    });

    if (isDialog) {
      myDialogState.setState(() {});
    }
  }

  void login(BuildContext context) async {
    userError = null;
    passwordError = null;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        password = passwordController.text;
        userName = userNameController.text;
        print(userName);
        print(password);
        userError = null;
        passwordError = null;
        schoolSelected = true;
        http.Response bearerResp;
        String code;
        if (userName == "") {
          userError = "Kérlek add meg a felhasználónevedet!";
          setState(() {
            loggingIn = false;
          });
        } else if (password == "") {
          setState(() {
            loggingIn = false;
          });
          passwordError = "Kérlek add meg a jelszavadat!";
        } else if (globals.selectedSchoolUrl == "") {
          setState(() {
            loggingIn = false;
          });
          schoolSelected = false;
        } else {
          //iskolák lekérése

          //bejelentkezés

          String instCode = globals.selectedSchoolCode; //suli kódja
          print(instCode);
          String jsonBody = "institute_code=" +
              instCode +
              "&userName=" +
              userName +
              "&password=" +
              password +
              "&grant_type=password&client_id=919e0c1c-76a2-4646-a2fb-7085bbbf3c56";
          print(jsonBody);

          try {
            bearerResp =
            await RequestHelper().getBearer(jsonBody, instCode);
            print(bearerResp.body);
            Map<String, dynamic> bearerMap = json.decode(bearerResp.body);
            print(bearerMap);
            code = bearerMap.values.toList()[0];

            Map<String, String> userInfo =
            await UserInfoHelper().getInfo(instCode, userName, password);

            setState(() {
              User user = new User(
                  int.parse(userInfo["StudentId"]),
                  userName,
                  password,
                  userInfo["StudentName"],
                  instCode,
                  globals.selectedSchoolUrl,
                  globals.selectedSchoolName,
                  userInfo["ParentName"],
                  userInfo["ParentId"]);
              AccountManager().addUser(user);

              globals.users.add(user);

              globals.multiAccount = globals.users.length != 1;

              globals.selectedUser = user;

              Navigator.pushNamed(context, "/main");
            });
          } catch (e) {
            setState(() {
              loggingIn = false;
            });
            print(e);
            setState(() {
              print(code);
              if (code == "invalid_grant") {
                passwordError = "hibás felasználónév vagy jelszó";
              } else if (bearerResp.statusCode == 403) {
                passwordError = "hibás felasználónév vagy jelszó";
              } else if (code == "invalid_password") {
                passwordError = "hibás felasználónév vagy jelszó";
              } else {
                passwordError = "hálózati probléma";
              }
            });
          }
        }
      } else {
        setState(() {
          loggingIn = false;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        loggingIn = false;
      });
      passwordError = "nincs internet";
    }

  }

  void showSelectDialog() {
    setState(() {
      myDialogState = new MyDialogState();
      showDialog<Institution>(
          context: context,
          builder: (BuildContext context) {
            return new MyDialog();
          });
    });

  }

  void setStateHere() {
    setState(() {
      globals.selectedSchoolName;
    });
  }

  @override
  Widget build(BuildContext context) {
    initJson();

    return new WillPopScope(
        onWillPop: (){},
        child: Scaffold(
            body: new Container(
                color: Colors.black87,
                child: new Center(
                    child: !loggingIn ? new Container(
                        child: new ListView(
                  reverse: true,
                  padding: EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 20.0),
                  children: <Widget>[
                    new Container(
                      padding: new EdgeInsets.only(left: 40.0, right: 40.0),
                      child: Image.asset("assets/icon.png"),
                      height: kbSize,
                    ),
                    new Container(
                        margin: EdgeInsets.only(top: 5.0),
                        child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              new Flexible(
                                child: new TextFormField(
                                  style: TextStyle(color: Colors.white),
                                  controller: userNameController,
                                  decoration: InputDecoration(
                                    prefixIcon: new Icon(Icons.person),
                                    hintText: "felhasználónév",
                                    hintStyle: TextStyle(color: Colors.white30),
                                    errorText: userError,
                                    fillColor: Color.fromARGB(40, 20, 20, 30),
                                    filled: true,
                                    helperText: helpSwitch
                                        ? "oktatási azonosító 11-jegyű diákigazolványszám"
                                        : null,
                                    helperStyle:
                                        TextStyle(color: Colors.white30),
                                    contentPadding: EdgeInsets.fromLTRB(
                                        5.0, 15.0, 5.0, 15.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        gapPadding: 1.0,
                                        borderSide: BorderSide(
                                          color: Colors.green,
                                          width: 2.0,
                                        )),
                                  ),
                                ),
                              ),
                              new IconButton(
                                  icon: helpIconSwitch,
                                  onPressed: () {
                                    setState(() {
                                      helpToggle();
                                    });
                                  })
                            ])),
                    new Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: new Row(children: <Widget>[
                          new Flexible(
                            child: new TextFormField(
                              style: TextStyle(color: Colors.white),
                              controller: passwordController,
                              keyboardType: TextInputType.text,
                              obscureText: !showSwitch,
                              decoration: InputDecoration(
                                prefixIcon: new Icon(Icons.https),
                                hintStyle: TextStyle(color: Colors.white30),
                                hintText: "jelszó",
                                errorText: passwordError,
                                fillColor: Color.fromARGB(40, 20, 20, 30),
                                filled: true,
                                helperText: helpSwitch
                                    ? "általában a születési dátum(pl.: 2000-01-02)"
                                    : null,
                                helperStyle: TextStyle(color: Colors.white30),
                                contentPadding:
                                    EdgeInsets.fromLTRB(5.0, 15.0, 5.0, 15.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    gapPadding: 1.0,
                                    borderSide: BorderSide(
                                      color: Colors.deepOrange,
                                      width: 2.0,
                                    )),
                              ),
                            ),
                          ),
                          new IconButton(
                              icon: showIconSwitch,
                              onPressed: () {
                                setState(() {
                                  showToggle();
                                });
                              }),
                        ])),
                    new Column(children: <Widget>[
                      new Container(
                        margin: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
                        padding: new EdgeInsets.fromLTRB(10.0, 4.0, 10.0, 4.0),
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Color.fromARGB(40, 20, 20, 30),
                          border: new Border.all(
                            color: schoolSelected ? Colors.black87 : Colors.red,
                            width: 1.0,
                          ),
                        ),
                        child: new Row(
                          children: <Widget>[
                            new Text(
                              "Iskola: ",
                              style: new TextStyle(
                                  fontSize: 21.0, color: Colors.white30),
                            ),
                            new Expanded(
                              child: new FlatButton(
                                onPressed: (){
                                  showSelectDialog();
                                  setState(() {
                                    globals.selectedSchoolName;
                                  });
                                },
                                child: new Text(
                                  globals.selectedSchoolName,
                                  style: new TextStyle(
                                      fontSize: 21.0, color: Colors.blue),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      !schoolSelected
                          ? new Text(
                              "Válassz egy iskolát is",
                              style: new TextStyle(color: Colors.red),
                            )
                          : new Container()
                    ]),
                    new Container(
                        margin: EdgeInsets.only(top: 20.0),
                        child: new FlatButton(
                          onPressed: !loggingIn ? () {
                            setState(() {
                              loggingIn = true;
                              login(context);
                            });
                          } : null,
                          disabledColor: Colors.blueGrey.shade800,
                          disabledTextColor: Colors.blueGrey,
                          child: new Text("Bejelentkezés"),
                          color: Colors.blue, //#2196F3
                          textColor: Colors.white,
                        )),
                  ].reversed.toList(),
                        )) : new Container(
                      child: new CircularProgressIndicator(),
                    )
                )
            )));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
//    passwordController.dispose();
//    userNameController.dispose();
    super.dispose();
  }
}

class MyDialog extends StatefulWidget {
//  List newList;

  const MyDialog();

  @override
  State createState() {
    globals.searchres = globals.jsonres;
    return myDialogState;
  }


}

MyDialogState myDialogState = new MyDialogState();

class MyDialogState extends State<MyDialog> {

  @override
  void dispose() {
//    this.dispose();
    // Clean up the controller when the Widget is disposed
//    passwordController.dispose();
//    userNameController.dispose();
//    myDialogState.dispose();
    isDialog=false;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    isDialog = true;
  }

  Widget build(BuildContext context) {
    return new SimpleDialog(
      title: new Text("Válassz iskolát:"),
      contentPadding: const EdgeInsets.all(10.0),
      children: <Widget>[
        new Container(
          child: new TextField(
              maxLines: 1,
              autofocus: true,
              onChanged: (String search) {
                setState(() {
                  updateSearch(search);
                });
              }),
          margin: new EdgeInsets.all(10.0),
        ),
        new Container(
          child: globals.searchres != null ? new ListView.builder(
            itemBuilder: _itemBuilder,
            itemCount: globals.searchres.length,
          ) : new Container(),
          width: 320.0,
          height: 400.0,
        )
      ],
    );
  }

  void updateSearch(String searchText) {
    setState(() {
      globals.searchres.clear();
      globals.searchres.addAll(globals.jsonres);
    });

    if (searchText != "") {
      setState(() {
        globals.searchres.removeWhere((dynamic element) => !element
            .toString()
            .toLowerCase()
            .contains(searchText.toLowerCase()));
      });
    }
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return new Column(
      children: <Widget>[
        ListTile(
          title: new Text(globals.searchres[index]["Name"]),
          subtitle: new Text(globals.searchres[index]["Url"]),
          onTap: () {
            globals.selectedSchoolCode =
            globals.searchres[index]["InstituteCode"];
            globals.selectedSchoolUrl = globals.searchres[index]["Url"];
            globals.selectedSchoolName = globals.searchres[index]["Name"];

            setState(() {
              Navigator.pop(context);
            });
//            isDialog=false;
            loginScreenState.setStateHere();

          },
        ),
        new Container(
          child: new Text(globals.searchres[index]["City"]),
          alignment: new Alignment(1.0, 0.0),
        )
      ],
    );
  }
}
