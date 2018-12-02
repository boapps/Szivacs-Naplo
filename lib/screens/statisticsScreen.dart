import 'dart:ui';
import 'package:flutter/material.dart';
import '../GlobalDrawer.dart';
import '../globals.dart' as globals;
import '../Datas/Average.dart';
import '../Datas/Evaluation.dart';
import '../Helpers/AverageHelper.dart';
import '../Helpers/EvaluationHelper.dart';
import 'package:charts_flutter/flutter.dart';

void main() {
  runApp(new MaterialApp(home: new StatisticsScreen()));
}

class StatisticsScreen extends StatefulWidget {
  @override
  StatisticsScreenState createState() => new StatisticsScreenState();
}

List<Average> averages = new List();
List<TimeAverage> data = new List();
var series;

class StatisticsScreenState extends State<StatisticsScreen> {
  Average selectedAverage;
  final List<Series<TimeAverage, DateTime>> seriesList = new List();
  List<Evaluation> evals = new List();
  String avrString = "Átlag: ";
  String classAvrString = "Osztályátlag: ";

  @override
  void initState() {
    setState(() {
      _initStats();
      initEvals();
    });
    super.initState();
  }

  void initEvals() async {
    evals = await EvaluationHelper().getEvaluationsOffline();
    evals.removeWhere((Evaluation e) => e.owner.id != globals.selectedUser.id);
    _onSelect(averages[0]);
  }

  void _initStats() async {
    await AverageHelper().getAveragesOffline().then((List<Average> avrs) {
      setState(() {
        avrs.removeWhere((Average e) => e.owner.id != globals.selectedUser.id);
        averages = avrs;
        selectedAverage = averages[0];
        globals.selectedAverage = selectedAverage;
        avrString = selectedAverage.value.toString();
        classAvrString = selectedAverage.classValue.toString();
        print(averages);
      });
    });
  }

  void _onSelect(Average average) async {
    setState(() {
      selectedAverage = average;
      globals.selectedAverage = selectedAverage;
      globals.currentEvals.clear();
      data.clear();
      series = [
        new Series(
          displayName: "asd",
          id: "averages",
          colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
          domainFn: (TimeAverage sales, _) => sales.time,
          measureFn: (TimeAverage sales, _) => sales.sales,
          data: data,
        ),
      ];
    });

    for (Evaluation e in evals) {
      print(e.subject);
      print(average.subject);
      if (average.subject == e.subject) {
        globals.currentEvals.add(e);
        print(e.date);
        print(e.date.substring(5, 7));
        setState(() {
          data.add(new TimeAverage(
              new DateTime(
                  int.parse(e.date.substring(0, 4)),
                  int.parse(e.date.substring(5, 7)),
                  int.parse(e.date.substring(8, 10))),
              e.numericValue));
          print(data);
          series = [
            new Series(
              displayName: "asd",
              id: "averages",
              colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
              domainFn: (TimeAverage sales, _) => sales.time,
              measureFn: (TimeAverage sales, _) => sales.sales,
              data: data,
            ),
          ];
        });
      }
    }
    avrString = average.value.toString();
  }

