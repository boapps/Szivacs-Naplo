import 'dart:ui';
import 'package:flutter/material.dart';
import '../GlobalDrawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:e_szivacs/generated/i18n.dart';
import '../globals.dart' as globals;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Datas/Account.dart';
import '../Datas/Student.dart';
import '../Utils/StringFormatter.dart';

class StudentScreen extends StatefulWidget {
  StudentScreen({this.account});

  Account account;

  @override
  StudentScreenState createState() => new StudentScreenState();
}

class StudentScreenState extends State<StudentScreen> {

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery
        .of(context)
        .size
        .width * 0.6;

    return new Scaffold(
      drawer: GDrawer(),
      appBar: new AppBar(
        title: new Text(this.widget.account.student.Name),
        actions: <Widget>[
        ],
      ),
      body:
      new Center(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text("születési dátum"),
              trailing: Text(dateToHuman(
                  DateTime.parse(this.widget.account.student.DateOfBirthUtc))),
            ),
            ListTile(
              title: Text("kréta id"),
              trailing: Text(this.widget.account.student.StudentId.toString()),
            ),
            Row(
              children: <Widget>[
                Expanded(child: Container(
                  child: Text("lakcím"), padding: EdgeInsets.all(18),),),
                Container(child: Column(
                  children: widget.account.student.AddressDataList.map((
                      String address) {
                    return Text(address, maxLines: 3, softWrap: true,);
                  }).toList(),
                ),
                  width: c_width,
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(child: Container(
                  child: Text("osztályfőnök"), padding: EdgeInsets.all(18),),),
                Container(child: Column(
                  children: <String>[
                    widget.account.student.FormTeacher.Name,
                    widget.account.student.FormTeacher.Email ?? "",
                    widget.account.student.FormTeacher.PhoneNumber ?? ""
                  ].map((String data) {
                    return Text(data, maxLines: 3, softWrap: true,);
                  }).toList(),
                ),
                  width: c_width,
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(child: Container(
                  child: Text("iskola"), padding: EdgeInsets.all(18),),),
                Container(child: Column(
                  children: <String>[
                    widget.account.student.InstituteName,
                    widget.account.student.InstituteCode ?? ""
                  ].map((String data) {
                    return Text(data, maxLines: 3, softWrap: true,);
                  }).toList(),
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                  width: c_width,
                ),
              ],
            ),
            widget.account.student.Tutelaries != null ? Row(
              children: <Widget>[
                Expanded(child: Container(
                  child: Text("szülők"), padding: EdgeInsets.all(18),),),
                Container(child: Column(
                  children: widget.account.student.Tutelaries.map((
                      TutelariesBean parrent) {
                    String details = (parrent.PhoneNumber != null &&
                        parrent.PhoneNumber != "" && parrent.Email != null &&
                        parrent.Email != "") ?
                    " (" + parrent.PhoneNumber + ", " + parrent.Email + ")"
                        : parrent.PhoneNumber != null &&
                        parrent.PhoneNumber != "" ? " (" +
                        parrent.PhoneNumber.toString() + ")"
                        : parrent.Email != null && parrent.Email != "" ? " (" +
                        (parrent.Email).toString() + ")"
                        : "";
                    return Text(parrent.Name + details, maxLines: 3,
                      softWrap: true,);
                  }).toList(),
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                  width: c_width,
                ),
              ],
            ) : Container(),
            ListTile(
              title: Text("anyja neve"),
              trailing: Text(widget.account.student.MothersName),
            ),
          ],
        ),
      ),
    );
  }
}
