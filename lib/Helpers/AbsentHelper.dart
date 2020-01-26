import 'dart:async';

import '../Datas/Student.dart';

class AbsentHelper {
  Future<Map<String, List<Absence>>> getAbsentsFrom(
      List<Absence> absenceList) async {
    Map<String, List<Absence>> absents = new Map<String, List<Absence>>();
    Set<String> uniqueAbsence = new Set<String>();
    absenceList.sort((Absence a, Absence b) {
      return b.LessonStartTime.compareTo(a.LessonStartTime);
    });

    // quick hack to remove duplicates
    // todo fix the root of the problem
    List<int> ids = List();
    List<Absence> tmp = List();
    for (Absence a in absenceList) {
      if (!ids.contains(a.AbsenceId)) {
        ids.add(a.AbsenceId);
        tmp.add(a);
      }
    }
    absenceList = tmp;

    for (Absence a in absenceList) {
      uniqueAbsence
          .add(a.LessonStartTime.toIso8601String() + a.owner.id.toString());
    }
    for (String s in uniqueAbsence) {
      List<Absence> theseAbsences = new List();
      for (Absence a in absenceList)
        if (a.LessonStartTime.toIso8601String() + a.owner.id.toString() == s)
          theseAbsences.add(a);
      absents.putIfAbsent(s, () => theseAbsences);
    }
    return absents;
  }
}
