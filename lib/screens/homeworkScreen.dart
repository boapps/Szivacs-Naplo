import 'dart:async';

import 'package:e_szivacs/generated/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html_unescape/html_unescape.dart';

import '../Datas/Homework.dart';
import '../Datas/User.dart';
import '../Dialog/TimeSelectDialog.dart';
import '../GlobalDrawer.dart';
import '../Helpers/HomeworkHelper.dart';
import '../Utils/StringFormatter.dart';
import '../globals.dart' as globals;

void main() {
  runApp(new MaterialApp(home: new HomeworkScreen()));
}

class HomeworkScreen extends StatefulWidget {
  @override
  HomeworkScreenState createState() => new HomeworkScreenState();
}

class HomeworkScreenState extends State<HomeworkScreen> {
  List<User> users;
  User selectedUser;

  bool hasLoaded = true;
  bool hasOfflineLoaded = false;

  List<Homework> homeworks = new List();
  List<Homework> selectedHomework = new List();

  @override
  void initState() {
    super.initState();
    initSelectedUser();
    _onRefreshOffline();
  }

  void initSelectedUser() async {
    setState(() {
      selectedUser = globals.selectedUser;
    });
  }

  void refHomework() {
    setState(() {
      selectedHomework.clear();
    });

    for (Homework n in homeworks) {
      if (n.owner.id == selectedUser.id) {
        setState(() {
          selectedHomework.add(n);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () {
          globals.screen = 0;
          Navigator.pushReplacementNamed(context, "/main");
        },
        child: Scaffold(
            drawer: GDrawer(),
            appBar: new AppBar(
              title: new Text(S.of(context).homeworks),
              actions: <Widget>[
                new IconButton(
                  icon: new Icon(Icons.access_time),
                  onPressed: () {
                    timeDialog().then((b) {
                      _onRefreshOffline();
                      refHomework();
                      _onRefresh();
                      refHomework();
                    });
                  },
                ),
              ],
            ),
            body: new Container(
                child: hasOfflineLoaded
                    ? new Column(children: <Widget>[
                !hasLoaded
                ? Container(
                child: new LinearProgressIndicator(
                  value: null,
                ),
              height: 3,
            )
              : Container(
          height: 3,
        ),
        new Expanded(child: new RefreshIndicator(
                            child: new ListView.builder(
                              itemBuilder: _itemBuilder,
                              itemCount: selectedHomework.length,
                            ),
                            onRefresh: _onRefresh))])
                    : new Center(child: new CircularProgressIndicator()))));
  }

  Future<bool> timeDialog() {
    return showDialog(
          barrierDismissible: true,
          context: context,
          builder: (BuildContext context) {
            return new TimeSelectDialog();
          },
        ) ??
        false;
  }

  Future<Null> homeworksDialog(Homework homework) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(homework.subject + " " + S.of(context).homework),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                homework.deadline != null
                    ? new Text(S.of(context).deadline + homework.deadline)
                    : new Container(),
                new Text(S.of(context).subject + homework.subject),
                new Text(S.of(context).uploader + homework.uploader),
                new Text(S.of(context).upload_time +
                    homework.uploadDate
                        .substring(0, 16)
                        .replaceAll("-", '. ')
                        .replaceAll("T", ". ")),
                new Divider(
                  height: 4.0,
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                ),
                new Html(data: HtmlUnescape().convert(homework.text)),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(S.of(context).ok),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<Null> _onRefresh() async {
    setState(() {
      hasLoaded = false;
    });
    Completer<Null> completer = new Completer<Null>();
    homeworks = await HomeworkHelper()
        .getHomeworks(globals.idoAdatok[globals.selectedTimeForHomework]);
    homeworks
        .sort((Homework a, Homework b) => b.uploadDate.compareTo(a.uploadDate));
    if (mounted)
      setState(() {
        refHomework();
        hasLoaded = true;
        hasOfflineLoaded = true;
        completer.complete();
      });
    return completer.future;
  }

  Future<Null> _onRefreshOffline() async {
    setState(() {
      hasOfflineLoaded = false;
    });
    Completer<Null> completer = new Completer<Null>();
    homeworks = await HomeworkHelper().getHomeworksOffline(
        globals.idoAdatok[globals.selectedTimeForHomework]);
    homeworks
        .sort((Homework a, Homework b) => b.uploadDate.compareTo(a.uploadDate));
    if (mounted)
      setState(() {
        refHomework();
        hasOfflineLoaded = true;
        completer.complete();
      });
    return completer.future;
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return new Column(
      children: <Widget>[
        new ListTile(
          title: new Text(
            selectedHomework[index].uploadDate.substring(0, 10) +
                " " +
                dateToWeekDay(
                    DateTime.parse(selectedHomework[index].uploadDate)) +
                (selectedHomework[index].subject == null
                    ? ""
                    : (" - " + selectedHomework[index].subject)),
            style: TextStyle(fontSize: 20.0),
          ),
          subtitle: new Html(
              data: HtmlUnescape().convert(selectedHomework[index].text)),
          isThreeLine: true,
          onTap: () {
            homeworksDialog(selectedHomework[index]);
          },
        ),
        new Divider(
          height: 5.0,
        ),
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    selectedHomework.clear();
    super.dispose();
  }
}