  void callback() {
    setState(() {
      data.clear();
      int sum = 0;
      int n = 0;
      for (Evaluation e in globals.currentEvals) {
        double multiplier = 1;
        try {
          multiplier = int.parse(e.weight.replaceAll("%", "")) / 100;
        } catch (e) {
          print(e);
        }

        sum += e.numericValue * multiplier.toInt();
        n += multiplier.toInt();

        setState(() {
          data.add(new TimeAverage(
              new DateTime(
                  int.parse(e.date.substring(0, 4)),
                  int.parse(e.date.substring(5, 7)),
                  int.parse(e.date.substring(8, 10))),
              e.numericValue));
          print(data);
          series = [
            new Series(
              displayName: "asd",
              id: "averages",
              colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
              domainFn: (TimeAverage sales, _) => sales.time,
              measureFn: (TimeAverage sales, _) => sales.sales,
              data: data,
            ),
          ];
        });
        avrString = (sum / n).toStringAsFixed(2);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    series = [
      new Series(
        displayName: "asd",
        id: "averages",
        colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
        domainFn: (TimeAverage sales, _) => sales.time,
        measureFn: (TimeAverage sales, _) => sales.sales,
        data: data,
      ),
    ];

    return new WillPopScope(
        onWillPop: () {
          globals.screen = 0;
          Navigator.pushReplacementNamed(context, "/main");
        },
        child: Scaffold(
            drawer: GDrawer(),
            appBar: new AppBar(
              title: new Text("Statisztikák"),
              actions: <Widget>[
                new FlatButton(
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
                )
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
//            bottomNavigationBar: BottomNavigationBar(items: <BottomNavigationBarItem>[
//              new BottomNavigationBarItem(icon: new Icon(Icons.sync),title: new Text("asd")),
//              new BottomNavigationBarItem(icon: new Icon(Icons.sync),title: new Text("asd")),
//    ]),
            body: new Stack(children: <Widget>[
              new Column(
                children: <Widget>[
                  new Container(
                    child: selectedAverage != null
                        ? new PopupMenuButton(
                            itemBuilder: (BuildContext context) {
                              print(averages);
                              return averages.map((Average average) {
                                return new PopupMenuItem<Average>(
                                    value: average,
                                    child: new Row(
                                      children: <Widget>[
                                        new Text(average.subject),
                                      ],
                                    ));
                              }).toList();
                            },
                            child: new Container(
                                child: new Row(
                              children: <Widget>[
                                new Text(
                                  selectedAverage.subject,
                                  style: new TextStyle(
                                      color: null, fontSize: 23.0),
                                ),
                                new Icon(
                                  Icons.arrow_drop_down,
                                  color: null,
                                ),
                              ],
                              mainAxisSize: MainAxisSize.min,
                            )),
                            onSelected: _onSelect,
                          )
                        : new Container(),
                    alignment: Alignment(0, 0),
                    margin: EdgeInsets.all(5),
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text("Átlag: "),
                      new Text(
                        avrString,
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold),
                      ),
                      //new Text(" Osztályátlag: "),
                      //new Text(classAvrString, style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),),
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
                      height: 200,
                    ),
                  ),
                  new Container(
                    child: new ListView.builder(
                      itemBuilder: _itemBuilder,
                      itemCount: globals.currentEvals.length,
                    ),
                    height: 250,
                  ),
                ],
              ),
            ])));
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
                globals.currentEvals[index].numericValue.toString(),
                textScaleFactor: 2.0,
              ),
              padding: EdgeInsets.only(left: 8.0),
            ),
            title: new Text(globals.currentEvals[index].subject),
            subtitle: new Text(globals.currentEvals[index].theme),
            trailing: new Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Column(
                  children: <Widget>[
                    new Text(globals.currentEvals[index].date.substring(0, 10)),
                    globals.multiAccount
                        ? new Text(
                            globals.currentEvals[index].owner.name,
                            style: new TextStyle(
                                color: globals.currentEvals[index].owner.color),
                          )
                        : new Text(""),
                  ],
                ),
                globals.currentEvals[index].mode == "Hamis"
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
              print(globals.currentEvals[index].subject);
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
          title: new Text(evaluation.subject + " " + evaluation.value),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                evaluation.theme != ""
                    ? new Text("téma: " + evaluation.theme)
                    : new Container(),
                new Text("tanár: " + evaluation.teacher),
                new Text("idő: " +
                    evaluation.date
                        .substring(0, 11)
                        .replaceAll("-", '. ')
                        .replaceAll("T", ". ")),
                new Text("mód: " + evaluation.mode),
                new Text("naplózás ideje: " +
                    evaluation.creationDate
                        .substring(0, 16)
                        .replaceAll("-", ". ")
                        .replaceAll("T", ". ")),
                new Text("súly: " + evaluation.weight),
                new Text("érték: " + evaluation.value),
                new Text("határ: " + evaluation.range),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('ok'),
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

//  List newList;
  GradeDialog(this.callback);

  @override
  GradeDialogState createState() => new GradeDialogState();
}

class GradeDialogState extends State<GradeDialog> {
  List<int> jegyek = [1, 2, 3, 4, 5];

  var jegy = 1;
  bool isTZ = false;

  Widget build(BuildContext context) {
    return new SimpleDialog(
      contentPadding: EdgeInsets.all(0),
      title: new Text("Ha kapnék egy..."),
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
                  activeColor: Colors.blueAccent,
                ),
                Radio<int>(
                  value: 2,
                  groupValue: jegy,
                  onChanged: (int value) {
                    setState(() {
                      jegy = value;
                    });
                  },
                  activeColor: Colors.blueAccent,
                ),
                Radio<int>(
                  value: 3,
                  groupValue: jegy,
                  onChanged: (int value) {
                    setState(() {
                      jegy = value;
                    });
                  },
                  activeColor: Colors.blueAccent,
                ),
                Radio<int>(
                  value: 4,
                  groupValue: jegy,
                  onChanged: (int value) {
                    setState(() {
                      jegy = value;
                    });
                  },
                  activeColor: Colors.blueAccent,
                ),
                Radio<int>(
                  value: 5,
                  groupValue: jegy,
                  onChanged: (int value) {
                    setState(() {
                      jegy = value;
                    });
                  },
                  activeColor: Colors.blueAccent,
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
                activeColor: Colors.blueAccent,
              ),
            ],
          ),
        ),
        new FlatButton(
          onPressed: () {
            print(isTZ);
            print(jegy);
            setState(() {
              Evaluation falseGrade = new Evaluation(
                  0,
                  "",
                  "",
                  "",
                  globals.selectedAverage.subject,
                  globals.selectedAverage.subjectCategory,
                  "Hamis",
                  isTZ ? "200%" : "100%",
                  jegy.toString(),
                  jegy,
                  "",
                  DateTime.now().year.toString() +
                      "-" +
                      DateTime.now().month.toString() +
                      "-" +
                      DateTime.now().day.toString() +
                      "    ",
                  DateTime.now().year.toString() +
                      "-" +
                      DateTime.now().month.toString() +
                      "-" +
                      DateTime.now().day.toString() +
                      "           ",
                  "");
              falseGrade.owner = globals.selectedUser;
              globals.currentEvals.add(falseGrade);
              print(globals.currentEvals.length);
              this.widget.callback();
              Navigator.pop(context);
            });
          },
          child: new Text(
            "kész",
            style: TextStyle(color: Colors.blueAccent),
          ),
          padding: EdgeInsets.all(10),
        ),
      ],
    );
  }
}
