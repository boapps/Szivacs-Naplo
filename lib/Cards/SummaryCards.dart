//Contributed by RedyAu

import 'dart:async';
import 'dart:ffi';
import 'dart:math';
import 'dart:ui' as prefix0;

import 'package:flutter/material.dart';
import 'package:flutter_html/html_parser.dart';

import '../Datas/Student.dart';
import '../Helpers/SettingsHelper.dart';
import '../Utils/StringFormatter.dart';
import '../globals.dart' as globals;
import '../Cards/EvaluationCard.dart';
import '../Utils/ColorManager.dart';

class SummaryCard extends StatelessWidget {
  List<Evaluation> summaryEvaluations;
  BuildContext context;
  int summaryType;
  DateTime date;
  String title;
  bool showTheme;
  bool showTitle;

  SummaryCard(List<Evaluation> summaryEvaluations, BuildContext context, String title, bool showTheme, bool showTitle) { //Summary types: 1: 1st Q, 2: Mid-year, 3: 3rd Q, 4: End-year
    this.summaryEvaluations = summaryEvaluations;
    this.context = context;
    this.title = title;
    this.showTheme = showTheme;
    this.showTitle = showTitle;
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
      color: globals.isDark ? Color.fromARGB(255, 25, 25, 25) : Colors.grey[300],
      margin: EdgeInsets.all(6.0),
      child: new Container(
      child: new Column(
        children: <Widget>[
          showTitle
          ? new Container(
            child: new Column(
              children: <Widget>[
                new Text(
                  title,
                  style:
                      new TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            padding: EdgeInsets.all(7),
            constraints: BoxConstraints.expand(height: 36),
          )
          : new Container(),
          new Container(
            child: evaluationList(context),
            padding: EdgeInsets.fromLTRB(0.0, 6.0, 0.0, 6.0),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  style: BorderStyle.none,
                  width: 0,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              color: globals.isDark ? globals.isAmoled ? Colors.black : Color.fromARGB(255, 15, 15, 15) : Colors.white,
            ),
          )
        ],
      ),
      decoration: new BoxDecoration(
        border: Border.all(
            color: globals.isDark ? Color.fromARGB(255, 25, 25, 25) : Colors.grey[300],
            width: 2.5),
        borderRadius: new BorderRadius.all(Radius.circular(5)),
      ),
    ),
    shape: RoundedRectangleBorder(
      side: BorderSide(
        style: BorderStyle.none,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(5),
    ));
  }
  
  String getDate() {//Place the card on the main page where the last item on it would go
    return summaryEvaluations.first.CreatingTime.toIso8601String()??"" + summaryEvaluations.first.trueID().toString()??"";
  }

  @override //Köszi BoA az emailes segítségnyújtást, erre nem jöttem volna rá :D
  Key get key => new Key(getDate());

  Widget evaluationList(BuildContext context) {
    return Column(children: <Widget>[
      for (Evaluation evaluation in summaryEvaluations) new ListTile(
        leading: new Container(
          child: new Text(
            evaluation.realValue.toString(),
            style: new TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: globals.isColor ? getColors(context, evaluation.realValue, false) : Colors.white,
            )),
            alignment: Alignment(0,0),
            height: 40,
            width: 40,
            decoration: new BoxDecoration(
              color: globals.isColor ? getColors(context, evaluation.realValue, true) : Color.fromARGB(255, 15, 15, 15), 
              borderRadius: new BorderRadius.all(Radius.circular(40))
            ),
        ),
        title: new Text(
          evaluation.Subject ?? evaluation.Jelleg.Leiras,
          style: new TextStyle(
            fontWeight: FontWeight.bold
          ),
          ),
        subtitle: new Text(evaluation.Teacher),
        trailing: new Text(dateToHuman(evaluation.Date)),
        onTap: () {openDialog(evaluation);},
        )
    ]
    );
  }

  void openDialog(Evaluation evaluation) {
    _evaluationDialog(evaluation);
  }

  Widget listEntry(String data, {bold = false, right = false}) => new Container(
    child: new Text(
      data,
      style: TextStyle(fontSize: right ? 16 : 19, fontWeight: bold ? FontWeight.bold : FontWeight.normal),
    ),
    alignment: right ? Alignment(1, -1) : Alignment(0, 0),
    padding: EdgeInsets.only(bottom: 3),
  );

  Future<Null> _evaluationDialog(Evaluation evaluation) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return new SimpleDialog(
          children: <Widget>[
            new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  evaluation.Value != null
                      ? listEntry(evaluation.Value)
                      : new Container(),
                  evaluation.Weight != "" &&
                      evaluation.Weight != "100%" &&
                      evaluation.Weight != null
                      ? listEntry(evaluation.Weight,
                      bold: ["200%", "300%"].contains(evaluation.Weight))
                      : new Container(),
                  evaluation.Theme != "" && evaluation.Theme != null
                      ? listEntry(evaluation.Theme)
                      : new Container(),
                  evaluation.Mode != "" && evaluation.Theme != null
                      ? listEntry(evaluation.Mode)
                      : new Container(),
                  evaluation.CreatingTime != null
                      ? listEntry(
                      dateToHuman(evaluation.CreatingTime), right: true)
                      : new Container(),
                  evaluation.Teacher != null
                      ? listEntry(evaluation.Teacher, right: true)
                      : new Container(),
                ],
              ),
            ),
          ],
          title: (evaluation.Subject != null)
              ? Text(evaluation.Subject)
              : evaluation.Jelleg.Leiras != null
              ? Text(evaluation.Jelleg.Leiras)
              : new Container(),
          contentPadding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              style: BorderStyle.none,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
        );
      },
    );
  }
}
