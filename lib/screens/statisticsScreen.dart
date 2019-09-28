import 'dart:convert' show utf8, json;
import 'dart:ui';

import 'package:charts_flutter/flutter.dart';
import 'package:e_szivacs/generated/i18n.dart';
import 'package:flutter/material.dart';

import '../Datas/Average.dart';
import '../Datas/Student.dart';
import '../GlobalDrawer.dart';
import '../Utils/StringFormatter.dart';
import '../globals.dart' as globals;

void main() {
  runApp(new MaterialApp(home: new StatisticsScreen()));
}

class StatisticsScreen extends StatefulWidget {
  @override
  StatisticsScreenState createState() => new StatisticsScreenState();
}
//todo refactor this file
List<Average> averages = new List();
List<TimeAverage> timeData = new List();
var series;

class StatisticsScreenState extends State<StatisticsScreen> {
  Average selectedAverage;
  final List<Series<TimeAverage, DateTime>> seriesList = new List();
  List<Evaluation> evals = new List();
  String avrString = "";
  String classAvrString = "";
  int db1 = 0;
  int db2 = 0;
  int db3 = 0;
  int db4 = 0;
  int db5 = 0;
  double allAverage;
  double allMedian;
  int allMode;

  Color color = MaterialPalette.blue.shadeDefault;

  @override
  void initState() {
    switch (globals.themeID) {
      case 0:
        color = MaterialPalette.blue.shadeDefault;
        break;
      case 1:
        color = MaterialPalette.red.shadeDefault;
        break;
      case 2:
        color = MaterialPalette.green.shadeDefault;
        break;
      case 3:
        color = MaterialPalette.green.shadeDefault;
        break;
      case 4:
        color = MaterialPalette.yellow.shadeDefault;
        break;
      case 5:
        color = MaterialPalette.deepOrange.shadeDefault;
        break;
      case 6:
        color = MaterialPalette.gray.shadeDefault;
        break;
      case 7:
        color = MaterialPalette.pink.shadeDefault;
        break;
      case 8:
        color = MaterialPalette.purple.shadeDefault;
        break;
      case 9:
        color = MaterialPalette.teal.shadeDefault;
        break;
    }

    setState(() {
      _initStats();
    });
    super.initState();
  }

  void initEvals() async {
    await globals.selectedAccount.refreshStudentString(true);
    evals = globals.selectedAccount.student.Evaluations;
    evals.removeWhere((Evaluation evaluation) =>
    evaluation.NumberValue == 0 ||
        evaluation.Mode == "Na" || evaluation.Weight == null ||
        evaluation.Weight == "-" || !evaluation.isMidYear());
    _onSelect(averages[0]);
    for (Evaluation e in evals)
      switch (e.NumberValue) {
        case 1:
          db1++;
          break;
        case 2:
          db2++;
          break;
        case 3:
          db3++;
          break;
        case 4:
          db4++;
          break;
        case 5:
          db5++;
          break;
      }
    allAverage = getAllAverages();
    allMedian = getMedian();
    allMode = getModusz();
    if (allMedian==null)
      allMedian = 0;
    if (allAverage==null)
      allAverage = 0;
    if (allMode==null)
      allMode = 0;
  }

  double getAllAverages() {
    double sum = 0;
    double n = 0;
    for (Evaluation e in evals) {
      if (e.NumberValue != 0) {
        double multiplier = 1;
        try {
          multiplier = double.parse(e.Weight.replaceAll("%", "")) / 100;
        } catch (e) {
          print(e);
        }
        sum += e.NumberValue * multiplier;
        n += multiplier;
      }
    }
    return sum / n;

  }

  double getMedian() {
    List<int> jegyek = new List();
    for (Evaluation e in evals)
      jegyek.add(e.NumberValue);
    jegyek.sort();
    if (!jegyek.length.isEven)
      return jegyek[((jegyek.length+1)/2).round()]/1;
    return (jegyek[(jegyek.length/2).round()]+jegyek[(jegyek.length/2+1).round()])/2;
  }

  int getModusz(){
    int max = 0;
    List<int> dbk = [db1, db2, db3, db4, db5];
    for (int n in dbk)
      if (n > max)
        max = n;
    return dbk.indexOf(max)+1;
  }

  void _initStats() async {
    await globals.selectedAccount.refreshStudentString(true);
    setState(() {
      averages = globals.selectedAccount.averages ?? List();
      averages.removeWhere((Average average) => average.value < 1);
      if (averages == null || averages.isEmpty)
        averages = [Average("", "", "", 0.0, 0.0, 0.0)];
      averages.sort((Average a, Average b) {
        return a.subject.compareTo(b.subject);
      });
      selectedAverage = averages[0];
      globals.selectedAverage = selectedAverage;
      avrString = selectedAverage.value.toString();
      classAvrString = selectedAverage.classValue.toString();
    });

    initEvals();
  }

