import 'package:flutter/material.dart';
import '../Datas/Absence.dart';
import '../Helpers/LocaleHelper.dart';
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
            if (absence.delayMinutes == 0)
              sumOfAllAbsences++;
            else
              sumOfDelayMinutes += absence.delayMinutes;
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
        title: new Text(AppLocalizations.of(context).statistics),
        contentPadding: const EdgeInsets.all(5.0),
        children: <Widget>[
          new Text(
            AppLocalizations.of(context).parental_justification(sumOfParentalAbsences),
            style: TextStyle(fontSize: 16.0),
          ),
          new Text(
            AppLocalizations.of(context).all_absences(sumOfAllAbsences),
            style: TextStyle(fontSize: 16.0),
          ),
          new Text(
            AppLocalizations.of(context).all_delay(sumOfDelayMinutes),
            style: TextStyle(fontSize: 16.0),
          ),
        ]);
  }
}