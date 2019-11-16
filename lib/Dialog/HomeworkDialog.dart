import 'package:e_szivacs/generated/i18n.dart';
import 'package:flutter/material.dart';
import '../Datas/Lesson.dart';
import '../Datas/Homework.dart';
import '../globals.dart' as globals;
import '../Utils/StringFormatter.dart';
import '../Helpers/HomeworkHelper.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html_unescape/html_unescape.dart';
import 'NewHomeworkDialog.dart';

class HomeworkDialog extends StatefulWidget {
  const HomeworkDialog(this.lesson);
  final Lesson lesson;

  @override
  HomeworkDialogState createState() => new HomeworkDialogState();
}

class HomeworkDialogState extends State<HomeworkDialog> {

  Widget build(BuildContext context) {
    return new AlertDialog(
      title: new Text(widget.lesson.subject),
      content: new SingleChildScrollView(
        child: new ListBody(
          children: <Widget>[
            new Text(S.of(context).room + widget.lesson.room),
            new Text(S.of(context).teacher + widget.lesson.teacher),
            new Text(S.of(context).group + widget.lesson.group),
            new Text(
                S.of(context).lesson_start + getLessonStartText(widget.lesson)),
            new Text(S.of(context).lesson_end + getLessonEndText(widget.lesson)),
            widget.lesson.isMissed
                ? new Text(S.of(context).state + widget.lesson.stateName)
                : new Container(),
            (widget.lesson.theme != "" && widget.lesson.theme != null)
                ? new Text(S.of(context).theme + widget.lesson.theme)
                : new Container(),

            widget.lesson.homework != null ? new Text("\n" + S.of(context).homework + ":"):Container(),
            widget.lesson.homework != null ? new Divider(color: Colors.blueGrey,):Container(),            
            Column(
              children: globals.currentHomeworks.map<Widget>((Homework homework){
                return ListTile(
                  title: Html(data: HtmlUnescape().convert(homework.text)),
                  subtitle: Text(homework.uploader + " | " + homework.uploadDate.substring(0, 10)), //, style: TextStyle(color: homework.byTeacher ? Colors.green:null),),
                );
              }).toList(),
            )
          ],
        ),
      ),
      actions: <Widget>[
        widget.lesson.homeworkEnabled ?
        new FlatButton(
          child: new Text(S.of(context).homework),
          onPressed: () {
            Navigator.of(context).pop();
            return showDialog(
              barrierDismissible: true,
              context: context,
              builder: (BuildContext context) {
                return new NewHomeworkDialog(widget.lesson);
              },
            ) ??
                false;
          },
        ) : Container(),
        new FlatButton(
          child: new Text(S.of(context).ok),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  void getHomeworks(Lesson lesson) async {
    globals.currentHomeworks.clear();
    globals.currentHomeworks = await HomeworkHelper().getHomeworksByLesson(lesson);
    setState(() {});
  }

  @override
  void initState() {
    if (widget.lesson.homework != null)
      getHomeworks(widget.lesson);
    else
      globals.currentHomeworks.clear();

    super.initState();
  }
}
