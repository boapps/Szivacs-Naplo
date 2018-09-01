import 'dart:async';

import 'package:flutter/material.dart';

import '../Datas/Average.dart';
import '../Datas/Evaluation.dart';
import '../Datas/User.dart';
import '../GlobalDrawer.dart';
import '../Helpers/AverageHelper.dart';
import '../Helpers/EvaluationHelper.dart';
import '../Utils/AccountManager.dart';
import '../globals.dart' as globals;

void main() {
  runApp(new MaterialApp(home: new EvaluationsScreen()));
}

class EvaluationsScreen extends StatefulWidget {
  @override
  EvaluationsScreenState createState() => new EvaluationsScreenState();
}

class EvaluationsScreenState extends State<EvaluationsScreen> {
  @override
  void initState() {
    super.initState();
    initSelectedUser();
    _onRefreshOffline();
    _onRefresh();
  }

  List<Evaluation> evals = new List();
  List<Average> avers = new List();

  User selectedUser;
  List<User> users;

  void initSelectedUser() async {
    users = await AccountManager().getUsers();
    setState(() {
      selectedUser = users[0];
    });
    globals.selectedUser = selectedUser;
    globals.users = users;
  }

  void _onSelect(User user) async {
    setState(() {
      selectedUser = user;
    });
  }

  Widget _averageBuilder(BuildContext context) {
    List<Widget> widgets = new List();
    initSelectedUser;
    selectedUser = users[0];
    /*widgets.add(new PopupMenuButton<User>(
      icon: new Icon(Icons.person),
      /*child: new Container(
        child: new Row(
          children: <Widget>[
            new Text(selectedUser.name, style: new TextStyle(color: Colors.black, fontSize: 17.0),),
            new Icon(Icons.arrow_drop_down, color: Colors.black,),
          ],
        ),
        padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 2.0),
      ),*/
      onSelected: _onSelect,
      itemBuilder: (BuildContext context) {
        return users.map((User user) {
          return new PopupMenuItem<User>(
            value: user,
            child: new Text(user.name),
          );
        }).toList();
      },
    )
    );*/

    for (Average average in avers)
      widgets.add(new ListTile(
        title: new Text(average.subject),
        subtitle: new Text(average.value.toString()),
        trailing: new Text(
          average.owner.name,
          style: TextStyle(color: average.owner.color),
        ),
      ));

    return new SimpleDialog(
      title: new Text("Átlag"),
      children: widgets,
    );
  }

  Future<bool> showAverages() {
    return showDialog(
          barrierDismissible: true,
          context: context,
          builder: (BuildContext context) {
            return new AverageDialog();
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () {
          globals.screen = 0;
          Navigator.pushReplacementNamed(context, "/main");
        },
        child: Scaffold(
            drawer: GlobalDrawer(context),
            appBar: new AppBar(
              title: new Text("Jegyek"),
              actions: <Widget>[
                new FlatButton(
                  onPressed: showAverages,
                  child: new Icon(Icons.assessment, color: Colors.white),
                )
              ],
              /* bottom: new PreferredSize(
              child: new LinearProgressIndicator(
                value: 0.7,
              ),
              preferredSize: null),*/
            ),
            body: new Container(
                child: evals.isNotEmpty
                    ? new Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: new RefreshIndicator(
                            child: new ListView.builder(
                              itemBuilder: _itemBuilder,
                              itemCount: evals.length,
                            ),
                            onRefresh: _onRefresh),
                      )
                    : new Center(child: new CircularProgressIndicator()))));
  }

  Map<String, dynamic> evaluationsMap;
  Map<String, dynamic> onlyEvaluations;

  Future<Null> _onRefresh() async {
    Completer<Null> completer = new Completer<Null>();
    avers = await AverageHelper().getAverages();
    globals.avers = avers;

    evals = await EvaluationHelper().getEvaluations();
    if (mounted)
      setState(() {
        completer.complete();
      });
    return completer.future;
  }

  Future<Null> _onRefreshOffline() async {
    Completer<Null> completer = new Completer<Null>();
    avers = await AverageHelper().getAveragesOffline();
    globals.avers = avers;

    evals = await EvaluationHelper().getEvaluationsOffline();
    if (mounted)
      setState(() {
        completer.complete();
      });
    return completer.future;
  }

  void evalDialog(int index) {
    print("tapped " + index.toString());
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return new Column(
      children: <Widget>[
        new Divider(
          height: index != 0 ? 2.0 : 0.0,
        ),
        new ListTile(
          leading: new Container(
            child: new Text(
              evals[index].numericValue.toString(),
              textScaleFactor: 2.0,
            ),
            padding: EdgeInsets.only(left: 8.0),
          ),
          title: new Text(evals[index].subject),
          subtitle: new Text(evals[index].theme),
          trailing: new Column(
            children: <Widget>[
              new Text(evals[index].date.substring(0, 10)),
              globals.multiAccount ? new Text(
                evals[index].owner.name,
                style: new TextStyle(color: evals[index].owner.color),
              ) : new Text(""),
            ],
          ),
          onTap: () {
            evalDialog(index);
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    evals.clear();
    super.dispose();
  }
}

class AverageDialog extends StatefulWidget {
//  List newList;
  const AverageDialog();

  @override
  AverageDialogState createState() => new AverageDialogState();
}

class AverageDialogState extends State<AverageDialog> {
  List<Evaluation> evals = new List();
  List<Average> avers = new List();
  List<Average> currentAvers = new List();

  User selectedUser;
  List<User> users;

  void initSelectedUser() async {
    users = await AccountManager().getUsers();
    setState(() {
      selectedUser = users[0];
    });
  }

  void _onSelect(User user) async {
    selectedUser = user;

    setState(() {
      refWidgets();
    });
    }

  List<Widget> widgets = new List();

  Widget build(BuildContext context) {
    widgets.clear();
    avers = globals.avers;
    if (selectedUser==null)
      selectedUser = globals.selectedUser;
    users = globals.users;

    setState(() {
      refWidgets();
    });

    if (globals.multiAccount)
      widgets.add(
      new PopupMenuButton<User>(
        child: new Container(
          child: new Row(
            children: <Widget>[
              new Text(
                selectedUser.name,
                style: new TextStyle(color: Colors.black, fontSize: 17.0),
              ),
              new Icon(
                Icons.arrow_drop_down,
                color: Colors.black,
              ),
            ],
          ),
          padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 2.0),
        ),
        onSelected: _onSelect,
        itemBuilder: (BuildContext context) {
          return users.map((User user) {
            return new PopupMenuItem<User>(
              value: user,
              child: new Text(user.name),
            );
          }).toList();
        },
      ),
    );

    setState(() {
      if (currentAvers.isNotEmpty)
        widgets.add(
          new Container(
            child: new ListView.builder(
                itemBuilder: _itemBuilder, itemCount: currentAvers.length),
            width: 320.0,
            height: 400.0,
          )
        );
    });

    return new SimpleDialog(
      title: new Text("Átlag"),
      contentPadding: const EdgeInsets.all(10.0),
      children: widgets,
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
//    return new Text("test");

    return new ListTile(
      title: new Text(currentAvers[index].subject),
      subtitle: new Text(currentAvers[index].value.toString()),
      trailing: globals.multiAccount ? new Text(currentAvers[index].owner.name,
          style: TextStyle(color: currentAvers[index].owner.color)):null,
      onTap: () {
//        setState(() {});
      },
    );
  }

  void refWidgets() {
    currentAvers.clear();
    for (Average average in avers)
      if (average.owner.id == selectedUser.id) currentAvers.add(average);
  }
}
