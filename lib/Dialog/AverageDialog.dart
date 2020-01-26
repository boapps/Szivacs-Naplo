import 'package:e_szivacs/generated/i18n.dart';
import 'package:flutter/material.dart';

import '../Datas/Average.dart';
import '../Datas/Student.dart';
import '../globals.dart' as globals;

class AverageDialog extends StatefulWidget {
  const AverageDialog();

  @override
  AverageDialogState createState() => new AverageDialogState();
}

class AverageDialogState extends State<AverageDialog> {
  List<Evaluation> evaluations = new List();
  List<Average> averages = new List();
  List<Average> currentAvers = new List(); // todo már nem is emlékszem ez mit csinál
  List<Widget> widgets = new List();
  bool felevi = false;
  int pageID = 0;

  void onChanged (int change) {
    pageID = change;
    setState(() {
      refWidgets();
    });
  }

  Widget build(BuildContext context) {
    widgets.clear();
    averages = globals.selectedAccount.averages;
    evaluations = globals.selectedAccount.student.Evaluations;
    evaluations.removeWhere((Evaluation e) =>
    e.NumberValue == 0
        || e.Mode == "Na" || e.Weight == null || e.Weight == "-");

    List<String> avrChoice = [
      S
          .of(context)
          .average_menu,
      S
          .of(context)
          .halfyear,
      S
          .of(context)
          .quarteryear + " (${S
          .of(context)
          .notworking})",
      S
          .of(context)
          .endyear
    ];

    widgets.add(
        new Container(
          child: new DropdownButton<int>(items: [0, 1, 2, 3].map((int choice){
            return DropdownMenuItem<int>(child: Text(avrChoice[choice]), value: choice,);
          }).toList(), onChanged: onChanged, value: pageID,),
          margin: EdgeInsets.all(10),
        )
    );

    setState(() {
      refWidgets();
    });

    setState(() {
      if (currentAvers.isNotEmpty)
        widgets.add(
            new Container(
              child: new ListView.builder(
                  itemBuilder: _itemBuilder, itemCount: currentAvers.length),
              width: 320.0,
              height: 400.0,
            )
        );
    });

    return new SimpleDialog(
      title: new Text(S
          .of(context)
          .averages),
      contentPadding: const EdgeInsets.all(10.0),
      children: widgets,
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return new ListTile(
      title: new Text(currentAvers[index].subject),
      subtitle: new Text(currentAvers[index].value.toStringAsFixed(2), style: TextStyle(
          color: currentAvers[index].value < 2 ? Colors.red : null),),
      onTap: () {},
    );
  }

  void refWidgets() {
    currentAvers.clear();
    switch(pageID){
      case 0: // sima átlagok
        for (Average average in averages)
          if (average.value >= 1 && average.value <= 5) currentAvers.add(average);
        currentAvers.sort((Average a, Average b) {
          return a.subject.compareTo(b.subject);
        });
        currentAvers.add(Average(S
            .of(context)
            .all_average, "",
            "", getAllAverages(), 0, 0));
        break;
      case 1: // félévi jegyek
        for (Evaluation evaluation in evaluations)
          if (evaluation.isHalfYear())
            currentAvers.add(Average(evaluation.Subject,
                evaluation.SubjectCategory, evaluation.Subject,
                evaluation.NumberValue / 1, 0, 0));
        currentAvers.sort((Average a, Average b) {
          return a.subject.compareTo(b.subject);
        });
        break;
      case 2: // TODO negyedéves jegyek
        break;
      case 3: // év végi jegyek
        for (Evaluation evaluation in evaluations)
          if (evaluation.isEndYear())
            currentAvers.add(Average(evaluation.Subject,
                evaluation.SubjectCategory, evaluation.Subject,
                evaluation.NumberValue / 1, 0, 0));
        currentAvers.sort((Average a, Average b) {
          return a.subject.compareTo(b.subject);
        });
        break;
    }
  }

  double getAllAverages() {
    double sum = 0;
    double n = 0;
    for (Evaluation evaluation in evaluations) {
      if (evaluation.NumberValue != 0 && evaluation.isMidYear()) {
        double multiplier = 1;
        try {
          multiplier =
              double.parse(evaluation.Weight.replaceAll("%", "")) / 100;
        } catch (e) {
          print(e);
        }
        sum += evaluation.NumberValue * multiplier;
        n += multiplier;
      }
    }
    return sum / n;
  }
}
