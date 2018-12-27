import 'dart:async';

import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart' as launcher;
import 'package:flutter_linkify/flutter_linkify.dart';

import '../Datas/Note.dart';
import '../Datas/User.dart';
import '../GlobalDrawer.dart';
import '../Helpers/NotesHelper.dart';
import '../globals.dart' as globals;

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
//    refNotes();
    _onRefresh();
//    refNotes();
  }

  bool hasOfflineLoaded = false;
  bool hasLoaded = false;

  List<Note> notes = new List();
  List<Note> selectedNotes = new List();
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

//    setState(() {
//      refWidgets();
//      _onRefreshOffline();
//      _onRefresh();
      refNotes();
//    });

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
//    avers = globals.avers;
//    selectedUser = globals.selectedUser;
//    users = globals.users;

//    print(globals.selectedUser);
//    print(selectedUser.name);
//    print(avers.length);

    return new WillPopScope(
        onWillPop: () {
          globals.screen = 0;
          Navigator.pushReplacementNamed(context, "/main");
        },
        child: Scaffold(
            drawer: GDrawer(),
        appBar: new AppBar(
          title: new Text("Feljegyzések"),
          actions: <Widget>[
          ],
         /* bottom: new PreferredSize(
              child: new LinearProgressIndicator(
                value: 0.7,
              ),
              preferredSize: null),*/
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
//    notes.removeWhere((Note n)=>n.owner==selectedUser);
    refNotes();
    if (mounted)
      setState(() {
        hasLoaded = true;
        completer.complete();
      });
    return completer.future;
  }

  Future<Null> _onRefreshOffline() async {
    setState(() {
      hasOfflineLoaded = false;
    });
    Completer<Null> completer = new Completer<Null>();
    notes = await NotesHelper().getNotesOffline();
    refNotes();
//    notes.removeWhere((Note n)=>n.owner==selectedUser);
    if (mounted)
      setState(() {
        hasOfflineLoaded = true;
        completer.complete();
      });
    return completer.future;
  }

  void evalDialog(int index){
    print("tapped " + index.toString());
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return new Column(
      children: <Widget>[
        new ListTile(
//      leading: new Text(selectedNotes[index].numericValue.toString(), textScaleFactor: 2.0,),
          title: new Text(selectedNotes[index].date.substring(0,10).replaceAll("-", ". ") + ". " + (selectedNotes[index].teacher!=null ? (" - " + selectedNotes[index].teacher):""), style: TextStyle(fontSize: 20.0),),
          subtitle: new Container(
            padding: EdgeInsets.all(5),
    child: Linkify(
      text: selectedNotes[index].content,
      onOpen: (String url) {
        launcher.launch(url);
      },
    ),
    //child: new RichTextView(text: selectedNotes[index].content),
    ),
          isThreeLine: true,
//      trailing: new Text(),
          onTap: () {evalDialog(index);},
        ),
        new Divider(height: 10.0,),
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