import 'User.dart';
import 'Evaluation.dart';
import 'Absence.dart';
import 'Note.dart';
import 'Average.dart';
import '../Helpers/RequestHelper.dart';
import '../Helpers/EvaluationHelper.dart';
import '../Helpers/AbsentHelper.dart';
import '../Helpers/AverageHelper.dart';
import '../Helpers/NotesHelper.dart';
import '../Utils/Saver.dart';

class Account {
  User user;
  String _studentString;
  String _eventsString;
  List<Evaluation> evaluations;
  Map<String, List<Absence>> absents;
  List<Note> notes;
  List<Average> averages;
  //todo add a Bearer token here

  Account(User user) {
    this.user = user;
  }

  Future<void> _refreshStudentString(bool isOffline) async {
    if (isOffline)
      _studentString = await readStudent(user);
    else
      _studentString = await RequestHelper().getStudentString(user);
  }

  Future<void> _refreshEventsString(bool isOffline) async {
    if (isOffline)
      _eventsString = await readEventsString(user);
    else
      _eventsString = await RequestHelper().getEventsString(user);
  }

  Future<void> refreshEvaluations(bool isForced, bool isOffline) async {
    if (_studentString == null || isForced)
      await _refreshStudentString(isOffline);
    evaluations = await EvaluationHelper().getEvaluationsFrom(_studentString, user);
  }

  Future<void> refreshAbsents(bool isForced, bool isOffline) async {
    if (_studentString == null || isForced)
      await _refreshStudentString(isOffline);
    absents = await AbsentHelper().getAbsentsFrom(_studentString, user);
  }

  Future<void> refreshNotes(bool isForced, bool isOffline) async {
    if (_studentString == null || isForced)
      await _refreshStudentString(isOffline);
    if (_eventsString == null || isForced)
      await _refreshEventsString(isOffline);
    notes = await NotesHelper().getNotesFrom(_eventsString, _studentString, user);
  }

  Future<void> refreshAverages(bool isForced, bool isOffline) async {
    if (_studentString == null || isForced)
      await _refreshStudentString(isOffline);
    averages = await AverageHelper().getAveragesFrom(_studentString, user);
  }

  List<Evaluation> get midyearEvaluations => evaluations.where(
          (Evaluation evaluation) => evaluation.isMidYear()).toList();
}