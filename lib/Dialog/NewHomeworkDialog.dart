import 'package:e_szivacs/Helpers/RequestHelper.dart';
import 'package:e_szivacs/generated/i18n.dart';
import 'package:flutter/material.dart';
import '../Datas/Lesson.dart';
import '../globals.dart' as globals;
import '../Utils/StringFormatter.dart';
import 'package:flutter_rounded_date_picker/rounded_date_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NewHomeworkDialog extends StatefulWidget {
  const NewHomeworkDialog(this.lesson);
  final Lesson lesson;

  @override
  NewHomeworkDialogState createState() => new NewHomeworkDialogState();
}

class NewHomeworkDialogState extends State<NewHomeworkDialog> {
  String homework;

  Widget build(BuildContext context) {
    return new SimpleDialog(
      title: new Text(S
          .of(context)
          .homework),
      contentPadding: const EdgeInsets.all(10.0),
      children: <Widget>[
        new TextField(
          keyboardType: TextInputType.multiline,
          maxLines: 10,
          onChanged: (String text) {homework = text;},
        ),
        MaterialButton(
          child: Text(S.of(context).ok),
          onPressed: () {
              RequestHelper().uploadHomework(homework, widget.lesson, globals.selectedAccount.user);
              Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
