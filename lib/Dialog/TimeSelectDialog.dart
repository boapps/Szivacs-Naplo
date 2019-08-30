import 'package:flutter/material.dart';
import '../globals.dart' as globals;
import 'package:e_szivacs/generated/i18n.dart';

class TimeSelectDialog extends StatefulWidget {
  const TimeSelectDialog();
  @override
  TimeSelectDialogState createState() => new TimeSelectDialogState();
}

class TimeSelectDialogState extends State<TimeSelectDialog> {
  int selectedTime = 1;

  void _onSelect(String sel, List<String> idok) {
    setState(() {
      selectedTime = idok.indexOf(sel);
      globals.selectedTimeForHomework = selectedTime;
      //todo: ezt meg kéne jegyeztetni
    });
  }

  Widget build(BuildContext context) {
    List<String> timeOptionList = [S
        .of(context)
        .day, S
        .of(context)
        .week, S
        .of(context)
        .month, S
        .of(context)
        .two_months
    ];

    return new SimpleDialog(
      title: new Text(S
          .of(context)
          .time),
      contentPadding: const EdgeInsets.all(10.0),
      children: <Widget>[
        new PopupMenuButton<String>(
          child: new Container(
            child: new Row(
              children: <Widget>[
                new Text(
                  timeOptionList[globals.selectedTimeForHomework],
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
          onSelected: (String selected) {_onSelect(selected, timeOptionList);},
          itemBuilder: (BuildContext context) {
            return timeOptionList.map((String sor) {
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

