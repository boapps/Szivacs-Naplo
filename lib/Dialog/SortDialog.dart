import 'package:e_szivacs/generated/i18n.dart';
import 'package:flutter/material.dart';

import '../globals.dart' as globals;

class SortDialog extends StatefulWidget {
  const SortDialog();

  @override
  SortDialogState createState() => new SortDialogState();
}

class SortDialogState extends State<SortDialog> {
  int selectedSortOption = 0;

  void _onSelect(String selected, List<String> sortOptionList) {
    setState(() {
      selectedSortOption = sortOptionList.indexOf(selected);
      globals.sort = selectedSortOption;
    });
  }

  Widget build(BuildContext context) {
    List<String> sortOptionList = [
      S
          .of(context)
          .sort_time,
      S
          .of(context)
          .sort_eval,
      S
          .of(context)
          .sort_subject,
      S
          .of(context)
          .sort_real_time,
    ];

    return new SimpleDialog(
      title: new Text(S
          .of(context)
          .sort),
      contentPadding: const EdgeInsets.all(10.0),
      children: <Widget>[
        new PopupMenuButton<String>(
          child: new Container(
            child: new Row(
              children: <Widget>[
                new Text(
                  sortOptionList[globals.sort],
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
          onSelected: (String selected) {_onSelect(selected, sortOptionList);},
          itemBuilder: (BuildContext context) {
            return sortOptionList.map((String sor) {
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
