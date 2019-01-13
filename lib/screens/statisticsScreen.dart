import 'dart:ui';
import 'package:flutter/material.dart';
import '../GlobalDrawer.dart';
import '../globals.dart' as globals;
import '../Datas/Average.dart';
import '../Datas/Evaluation.dart';
import '../Helpers/AverageHelper.dart';
import '../Helpers/EvaluationHelper.dart';
import 'package:charts_flutter/flutter.dart';
import "dart:math";
import 'package:flutter_localizations/flutter_localizations.dart';
import '../Helpers/LocaleHelper.dart';

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
  String avrString = "";
  String classAvrString = "";
  int db1 = 0;
  int db2 = 0;
  int db3 = 0;
  int db4 = 0;
  int db5 = 0;
  double allAverage;
  double allMedian;
  int allModusz;

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
    evals.removeWhere((Evaluation e) => e.numericValue == 0 || e.mode=="Na" || e.weight == null || e.weight == "-");
    _onSelect(averages[0]);
    for (Evaluation e in evals)
      switch(e.numericValue){
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
    allModusz = getModusz();
    if (allMedian==null)
      allMedian = 0;
    if (allAverage==null)
      allAverage = 0;
    if (allModusz==null)
      allModusz = 0;
  }

  double getAllAverages() {

    double sum = 0;
    double n = 0;
    for (Evaluation e in evals) {
      if (e.numericValue!=0) {
        double multiplier = 1;
        try {
          multiplier = double.parse(e.weight.replaceAll("%", "")) / 100;
        } catch (e) {
          print(e);
        }

        sum += e.numericValue * multiplier;
        n += multiplier;
      }
    }
    return sum / n;

  }

  double getMedian() {
    List<int> jegyek = new List();
    for (Evaluation e in evals)
      jegyek.add(e.numericValue);
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

    for (Evaluation e in evals.reversed) {
      if (e.numericValue != 0) {
        print(e.subject);
        print(average.subject);
        if (average.subject == e.subject) {
          globals.currentEvals.add(e);
          print(e.date);
          print(e.date.indexOf("-"));
          setState(() {
            data.add(new TimeAverage(
                new DateTime(
                    int.parse(e.date.substring(0, e.date.indexOf("-"))),
                    int.parse(e.date.substring(e.date.indexOf("-") + 1, e.date.indexOf("-", e.date.indexOf("-") + 1))),
                    int.parse(e.date.substring(e.date.indexOf("-", e.date.indexOf("-") + 1) + 1, 10))),
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
    }
    avrString = average.value.toString();
  }

  void callback() {
    setState(() {
      data.clear();
      double sum = 0;
      double n = 0;
      for (Evaluation e in globals.currentEvals) {
        if (e.numericValue != 0) {
          double multiplier = 1;
          try {
            multiplier = double.parse(e.weight.replaceAll("%", "")) / 100;
          } catch (e) {
            print(e);
          }

          sum += e.numericValue * multiplier;
          n += multiplier;

          setState(() {
            print(e.date.indexOf("-"));
            data.add(new TimeAverage(
                new DateTime(
                    int.parse(e.date.substring(0, e.date.indexOf("-"))),
                    int.parse(e.date.substring(e.date.indexOf("-") + 1, e.date.indexOf("-", e.date.indexOf("-") + 1))),
                    int.parse(e.date.substring(e.date.indexOf("-", e.date.indexOf("-") + 1) + 1, 10))),
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
      }
    });
  }

  int currentBody = 0;
  Widget body0;
  Widget body1;

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

    body1 = new SingleChildScrollView(child: new Center(
      child: new Container(
        margin: EdgeInsets.all(10),
        child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                new Text(AppLocalizations.of(context).grade1, style: TextStyle(fontSize: 21),),
                new Text(db1.toString() + " db", style: TextStyle(fontSize: 21),),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),

            Row(
              children: <Widget>[
                new Text(AppLocalizations.of(context).grade2, style: TextStyle(fontSize: 21),),
                new Text(db2.toString() + " db", style: TextStyle(fontSize: 21),),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            Row(
              children: <Widget>[
                new Text(AppLocalizations.of(context).grade3, style: TextStyle(fontSize: 21),),
                new Text(db3.toString() + " db", style: TextStyle(fontSize: 21),),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            Row(
              children: <Widget>[
                new Text(AppLocalizations.of(context).grade4, style: TextStyle(fontSize: 21),),
                new Text(db4.toString() + " db", style: TextStyle(fontSize: 21),),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            Row(
              children: <Widget>[
                new Text(AppLocalizations.of(context).grade5, style: TextStyle(fontSize: 21),),
                new Text(db5.toString() + " db", style: TextStyle(fontSize: 21),),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            new Divider(),
            Row(
              children: <Widget>[
                new Text(AppLocalizations.of(context).all_average, style: TextStyle(fontSize: 21),),
                new Text(allAverage != null ? allAverage.toStringAsFixed(2):"...", style: TextStyle(fontSize: 21),),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            Row(
              children: <Widget>[
                new Text(AppLocalizations.of(context).all_median, style: TextStyle(fontSize: 21),),
                new Text(allMedian != null ? allMedian.toStringAsFixed(2):"...", style: TextStyle(fontSize: 21),),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            Row(
              children: <Widget>[
                new Text(AppLocalizations.of(context).all_mode, style: TextStyle(fontSize: 21),),
                new Text(allModusz != null ? allModusz.toString():"...", style: TextStyle(fontSize: 21),),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),

          ],
      ),
      ),
    ),
    );

    body0 = new Stack(
        children: <Widget>[
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
                  new Text(AppLocalizations.of(context).average),
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
                title: new Text(AppLocalizations.of(context).averages),
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.info),
                title: new Text(AppLocalizations.of(context).datas),
              ),
            ],
            onTap: switchToScreen,
            ),
            drawer: GDrawer(),
            appBar: new AppBar(
              title: new Text(AppLocalizations.of(context).statistics),
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
//            bottomNavigationBar: BottomNavigationBar(items: <BottomNavigationBarItem>[
//              new BottomNavigationBarItem(icon: new Icon(Icons.sync),title: new Text("asd")),
//              new BottomNavigationBarItem(icon: new Icon(Icons.sync),title: new Text("asd")),
//    ]),
            body: currentBody==0 ? body0:body1));
  }

  void switchToScreen(int n) {
    print(n);
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
                globals.currentEvals[index].numericValue.toString(),
                textScaleFactor: 2.0,
                style: TextStyle(color: globals.currentEvals[index].color)
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
                    new Text(globals.currentEvals[index].date.substring(0, 10).replaceAll("-", ". ") + ". "),
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
                    ? new Text(AppLocalizations.of(context).theme + evaluation.theme)
                    : new Container(),
                new Text(AppLocalizations.of(context).teacher + evaluation.teacher),
                new Text(AppLocalizations.of(context).time +
                    evaluation.date
                        .substring(0, 11)
                        .replaceAll("-", '. ')
                        .replaceAll("T", ". ")),
                new Text(AppLocalizations.of(context).mode + evaluation.mode),
                new Text(AppLocalizations.of(context).administration_time +
                    evaluation.creationDate
                        .substring(0, 16)
                        .replaceAll("-", ". ")
                        .replaceAll("T", ". ")),
                new Text(AppLocalizations.of(context).weight + evaluation.weight),
                new Text(AppLocalizations.of(context).value + evaluation.value),
                new Text(AppLocalizations.of(context).range + evaluation.range),
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

  String weight = "200";

  void onChanged(String text) {
    weight = text;
  }

  Widget build(BuildContext context) {
    return new SimpleDialog(
      contentPadding: EdgeInsets.all(0),
      title: new Text(AppLocalizations.of(context).if_i_got),
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
              new Container(
                width: 60,
                child: new TextField(
                  maxLines: 1,
                  onChanged: onChanged,
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
                  isTZ ? (weight+"%") : "100%",
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
            AppLocalizations.of(context).done,
            style: TextStyle(color: Colors.blueAccent),
          ),
          padding: EdgeInsets.all(10),
        ),
      ],
    );
  }
}
