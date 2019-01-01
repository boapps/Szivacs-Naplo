import 'dart:async';
import 'dart:convert' show utf8, json;
//import 'package:shared_preferences/shared_preferences.dart';
import '../Datas/Note.dart';
import '../Datas/User.dart';
import '../Helpers/RequestHelper.dart';
import '../Utils/AccountManager.dart';
import '../Utils/Saver.dart';


class NotesHelper {
  List<dynamic> notesMap;
  List<dynamic> evalsMap;
  Map<String, dynamic> onlyNotes;

  Future<List<Note>> getNotes() async {
    List<Note> notes = new List<Note>();
    notesMap = await getNotesList();
    notes.clear();
    for (int n = 0; n < notesMap.length; n++) {
      notes.add(new Note.fromJson(notesMap[n]));
      notes[n].owner=notesMap[n]["user"];
    }
    notes.sort((Note a, Note b) {
      return b.date.compareTo(a.date);
    });

    return notes;
  }

  Future<List<Note>> getNotesOffline() async {
    List<Note> notes = new List<Note>();

    List<User> users = await AccountManager().getUsers();
    notes.clear();

    for (User user in users) {
      notesMap = await readEvents(user);
      evalsMap = (await readEvaluations(user))["Notes"];
      if (notesMap!=null) {
        notesMap.addAll(evalsMap);
        for (int n = 0; n < notesMap.length; n++) {
          Note note = new Note.fromJson(notesMap[n]);
          note.owner = user;
          notes.add(note);
        }
      }
    }

    notes.sort((Note a, Note b) {
      return b.date.compareTo(a.date);
    });

    return notes;
  }

  Future <List<dynamic>> getNotesList() async{
    List<User> users = await AccountManager().getUsers();
    List<dynamic> onlyNotes = new List<dynamic>();

    for (User user in users) {

      String instCode = user.schoolCode; //suli kódja
      String userName = user.username;
      String password = user.password;

      String jsonBody = "institute_code=" +
          instCode +
          "&userName=" +
          userName +
          "&password=" +
          password +
          "&grant_type=password&client_id=919e0c1c-76a2-4646-a2fb-7085bbbf3c56";

      Map<String, dynamic> bearerMap =
      json.decode((await RequestHelper().getBearer(jsonBody, instCode)).body);

      String code = bearerMap.values.toList()[0];

      String eventsString = (await RequestHelper().getEvents(code, instCode));
      String evaluationsString = (await RequestHelper().getEvaluations(
          code, instCode));
      saveEvaluations(evaluationsString, user);
      saveEvents(eventsString, user);

      Map<String, dynamic> notesMap = json.decode(evaluationsString);
      List<dynamic> eventsMap = json.decode(eventsString);
      eventsMap.addAll(notesMap["Notes"]);
      Map<String, User> userProperty = <String, User>{"user": user};

      eventsMap.forEach((dynamic e) => e.addAll(userProperty));

      onlyNotes.addAll(eventsMap);
    }

    return onlyNotes;
  }
}
