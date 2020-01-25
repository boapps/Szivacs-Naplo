//Contributed by RedyAu

import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';

import '../Datas/Student.dart';
import '../Helpers/SettingsHelper.dart';
import '../Utils/StringFormatter.dart';
import '../globals.dart' as globals;

class SummaryCard extends StatelessWidget {
  
  List<Evaluation> summaryEvaluations;
  BuildContext context;
  int summaryType;
  DateTime date;

  SummaryCard (List<Evaluation> summaryEvaluations, BuildContext context, int summaryType, DateTime date) { //Summary types: 1: 1st Q, 2: Mid-year, 3: 3rd Q, 4: End-year
    this.summaryEvaluations = summaryEvaluations;
    this.context = context;
    this.summaryType = summaryType;
    this.date = date;
  }
  /*static void itemToList(gotEvaluation) {
    summaryEvaluations.add(gotEvaluation);
  }*/

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new Card(
        child: new Text (summaryType.toString())
      )
      );
    
  }
}