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
        )
    ]
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