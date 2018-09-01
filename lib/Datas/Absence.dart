import 'User.dart';

class Absence {
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

  Absence(this.id, this.type, this.typeName, this.mode, this.modeName,
      this.subject, this.subjectName, this.delayMinutes, this.teacher,
      this.startTime, this.creationTime, this.lessonNumber,
      this.justificationState, this.justificationStateName,
      this.justificationType, this.justificationTypeName);

  Absence.fromJson(Map json){
  this.id = json["AbsenceId"];
  this.type = json["Type"];
  this.typeName = json["TypeName"];
  this.mode = json["Mode"];
  this.modeName = json["ModeName"];
  this.subject = json["Subject"];
  this.subjectName = json["SubjectCategoryName"];
  this.delayMinutes = json["DelayTimeMinutes"];
  this.teacher = json["Teacher"];
  this.startTime = json["LessonStartTime"];
  this.lessonNumber = json["NumberOfLessons"];
  this.creationTime = json["CreatingTime"];
  this.justificationState = json["JustificationState"];
  this.justificationStateName = json["JustificationStateName"];
  this.justificationType = json["JustificationType"];
  this.justificationTypeName = json["JustificationTypeName"];

  print(justificationState);
  print(justificationStateName);

  }


}