import 'dart:async';
import 'dart:convert' show utf8, json;
import '../Datas/Note.dart';
import '../Datas/User.dart';

class NotesHelper {
  List<dynamic> notesMap;
  List<dynamic> evalsMap;
  Map<String, dynamic> onlyNotes;

  Future<List<Note>> getNotesFrom(String eventsString, String studentString, User user) async {
    List<Note> notesList = List();
    try {
      List<dynamic> dynamicNotesList = json.decode(studentString)["Notes"];
      List<dynamic> dynamicEventsList = json.decode(eventsString);
      dynamicNotesList.addAll(dynamicEventsList);

      for (dynamic d in dynamicNotesList) {
            notesList.add(Note.fromJson(d));
          }

      notesList.forEach((Note n) => n.owner = user);
    } catch (e) {
      print(e);
    }

    return notesList;
  }
}
