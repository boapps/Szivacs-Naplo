import 'package:e_szivacs/Helpers/RequestHelper.dart';
import 'package:e_szivacs/generated/i18n.dart';
import 'package:flutter/material.dart';
import '../Datas/Lesson.dart';
import '../globals.dart' as globals;
import '../Utils/StringFormatter.dart';
import 'package:flutter_rounded_date_picker/rounded_date_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeWorkDialog extends StatefulWidget {
  const HomeWorkDialog(this.lesson);
  final Lesson lesson;

  @override
  HomeWorkDialogState createState() => new HomeWorkDialogState();
}

class HomeWorkDialogState extends State<HomeWorkDialog> {
  String selectedDate;
  String homework;
  List<DateTime> pickedDate;

  Widget build(BuildContext context) {
    return new SimpleDialog(
      title: new Text(S
          .of(context)
          .homework),
      contentPadding: const EdgeInsets.all(10.0),
      children: <Widget>[
    new MaterialButton(
    color: selectedDate==null ? Colors.deepOrangeAccent:Colors.green,
      onPressed: () async {
        DateTime newDateTime = await RoundedDatePicker.show(context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now().subtract(Duration(days: 1)),
            lastDate: DateTime(DateTime.now().year + 1),
            borderRadius: 5);
        if (newDateTime != null) {
          selectedDate = dateToHuman(newDateTime);
          setState(() {});
        }
      },
      child: new Text(selectedDate??"válassz határidőt"),
    ),
        new TextField(
          keyboardType: TextInputType.multiline,
          maxLines: 10,
          onChanged: (String text) {homework = text;},
        ),
        MaterialButton(
          child: Text(S.of(context).ok),
          onPressed: () {
            if (selectedDate != null){
              RequestHelper().uploadHomework(homework, selectedDate + "22:00:00", widget.lesson, globals.selectedAccount.user);
              Navigator.of(context).pop();
            } else {
              Fluttertoast.showToast(
                  msg: "Válassz határidőt!",
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }
          },
        )
      ],
    );
  }
}
