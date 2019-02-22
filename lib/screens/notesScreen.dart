import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'package:flutter_linkify/flutter_linkify.dart';
import '../Datas/Note.dart';
import '../GlobalDrawer.dart';
import '../globals.dart' as globals;
import '../Helpers/LocaleHelper.dart';

void main() {
  runApp(new MaterialApp(home: new NotesScreen()));
}

class NotesScreen extends StatefulWidget {
  @override
  NotesScreenState createState() => new NotesScreenState();
}

class NotesScreenState extends State<NotesScreen> {
  @override
  void initState() {
    super.initState();
    _onRefreshOffline();
    _onRefresh();
  }

  bool hasOfflineLoaded = false;
  bool hasLoaded = false;

  List<Note> notes = new List();

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
              backgroundColor: globals.isDark ? Color.fromARGB(255, 25, 25, 25) : Colors.blue[700],
              title: new Text(AppLocalizations.of(context).notes),
              actions: <Widget>[],
            ),
            body: new Container(
                child: hasOfflineLoaded
                    ? new Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: new RefreshIndicator(
                            child: new ListView.builder(
                              itemBuilder: _itemBuilder,
                              itemCount: notes.length,
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

    globals.selectedAccount.refreshNotes(false, false);
    notes = globals.selectedAccount.notes;

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

    globals.selectedAccount.refreshNotes(false, true);
    notes = globals.selectedAccount.notes;

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
          title: notes[index].title != null && notes[index].title != "" ? new Text(notes[index].title) : null,
          subtitle: new Column(children: <Widget>[
            new Container(
            padding: EdgeInsets.all(5),
            child: Linkify(
              style: TextStyle(fontSize: 16),
              text: notes[index].content,
              onOpen: (String url) {
                launcher.launch(url);
              },
            ),
          ),
            new Container(
              child: new Text(notes[index].date.substring(0, 10).replaceAll("-", ". ")),
              alignment: Alignment(1, -1),
            ),
            notes[index].teacher != null ? new Container(
              child: new Text(notes[index].teacher),
              alignment: Alignment(1, -1),
            ) : new Container(),
    ]
          ),
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
