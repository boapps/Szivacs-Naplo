import 'package:flutter/material.dart';

import '../Datas/Average.dart';
import '../Datas/Evaluation.dart';
import '../globals.dart' as globals;
import '../Helpers/LocaleHelper.dart';

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
    evaluations = globals.selectedAccount.evaluations;
    evaluations.removeWhere((Evaluation e) => e.numericValue == 0
        || e.mode=="Na" || e.weight == null || e.weight == "-");

    List<String> avrChoice = [
      AppLocalizations.of(context).average,
    AppLocalizations.of(context).halfyear,
    AppLocalizations.of(context).quarteryear
        + " (${AppLocalizations.of(context).notworking})",
    AppLocalizations.of(context).endyear
        + " (${AppLocalizations.of(context).notworking})"
    ];

    widgets.add(
      new Container(
        child: new DropdownButton<int>(items: [0, 1, 2, 3].map((int choice){
          return DropdownMenuItem<int>(child: Text(avrChoice[choice]), value: choice,);
        }).toList(), onChanged: onChanged, value: pageID,),
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
      title: new Text(AppLocalizations.of(context).averages),
      contentPadding: const EdgeInsets.all(10.0),
      children: widgets,
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return new ListTile(
      title: new Text(currentAvers[index].subject),
      subtitle: new Text(currentAvers[index].value.toStringAsFixed(2), style: TextStyle(
          color: currentAvers[index].value < 2 ? Colors.red : null),),
      onTap: () {
      },
    );
  }

  void refWidgets() {
    currentAvers.clear();
    switch(pageID){
      case 0:
        for (Average average in averages)
          if (average.value >= 1 && average.value <= 5) currentAvers.add(average);
        currentAvers.add(Average(AppLocalizations.of(context).all_average, "",
            "", getAllAverages(), 0, 0));
        break;
      case 1:
        for (Evaluation evaluation in evaluations)
          if (evaluation.isHalfYear())
            currentAvers.add(Average(evaluation.subject,
                evaluation.subjectCategory, evaluation.subject,
                evaluation.numericValue / 1, 0, 0));
        break;
      case 2:
        //todo get string for this
        break;
      case 3:
        //todo and this
        break;
    }
  }

  double getAllAverages() {
    double sum = 0;
    double n = 0;
    for (Evaluation evaluation in evaluations) {
      if (evaluation.numericValue!=0 && evaluation.isMidYear()) {
        double multiplier = 1;
        try {
          multiplier = double.parse(evaluation.weight.replaceAll("%", "")) / 100;
        } catch (e) {
          print(e);
        }
        sum += evaluation.numericValue * multiplier;
        n += multiplier;
      }
    }
    return sum / n;
  }
}
