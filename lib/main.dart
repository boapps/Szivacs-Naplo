import 'dart:convert' show json;
import 'dart:io';
import 'dart:math';

import 'package:background_fetch/background_fetch.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:e_szivacs/generated/i18n.dart';
import 'package:e_szivacs/screens/messageScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';

import 'Datas/Account.dart';
import 'Datas/Institution.dart';
import 'Datas/User.dart';
import 'Helpers/BackgroundHelper.dart';
import 'Helpers/DBHelper.dart';
import 'Helpers/RequestHelper.dart';
import 'Helpers/SettingsHelper.dart';
import 'Helpers/UserInfoHelper.dart';
import 'Helpers/encrypt_codec.dart';
import 'Utils/AccountManager.dart';
import 'Utils/ColorManager.dart';
import 'Utils/Saver.dart' as Saver;
import 'globals.dart' as globals;
import 'screens/LogoApp.dart';
import 'screens/aboutScreen.dart';
import 'screens/absentsScreen.dart';
import 'screens/accountsScreen.dart';
import 'screens/battleroyalScreen.dart';
import 'screens/evaluationColorSettingsScreen.dart';
import 'screens/evaluationsScreen.dart';
import 'screens/exportScreen.dart';
import 'screens/homeworkScreen.dart';
import 'screens/importScreen.dart';
import 'screens/mainScreen.dart';
import 'screens/notesScreen.dart';
import 'screens/settingsScreen.dart';
import 'screens/statisticsScreen.dart';
import 'screens/studentScreen.dart';
import 'screens/timeTableScreen.dart';

bool isNew = true;

final GlobalKey<NavigatorState> navigatorKey =
GlobalKey(debugLabel: "Main Navigator");

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => ColorManager().getTheme(brightness),
        themedWidgetBuilder: (context, theme) {
          return new MaterialApp(
            localizationsDelegates: const <LocalizationsDelegate>[
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            locale: globals.lang != "auto" ? Locale(globals.lang) : null,
            onGenerateTitle: (BuildContext context) => S.of(context).title,
            title: "e-Szivacs 2",
            theme: theme,
            routes: <String, WidgetBuilder>{
              '/main': (_) => new MainScreen(),
              '/accept': (_) => new AcceptTermsState(),
              '/login': (_) => new LoginScreen(),
              '/about': (_) => new AboutScreen(),
              '/timetable': (_) => new TimeTableScreen(),
              '/homework': (_) => new HomeworkScreen(),
              '/evaluations': (_) => new EvaluationsScreen(),
              '/notes': (_) => new NotesScreen(),
              '/messages': (_) => new MessageScreen(),
              '/absents': (_) => new AbsentsScreen(),
              '/accounts': (_) => new AccountsScreen(),
              '/settings': (_) => new SettingsScreen(),
              '/statistics': (_) => new StatisticsScreen(),
              '/export': (_) => new ExportScreen(),
              '/import': (_) => new ImportScreen(),
              '/easteregg': (_) => new BattleRoyaleScreen(),
              '/evalcolor': (_) => new colorSettingsScreen(),
              '/student': (_) => new StudentScreen(),
            },
            navigatorKey: navigatorKey,
            home: isNew ? new LogoApp() : MainScreen(),
          );
        });
  }
}

// todo refactor this and separate the 3 screens here

