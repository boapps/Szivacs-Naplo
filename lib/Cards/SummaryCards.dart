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

class SummaryCard extends StatelessWidget {
  List<Evaluation> summaryEvaluations;
  BuildContext context;
  int summaryType;
  DateTime date;

  SummaryCard(List<Evaluation> summaryEvaluations, BuildContext context, int summaryType, DateTime date) { //Summary types: 1: 1st Q, 2: Mid-year, 3: 3rd Q, 4: End-year
    this.summaryEvaluations = summaryEvaluations;
    this.context = context;
    this.summaryType = summaryType;
    this.date = date;
  }

  @override
  Widget build(BuildContext context) {
    String summaryTitle;
    switch (summaryType) {
      case 1:
        summaryTitle = "Első negyedévi jegyek";
        break;
      case 2:
        summaryTitle = "Félévi jegyek";
        break;
      case 3:
        summaryTitle = "Harmadik negyedévi jegyek";
        break;
      case 4:
        summaryTitle = "Év végi jegyek - Jó szünetet!";
        break;
      default:
        summaryTitle = "Hiba!";
    }

    return new Card(
        child: new Container(
      child: new Column(
        children: <Widget>[
          new Container(
            child: new Column(
              children: <Widget>[
                new Text(
                  summaryTitle,
                  style:
                      new TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            padding: EdgeInsets.all(7),
            color: globals.isDark ? Colors.white24 : Colors.black12,
            constraints: BoxConstraints.expand(height: 36),
          ),
          new Container(
            child: evaluationList(context)
          )
        ],
      ),
      decoration: new BoxDecoration(
        border: Border.all(
            color: globals.isDark ? Colors.white54 : Colors.black45,
            width: 1.5),
        borderRadius: new BorderRadius.all(Radius.circular(5)),
      ),
    ));
  }
  
  String getDate() {
    return summaryEvaluations.first.CreatingTime.toIso8601String()??"" + summaryEvaluations.first.trueID().toString()??"";
  }

  @override
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
              color: getColors(context, evaluation.realValue, false)
            ),
            ),
            alignment: Alignment(0,0),
            height: 40,
            width: 40,
            decoration: new BoxDecoration(
              color: getColors(context, evaluation.realValue, true),
              borderRadius: new BorderRadius.all(Radius.circular(40))
            ),
        ),
        title: new Text(evaluation.Subject ?? evaluation.Jelleg.Leiras),
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
            borderRadius: BorderRadius.circular(3),
          ),
        );
      },
    );
  }

  getColors(BuildContext context, int value, bool getBackground) {
    switch (value) { //Define background and foreground color of the card for number values.
        case 1:
          return getBackground
          ? globals.color1
          : globals.colorF1;
        case 2:
          return getBackground
          ? globals.color2
          : globals.colorF2;
        case 3:
          return getBackground
          ? globals.color3
          : globals.colorF3;
        case 4:
          return getBackground
          ? globals.color4
          : globals.colorF4;
        case 5:
          return getBackground
          ? globals.color5
          : globals.colorF5;
        default:
          return getBackground
          ? Colors.white
          : Colors.black;
  }
}
}