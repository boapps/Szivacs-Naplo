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
  int prnt = 0;
  int ossz = 0;
  int delayMins = 0;

  List<User> users;
  Map<String, List<Absence>> absents = new Map();

  void initSelectedUser() async {
    absents = globals.absents;
    ossz = 0;
    prnt = 0;
    delayMins = 0;

    setState(() {
      absents.forEach((String key, List<Absence> value) {
        if (value[0].justificationType == "Parental" &&
            value[0].owner.id == globals.selectedUser.id) {
          prnt++;
        }
        if (value[0].owner.id == globals.selectedUser.id) {
          for (Absence a in value)
            if (a.delayMinutes == 0)
              ossz++;
            else
              delayMins += a.delayMinutes;
        }
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
            AppLocalizations.of(context).parental_justification(prnt),
            style: TextStyle(fontSize: 16.0),
          ),
          new Text(
            AppLocalizations.of(context).all_absences(ossz),
            style: TextStyle(fontSize: 16.0),
          ),
          new Text(
            AppLocalizations.of(context).all_delay(delayMins),
            style: TextStyle(fontSize: 16.0),
          ),
        ]);
  }
}
