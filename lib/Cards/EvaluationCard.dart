import 'package:flutter/material.dart';
import '../Datas/Evaluation.dart';
import '../globals.dart' as globals;
import '../Helpers/SettingsHelper.dart';
import 'dart:async';

class EvaluationCard extends StatelessWidget {
  Evaluation evaluation;
  Color bColor;
  Color fColor;

  IconData typeIcon;
  String typeName;
  bool showPadding;

  Future<bool> get isColor async {
    return await SettingsHelper().getColoredMainPage();
  }

  EvaluationCard(Evaluation evaluation, bool isColor){
    this.evaluation = evaluation;
//    fColor = Colors.white70;
//    bColor = Colors.black87;
    if (isColor) {
      switch (evaluation.numericValue) {
        case 1:
          bColor = Colors.red;
          fColor = Colors.white;
          break;
        case 2:
          bColor = Colors.brown;
          fColor = Colors.white;
          break;
        case 3:
          bColor = Colors.orange;
          fColor = Colors.white;
          break;
        case 4:
          bColor = Color.fromARGB(255, 255, 241,
              118); //rgb(255,235,59)rgb(253, 216, 53)rgb(192, 202, 51)rgb(255,241,118)rgb(255,234,0)rgb(255,255,0)
          fColor = Colors.black;
          break;
        case 5:
          bColor = Colors.green; //dce775
          fColor = Colors.white;
          break;
        default:
          bColor = Colors.black;
          fColor = Colors.white;
          break;
      }
    }
    bool hastype = true;
    switch(evaluation.mode) {
      case "Írásbeli témazáró dolgozat":
        typeIcon=Icons.widgets;
        typeName="TZ";
        break;
      case "Írásbeli röpdolgozat":
        typeIcon=Icons.border_color;
        typeName="röpdolgozat";
        break;
      case "Dolgozat":
        typeIcon=Icons.subject;
        typeName="dolgozat";
        break;
      case "Projektmunka":
        typeIcon=Icons.assignment;
        typeName="projektmunka";
        break;
      case "Gyakorlati feladat":
        typeIcon=Icons.directions_walk;
        typeName="gyakorlati feladat";
        break;
      case "Szódolgozat":
        typeIcon=Icons.language;
        typeName="szódolgozat";
        break;
      case "Szóbeli felelet":
        typeIcon=Icons.person;
        typeName="felelés";
        break;
      case "Házi feladat":
        typeIcon=Icons.home;
        typeName="házi feladat";
        break;
      case "Órai munka":
        typeIcon=Icons.school;
        typeName="órai munka";
        break;
      case "Versenyen, vetélkedőn való részvétel":
        typeIcon=Icons.account_balance;
        typeName="verseny";
        break;
      case "Magyar nyelv évfolyamdolgozat":
        typeIcon=Icons.book;
        typeName="évfolyamdolgozat";
        break;
      case "":
        typeIcon=null;
        typeName="";
        hastype = false;
        break;
      case "Na":
        typeIcon=null;
        typeName="";
        hastype = false;
        break;
      default:
        typeIcon=Icons.help;
        typeName=evaluation.mode;
        break;
    }

    showPadding = globals.multiAccount||hastype;
  }

  String getDate(){
    return evaluation.creationDate;
  }
  @override
  Key get key => new Key(getDate());

  @override
  Widget build(BuildContext context) {
    return  new Card(
      color: bColor,
      child: new Column(
        children: <Widget>[

          new Container(
            /*child: new Row(
              children: <Widget>[
                new Container(
                  child: new Text(evaluation.numericValue.toString(), style: new TextStyle(color: fColor, fontSize: 40.0)),
                  padding: EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
                ),
                new Container(
//                  width: 200.0,
                  child: new Column(
                  children: <Widget>[
                    new Text(evaluation.subject, style: new TextStyle(color: fColor, fontSize: 18.0)),
                    new Text(evaluation.theme, style: new TextStyle(color: fColor, fontSize: 18.0)),
                    new Text(evaluation.teacher, style: new TextStyle(color: fColor, fontSize: 15.0),),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                ),
                new Expanded(
                         child: new Container(
                              child: new Text(evaluation.date.substring(0, 10), style: new TextStyle(color: fColor, fontSize: 15.0,),),
                            alignment: Alignment(1.0, -1.0),
                          ),
                ),
                ],
            ),*/
            child: new ListTile(
              title: new Text(evaluation.subject, style: new TextStyle(color: fColor, fontSize: 18.0, fontWeight: FontWeight.bold)),
              leading: new Text(evaluation.numericValue.toString(), style: new TextStyle(color: fColor, fontSize: 40.0, fontWeight: FontWeight.bold)),
              subtitle: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(evaluation.theme, style: new TextStyle(color: fColor, fontSize: 18.0)),
                    new Text(evaluation.teacher, style: new TextStyle(color: fColor, fontSize: 15.0),),
                  ],
              ),
//              trailing: new Text(evaluation.date.substring(0, 10), style: new TextStyle(color: fColor, fontSize: 15.0,),),

            ),
            margin: EdgeInsets.all(10.0),
          ),
          !showPadding||globals.multiAccount ? new Container(
            child: new Text(evaluation.date.substring(0, 10), style: new TextStyle(fontSize: 16.0, color: fColor)),
            alignment: Alignment(1.0, -1.0),
            padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 2.0),
          ):new Container(),
          showPadding ? new Container(
            color: Colors.white,
          child: new Padding(
              padding: new EdgeInsets.all(7.0),
              child: new Row(
                children: <Widget>[
                  new Divider(),


                  new Padding(
                    padding: new EdgeInsets.all(7.0),
                    child: new Icon(typeIcon,  color: Colors.black87),
                  ),
                  new Padding(
                    padding: new EdgeInsets.all(7.0),
                    child: new Text(typeName,style: new TextStyle(fontSize: 18.0, color: Colors.black87),),
                  ),
                  globals.multiAccount ?  new Expanded(
                    child: new Container(
                      child: new Text(evaluation.owner.name, style: new TextStyle(color: evaluation.owner.color, fontSize: 18.0)),
                      alignment: Alignment(1.0, -1.0),
                    ),
                  ):new Container(),
                  !globals.multiAccount ? new Expanded(
                      child: new Container(
                        child: new Text(evaluation.date.substring(0, 10), style: new TextStyle(fontSize: 18.0, color: Colors.black87)),
                        alignment: Alignment(1.0, 0.0),
                      )):new Container(),

                ],
              ),
          )
          ):new Container()
        ],
      ),
    );
  }
}