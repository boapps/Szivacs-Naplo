import 'dart:async';

import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart' as launcher;
import 'package:flutter_linkify/flutter_linkify.dart';

import '../Datas/Note.dart';
import '../Datas/User.dart';
import '../GlobalDrawer.dart';
import '../Helpers/NotesHelper.dart';
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
    initSelectedUser();
    _onRefreshOffline();
    _onRefresh();
  }

  bool hasOfflineLoaded = false;
  bool hasLoaded = false;

  List<Note> notes = new List();
  List<Note> selectedNotes = new List();

  User selectedUser;
  List<User> users;

  void initSelectedUser() async {
    setState(() {
      selectedUser = globals.selectedUser;
    });
  }

  void refNotes() {
      selectedNotes.clear();
      for (Note n in notes) {
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
          title: new Text(AppLocalizations.of(context).notes),
          actions: <Widget>[
          ],
        ),
        body: new Container(
              child:
              hasOfflineLoaded ? new Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: new RefreshIndicator(
                        child: new ListView.builder(
                          itemBuilder: _itemBuilder,
                          itemCount: selectedNotes.length,
                    ),
                        onRefresh: _onRefresh),
                  ) :
                  new Center(child: new CircularProgressIndicator())
         )
        )
        );
  }

  Future<Null> _onRefresh() async {
    setState(() {
      hasLoaded = false;
    });

    Completer<Null> completer = new Completer<Null>();
    notes = await NotesHelper().getNotes();
    globals.notes = notes;

    refNotes();
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

    if (globals.notes.length > 0)
      notes = globals.notes;
    else {
      notes = await NotesHelper().getNotesOffline();
      globals.notes = notes;
    }

    refNotes();
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
          title: new Text(
            selectedNotes[index].date.substring(0,10).replaceAll("-", ". ") + ". " +
                (selectedNotes[index].teacher != null ? (" - " + selectedNotes[index].teacher):""),
            style: TextStyle(fontSize: 20.0),
          ),
          subtitle: new Container(
            padding: EdgeInsets.all(5),
    child: Linkify(
      text: selectedNotes[index].content,
      onOpen: (String url) {
        launcher.launch(url);
      },
    ),
    ),
          isThreeLine: true,
        ),
        new Divider(height: 10.0,),
      ],
    );
  }

  @override
  void dispose() {
    selectedNotes.clear();
    super.dispose();
  }
  }