import 'package:e_szivacs/Datas/Homework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:html_unescape/html_unescape.dart';
import '../Datas/Note.dart';
import '../Utils/StringFormatter.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class HomeworkCard extends StatelessWidget {
  Homework homework;
  BuildContext context;
  bool isSingle;

  HomeworkCard(Homework homework, isSingle, BuildContext context){
    this.homework = homework;
    this.isSingle = isSingle;
    this.context = context;
  }

  String getDate(){
    return homework.uploadDate;
  }
  @override
  Key get key => new Key(getDate());

  void openDialog() {
    //_noteDialog(note);
  }

  Future<Null> _noteDialog(Note note) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return new SimpleDialog(
          children: <Widget>[
            new SingleChildScrollView(
              child: new Linkify(
                  text: note.content,
                  onOpen: (String url) {launcher.launch(url);},
              ),
            ),
          ],
          title: Text(note.title ?? "", ),
          contentPadding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              style: BorderStyle.none,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: openDialog,
      child: new Card(
      margin: EdgeInsets.all(6.0),
      color: Colors.lightBlue,
      child: new Column(
        children: <Widget>[
          new Container(
            child: /*new Row(
              children: <Widget>[*/
                new Text(homework.uploader, style: new TextStyle(fontSize: 21.0, color: Colors.white, fontWeight: FontWeight.bold),),
//              ],
//            ),
            margin: EdgeInsets.all(10.0),
          ),

          new Container(
            child: new Html(data: HtmlUnescape().convert(homework.text),),
            padding: EdgeInsets.all(10.0),
          ),

          /*!isSingle ? new Container(
            child: new Text(dateToHuman(note.date) + dateToWeekDay(homework.deadline, style: new TextStyle(fontSize: 16.0, color: Colors.white)),
            alignment: Alignment(1.0, -1.0),
            padding: EdgeInsets.fromLTRB(5.0, 5.0, 10.0, 5.0),
          ) : new Container(),
*/
          new Divider(height: 1.0,color: Colors.white,),
          new Container(
              color: Colors.blue,
              child: new Padding(
                padding: new EdgeInsets.all(10.0),
                child: new Row(
                  children: <Widget>[
                    new Divider(),
                    isSingle || homework.owner == null ? new Expanded(
                        child: new Container(
                          child: new Text(homework.deadline, style: new TextStyle(fontSize: 18.0, color: Colors.white)),
                          alignment: Alignment(1.0, 0.0),
                        )) : new Container(),
                    !isSingle ? new Expanded(
                      child: new Container(
                        child: new Text(homework.owner.name, style: new TextStyle(color: Colors.white, fontSize: 15.0)),
                        alignment: Alignment(1.0, -1.0),
                      ),
                    ) : new Container(),

                  ],
                ),
              )
          ),
        ],
      ),
      ),
    );
  }
}