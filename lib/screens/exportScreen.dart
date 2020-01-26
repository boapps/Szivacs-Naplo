import 'dart:ui';
import 'package:e_szivacs/Datas/Account.dart';
import 'package:flutter/material.dart';
import '../GlobalDrawer.dart';
import 'package:e_szivacs/generated/i18n.dart';
import '../Datas/User.dart';
import '../Utils/Saver.dart' as Saver;
import '../globals.dart' as globals;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert' show json;
import 'package:csv/csv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import '../Helpers/TimetableHelper.dart';

void main() {
  runApp(new MaterialApp(
    home: new ExportScreen(),
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

  //todo refactor everything below this

  void initPath() async {
      path = (await getExternalStorageDirectory()).path + "/grades-" + selectedUser.username + ".json";
      controller.text = path;
  }

  TextEditingController controller = new TextEditingController();
  User selectedUser = globals.users[0];
  List<String> get exportOptions => [S.of(context).export_grades, S.of(context).export_lessons, S.of(context).export_accounts];
  List<String> formatOptions = ["JSON", "CSV"];
  List<String> formats = [".json", ".csv"];
  int selectedData = 0;
  int selectedFormat = 0;
  String path = "";
  String selectedDate;
  List<DateTime> pickedDate;
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
          title: new Text(S
              .of(context)
              .title),
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

                    new DropdownButton(items: exportOptions.map((String exportData){
                      return DropdownMenuItem(child: Text(exportData), value: exportData,);
                    }).toList(), onChanged: (exportData) async {
                      selectedData = exportOptions.indexOf(exportData);
                      switch(selectedData) {
                        case 0:
                          path = (await getExternalStorageDirectory()).path + "/grades-" + selectedUser.username + formats[selectedFormat];
                          break;
                        case 1:
                          path = (await getExternalStorageDirectory()).path + "/lessons-" + selectedUser.username + formats[selectedFormat];
                          break;
                        case 2:
                          path = (await getExternalStorageDirectory()).path + "/users" + formats[selectedFormat];
                          break;
                      }
                      controller.text = path;
                      setState(() {
                      });

                    }, value: exportOptions[selectedData],),

                    (selectedData != 2) ? new DropdownButton(items: globals.users.map((User user){
                      return DropdownMenuItem(child: Text(user.name), value: user,);
                    }).toList(), onChanged: (user){
                      setState(() {
                        selectedUser = user;

                      });
                    }, value: selectedUser,):new Container(),

                    (selectedData == 1) ? new MaterialButton(
                        color: selectedDate==null ? Colors.deepOrangeAccent:Colors.green,
                        onPressed: () async {
                          final List<DateTime> picked = await DateRagePicker.showDatePicker(
                              context: context,
                              initialFirstDate: new DateTime.now().subtract(Duration(days: DateTime.now().weekday-1)),
                              initialLastDate: new DateTime.now().subtract(Duration(days: DateTime.now().weekday-7)),
                              firstDate: new DateTime(2018),
                              lastDate: new DateTime(2025)
                          );
                          if (picked != null && picked.length == 2) {
                            pickedDate = picked;
                            selectedDate = picked[0].toIso8601String().substring(0, 10) + "  -  " + picked[1].toIso8601String().substring(0, 10);
                            setState(() {});
                          }
                        },
                        child: new Text(selectedDate??S.of(context).export_interval),
                    ):new Container(),

                    (selectedData != 2) ? new DropdownButton(items: formatOptions.map((String exportFormat){
                      return DropdownMenuItem(child: Text(exportFormat), value: exportFormat,);
                    }).toList(), onChanged: (exportFormat) async {
                      selectedFormat = formatOptions.indexOf(exportFormat);

                      switch(selectedData) {
                        case 0:
                          path = (await getExternalStorageDirectory()).path + "/grades-" + selectedUser.username + formats[selectedFormat];
                          break;
                        case 1:
                          path = (await getExternalStorageDirectory()).path + "/lessons-" + selectedUser.username + formats[selectedFormat];
                          break;
                        case 2:
                          path = (await getExternalStorageDirectory()).path + "/users" + formats[selectedFormat];
                          break;
                      }
                      controller.text = path;
                      setState(() {});

                      },
                      value: formatOptions[selectedFormat],
                    ):new Container(),

                    new TextField(onChanged: (text){path = text;}, controller: controller,),
                    new Container(
                    child: new RaisedButton(onPressed: () async {
                      switch(selectedData) {
                        case 0:
                          //jegyek
                          switch(selectedFormat){
                            //json
                            case 0:
                              Account selectedAccount = globals.accounts.firstWhere((Account a) => a.user.id == selectedUser.id);
                              String data = selectedAccount.getStudentString();
                              File file = File(path);
                              PermissionHandler().requestPermissions(
                                  [PermissionGroup.storage]).then((Map<
                                  PermissionGroup,
                                  PermissionStatus> permissions) {
                                file.writeAsString(data).then((File f){
                                  if (f.existsSync())
                                    Fluttertoast.showToast(
                                        msg: S.of(context).export_success + ": " + path,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                });
                              });
                              break;
                            case 1:
                              //csv
                              Account selectedAccount = globals.accounts.firstWhere((Account a) => a.user.id == selectedUser.id);
                              Map data = selectedAccount.getStudentJson();
                              List<List<dynamic>> csvList = [["EvaluationId", "Form", "FormName", "Type", "TypeName", "Subject", "SubjectCategory", "SubjectCategoryName", "Theme", "Mode", "Weight", "Value", "NumberValue", "SeenByTutelaryUTC", "Teacher", "Date", "CreatingTime"]];
                              for (var jegy in data["Evaluations"])
                                csvList.add([jegy["EvaluationId"], jegy["Form"], jegy["FormName"], jegy["Type"], jegy["TypeName"], jegy["Subject"], jegy["SubjectCategory"], jegy["SubjectCategoryName"], jegy["Theme"], jegy["Mode"], jegy["Weight"], jegy["Value"], jegy["NumberValue"], jegy["SeenByTutelaryUTC"], jegy["Teacher"], jegy["Date"], jegy["CreatingTime"]]);
                              String csv = const ListToCsvConverter().convert(csvList);
                              File file = File(path);
                              PermissionHandler().requestPermissions(
                                  [PermissionGroup.storage]).then((Map<
                                  PermissionGroup,
                                  PermissionStatus> permissions) {
                                file.writeAsString(csv).then((File f){
                                  if (f.existsSync())
                                    Fluttertoast.showToast(
                                        msg: S.of(context).export_success + ": " + path,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                });
                              });
                          }
                          break;
                        case 2:
                          //user
                          String data = json.encode(await Saver.readUsers());
                          File file = File(path);
                          PermissionHandler().requestPermissions([
                            PermissionGroup.storage
                          ]).then((Map<PermissionGroup,
                              PermissionStatus> permissions) {
                            file.writeAsString(data).then((File f){
                              if (f.existsSync())
                                Fluttertoast.showToast(
                                    msg: S.of(context).export_success + ": " + path,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                            });
                          });
                          break;
                        case 1:
                          //orarend
                          switch(selectedFormat){
                          //json
                            case 0:
                              String data = await getLessonsJson(pickedDate[0], pickedDate[1], selectedUser, true);
                              File file = File(path);
                              PermissionHandler().requestPermissions(
                                  [PermissionGroup.storage]).then((Map<
                                  PermissionGroup,
                                  PermissionStatus> permissions) {
                                file.writeAsString(data).then((File f){
                                  if (f.existsSync())
                                    Fluttertoast.showToast(
                                        msg: S.of(context).export_success + ": " + path,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                });

                              });
                              break;
                            case 1:
                            //csv
                              var data = json.decode(await getLessonsJson(pickedDate[0], pickedDate[1], selectedUser, true));
                              //{LessonId: 112975, CalendarOraType: OrarendiOra, Count: 4, Date: 2019-05-03T00:00:00, StartTime: 2019-05-03T11:00:00, EndTime: 2019-05-03T11:45:00, Subject: német, SubjectCategory: null, SubjectCategoryName: Német nyelv, ClassRoom: 14, ClassGroup: 11.A/NK, Teacher: Pócsik Viktor, DeputyTeacher: , State: NotRegistered, StateName: Nem naplózott tanóra, PresenceType: NotDefined, PresenceTypeName: Nem definiált, TeacherHomeworkId: null, IsTanuloHaziFeladatEnabled: true, Theme: , Homework: null}
                              List<List<dynamic>> csvList = [["LessonId", "CalendarOraType", "Count", "Date", "StartTime", "EndTime", "Subject", "SubjectCategory", "SubjectCategoryName", "ClassRoom", "ClassGroup", "Teacher", "DeputyTeacher", "State", "StateName", "PresenceType", "PresenceTypeName", "TeacherHomeworkId", "IsTanuloHaziFeladatEnabled", "Theme", "Homework"]];
                              for (var ora in data)
                                csvList.add([ora["LessonId"], ora["CalendarOraType"], ora["Count"], ora["Date"], ora["StartTime"], ora["EndTime"], ora["Subject"], ora["SubjectCategory"], ora["SubjectCategoryName"], ora["ClassRoom"], ora["ClassGroup"], ora["Teacher"], ora["DeputyTeacher"], ora["State"], ora["StateName"], ora["PresenceType"], ora["PresenceTypeName"], ora["TeacherHomeworkId"], ora["IsTanuloHaziFeladatEnabled"], ora["Theme"], ora["Homework"]]);
                              String csv = const ListToCsvConverter().convert(csvList);
                              File file = File(path);
                              PermissionHandler().requestPermissions(
                                  [PermissionGroup.storage]).then((Map<
                                  PermissionGroup,
                                  PermissionStatus> permissions) {
                                file.writeAsString(csv).then((File f){
                                  if (f.existsSync())
                                    Fluttertoast.showToast(
                                        msg: S.of(context).export_success + ": " + path,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                });
                              });
                          }                      }
                    }, child: new Text(S.of(context).export, style: TextStyle(color: Colors.white),), color: Colors.blue[700],),
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
