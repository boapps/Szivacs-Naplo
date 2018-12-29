import 'dart:async';

import 'package:flutter/material.dart';

import '../Datas/Homework.dart';
import '../Datas/User.dart';
import '../GlobalDrawer.dart';
import '../Helpers/HomeworkHelper.dart';

//import '../Helpers/AverageHelper.dart';
//import '../Helpers/EvaluationHelper.dart';
import '../Utils/AccountManager.dart';
import '../globals.dart' as globals;
import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:html_unescape/html_unescape.dart';

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

  bool hasLoaded = false;
  bool hasOfflineLoaded = false;

  List<Homework> homeworks = new List();
  List<Homework> selectedHomework = new List();

  @override
  void initState() {
    super.initState();
    initSelectedUser();
    _onRefreshOffline();
    refHomework();
    _onRefresh();
    refHomework();
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
              title: new Text("Házi feladatok"),
              actions: <Widget>[
                new IconButton(icon: new Icon(Icons.access_time), onPressed: (){
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
                    ? new Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: new RefreshIndicator(
                            child: new ListView.builder(
                              itemBuilder: _itemBuilder,
                              itemCount: selectedHomework.length,
                            ),
                            onRefresh: _onRefresh),
                      )
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
          title: new Text(homework.subject + " házi"),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                homework.deadline != null ? new Text("határidő: " + homework.deadline) : new Container(),
                new Text("tárgy: " + homework.subject),
                new Text("feltöltő: " + homework.uploader),
                new Text("feltöltés ideje: " +
                    homework.uploadDate
                        .substring(0, 16)
                        .replaceAll("-", '. ')
                        .replaceAll("T", ". ")),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('ok'),
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
    homeworks = await HomeworkHelper().getHomeworks(globals.idoAdatok[globals.ido]);
    homeworks
        .sort((Homework a, Homework b) => b.uploadDate.compareTo(a.uploadDate));
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
    homeworks = await HomeworkHelper().getHomeworksOffline(globals.idoAdatok[globals.ido]);
    homeworks.forEach((h) {
      print(HtmlUnescape().convert(h.text));
    });
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
    print(HtmlUnescape().convert(selectedHomework[index].text.toString()));
    return new Column(
      children: <Widget>[
        new ListTile(
          title: new Text(
            selectedHomework[index].uploadDate.substring(0, 10) +
                (selectedHomework[index].subject == null
                    ? ""
                    : (" - " + selectedHomework[index].subject)),
            style: TextStyle(fontSize: 20.0),
          ),
          subtitle: new HtmlView(
            data: HtmlUnescape().convert(selectedHomework[index].text.toString()),
          ),
          isThreeLine: true,
          onTap: () {
            homeworksDialog(homeworks[index]);
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

class TimeSelectDialog extends StatefulWidget {
  const TimeSelectDialog();

  @override
  TimeSelectDialogState createState() => new TimeSelectDialogState();
}

class TimeSelectDialogState extends State<TimeSelectDialog> {

  List<String> idok = globals.idok;
  int selected = 1;

  void _onSelect(String sel) {
    setState(() {
      selected = idok.indexOf(sel);
      globals.ido = selected;
    });
  }

  Widget build(BuildContext context) {
    return new SimpleDialog(
      title: new Text("Idő"),
      contentPadding: const EdgeInsets.all(10.0),
      children: <Widget>[
        new PopupMenuButton<String>(
          child: new Container(
            child: new Row(
              children: <Widget>[
                new Text(
                  idok[globals.ido],
                  style: new TextStyle(color: null, fontSize: 17.0),
                ),
                new Icon(
                  Icons.arrow_drop_down,
                  color: null,
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 2.0),
          ),
          onSelected: _onSelect,
          itemBuilder: (BuildContext context) {
            return idok.map((String sor) {
              return new PopupMenuItem<String>(
                value: sor,
                child: new Text(sor),
              );
            }).toList();
          },
        ),
      ],
    );
  }


}
