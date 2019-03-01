import 'dart:ui';
import 'package:flutter/material.dart';
import '../GlobalDrawer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Helpers/LocaleHelper.dart';
import '../Datas/User.dart';
import '../Utils/Saver.dart' as Saver;
import '../globals.dart' as globals;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:simple_permissions/simple_permissions.dart';

void main() {
  runApp(new MaterialApp(
    home: new ExportScreen(),
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

class ExportScreen extends StatefulWidget {
  @override
  ExportScreenState createState() => new ExportScreenState();
}

class ExportScreenState extends State<ExportScreen> {

  @override
  void initState() {
    super.initState();
    setState(() {
      initPath();
    });
  }

  void initPath() async {
      path = (await getExternalStorageDirectory()).path + "/grades.json";
      controller.text = path;
  }

  TextEditingController controller = new TextEditingController();
  User selectedUser = globals.users[0];
  List<String> exportOptions = ["adatok, jegyek, hiányzások ...", "órák (WIP)", ];
  List<String> formatOptions = ["json", "excel (WIP)", "CSV (WIP)", "HTML (WIP)"];
  int selectedData = 0;
  int selectedFormat = 0;
  String path = "";

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
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new DropdownButton(items: globals.users.map((User user){
                      return DropdownMenuItem(child: Text(user.name), value: user,);
                    }).toList(), onChanged: (user){
                      setState(() {
                        selectedUser = user;
                      });
                      }, value: selectedUser,),

                    new DropdownButton(items: exportOptions.map((String exportData){
                      return DropdownMenuItem(child: Text(exportData), value: exportData,);
                    }).toList(), onChanged: (exportData){
                      setState(() {
                        selectedData = exportOptions.indexOf(exportData);
                      });
                      }, value: exportOptions[selectedData],),

                    new DropdownButton(items: formatOptions.map((String exportFormat){
                      return DropdownMenuItem(child: Text(exportFormat), value: exportFormat,);
                    }).toList(), onChanged: (exportFormat){
                      setState(() {
                        selectedFormat = formatOptions.indexOf(exportFormat);
                      });
                      }, value: formatOptions[selectedFormat],),

                    new TextField(onChanged: (text){path = text;},controller: controller,),
                    new Container(
                    child: new RaisedButton(onPressed: () async {
                      switch(selectedData) {
                        case 0:
                          //jegyek
                          String data = await Saver.readStudent(selectedUser);
                          print(data);
                          print(path);
                          File file = File(path);
                          SimplePermissions.requestPermission(Permission.WriteExternalStorage).then((PermissionStatus ps){
                            print(ps.toString());
                            file.writeAsString(data).then((File f){
                              print("done");
                            });

                          });
                          break;
                      }
                    }, child: new Text("Export", style: TextStyle(color: Colors.white),), color: Colors.blue[700],),
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