void main() async {
  final storage = new FlutterSecureStorage();
  String value = await storage.read(key: "db_key");
  if (value == null) {
    int randomNumber = Random.secure().nextInt(4294967296);
    await storage.write(key: "db_key", value: randomNumber.toString());
    value = await storage.read(key: "db_key");
  }

  var codec = getEncryptSembastCodec(password: value);

  globals.db = await globals.dbFactory.openDatabase(
      (await DBHelper().localFolder) + DBHelper().dbPath,
      codec: codec);
  if (await Saver.shouldMigrate) {
    Saver.migrate();
  } else {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    globals.version = packageInfo.version;
    List<User> users = await AccountManager().getUsers();
    isNew = (users.isEmpty);
    globals.isLogo = await SettingsHelper().getLogo();
    globals.isSingle = await SettingsHelper().getSingleUser();
    globals.lang = await SettingsHelper().getLang();

    if (!isNew) {
      //BackgroundHelper().register();

      globals.isDark = await SettingsHelper().getDarkTheme();
      globals.isAmoled = await SettingsHelper().getAmoled();
      globals.isColor = await SettingsHelper().getColoredMainPage();
      globals.isSingle = await SettingsHelper().getSingleUser();
      globals.multiAccount = (await Saver.readUsers()).length != 1;
      globals.users = users;
      globals.accounts = List();
      for (User user in users)
        globals.accounts.add(Account(user));
      globals.selectedAccount = globals.accounts[0];
      globals.selectedUser = users[0];
      globals.themeID = await SettingsHelper().getTheme();

      globals.color1 = await SettingsHelper().getEvalColor(0);
      globals.color2 = await SettingsHelper().getEvalColor(1);
      globals.color3 = await SettingsHelper().getEvalColor(2);
      globals.color4 = await SettingsHelper().getEvalColor(3);
      globals.color5 = await SettingsHelper().getEvalColor(4);
    }

    runApp(MyApp());
    BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  }
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

  await BackgroundHelper().backgroundTask().then((int finished) {
    BackgroundFetch.finish();
  });
}

LoginScreenState loginScreenState = new LoginScreenState();

class LoginScreen extends StatefulWidget {
  LoginScreen({this.fromApp});

  bool fromApp = false;

  @override
  LoginScreenState createState() => LoginScreenState();
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

double kbSize;

bool isDialog = false;

bool loggingIn = false;

final userNameController = new TextEditingController();
final passwordController = new TextEditingController();

class LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    loggingIn = false;
    super.initState();

