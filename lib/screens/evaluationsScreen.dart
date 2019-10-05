import 'dart:async';

import 'package:e_szivacs/generated/i18n.dart';
import 'package:flutter/material.dart';

import '../Datas/Average.dart';
import '../Datas/Student.dart';
import '../Datas/User.dart';
import '../Dialog/AverageDialog.dart';
import '../Dialog/SortDialog.dart';
import '../GlobalDrawer.dart';
import '../Utils/StringFormatter.dart';
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
    _onRefreshOffline();
  }

  List<Evaluation> _evaluations = new List();
  List<Average> averages = new List();
  List<User> users = new List();

  bool hasOfflineLoaded = false;
  bool hasLoaded = true;

  User selectedUser;

  Future<bool> showAveragesDialog() {
    return showDialog(
          barrierDismissible: true,
          context: context,
          builder: (BuildContext context) {
            return new AverageDialog();
          },
        ) ??
        false;
  }

  Future<bool> showSortDialog() {
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
              title: new Text(S.of(context).evaluations),
              actions: <Widget>[
                new Tooltip(
                  child: new FlatButton(
                    onPressed: showAveragesDialog,
                    child: new Icon(Icons.assessment, color: Colors.white),
                  ),
                  message: S.of(context).averages,
                ),
                new Tooltip(
                  child: new FlatButton(
                    onPressed: () {
                      showSortDialog().then((b) {
                        refreshSort();
                      });
                    },
                    child: new Icon(Icons.sort, color: Colors.white),
                  ),
                  message: S.of(context).sort,
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
                        new Expanded(
                          child: new RefreshIndicator(
                              child: new ListView.builder(
                                itemBuilder: _itemBuilder,
                                itemCount: _evaluations.length,
                              ),
                              onRefresh: _onRefresh),
                        )
                      ])
                    : new Center(child: new CircularProgressIndicator()))));
  }

  Future<Null> _onRefresh() async {
    setState(() {
      hasLoaded = false;
    });

    Completer<Null> completer = new Completer<Null>();

    await globals.selectedAccount.refreshStudentString(false);

    averages = globals.selectedAccount.averages;

    _evaluations = globals.selectedAccount.midyearEvaluations;

    switch (globals.sort) {
      case 0:
        _evaluations.sort((a, b) => b.CreatingTime.compareTo(a.CreatingTime));
        break;
      case 1:
        _evaluations.sort((a, b) => a.realValue.compareTo(b.realValue));
        break;
      case 2:
        _evaluations.sort((a, b) => a.Subject.compareTo(b.Subject));
        break;
      case 3:
        _evaluations.sort((a, b) => a.Date.compareTo(b.Date));
        break;
    }

    hasLoaded = true;

    if (mounted) setState(() => completer.complete());
    return completer.future;
  }

  void refreshSort() async {
    setState(() {
      switch (globals.sort) {
        case 0:
          _evaluations.sort((a, b) => b.CreatingTime.compareTo(a.CreatingTime));
          break;
        case 1:
          _evaluations.sort((a, b) {
            if (a.realValue == b.realValue)
              return b.CreatingTime.compareTo(a.CreatingTime);
            return a.realValue.compareTo(b.realValue);
          });
          break;
        case 2:
          _evaluations.sort((a, b) {
            if (a.Subject == b.Subject)
              return b.CreatingTime.compareTo(a.CreatingTime);
            return a.Subject.compareTo(b.Subject);
          });
          break;
        case 3:
          _evaluations.sort((a, b) => b.Date.compareTo(a.Date));
          break;
      }
    });
  }

  Future<Null> _onRefreshOffline() async {
    setState(() {
      hasOfflineLoaded = false;
    });
    Completer<Null> completer = new Completer<Null>();

    globals.selectedAccount.refreshStudentString(true);
    globals.selectedAccount.refreshStudentString(true);

    averages = globals.selectedAccount.averages;

    _evaluations = globals.selectedAccount.midyearEvaluations;

    switch (globals.sort) {
      case 0:
        _evaluations.sort((a, b) => b.CreatingTime.compareTo(a.CreatingTime));
        break;
      case 1:
        _evaluations.sort((a, b) {
          if (a.realValue == b.realValue)
            return b.CreatingTime.compareTo(a.CreatingTime);
          return a.realValue.compareTo(b.realValue);
        });
        break;
      case 2:
        _evaluations.sort((a, b) {
          if (a.Subject == b.Subject)
            return b.CreatingTime.compareTo(a.CreatingTime);
          return a.Subject.compareTo(b.Subject);
        });
        break;
      case 3:
        _evaluations.sort((a, b) => b.Date.compareTo(a.Date));
        break;
    }

    hasOfflineLoaded = true;

    if (mounted) setState(() => completer.complete());
    return completer.future;
  }

  Future<Null> _evaluationDialog(Evaluation evaluation) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(evaluation.Subject + " " + evaluation.Value),
          titlePadding: EdgeInsets.only(left: 16, right: 16, top: 16),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                evaluation.Theme != "" && evaluation.Theme != null
                    ? new Text(S.of(context).theme + evaluation.Theme)
                    : new Container(),
                evaluation.Teacher != null
                    ? new Text(S.of(context).teacher + evaluation.Teacher)
                    : new Container(),
                evaluation.Date != null
                    ? new Text(
                        S.of(context).time + dateToHuman(evaluation.Date))
                    : new Container(),
                evaluation.Mode != null
                    ? new Text(S.of(context).mode + evaluation.Mode)
                    : new Container(),
                evaluation.CreatingTime != null
                    ? new Text(S.of(context).administration_time +
                        dateToHuman(evaluation.Date))
                    : new Container(),
                evaluation.Weight != null
                    ? new Text(S.of(context).weight + evaluation.Weight)
                    : new Container(),
                evaluation.Value != null
                    ? new Text(S.of(context).value + evaluation.Value)
                    : new Container(),
                evaluation.FormName != null
                    ? new Text(S.of(context).range + evaluation.FormName)
                    : new Container(),
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

  Widget _itemBuilder(BuildContext context, int index) {
    String textShort;

    switch (_evaluations[index].Value) {
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

    Widget sep = new Container();

    switch (globals.sort) {
      case 0:
        break;
      case 1:
        if (((index == 0) && (_evaluations[index].Value.length < 16) ||
            (_evaluations[index].Value != _evaluations[index - 1].Value &&
                _evaluations[index].Value.length < 16)))
          sep = Container(
            child: new Text(
              _evaluations[index].Value,
              style: TextStyle(fontSize: 16),
            ),
            margin: EdgeInsets.all(6),
          );
        break;
      case 2:
        if (index == 0 ||
            (_evaluations[index].Subject != _evaluations[index - 1].Subject))
          sep = Container(
            child: new Text(
              _evaluations[index].Subject,
              style: TextStyle(fontSize: 16),
            ),
            margin: EdgeInsets.all(6),
          );
        break;
    }

    return new Column(
      children: <Widget>[
        sep,
        new Divider(
          height: index != 0 ? 2.0 : 0.0,
        ),
        new ListTile(
          leading: new Container(
            child: new Text(
              _evaluations[index].NumberValue != 0
                  ? _evaluations[index].NumberValue.toString()
                  : textShort ?? "?",
              textScaleFactor: 2.0,
              style: TextStyle(color: _evaluations[index].color),
            ),
            padding: EdgeInsets.only(left: 8.0),
          ),
          title: new Text(_evaluations[index].Subject),
          subtitle:
              new Text(_evaluations[index].Theme ?? _evaluations[index].Value),
          trailing: new Column(
            children: <Widget>[
              new Text(dateToHuman(_evaluations[index].Date)),
              new Text(dateToWeekDay(_evaluations[index].Date)),
            ],
          ),
          onTap: () {
            _evaluationDialog(_evaluations[index]);
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
