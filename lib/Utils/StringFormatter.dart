import '../Datas/Lesson.dart';

String getTimetableText(DateTime startDateText) {
  return ((" (" +
      startDateText.month.toString() +
      ". " +
      startDateText.day.toString() +
      ". - " +
      startDateText
          .add(new Duration(days: 6))
          .month
          .toString() +
      ". " +
      startDateText
          .add(new Duration(days: 6))
          .day
          .toString() +
      ".)") ??
      "");
}

String getLessonRangeText(Lesson lesson) {
  return getLessonStartText(lesson) + "-" + getLessonEndText(lesson);
}

String getLessonStartText(Lesson lesson) {
  return lesson.start.hour.toString().padLeft(2, "0") +
      ":" +
      lesson.start.minute.toString().padLeft(2, "0");
}

String getLessonEndText(Lesson lesson) {
  return lesson.end.hour.toString().padLeft(2, "0") +
      ":" +
      lesson.end.minute.toString().padLeft(2, "0");
}

String dateToHuman(DateTime date) {
  return date
      .toIso8601String()
      .substring(0, 11)
      .replaceAll("-", '. ')
      .replaceAll("T", ". ");
}

String lessonToHuman(Lesson lesson) {
  return lesson.date
      .toIso8601String()
      .substring(0, 11)
      .replaceAll("-", '. ')
      .replaceAll("T", ". ");
}

String dateToWeekDay(DateTime date) {
  switch (date.weekday) {
    case DateTime.monday:
      return "Hétfő";
    case DateTime.tuesday:
      return "Kedd";
    case DateTime.wednesday:
      return "Szerda";
    case DateTime.thursday:
      return "Csütörtök";
    case DateTime.friday:
      return "Péntek";
    case DateTime.saturday:
      return "Szombat";
    case DateTime.sunday:
      return "Vasárnap";
  }
  return "";
}
