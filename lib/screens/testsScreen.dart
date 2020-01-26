import 'dart:async';

import 'package:e_szivacs/generated/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

import '../Datas/Test.dart';
import '../GlobalDrawer.dart';
import '../Utils/StringFormatter.dart';
import '../globals.dart' as globals;

void main() {
  runApp(new MaterialApp(home: new TestsScreen()));
}

class TestsScreen extends StatefulWidget {
  @override
  TestsScreenState createState() => new TestsScreenState();
}

class TestsScreenState extends State<TestsScreen> {
  @override
  void initState() {
    super.initState();
    _onRefreshOffline();
    _onRefresh(showErrors: false);
  }

  bool hasOfflineLoaded = false;
  bool hasLoaded = true;

  List<Test> tests = new List();

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
              title: new Text(S
                  .of(context)
                  .tests),
              actions: <Widget>[],
            ),
            body: new Container(
                child: (hasOfflineLoaded && tests != null)
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
                              itemCount: tests.length,
                            ),
                            onRefresh: _onRefresh,
        ),
                      ),
                ])
                    : new Center(child: new CircularProgressIndicator()))));
  }

  Future<Null> _onRefresh({bool showErrors}) async {
    setState(() {
      hasLoaded = false;
    });
    Completer<Null> completer = new Completer<Null>();

    try {
      await globals.selectedAccount.refreshTests(false, showErrors);
      tests = globals.selectedAccount.tests;
      tests.sort((Test a, Test b) => b.creationDate.compareTo(a.creationDate));
    } catch (e) {
      print(e);
    }

    hasLoaded = true;
    if (mounted)
      setState(() {
        completer.complete();
      });
    return completer.future;
  }

  Future<Null> _onRefreshOffline() async {
    setState(() {
      hasOfflineLoaded = false;
    });
    Completer<Null> completer = new Completer<Null>();

    await globals.selectedAccount.refreshTests(true, false);
    tests = globals.selectedAccount.tests;

    hasOfflineLoaded = true;
    if (mounted)
      setState(() {
        completer.complete();
      });
    return completer.future;
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return new Column(
      children: <Widget>[
        new ListTile(
          title: tests[index].title != null && tests[index].title != ""
              ? new Text(
                  tests[index].title,
                  style: TextStyle(fontSize: 22),
                )
              : null,
          subtitle: new Column(children: <Widget>[
            new Container(
              padding: EdgeInsets.all(5),
              child: Linkify(
                style: TextStyle(fontSize: 16),
                text: tests[index].subject + " " + tests[index].mode,
                onOpen: (String url) {
                  launcher.launch(url);
                },
              ),
            ),
            new Container(
              child: new Text(dateToHuman(tests[index].date) +
                  dateToWeekDay(tests[index].date)),
              alignment: Alignment(1, -1),
            ),
            tests[index].teacher != null
                ? new Container(
                    child: new Text(tests[index].teacher),
                    alignment: Alignment(1, -1),
                  )
                : new Container(),
          ]),
          isThreeLine: true,
        ),
        new Divider(
          height: 10.0,
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
