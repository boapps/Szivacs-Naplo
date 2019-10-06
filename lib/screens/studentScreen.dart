import 'dart:ui';

import 'package:e_szivacs/generated/i18n.dart';
import 'package:flutter/material.dart';

import '../Datas/Account.dart';
import '../Datas/Student.dart';
import '../GlobalDrawer.dart';
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
    double c_width = MediaQuery.of(context).size.width * 0.5;

    return new Scaffold(
      drawer: GDrawer(),
      appBar: new AppBar(
        title: new Text(this.widget.account.student != null ? this.widget.account.student.Name??"":""),
        actions: <Widget>[
        ],
      ),
      body:
      new Center(
        child: ListView(
          children: <Widget>[

            Card(
              child: ListTile(
                title: Text(S.of(context).info_birthdate),
                trailing: this.widget.account.student != null ? Text(dateToHuman(
                    DateTime.parse(this.widget.account.student.DateOfBirthUtc??"")
                        .add(Duration(days: 1)))):Container(),
              ),
            ),
            Card(
            child: ListTile(
              title: Text(S.of(context).info_kretaid),
              trailing: Text(
                  this.widget.account.student.StudentId != null ? this.widget
                      .account.student.StudentId.toString() : "-"),
            ),
            ),
    Card(
    child: Row(
              children: <Widget>[
                Expanded(child: Container(
                  child: Text(S.of(context).info_address), padding: EdgeInsets.all(18),),),
                Container(child: Column(
                  children: widget.account.student.AddressDataList.toSet().toList().map((
                      String address) {
                    return Text(address, maxLines: 3, softWrap: true, textAlign: TextAlign.end,);
                  }).toList(),
                  crossAxisAlignment: CrossAxisAlignment.end,
                ),
                  width: c_width,
                  margin: EdgeInsets.only(right: 15, left: 15),
                ),
              ],
            ),
    ),
      widget.account.student.FormTeacher != null ? Card(
    child: Row(
              children: <Widget>[
                Expanded(child: Container(
                  child: Text(S.of(context).info_teacher, softWrap: false, maxLines: 1,), padding: EdgeInsets.all(18),),),
                Container(child: Column(
                  children: <String>[
                    widget.account.student.FormTeacher.Name ?? "",
                    widget.account.student.FormTeacher.Email ?? "",
                    widget.account.student.FormTeacher.PhoneNumber ?? ""
                  ].where((String data) => data != "").map((String data) {
                    return Text(data, maxLines: 3, softWrap: true, textAlign: TextAlign.end,);
                  }).toList(),
                  crossAxisAlignment: CrossAxisAlignment.end,
                ),
                  width: c_width,
                  margin: EdgeInsets.only(right: 15, left: 15),
                ),
              ],
            ),) : Container(),
    Card(
    child: Row(
              children: <Widget>[
                Expanded(child: Container(
                  child: Text(S.of(context).info_school), padding: EdgeInsets.all(18),),),
                Container(child: Column(
                  children: <String>[
                    widget.account.student.InstituteName ?? "",
                    widget.account.student.InstituteCode ?? ""
                  ].map((String data) {
                    return Text(data, maxLines: 3, softWrap: true, textAlign: TextAlign.end,);
                  }).toList(),
                  crossAxisAlignment: CrossAxisAlignment.end,
                ),
                  width: c_width,
                  margin: EdgeInsets.only(right: 15, left: 15),
                ),
              ],
            ),
    ),
            widget.account.student.Tutelaries != null ? Card(
                child: Row(
              children: <Widget>[
                Expanded(child: Container(
                  child: Text(S.of(context).info_parents), padding: EdgeInsets.all(18),),),
                Container(child: Column(
                  children: widget.account.student.Tutelaries.map((
                      TutelariesBean parrent) {
                    String details = (parrent.PhoneNumber != null &&
                        parrent.PhoneNumber != "" && parrent.Email != null &&
                        parrent.Email != "") ?
                    ":\n- " + parrent.PhoneNumber + "\n- " + parrent.Email
                        : parrent.PhoneNumber != null &&
                        parrent.PhoneNumber != "" ?
                    ":\n- " + parrent.PhoneNumber.toString()
                        : parrent.Email != null && parrent.Email != "" ?
                    ":\n- " + parrent.Email.toString()
                        : "";
                    return Text(parrent.Name + details, maxLines: 3,
                      softWrap: true, textAlign: TextAlign.start,);
                  }).toList(),
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                  width: c_width,
                  margin: EdgeInsets.only(right: 15, left: 15),
                ),
              ],
            ),) : Container(),
            widget.account.student.MothersName != null ? Card(
                child: ListTile(
              title: Text(S.of(context).info_mathers_name),
              trailing: Text(widget.account.student.MothersName),
            ),) : Container(),
          ],
        ),
      ),
    );
  }
}
