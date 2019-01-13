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
import 'package:flutter_localizations/flutter_localizations.dart';
import '../Helpers/LocaleHelper.dart';

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

  bool hasOfflineLoaded = false;
  bool hasLoaded = false;

  User selectedUser;
  List<User> users;

  void initSelectedUser() async {
    users = await AccountManager().getUsers();
    setState(() {
      selectedUser = users[0];
    });
  }

  void _onSelect(User user) async {
    setState(() {
      selectedUser = user;
    });
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

  Future<bool> sort() {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return new SortDialog();
      },
    ) ??
        false;
  }

  void ss() {

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
              title: new Text(AppLocalizations.of(context).evaluations),
              actions: <Widget>[
                new FlatButton(
                  onPressed: showAverages,
                  child: new Icon(Icons.assessment, color: Colors.white),
                ),
                new FlatButton(
                  onPressed: () {
                    sort().then((b) {
                      refreshOffline();
                    });
                  },
                  child: new Icon(Icons.sort, color: Colors.white),
                )
              ],
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
                              itemCount: evals.length,
                            ),
                            onRefresh: _onRefresh),
                      )
                    : new Center(child: new CircularProgressIndicator()))));
  }

  Map<String, dynamic> evaluationsMap;
  Map<String, dynamic> onlyEvaluations;

  Future<Null> _onRefresh() async {
    setState(() {
      hasLoaded = false;
    });
    Completer<Null> completer = new Completer<Null>();
    avers = await AverageHelper().getAverages();
    globals.avers = avers;

    evals = await EvaluationHelper().getEvaluations();

    evals.removeWhere((Evaluation e) => e.owner.id != globals.selectedUser.id);

    switch (globals.sort) {
      case 0:
        evals.sort((a, b) => b.creationDate.compareTo(a.creationDate));
        break;
      case 1:
        evals.sort((a, b) => a.numericValue.compareTo(b.numericValue));
        break;
      case 2:
        evals.sort((a, b) => a.subject.compareTo(b.subject));
        break;
    }

    if (mounted)
      setState(() {
        completer.complete();
        hasLoaded = true;
      });
    return completer.future;
  }

  void refreshOffline() async {
    setState(() {
      switch (globals.sort) {
        case 0:
          evals.sort((a, b) => b.creationDate.compareTo(a.creationDate));
          break;
        case 1:
          evals.sort((a, b) {
            if (a.numericValue == b.numericValue)
              return b.creationDate.compareTo(a.creationDate);
            return a.numericValue.compareTo(b.numericValue);
          });
          break;
        case 2:
          evals.sort((a, b) {
            if (a.subject == b.subject)
              return b.creationDate.compareTo(a.creationDate);
            return a.subject.compareTo(b.subject);
          });
          break;
      }
    });
  }

  Future<Null> _onRefreshOffline() async {
    setState(() {
      hasOfflineLoaded = false;
    });
    Completer<Null> completer = new Completer<Null>();
    avers = await AverageHelper().getAveragesOffline();
    globals.avers = avers;

    evals = await EvaluationHelper().getEvaluationsOffline();

    evals.removeWhere((Evaluation e) => e.owner.id != globals.selectedUser.id);

    switch (globals.sort) {
      case 0:
        evals.sort((a, b) => b.creationDate.compareTo(a.creationDate));
        break;
      case 1:
        evals.sort((a, b) {
          if (a.numericValue == b.numericValue)
            return b.creationDate.compareTo(a.creationDate);
          return a.numericValue.compareTo(b.numericValue);
        });
        break;
      case 2:
        evals.sort((a, b) {
          if (a.subject == b.subject)
            return b.creationDate.compareTo(a.creationDate);
          return a.subject.compareTo(b.subject);
        });
        break;
    }

    if (mounted)
      setState(() {
        completer.complete();
        hasOfflineLoaded = true;
      });
    return completer.future;
  }

  Future<Null> _evaluationDialog(Evaluation evaluation) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(evaluation.subject + " " + evaluation.value),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                evaluation.theme != "" && evaluation.theme != null
                    ? new Text(AppLocalizations.of(context).theme + evaluation.theme)
                    : new Container(),
                evaluation.teacher != null ? new Text(AppLocalizations.of(context).teacher + evaluation.teacher) : new Container(),
                evaluation.date != null ? new Text(AppLocalizations.of(context).time + evaluation.date.substring(0, 11)
                    .replaceAll("-", '. ')
                    .replaceAll("T", ". ")) : new Container(),
                evaluation.mode != null ? new Text(AppLocalizations.of(context).mode + evaluation.mode) : new Container(),
                evaluation.creationDate != null ? new Text(AppLocalizations.of(context).administration_time +
                    evaluation.creationDate.substring(0, 16).replaceAll(
                        "-", ". ").replaceAll("T", ". ")) : new Container(),
                evaluation.weight != null ? new Text(AppLocalizations.of(context).weight + evaluation.weight) : new Container(),
                evaluation.value != null ? new Text(AppLocalizations.of(context).value + evaluation.value) : new Container(),
                evaluation.range != null ? new Text(AppLocalizations.of(context).range + evaluation.range) : new Container(),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(AppLocalizations.of(context).ok),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {

    String textShort;

    switch(evals[index].value){
      case "Példás":
        textShort = ":D";
        break;
      case "Jó":
        textShort = ":)";
        break;
      case "Változó":
        textShort = ":/";
        break;
      case "Hanyag":
        textShort = ":(";
        break;
    }

    return new Column(
      children: <Widget>[
        new Divider(
          height: index != 0 ? 2.0 : 0.0,
        ),
        new ListTile(
          leading: new Container(
            child: new Text(
              evals[index].numericValue != 0 ?
              evals[index].numericValue.toString() : textShort ?? "?",
              textScaleFactor: 2.0,
              style: TextStyle(color: evals[index].color),
            ),
            padding: EdgeInsets.only(left: 8.0),
          ),
          title: new Text(evals[index].subject),
          subtitle: new Text(evals[index].theme ?? evals[index].value),
          trailing: new Column(
            children: <Widget>[
              new Text(evals[index].date.substring(0, 10).replaceAll("-", ". ") + ". "),
            ],
          ),
          onTap: () {
            _evaluationDialog(evals[index]);
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
      title: new Text(AppLocalizations.of(context).averages),
      contentPadding: const EdgeInsets.all(10.0),
      children: widgets,
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
//    return new Text("test");

    return new ListTile(
      title: new Text(currentAvers[index].subject),
      subtitle: new Text(currentAvers[index].value.toString(), style: TextStyle(
          color: currentAvers[index].value < 2 ? Colors.red : null),),
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

class SortDialog extends StatefulWidget {
//  List newList;
  const SortDialog();

  @override
  SortDialogState createState() => new SortDialogState();
}

class SortDialogState extends State<SortDialog> {
  int selected = 0;

  void _onSelect(String sel, List<String> sorba) {
    setState(() {
      selected = sorba.indexOf(sel);
      globals.sort = selected;
    });
  }

  Widget build(BuildContext context) {
    List<String> sorba = [AppLocalizations.of(context).sort_time, AppLocalizations.of(context).sort_eval, AppLocalizations.of(context).sort_subject];
    return new SimpleDialog(
      title: new Text(AppLocalizations.of(context).sort),
      contentPadding: const EdgeInsets.all(10.0),
      children: <Widget>[
        new PopupMenuButton<String>(
          child: new Container(
            child: new Row(
              children: <Widget>[
                new Text(
                  sorba[globals.sort],
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
          onSelected: (String sel) {_onSelect(sel, sorba);},
          itemBuilder: (BuildContext context) {
            return sorba.map((String sor) {
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
