import 'dart:async';

import 'package:flutter/material.dart';

import '../Datas/Student.dart';
import '../Helpers/SettingsHelper.dart';
import '../Utils/StringFormatter.dart';
import '../globals.dart' as globals;

class EvaluationCard extends StatelessWidget {
  Evaluation evaluation;
  Color bColor;
  Color fColor;

  IconData typeIcon;
  String typeName;
  bool showPadding;
  bool isSingle;

  BuildContext context;

  String textShort;

  Future<bool> get isColor async {
    return await SettingsHelper().getColoredMainPage();
  }

  EvaluationCard(Evaluation evaluation, bool isColor, bool isSingle, BuildContext context) {
    this.evaluation = evaluation;
    this.context = context;

    bool hastype = true;
    this.isSingle = isSingle;

    if (isColor) {
      switch (evaluation.realValue) { //Define background and foreground color of the card for number values.
        case 1:
          bColor = globals.color1;
          fColor = globals.colorF1;
          break;
        case 2:
          bColor = globals.color2;
          fColor = globals.colorF2;
          break;
        case 3:
          bColor = globals.color3;
          fColor = globals.colorF3;
          break;
        case 4:
          bColor = globals.color4;
          fColor = globals.colorF4;
          break;
        case 5:
          bColor = globals.color5;
          fColor = globals.colorF5;
          break;
        default:
          bColor = Colors.black;
          fColor = Colors.white;
          break;
      } //Define background and foreground color of the card for text values.
    } //Map text values to be more readable
    switch (evaluation.Value) {
      case "Példás":
        textShort = "5";
        break;
      case "Jó":
        textShort = "4";
        break;
      case "Változó":
        textShort = "3";
        break;
      case "Hanyag":
        textShort = "2";
        break;
    }

    switch (evaluation.Mode) { //Map evalutaion types to shorter, more readable versions. Set icons.
      case "Írásbeli témazáró dolgozat":
        typeIcon = Icons.widgets;
        typeName = "témazáró";
        break;
      case "Témazáró":
        typeIcon = Icons.widgets;
        typeName = "témazáró";
        break;
      case "Írásbeli röpdolgozat":
        typeIcon = Icons.border_color;
        typeName = "röpdolgozat";
        break;
      case "Beszámoló":
        typeIcon = Icons.border_color;
        typeName = "beszámoló";
        break;
      case "Dolgozat":
        typeIcon = Icons.subject;
        typeName = "dolgozat";
        break;
      case "Projektmunka":
        typeIcon = Icons.assignment;
        typeName = "projektmunka";
        break;
      case "Gyakorlati feladat":
        typeIcon = Icons.directions_walk;
        typeName = "gyakorlati feladat";
        break;
      case "Szódolgozat":
        typeIcon = Icons.language;
        typeName = "szódolgozat";
        break;
      case "Szóbeli felelet":
        typeIcon = Icons.person;
        typeName = "felelés";
        break;
      case "Házi feladat":
        typeIcon = Icons.home;
        typeName = "házi feladat";
        break;
      case "Órai munka":
        typeIcon = Icons.school;
        typeName = "órai munka";
        break;
      case "Versenyen, vetélkedőn való részvétel":
        typeIcon = Icons.account_balance;
        typeName = "verseny";
        break;
      case "Magyar nyelv évfolyamdolgozat":
        typeIcon = Icons.book;
        typeName = "évfolyamdolgozat";
        break;
      case "év végi":
        typeIcon = IconData(0xF23C, fontFamily: "Material Design Icons");
        typeName = "év végi dolgozat";
        break;
      case "Házi dolgozat":
        typeIcon = IconData(0xF224, fontFamily: "Material Design Icons");
        typeName = "házi dolgozat";
        break;
      case "":
        typeIcon = null;
        typeName = "";
        hastype = false;
        break;
      case "Na":
        typeIcon = null;
        typeName = "";
        hastype = false;
        break;
      default:
        typeIcon = Icons.help;
        typeName = evaluation.Mode;
        /*if (evaluation.Mode == null && !evaluation.isMidYear()) { //HELYETTE MÁSIK CARD KELL, EZEKET NEM MUTATJA KÜLÖN
          if (evaluation.isEndYear())
            typeName = "év végi";
          if (evaluation.isHalfYear())
            typeName = "félévi";
          if (evaluation.isFirstQuarter())
            typeName = "első negyedéves";
          if (evaluation.isThirdQuarter())
            typeName = "harmadik negyedéves";
        }*/
        break;
    }

    showPadding = !isSingle || hastype;
  }

  String getDate() {
    return evaluation.CreatingTime.toIso8601String()??"" +
        evaluation.trueID().toString()??"";
  }

  @override
  Key get key => new Key(getDate());