  void _onSelect(Average average) async {
    setState(() {
      selectedAverage = average;
      globals.selectedAverage = selectedAverage;
      globals.currentEvals.clear();
      timeData.clear();
      series = [
        new Series(
          displayName: "asd",
          id: "averages",
          colorFn: (_, __) => color,
          domainFn: (TimeAverage sales, _) => sales.time,
          measureFn: (TimeAverage sales, _) => sales.sales,
          data: timeData,
        ),
      ];
    });

    for (Evaluation e in evals.reversed) {
      if (e.NumberValue != 0) {
        if (average.subject == e.Subject) {
          globals.currentEvals.add(e);
          setState(() {
            timeData.add(new TimeAverage(
                e.Date,
                e.NumberValue));
            series = [
              new Series(
                displayName: "asd",
                id: "averages",
                colorFn: (_, __) => color,
                domainFn: (TimeAverage sales, _) => sales.time,
                measureFn: (TimeAverage sales, _) => sales.sales,
                data: timeData,
              ),
            ];
          });
        }
      }
    }
    avrString = average.value.toString();
  }

  void callback() {
    setState(() {
      timeData.clear();
      double sum = 0;
      double n = 0;
      for (Evaluation e in globals.currentEvals) {
        if (e.NumberValue != 0) {
          double multiplier = 1;
          try {
            multiplier = double.parse(e.Weight.replaceAll("%", "")) / 100;
          } catch (e) {
            print(e);
          }

          sum += e.NumberValue * multiplier;
          n += multiplier;

          setState(() {
            timeData.add(new TimeAverage(e.Date, e.NumberValue));
            series = [
              new Series(
                displayName: "asd",
                id: "averages",
                colorFn: (_, __) => color,
                domainFn: (TimeAverage sales, _) => sales.time,
                measureFn: (TimeAverage sales, _) => sales.sales,
                data: timeData,
              ),
            ];
          });
          avrString = (sum / n).toStringAsFixed(2);
        }
      }
    });
  }

  int currentBody = 0;
  Widget averageBody;
  Widget dataBody;

