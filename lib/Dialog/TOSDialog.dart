import 'package:e_szivacs/Helpers/RequestHelper.dart';
import 'package:e_szivacs/Helpers/SettingsHelper.dart';
import 'package:e_szivacs/generated/i18n.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Datas/Lesson.dart';
import '../Datas/Homework.dart';
import '../globals.dart' as globals;
import '../Utils/StringFormatter.dart';
import '../Helpers/HomeworkHelper.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html_unescape/html_unescape.dart';
import 'NewHomeworkDialog.dart';

class TOSDialog extends StatefulWidget {
  const TOSDialog();

  @override
  TOSDialogState createState() => new TOSDialogState();
}

class TOSDialogState extends State<TOSDialog> {
  bool accepted = false;
  String htmlTOS = "betöltés...";

  Widget build(BuildContext context) {
    return new AlertDialog(
      title: new Text("Felhasználási feltételek"),
      content: new ListView(
          children: <Widget>[
            Text("""
Az alkalmazás felhasználási feltétele ezen dokumentum elolvasása és elfogadása. Amennyiben ez nem történik meg, vagy esetlegesen e dokumentummal való egyetértés megszűnik, az alkalmazás nem használható tovább. Ez esetben az alkalmazás eltávolítása a felhasználó feladata.
            """),
        Html(data: htmlTOS),
      ],
      ),
      actions: <Widget>[
        Text("Elfogadom: "),
        Checkbox(
          value: accepted,
          onChanged: (bool value) {
            setState(() {
              accepted = value;
            });},
        ),

        new MaterialButton(
          child: Text("Kész"),
          onPressed: () {
            if (accepted) {
              Navigator.of(context).pop(true);
              SettingsHelper().setAcceptTOS(true);
            } else {
              Fluttertoast.showToast(
                  msg: "A Felhasználási feltételeket el kell fogadnod az alkalmazás használatához!");
            }
          },
        )
      ],
    );
  }

  void loadTOS() async {
    htmlTOS = await RequestHelper().getTOS();
    setState(() {});
  }

  @override
  void initState() {
    loadTOS();
    super.initState();
  }
}
