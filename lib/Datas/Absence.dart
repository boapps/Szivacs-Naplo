import 'User.dart';

class Absence {
  // constants:
  static const PARENTAL = "Parental";

  int id;
  String type;
  String typeName;
  String mode;
  String modeName;
  String subject;
  String subjectName;
  int delayMinutes;
  String teacher;
  String startTime;
  String creationTime;
  int lessonNumber;
  String justificationState;
  String justificationStateName;
  String justificationType;
  String justificationTypeName;
  User owner;

  Absence(
      this.id,
      this.type,
      this.typeName,
      this.mode,
      this.modeName,
      this.subject,
      this.subjectName,
      this.delayMinutes,
      this.teacher,
      this.startTime,
      this.creationTime,
      this.lessonNumber,
      this.justificationState,
      this.justificationStateName,
      this.justificationType,
      this.justificationTypeName);

  bool isParental() => justificationType == PARENTAL;

  Absence.fromJson(Map json) {
    id = json["AbsenceId"];
    type = json["Type"];
    typeName = json["TypeName"];
    mode = json["Mode"];
    modeName = json["ModeName"];
    subject = json["Subject"];
    subjectName = json["SubjectCategoryName"];
    delayMinutes = json["DelayTimeMinutes"];
    teacher = json["Teacher"];
    startTime = json["LessonStartTime"];
    lessonNumber = json["NumberOfLessons"];
    creationTime = json["CreatingTime"];
    justificationState = json["JustificationState"];
    justificationStateName = json["JustificationStateName"];
    justificationType = json["JustificationType"];
    justificationTypeName = json["JustificationTypeName"];
  }
}