  @override
  Widget build(BuildContext context) {
    series = [
      new Series(
        displayName: "asd",
        id: "averages",
        colorFn: (_, __) => color,
        domainFn: (TimeAverage sales, _) => sales.time,
        measureFn: (TimeAverage sales, _) => sales.sales,
        data: timeData,
      ),
    ];

    dataBody = new SingleChildScrollView(child: new Center(
      child: new Container(
        margin: EdgeInsets.all(10),
        child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                new Text(S
                    .of(context)
                    .grade1, style: TextStyle(fontSize: 21),),
                new Text(db1.toString() + " db", style: TextStyle(fontSize: 21),),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),

            Row(
              children: <Widget>[
                new Text(S
                    .of(context)
                    .grade2, style: TextStyle(fontSize: 21),),
                new Text(db2.toString() + " db", style: TextStyle(fontSize: 21),),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            Row(
              children: <Widget>[
                new Text(S
                    .of(context)
                    .grade3, style: TextStyle(fontSize: 21),),
                new Text(db3.toString() + " db", style: TextStyle(fontSize: 21),),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            Row(
              children: <Widget>[
                new Text(S
                    .of(context)
                    .grade4, style: TextStyle(fontSize: 21),),
                new Text(db4.toString() + " db", style: TextStyle(fontSize: 21),),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            Row(
              children: <Widget>[
                new Text(S
                    .of(context)
                    .grade5, style: TextStyle(fontSize: 21),),
                new Text(db5.toString() + " db", style: TextStyle(fontSize: 21),),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            new Divider(),
            Row(
              children: <Widget>[
                new Text(S
                    .of(context)
                    .all_average, style: TextStyle(fontSize: 21),),
                new Text(allAverage != null ? allAverage.toStringAsFixed(2):"...", style: TextStyle(fontSize: 21),),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            Row(
              children: <Widget>[
                new Text(S
                    .of(context)
                    .all_median, style: TextStyle(fontSize: 21),),
                new Text(allMedian != null ? allMedian.toStringAsFixed(2):"...", style: TextStyle(fontSize: 21),),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            Row(
              children: <Widget>[
                new Text(S
                    .of(context)
                    .all_mode, style: TextStyle(fontSize: 21),),
                new Text(allMode != null ? allMode.toString():"...", style: TextStyle(fontSize: 21),),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),

          ],
      ),
      ),
    ),
    );

    averageBody = new Stack(
        children: <Widget>[
          new Column(
            children: <Widget>[
              new Container(
                  child: selectedAverage != null
                      ? new DropdownButton(
                    items: averages.map((Average average) {
                      return new DropdownMenuItem<Average>(
                          value: average,
                          child: new Row(
                            children: <Widget>[
                              new Text(average.subject),
                            ],
                          ));
                    }).toList(),
                    onChanged: _onSelect,
                    value: selectedAverage,
                  ) : new Container(),
                alignment: Alignment(0, 0),
                margin: EdgeInsets.all(5),
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(S
                      .of(context)
                      .average),
                  new Text(
                    avrString,
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold),
                  ),
                  new Container(padding: EdgeInsets.only(left: 10),),
                  selectedAverage != null ? selectedAverage.classValue != null
                      ? new Text(S
                      .of(context)
                      .class_average)
                      : Container() : Container(),
                  selectedAverage != null ? selectedAverage.classValue != null
                      ? new Text(
                    selectedAverage.classValue.toString(),
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold),
                  )
                      : Container() : Container(),
                ],
              ),
              new Container(
                child: new SizedBox(
                  child: new TimeSeriesChart(
                    series,
                    animate: true,
                    primaryMeasureAxis: NumericAxisSpec(
                      showAxisLine: true,
                    ),
                  ),
                  height: 150,
                ),
              ),
              new Flexible(child:
              new Container(
                child: new ListView.builder(
                  itemBuilder: _itemBuilder,
                  itemCount: globals.currentEvals.length,
                  shrinkWrap: true,
                ),
              ),
              ),
            ],
          ),
        ]);


    return new WillPopScope(
        onWillPop: () {
          globals.screen = 0;
          Navigator.pushReplacementNamed(context, "/main");
        },
        child: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: currentBody,
              items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: new Icon(Icons.insert_chart),
                title: new Text(S
                    .of(context)
                    .averages),
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.info),
                title: new Text(S
                    .of(context)
                    .datas),
              ),
            ],
            onTap: switchToScreen,
            ),
            drawer: GDrawer(),
            appBar: new AppBar(
              title: new Text(S
                  .of(context)
                  .statistics),
              actions: <Widget>[
                currentBody==0 ? new FlatButton(
                  onPressed: () {
                    return showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (BuildContext context) {
                            return new GradeDialog(this.callback);
                          },
                        ) ??
                        false;
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ):new Container(),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            body: currentBody==0 ? averageBody:dataBody));
  }

  void switchToScreen(int n) {
    setState(() {
      currentBody = n;
    });
  }

  Widget _itemBuilder(BuildContext context, int index) {
    try {
      return new Column(
        children: <Widget>[
          new Divider(
            height: index != 0 ? 2.0 : 0.0,
          ),
          new ListTile(
            leading: new Container(
              child: new Text(
                  globals.currentEvals[index].NumberValue.toString(),
                textScaleFactor: 2.0,
                style: TextStyle(color: globals.currentEvals[index].color)
              ),
              padding: EdgeInsets.only(left: 8.0),
            ),
            title: new Text(globals.currentEvals[index].Subject),
            subtitle: new Text(globals.currentEvals[index].Theme),
            trailing: new Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Column(
                  children: <Widget>[
                    new Text(dateToHuman(globals.currentEvals[index].Date)),
                    new Text(dateToWeekDay(globals.currentEvals[index].Date)),
                  ],
                ),
                globals.currentEvals[index].Mode == "Hamis"
                    ? new Container(
                        padding: EdgeInsets.all(0.0),
                        margin: EdgeInsets.all(0),
                        height: 40,
                        width: 40,
                        child: new FlatButton(
                          onPressed: () {
                            setState(() {
                              globals.currentEvals.removeAt(index);
                              callback();
                            });
                          },
                          child: new Icon(
                            Icons.clear,
                            color: Colors.redAccent,
                            size: 30,
                          ),
                          padding: EdgeInsets.all(0.0),
                        ),
                      )
                    : new Container(),
              ],
            ),
            onTap: () {
              _evaluationDialog(globals.currentEvals[index]);
            },
          ),
        ],
      );
    } catch (e) {
      print(e);
    }
  }

  Future<Null> _evaluationDialog(Evaluation evaluation) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(evaluation.Subject + " " + evaluation.Value),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                evaluation.Theme != ""
                    ? new Text(S
                    .of(context)
                    .theme + evaluation.Theme)
                    : new Container(),
                new Text(S
                    .of(context)
                    .teacher + evaluation.Teacher),
                new Text(S
                    .of(context)
                    .time +
                    dateToHuman(evaluation.Date)),
                new Text(S
                    .of(context)
                    .mode + evaluation.Mode),
                new Text(S
                    .of(context)
                    .administration_time +
                    dateToHuman(evaluation.CreatingTime)),
                new Text(S
                    .of(context)
                    .weight + evaluation.Weight),
                new Text(S
                    .of(context)
                    .value + evaluation.Value),
                new Text(S
                    .of(context)
                    .range + evaluation.FormName),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(S
                  .of(context)
                  .ok),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class TimeAverage {
  DateTime time;
  int sales;

  TimeAverage(this.time, this.sales);
}

class GradeDialog extends StatefulWidget {
  Function callback;
  GradeDialog(this.callback);
  @override
  GradeDialogState createState() => new GradeDialogState();
}

class GradeDialogState extends State<GradeDialog> {
  static const List<int> GRADES = [1, 2, 3, 4, 5];

  var jegy = 1;
  bool isTZ = false;

  String weight = "200";

  void _onWeightInput(String text) {
    weight = text;
  }

  Widget build(BuildContext context) {
    return new SimpleDialog(
      contentPadding: EdgeInsets.all(0),
      title: new Text(S
          .of(context)
          .if_i_got),
      children: <Widget>[
        Container(
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Radio<int>(
                  value: 1,
                  groupValue: jegy,
                  onChanged: (int value) {
                    setState(() {
                      jegy = value;
                    });
                  },
                  activeColor: Theme.of(context).accentColor,
                ),
                Radio<int>(
                  value: 2,
                  groupValue: jegy,
                  onChanged: (int value) {
                    setState(() {
                      jegy = value;
                    });
                  },
                  activeColor: Theme.of(context).accentColor,
                ),
                Radio<int>(
                  value: 3,
                  groupValue: jegy,
                  onChanged: (int value) {
                    setState(() {
                      jegy = value;
                    });
                  },
                  activeColor: Theme.of(context).accentColor,
                ),
                Radio<int>(
                  value: 4,
                  groupValue: jegy,
                  onChanged: (int value) {
                    setState(() {
                      jegy = value;
                    });
                  },
                  activeColor: Theme.of(context).accentColor,
                ),
                Radio<int>(
                  value: 5,
                  groupValue: jegy,
                  onChanged: (int value) {
                    setState(() {
                      jegy = value;
                    });
                  },
                  activeColor: Theme.of(context).accentColor,
                ),
              ]),
          padding: EdgeInsets.only(left: 20, right: 20),
        ),
        Container(
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
              Text(
                "1",
                textAlign: TextAlign.center,
              ),
              Text(
                "2",
                textAlign: TextAlign.center,
              ),
              Text(
                "3",
                textAlign: TextAlign.center,
              ),
              Text(
                "4",
                textAlign: TextAlign.center,
              ),
              Text(
                "5",
                textAlign: TextAlign.center,
              ),
            ])),
        new Center(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text("TZ: "),
              new Checkbox(
                value: isTZ,
                onChanged: (value) {
                  setState(() {
                    isTZ = value;
                  });
                },
                activeColor: Theme.of(context).accentColor,
              ),
              new Container(
                width: 60,
                child: new TextField(
                  maxLines: 1,
                  onChanged: _onWeightInput,
                  autocorrect: false,
                  autofocus: isTZ,
                  decoration: InputDecoration(
                    suffix: Text("%"),
                    hintText: "200"
                  ),
                  keyboardAppearance: Brightness.dark,
                  enabled: isTZ,
                ),
              ),
            ],
          ),
        ),
        new FlatButton(
          onPressed: () {
            setState(() {
              Evaluation falseGrade = Evaluation.fromMap(json.decode("""
              {
      "EvaluationId": 12345678,
      "Form": "Mark",
      "FormName": "Elégtelen (1) és Jeles (5) között az öt alapértelmezett érték",
      "Type": "MidYear",
      "TypeName": "Évközi jegy/értékelés",
      "Subject": "${globals.selectedAverage.subject}",
      "SubjectCategory": null,
      "SubjectCategoryName": "",
      "Theme": "",
      "IsAtlagbaBeleszamit": true,
      "Mode": "Hamis",
      "Weight": "$weight",
      "Value": "Jeles(5)",
      "NumberValue": $jegy,
      "SeenByTutelaryUTC": null,
      "Teacher": "",
      "Date": "${DateTime.now().toIso8601String()}",
      "CreatingTime": "${DateTime.now().toIso8601String()}",
      "Jelleg": {
        "Id": 1,
        "Nev": "Ertekeles",
        "Leiras": "Értékelés"
      },
      "JellegNev": "Ertekeles",
      "ErtekFajta": {
        "Id": 1,
        "Nev": "Osztalyzat",
        "Leiras": "Osztályzat"
      }
    }
              """), globals.selectedUser);
              globals.currentEvals.add(falseGrade);
              this.widget.callback();
              Navigator.pop(context);
            });
          },
          child: new Text(
            S
                .of(context)
                .done,
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
          padding: EdgeInsets.all(10),
        ),
      ],
    );
  }
}
