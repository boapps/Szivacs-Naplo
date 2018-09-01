import 'User.dart';

class Note {
int id;
String type;
String title;
String content;
String teacher;
String date;
String creationDate;
bool isEvent = false;
User owner;

Note(this.id, this.type, this.title, this.content, this.teacher, this.date,
    this.creationDate);

Note.fromJson(Map json){
  if (json["EventId"]!=null) {
    this.id = json["EventId"];
    isEvent = true;
  } else
    this.id = json["NoteId"];
  print(id);
  this.date = json["Date"];
  this.content = json["Content"];
  this.title = json["Title"];
  this.teacher = json["Teacher"];
  this.type = json["Type"];

}

}