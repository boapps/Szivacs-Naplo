import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import '../Datas/Note.dart';
import '../Utils/StringFormatter.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class NoteCard extends StatelessWidget {
  Note note;
  BuildContext context;
  bool isSingle;

  NoteCard(Note note, isSingle, BuildContext context){
    this.note = note;
    this.isSingle = isSingle;
    this.context = context;
  }

  String getDate(){
    return note.date.toIso8601String();
  }
  @override
  Key get key => new Key(getDate());

  void openDialog() {
    _noteDialog(note);
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
                  style: new TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            ),
          ],
          title: Text(note.title ?? "", ),
          contentPadding: EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              style: BorderStyle.none,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!note.isEvent)
    return new GestureDetector(
      onTap: openDialog,
      child: new Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          style: BorderStyle.none,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      margin: EdgeInsets.all(6.0),
      color: Colors.lightBlue,
      child: new Column(
        children: <Widget>[
          new Container(
            child: new Text(note.title, style: new TextStyle(fontSize: 21.0, color: Colors.white, fontWeight: FontWeight.bold),),
            margin: EdgeInsets.all(10.0),
          ),

          new Container(
            child: new Text(note.content, style: new TextStyle(fontSize: 17.0, color: Colors.white),),
            padding: EdgeInsets.all(10.0),
          ),

          !isSingle ? new Container(
            child: new Text(dateToHuman(note.date) + dateToWeekDay(note.date), style: new TextStyle(fontSize: 16.0, color: Colors.white)),
            alignment: Alignment(1.0, -1.0),
            padding: EdgeInsets.fromLTRB(5.0, 5.0, 10.0, 5.0),
          ) : new Container(),

          new Divider(height: 1.0,color: Colors.white,),
          new Container(
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  style: BorderStyle.none,
                  width: 0,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              color: Colors.blue,
            ),
            child: new Padding(
              padding: new EdgeInsets.all(10.0),
              child: new Row(
                children: <Widget>[
                  new Divider(),
                  !!isSingle ? new Expanded(
                      child: new Container(
                        child: new Text(dateToHuman(note.date) + dateToWeekDay(note.date), style: new TextStyle(fontSize: 18.0, color: Colors.white)),
                        alignment: Alignment(1.0, 0.0),
                      )) : new Container(),

                  !isSingle ? new Expanded(
                    child: new Container(
                      child: new Text(note.owner.name, style: new TextStyle(color: Colors.white, fontSize: 15.0)),
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
    else
    return new GestureDetector(
        onTap: openDialog,
        child: Card(
      color: Colors.lightBlue,
      child: new Column(
        children: <Widget>[

          new Container(
            child: new Text(note.content, style: new TextStyle(fontSize: 17.0, color: Colors.white),),
            padding: EdgeInsets.all(10.0),
          ),

          !isSingle ? new Container(
            child: new Text(dateToHuman(note.date) + dateToWeekDay(note.date), style: new TextStyle(fontSize: 16.0, color: Colors.white)),
            alignment: Alignment(1.0, -1.0),
            padding: EdgeInsets.fromLTRB(5.0, 5.0, 10.0, 5.0),
          ) : new Container(),

          new Divider(height: 1.0,color: Colors.white,),
          new Container(
              color: Colors.blue,
              child: new Padding(
                padding: new EdgeInsets.all(10.0),
                child: new Row(
                  children: <Widget>[
                    new Divider(),
                    !!isSingle ? new Expanded(
                        child: new Container(
                          child: new Text(dateToHuman(note.date) + dateToWeekDay(note.date), style: new TextStyle(fontSize: 18.0, color: Colors.white)),
                          alignment: Alignment(1.0, 0.0),
                        )) : new Container(),

                    !isSingle ? new Expanded(
                      child: new Container(
                        child: new Text(note.owner.name, style: new TextStyle(color: Colors.white, fontSize: 15.0)),
                        alignment: Alignment(1.0, -1.0),
                      ),
                    ) : new Container(),
                  ],
                ),
              )
          )
        ],
      ),
        ),
    );


  }
}