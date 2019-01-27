import 'package:flutter/material.dart';

import '../globals.dart' as globals;
import '../Helpers/LocaleHelper.dart';

class SortDialog extends StatefulWidget {
  const SortDialog();

  @override
  SortDialogState createState() => new SortDialogState();
}

class SortDialogState extends State<SortDialog> {
  int selected = 0;

  void _onSelect(String sel, List<String> sorba) {
    setState(() {
      selected = sorba.indexOf(sel);
      globals.sort = selected;
    });
  }

  Widget build(BuildContext context) {
    List<String> sorba = [
      AppLocalizations.of(context).sort_time,
      AppLocalizations.of(context).sort_eval,
      AppLocalizations.of(context).sort_subject
    ];

    return new SimpleDialog(
      title: new Text(AppLocalizations.of(context).sort),
      contentPadding: const EdgeInsets.all(10.0),
      children: <Widget>[
        new PopupMenuButton<String>(
          child: new Container(
            child: new Row(
              children: <Widget>[
                new Text(
                  sorba[globals.sort],
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
          onSelected: (String sel) {_onSelect(sel, sorba);},
          itemBuilder: (BuildContext context) {
            return sorba.map((String sor) {
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