  void openDialog() {
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
            borderRadius: BorderRadius.circular(4),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return new GestureDetector(
      onTap: openDialog,
      child: new Card(
        margin: EdgeInsets.all(6.0),
        color: bColor,
        child: Container(
          child: new Column(
            children: <Widget>[
              new Container(
                child: new ListTile(
                  title: evaluation.Subject != null
                      ? new Text(evaluation.Subject,
                          style: new TextStyle(
                              color: fColor,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold))
                      : evaluation.Jelleg.Leiras != null
                      ? new Text(evaluation.Jelleg.Leiras,
                      style: new TextStyle(
                          color: fColor,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold))
                      : Container(),
                  leading: (evaluation.NumberValue != 0 && textShort == null)
                      ? new Text(evaluation.NumberValue.toString(),
                          style: new TextStyle(
                              color: fColor,
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold))
                      : new Text(textShort ?? "",
                          style: new TextStyle(
                              color: fColor,
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold)),
                  subtitle: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      evaluation.isText()
                          ? new Text(evaluation.Value)
                          : new Container(),
                      evaluation.Theme != null
                          ? new Text(evaluation.Theme,
                              style: new TextStyle(color: fColor, fontSize: 18.0))
                          : Container(),
                      new Text(
                        evaluation.Teacher,
                        style: new TextStyle(color: fColor, fontSize: 15.0),
                      ),
                    ],
                  ),
                ),
                margin: EdgeInsets.all(6.0),
              ),
              !showPadding || !isSingle
                  ? new Container(
                      child: new Text(
                          dateToHuman(evaluation.Date)??"" +
                              dateToWeekDay(evaluation.Date)??"",
                          style: new TextStyle(fontSize: 16.0, color: fColor)),
                      alignment: Alignment(1.0, -1.0),
                    )
                  : new Container(),
              showPadding
                  ? new Container(
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            style: BorderStyle.none,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        color: globals.isDark
                            ? Color.fromARGB(255, 25, 25, 25)
                            : Colors.white,
                      ),
                      child: new Padding(
                        padding: new EdgeInsets.fromLTRB(7.0, 3.0, 12.0, 3.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            new Divider(),
                            new Padding(
                              padding: new EdgeInsets.all(7.0),
                              child: new Icon(typeIcon,
                                  color: globals.isDark
                                      ? Colors.white
                                      : Colors.black87),
                            ),
                            new Padding(
                              padding: new EdgeInsets.all(7.0),
                              child: typeName != null
                                  ? new Text(
                                      typeName,
                                      style: new TextStyle(
                                          fontSize: 18.0,
                                          color: globals.isDark
                                              ? Colors.white
                                              : Colors.black87),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    )
                                  : new Text(
                                evaluation.Value,
                                      style: new TextStyle(
                                          fontSize: 18.0,
                                          color: globals.isDark
                                              ? Colors.white
                                              : Colors.black87),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                            ),
                            new Container(
                              child: new Padding(
                                child: (evaluation.Weight != "100%" && evaluation.Weight != null)
                                    ? new Text(evaluation.Weight,
                                        style: TextStyle(
                                            color: globals.isDark
                                                ? Colors.white
                                                : Colors.black87))
                                    : null,
                                padding: new EdgeInsets.all(2.0),
                                ),
                              alignment: Alignment(-1.0, 0.0),
                            ),
                            !isSingle
                                ? new Expanded(
                                    child: new Container(
                                      child: new Text(evaluation.owner.name ?? "",
                                        maxLines: 1,
                                        softWrap: false,
                                        overflow: TextOverflow.fade, 
                                        style: new TextStyle(
                                            color: evaluation.owner.color ??
                                                Colors.black,
                                            fontSize: 18.0)),
                                      alignment: Alignment(1.0, -1.0),
                                    ),
                                  )
                                : new Container(),
                            isSingle
                                ? new Expanded( 
                                    child: new Container(
                                      child: new Text(
                                        dateToHuman(evaluation.Date)??"" +
                                            dateToWeekDay(evaluation.Date)??"",
                                        maxLines: 1,
                                        softWrap: false,
                                        overflow: TextOverflow.fade,
                                        style: new TextStyle(
                                            fontSize: 16.0,
                                            color: globals.isDark
                                                ? Colors.white
                                                : Colors.black87),
                                        textAlign: TextAlign.end,
                                      ),
                                    alignment: Alignment(1.0, 0.0),
                                  ),
                                )
                                : new Container(),
                          ],
                        ),
                      ))
                  : new Container()
            ],
          ),
          decoration: new BoxDecoration(
            border: Border.all(
              color: Colors.transparent,
              width: 2.5),
            borderRadius: new BorderRadius.all(Radius.circular(5)),
          ),
        ),
      ),
    );
  }
}
