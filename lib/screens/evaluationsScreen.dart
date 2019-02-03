import 'dart:async';

import 'package:flutter/material.dart';

import '../Datas/Average.dart';
import '../Datas/Evaluation.dart';
import '../Datas/User.dart';
import '../GlobalDrawer.dart';
import '../Helpers/AverageHelper.dart';
import '../Helpers/EvaluationHelper.dart';
import '../Utils/AccountManager.dart';
import '../Utils/StringFormatter.dart';
import '../globals.dart' as globals;
import '../Helpers/LocaleHelper.dart';
import '../Helpers/DataHelper.dart';
import '../Dialog/SortDialog.dart';
import '../Dialog/AverageDialog.dart';

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

  List<Evaluation> _evals = new List();
  List<Average> avers = new List();
  List<User> users = new List();
  Map<String, dynamic> evaluationsMap;
  Map<String, dynamic> onlyEvaluations;

  bool hasOfflineLoaded = false;
  bool hasLoaded = false;

  User selectedUser;

  void initSelectedUser() async {
    users = await AccountManager().getUsers();
    setState(() {
      selectedUser = users[0];
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
            ),
            body: new Container(
                child: hasOfflineLoaded
                    ? new Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: new RefreshIndicator(
                            child: new ListView.builder(
                              itemBuilder: _itemBuilder,
                              itemCount: _evals.length,
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
    avers = await AverageHelper().getAverages();
    globals.avers = avers;

    refreshOnline();

    _evals = normalEvalsSingle;

    switch (globals.sort) {
      case 0:
        _evals.sort((a, b) => b.creationDate.compareTo(a.creationDate));
        break;
      case 1:
        _evals.sort((a, b) => a.realValue.compareTo(b.realValue));
        break;
      case 2:
        _evals.sort((a, b) => a.subject.compareTo(b.subject));
        break;
    }

    hasLoaded = true;

    if (mounted)
      setState(() => completer.complete());
    return completer.future;
  }

  void refreshOffline() async {
    setState(() {
      switch (globals.sort) {
        case 0:
          _evals.sort((a, b) => b.creationDate.compareTo(a.creationDate));
          break;
        case 1:
          _evals.sort((a, b) {
            if (a.realValue == b.realValue)
              return b.creationDate.compareTo(a.creationDate);
            return a.realValue.compareTo(b.realValue);
          });
          break;
        case 2:
          _evals.sort((a, b) {
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

    if (globals.avers.length > 0)
      avers = globals.avers;
    else {
      avers = await AverageHelper().getAveragesOffline();
      globals.avers = avers;
    }

    refreshOffline();

    _evals = normalEvalsSingle;

    switch (globals.sort) {
      case 0:
        _evals.sort((a, b) => b.creationDate.compareTo(a.creationDate));
        break;
      case 1:
        _evals.sort((a, b) {
          if (a.realValue == b.realValue)
            return b.creationDate.compareTo(a.creationDate);
          return a.realValue.compareTo(b.realValue);
        });
        break;
      case 2:
        _evals.sort((a, b) {
          if (a.subject == b.subject)
            return b.creationDate.compareTo(a.creationDate);
          return a.subject.compareTo(b.subject);
        });
        break;
    }

    hasOfflineLoaded = true;

    if (mounted)
      setState(() => completer.complete());
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
                evaluation.teacher != null ? new Text(
                    AppLocalizations.of(context).teacher + evaluation.teacher)
                    : new Container(),
                evaluation.date != null ? new Text(
                    AppLocalizations.of(context).time + dateToHuman(evaluation))
                    : new Container(),
                evaluation.mode != null ? new Text(
                    AppLocalizations.of(context).mode + evaluation.mode)
                    : new Container(),
                evaluation.creationDate != null ? new Text(
                    AppLocalizations.of(context).administration_time +
                    evaluation.creationDate.substring(0, 16).replaceAll(
                        "-", ". ").replaceAll("T", ". ")) : new Container(),
                evaluation.weight != null ? new Text(
                    AppLocalizations.of(context).weight + evaluation.weight)
                    : new Container(),
                evaluation.value != null ? new Text(
                    AppLocalizations.of(context).value + evaluation.value)
                    : new Container(),
                evaluation.range != null ? new Text(
                    AppLocalizations.of(context).range + evaluation.range)
                    : new Container(),
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

    switch(_evals[index].value){
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
              _evals[index].numericValue != 0 ?
              _evals[index].numericValue.toString() : textShort ?? "?",
              textScaleFactor: 2.0,
              style: TextStyle(color: _evals[index].color),
            ),
            padding: EdgeInsets.only(left: 8.0),
          ),
          title: new Text(_evals[index].subject),
          subtitle: new Text(_evals[index].theme ?? _evals[index].value),
          trailing: new Column(
            children: <Widget>[
              new Text(_evals[index].date.substring(0, 10).replaceAll("-", ". ") + ". "),
            ],
          ),
          onTap: () {
            _evaluationDialog(_evals[index]);
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    EvaluationsScreenState().deactivate();
  }
}