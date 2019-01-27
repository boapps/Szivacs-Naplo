import '../Datas/Lesson.dart';
import '../Datas/Evaluation.dart';

String getTimetableText(DateTime startDateText) {
  return ((" (" +
      startDateText.month.toString() + ". " +
      startDateText.day.toString() + ". - " +
      startDateText.add(new Duration(days: 6)).month.toString() + ". " +
      startDateText.add(new Duration(days: 6)).day.toString() + ".)")??"");
}

String getLessonRangeText(Lesson lesson) {
  return getLessonStartText(lesson) + "-" + getLessonEndText(lesson);
}

String getLessonStartText(Lesson lesson) {
  return lesson.start.hour.toString().padLeft(2, "0") + ":" +
      lesson.start.minute.toString().padLeft(2, "0");
}

String getLessonEndText(Lesson lesson) {
  return lesson.end.hour.toString().padLeft(2, "0") + ":" +
      lesson.end.minute.toString().padLeft(2, "0");
}

String dateToHuman(Evaluation grade) {
  return grade.date.substring(0, 11).replaceAll("-", '. ').replaceAll("T", ". ");
}