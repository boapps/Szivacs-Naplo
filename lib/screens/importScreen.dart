import 'dart:ui';
import 'package:flutter/material.dart';
import '../GlobalDrawer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Helpers/LocaleHelper.dart';
import '../globals.dart' as globals;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:simple_permissions/simple_permissions.dart';
import '../Utils/Saver.dart' as Saver;
import 'package:flutter/services.dart';

void main() {
  runApp(new MaterialApp(
    home: new ImportScreen(),
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
                          SimplePermissions.requestPermission(Permission.WriteExternalStorage).then((PermissionStatus ps) async {
                            File importFile = new File(path);
                            String data = importFile.readAsStringSync();
                            (await Saver.userFile).writeAsStringSync(data);
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