    initJson();
/*
    DynamicTheme.of(context).setBrightness(Brightness.light).then((void a){
      setStateHere();
    });
*/
  }

  void initJson() async {
    String data = "";//await DefaultAssetBundle.of(context).loadString("assets/data.json");

    data = await RequestHelper().getInstitutes();

    globals.jsonres = json.decode(data);

    print(globals.jsonres.length);

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
        userError = null;
        passwordError = null;
        schoolSelected = true;
        http.Response bearerResp;
        String code;
        if (userName == "") {
          userError = S
              .of(context)
              .choose_username;
          setState(() {
            loggingIn = false;
          });
        } else if (password == "") {
          setState(() {
            loggingIn = false;
          });
          passwordError = S
              .of(context)
              .choose_password;
        } else if (globals.selectedSchoolUrl == "") {
          setState(() {
            loggingIn = false;
          });
          schoolSelected = false;
        } else {
          String instCode = globals.selectedSchoolCode; //suli kódja
          String jsonBody = "institute_code=" +
              instCode +
              "&userName=" +
              userName +
              "&password=" +
              password +
              "&grant_type=password&client_id=919e0c1c-76a2-4646-a2fb-7085bbbf3c56";

          try {
            bearerResp = await RequestHelper().getBearer(jsonBody, instCode);
            Map<String, dynamic> bearerMap = json.decode(bearerResp.body);
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

              globals.accounts = List();
              for (User user in globals.users)
                globals.accounts.add(Account(user));
              globals.selectedAccount = globals.accounts
                  .firstWhere((Account account) => account.user.id == user.id);
              globals.selectedUser = user;

              Navigator.pushNamed(context, "/main");
            });
          } catch (e) {
            setState(() {
              loggingIn = false;
            });
            print(e);
            setState(() {
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
          }).then((dynamic){
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return new WillPopScope(
        onWillPop: () {
          if (widget.fromApp)
            Navigator.pushReplacementNamed(context, "/accounts");
        },
        child: Scaffold(
            body: new Container(
                color: Colors.black87,
                child: new Center(
                    child: !loggingIn
                        ? new Container(
                        child: new ListView(
                          reverse: true,
                          padding:
                          EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 20.0),
                          children: <Widget>[
                            new Container(
                              padding: new EdgeInsets.only(
                                  left: 40.0, right: 40.0),
                              child: Image.asset("assets/icon.png"),
                              height: kbSize,
                            ),
                            new Container(
                                margin: EdgeInsets.only(top: 5.0),
                                child: new Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      new Flexible(
                                        child: new TextFormField(
                                          style:
                                          TextStyle(color: Colors.white),
                                          controller: userNameController,
                                          decoration: InputDecoration(
                                            prefixIcon:
                                            new Icon(Icons.person),
                                            hintText: S
                                                .of(context)
                                                .username,
                                            hintStyle: TextStyle(
                                                color: Colors.white30),
                                            errorText: userError,
                                            fillColor: Color.fromARGB(
                                                40, 20, 20, 30),
                                            filled: true,
                                            helperText: helpSwitch
                                                ? S
                                                .of(context)
                                                .username_hint
                                                : null,
                                            helperStyle: TextStyle(
                                                color: Colors.white30),
                                            contentPadding:
                                            EdgeInsets.fromLTRB(
                                                5.0, 15.0, 5.0, 15.0),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    5.0),
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
                                        hintStyle:
                                        TextStyle(color: Colors.white30),
                                        hintText: S
                                            .of(context)
                                            .password,
                                        errorText: passwordError,
                                        fillColor:
                                        Color.fromARGB(40, 20, 20, 30),
                                        filled: true,
                                        helperText: helpSwitch
                                            ? S
                                            .of(context)
                                            .password_hint
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
                                margin: new EdgeInsets.fromLTRB(
                                    0.0, 10.0, 0.0, 5.0),
                                padding: new EdgeInsets.fromLTRB(
                                    10.0, 4.0, 10.0, 4.0),
                                decoration: new BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Color.fromARGB(40, 20, 20, 30),
                                  border: new Border.all(
                                    color: schoolSelected
                                        ? Colors.black87
                                        : Colors.red,
                                    width: 1.0,
                                  ),
                                ),
                                child: new Row(
                                  children: <Widget>[
                                    new Text(
                                      S
                                          .of(context)
                                          .school,
                                      style: new TextStyle(
                                          fontSize: 21.0,
                                          color: Colors.white30),
                                    ),
                                    new Expanded(
                                      child: new FlatButton(
                                        onPressed: () {
                                          showSelectDialog();
                                          setState(() {});
                                        },
                                        child: new Text(
                                          globals.selectedSchoolName ??
                                              S
                                                  .of(context)
                                                  .choose,
                                          style: new TextStyle(
                                              fontSize: 21.0,
                                              color: Colors.blue),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              !schoolSelected
                                  ? new Text(
                                S
                                    .of(context)
                                    .choose_school_warning,
                                style: new TextStyle(color: Colors.red),
                              )
                                  : new Container(),
                            ]),
                            new Row(
                              children: <Widget>[
                                new Container(
                                  //margin: EdgeInsets.only(top: 20.0),
                                  child: FlatButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, "/import");
                                    },
                                    child: new Text("Import"),
                                    disabledColor: Colors.blueGrey.shade800,
                                    disabledTextColor: Colors.blueGrey,
                                    color: Colors.green,
                                    //#2196F3
                                    textColor: Colors.white,
                                  ),
                                ),
                                new Container(
                                  padding: EdgeInsets.all(6),
                                ),
                                new Expanded(
                                  //margin: EdgeInsets.only(top: 20.0),
                                    child: new FlatButton(
                                      onPressed: !loggingIn
                                          ? () {
                                        setState(() {
                                          loggingIn = true;
                                          login(context);
                                        });
                                      }
                                          : null,
                                      disabledColor: Colors.blueGrey.shade800,
                                      disabledTextColor: Colors.blueGrey,
                                      child: new Text(S
                                          .of(context)
                                          .login),
                                      color: Colors.blue,
                                      //#2196F3
                                      textColor: Colors.white,
                                    )),
                              ],
                            ),
                          ].reversed.toList(),
                        ))
                        : new Container(
                      child: new CircularProgressIndicator(),
                    )))));
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
    print(globals.jsonres.length);
    globals.searchres.addAll(globals.jsonres);
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
    isDialog = false;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    isDialog = true;
  }

  Widget build(BuildContext context) {
    return new SimpleDialog(
      title: new Text(S
          .of(context)
          .choose_school),
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
          child: globals.searchres != null
              ? new ListView.builder(
            itemBuilder: _itemBuilder,
            itemCount: globals.searchres.length,
          )
              : new Container(),
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
      print(globals.jsonres.length);

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
