import 'package:e_szivacs/generated/i18n.dart';
import 'package:flutter/material.dart';

import '../Datas/Student.dart';
import '../Datas/User.dart';
import '../globals.dart' as globals;

class AbsentDialog extends StatefulWidget {
  const AbsentDialog();

  @override
  AbsentDialogState createState() => new AbsentDialogState();
}

class AbsentDialogState extends State<AbsentDialog> {
  int sumOfParentalAbsences = 0;
  int sumOfAllAbsences = 0;
  int sumOfDelayMinutes = 0;

  List<User> users;
  Map<String, List<Absence>> absents = new Map();

  void initSelectedUser() async {
    absents = globals.selectedAccount.absents;
    sumOfAllAbsences = 0;
    sumOfParentalAbsences = 0;
    sumOfDelayMinutes = 0;

    setState(() {
      absents.forEach((String day, List<Absence> absencesOnDay) {
        if (absencesOnDay[0].isParental() && absencesOnDay[0].owner.isSelected())
          sumOfParentalAbsences++;
        if (absencesOnDay[0].owner.isSelected())
          for (Absence absence in absencesOnDay)
            if (absence.DelayTimeMinutes == 0)
              sumOfAllAbsences++;
            else
              sumOfDelayMinutes += absence.DelayTimeMinutes;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initSelectedUser();
  }

  Widget build(BuildContext context) {
    return new SimpleDialog(
        title: new Text(S
            .of(context)
            .statistics),
        titlePadding: EdgeInsets.all(16),
        contentPadding: const EdgeInsets.all(5.0),
        children: <Widget>[
          Container(child: new Text(
            S.of(context).parental_justification(
                sumOfParentalAbsences.toString()),
            style: TextStyle(fontSize: 16.0),
          ),
            margin: EdgeInsets.all(8),
          ),
          Container(child: new Text(
            S.of(context).all_absences(sumOfAllAbsences.toString()),
            style: TextStyle(fontSize: 16.0),
          ),
            margin: EdgeInsets.all(8),
          ),
          Container(child: new Text(
            S.of(context).all_delay(sumOfDelayMinutes.toString()),
            style: TextStyle(fontSize: 16.0),
          ),
            margin: EdgeInsets.all(8),
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            child: new Text(S.of(context).excluding_delay),
          )
        ]);
  }
}