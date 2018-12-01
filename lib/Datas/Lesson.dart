class Lesson {
  int id;
  int count;
  int oraszam;
  DateTime date;
  DateTime start;
  DateTime end;
  String subject;
  String subjectName;
  String room;
  String group;
  String teacher;
  String depTeacher;
  String state;
  String stateName;
  String presence;
  String presenceName;
  String theme;
  String homework;
  String calendarOraType;

  Lesson(
      this.id,
      this.count,
      this.oraszam,
      this.date,
      this.start,
      this.end,
      this.subject,
      this.subjectName,
      this.room,
      this.group,
      this.teacher,
      this.depTeacher,
      this.state,
      this.stateName,
      this.presence,
      this.presenceName,
      this.theme,
      this.homework,
      this.calendarOraType);

  Lesson.fromJson(Map json) {
    this.id = json["LessonId"];
    this.count = json["Count"];
    this.oraszam = 0;
    this.date = DateTime.parse(json["Date"]);
    this.start = DateTime.parse(json["StartTime"]);
    this.end = DateTime.parse(json["EndTime"]);
    this.subject = json["Subject"];
    this.subjectName = json["SubjectCategoryName"];
    this.room = json["ClassRoom"];
    this.group = json["ClassGroup"];
    this.teacher = json["Teacher"];
    this.depTeacher = json["DeputyTeacher"];
    this.state = json["State"];
    this.stateName = json["StateName"];
    this.presence = json["PresenceType"];
    this.presenceName = json["PresenceTypeName"];
    this.theme = json["Theme"];
    this.homework = json["Homework"];
    this.calendarOraType = json["CalendarOraType"];
  }
}
