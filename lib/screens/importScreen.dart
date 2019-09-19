import 'dart:convert' show json;
import 'dart:io';
import 'dart:ui';

import 'package:e_szivacs/generated/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Datas/User.dart';
import '../Helpers/DBHelper.dart';
import '../globals.dart' as globals;

void main() {
  runApp(new MaterialApp(
    home: new ImportScreen(),
    localizationsDelegates: const <LocalizationsDelegate<WidgetsLocalizations>>[
      S.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    onGenerateTitle: (BuildContext context) =>
    S
        .of(context)
        .title,
  ));
}

class ImportScreen extends StatefulWidget {
  @override
  ImportScreenState createState() => new ImportScreenState();
}

class ImportScreenState extends State<ImportScreen> {
  @override
  void initState() {
    super.initState();
    setState(() {
      initPath();
    });
    _showDialog();
  }

  void _showDialog()async {
    // flutter defined function
    await Future.delayed(Duration(milliseconds: 50));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Figyelem"),
          content: new Text("Ez kitöröl minden meglévő felhasználót! (ha van)"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void initPath() async {
    path = (await getExternalStorageDirectory()).path + "/users.json";
    controller.text = path;
  }

  TextEditingController controller = new TextEditingController();
  String path = "";

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () {
          globals.screen = 0;
          Navigator.pushReplacementNamed(context, "/login");
        },
        child: Scaffold(
          appBar: new AppBar(
            title: new Text("Import"),
            actions: <Widget>[
            ],
          ),
          body:
          new Center(
            child: Container(
              padding: EdgeInsets.all(20),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new TextField(onChanged: (text){path = text;},controller: controller,),
                  new Container(
                    child: new RaisedButton(onPressed: () async {
                      PermissionHandler().requestPermissions(
                          [PermissionGroup.storage]).then((Map<
                          PermissionGroup,
                          PermissionStatus> permissions) async {
                            File importFile = new File(path);
                            List<Map<String, dynamic>> userMap = new List();
                            String data = importFile.readAsStringSync();
                            List<dynamic> userList = json.decode(data);
                            for (dynamic d in userList)
                              userMap.add(d as Map<String, dynamic>);

                            List<User> users = new List();
                            if (userMap.isNotEmpty)
                              for (Map<String, dynamic> m in userMap)
                                users.add(User.fromJson(m));
                            List<Color> colors = [
                              Colors.blue,
                              Colors.green,
                              Colors.red,
                              Colors.black,
                              Colors.brown,
                              Colors.orange
                            ];
                            Iterator<Color> cit = colors.iterator;
                            for (User u in users) {
                              cit.moveNext();
                              if (u.color.value == 0)
                                u.color = cit.current;
                            }

                            DBHelper().saveUsersJson(users);

                            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                          });
                    }, child: new Text("Import", style: TextStyle(color: Colors.white),), color: Colors.green[700],),
                    margin: EdgeInsets.all(16),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}
