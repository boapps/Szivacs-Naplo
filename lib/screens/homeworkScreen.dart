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
  @override
  void initState() {
    super.initState();
    initSelectedUser();
    _onRefreshOffline();
    refNotes();
    _onRefresh();
    refNotes();
  }

  bool hasOfflineLoaded = false;
  bool hasLoaded = false;

  List<Homework> notes = new List();
  List<Homework> selectedNotes = new List();

//  List<Evaluation> evals = new List();
//  List<Average> avers = new List();
//  List<Average> currentAvers = new List();

  User selectedUser;
  List<User> users;

  void initSelectedUser() async {
    setState(() {
      selectedUser = globals.selectedUser;
    });
  }

  void _onSelect(User user) async {
    selectedUser = user;

    setState(() {
      refNotes();
    });
  }

  void refNotes() {
    setState(() {
      selectedNotes.clear();
    });

    for (Homework n in notes) {
      if (n.owner.id == selectedUser.id) {
        setState(() {
          selectedNotes.add(n);
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
              actions: <Widget>[],
              /* bottom: new PreferredSize(
              child: new LinearProgressIndicator(
                value: 0.7,
              ),
              preferredSize: null),*/
            ),
            body: new Container(
                child: hasOfflineLoaded
                    ? new Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: new RefreshIndicator(
                            child: new ListView.builder(
                              itemBuilder: _itemBuilder,
                              itemCount: selectedNotes.length,
                            ),
                            onRefresh: _onRefresh),
                      )
                    : new Center(child: new CircularProgressIndicator()))));
  }

  Future<Null> _onRefresh() async {
    setState(() {
      hasLoaded = false;
    });
    Completer<Null> completer = new Completer<Null>();
    notes = await HomeworkHelper().getHomeworks();
    notes
        .sort((Homework a, Homework b) => b.uploadDate.compareTo(a.uploadDate));
//    notes.removeWhere((Note n)=>n.owner==selectedUser);
    setState(() {
      refNotes();
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
    notes = await HomeworkHelper().getHomeworksOffline();
    notes.forEach((h) {
      print(HtmlUnescape().convert(h.text));
    });
    notes
        .sort((Homework a, Homework b) => b.uploadDate.compareTo(a.uploadDate));
    if (mounted)
      setState(() {
        refNotes();
        hasOfflineLoaded = true;
        completer.complete();
      });
    return completer.future;
  }

  void evalDialog(int index) {
    print("tapped " + index.toString());
  }

  Widget _itemBuilder(BuildContext context, int index) {
    print(HtmlUnescape().convert(selectedNotes[index].text.toString()));
    return new Column(
      children: <Widget>[
        new ListTile(
//      leading: new Text(selectedNotes[index].numericValue.toString(), textScaleFactor: 2.0,),
          title: new Text(
            selectedNotes[index].uploadDate.substring(0, 10) +
                (selectedNotes[index].subject == null
                    ? ""
                    : (" - " + selectedNotes[index].subject)),
            style: TextStyle(fontSize: 20.0),
          ),
          subtitle: new HtmlView(
            data: HtmlUnescape().convert(selectedNotes[index].text.toString()),
          ),
          isThreeLine: true,
//      trailing: new Text(),
          onTap: () {
            evalDialog(index);
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
    selectedNotes.clear();
    super.dispose();
  }
}
