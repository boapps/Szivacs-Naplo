import 'package:flutter/material.dart';

import '../Datas/Average.dart';
import '../Datas/Evaluation.dart';
import '../Datas/User.dart';
import '../Utils/AccountManager.dart';
import '../globals.dart' as globals;
import '../Helpers/LocaleHelper.dart';

class AverageDialog extends StatefulWidget {
  const AverageDialog();

  @override
  AverageDialogState createState() => new AverageDialogState();
}

class AverageDialogState extends State<AverageDialog> {
  List<Evaluation> evals = new List();
  List<Average> avers = new List();
  List<Average> currentAvers = new List();
  List<Widget> widgets = new List();

  User selectedUser;
  List<User> users;

  bool felevi = false;

  void initSelectedUser() async {
    users = await AccountManager().getUsers();
    setState(() {
      selectedUser = users[0];
    });
  }


  Widget build(BuildContext context) {
    widgets.clear();
    avers = globals.avers;
    evals = globals.global_evals;

    evals.removeWhere((Evaluation e) => e.owner.id != globals.selectedUser.id);
    evals.removeWhere((Evaluation e) => e.numericValue == 0 || e.mode=="Na" || e.weight == null || e.weight == "-");

    if (selectedUser==null)
      selectedUser = globals.selectedUser;
    users = globals.users;

    widgets.add(
      new Container(
        child: new Row(
          children: <Widget>[
            new Text("Félévi "),
            new Switch(value: felevi, onChanged: (bool change){
              felevi = change;
              setState(() {
                refWidgets();
              });
            })
          ],
        ),
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
    if (!felevi) {
      for (Average average in avers)
        if (average.owner.id == selectedUser.id && average.value >= 1 &&
            average.value <= 5) currentAvers.add(average);


      currentAvers.add(Average("Összes jegy átlaga", "", "", getAllAverages(), 0, 0));
    } else {
      for (Evaluation e in evals) {
        if (e.type == "HalfYear" && e.owner.id == selectedUser.id)
                currentAvers.add(Average(
                    e.subject, e.subjectCategory, e.subject, e.numericValue / 1, 0, 0));
      }
    }
  }

  double getAllAverages() {

    double sum = 0;
    double n = 0;
    for (Evaluation e in evals) {
      if (e.numericValue!=0 && e.type == "MidYear") {
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
}
