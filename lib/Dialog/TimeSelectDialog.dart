import 'package:flutter/material.dart';

import '../globals.dart' as globals;
import '../Helpers/LocaleHelper.dart';



class TimeSelectDialog extends StatefulWidget {
  const TimeSelectDialog();

  @override
  TimeSelectDialogState createState() => new TimeSelectDialogState();
}

class TimeSelectDialogState extends State<TimeSelectDialog> {

  int selected = 1;

  void _onSelect(String sel, List<String> idok) {
    setState(() {
      selected = idok.indexOf(sel);
      globals.ido = selected;
      //todo: ezt meg kéne jegyeztetni
    });
  }

  Widget build(BuildContext context) {
    List<String> idok = [AppLocalizations.of(context).day, AppLocalizations.of(context).week, AppLocalizations.of(context).month, AppLocalizations.of(context).two_months];

    return new SimpleDialog(
      title: new Text(AppLocalizations.of(context).time),
      contentPadding: const EdgeInsets.all(10.0),
      children: <Widget>[
        new PopupMenuButton<String>(
          child: new Container(
            child: new Row(
              children: <Widget>[
                new Text(
                  idok[globals.ido],
                  style: new TextStyle(color: null, fontSize: 17.0),
                ),
                new Icon(
                  Icons.arrow_drop_down,
                  color: null,
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 2.0),
          ),
          onSelected: (String sel) {_onSelect(sel, idok);},
          itemBuilder: (BuildContext context) {
            return idok.map((String sor) {
              return new PopupMenuItem<String>(
                value: sor,
                child: new Text(sor),
              );
            }).toList();
          },
        ),
      ],
    );
  }
}

