class Lesson {
  int id;
  int count;
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

  static const String MISSED = "Missed";

  Lesson(
      this.id,
      this.count,
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

  bool isMissed() => state == MISSED;
  bool isSubstitution() => depTeacher != "";

  Lesson.fromJson(Map json) {
    id = json["LessonId"];
    count = json["Count"];
    date = DateTime.parse(json["Date"]);
    start = DateTime.parse(json["StartTime"]);
    end = DateTime.parse(json["EndTime"]);
    subject = json["Subject"];
    subjectName = json["SubjectCategoryName"];
    room = json["ClassRoom"];
    group = json["ClassGroup"];
    teacher = json["Teacher"];
    depTeacher = json["DeputyTeacher"];
    state = json["State"];
    stateName = json["StateName"];
    presence = json["PresenceType"];
    presenceName = json["PresenceTypeName"];
    theme = json["Theme"];
    homework = json["Homework"];
    calendarOraType = json["CalendarOraType"];

    if (theme == null)
      theme = "";
    if (subject == null)
      subject = "";
    if (subjectName == null)
      subjectName = "";
    if (room == null)
      room = "";
    if (group == null)
      group = "";
    if (teacher == null)
      teacher = "";
    if (depTeacher == null)
      depTeacher = "";
    if (state == null)
      state = "";
    if (stateName == null)
      stateName = "";
    if (presence == null)
      presence = "";
    if (presenceName == null)
      presenceName = "";
    if (homework == null)
      homework = "";
    if (calendarOraType == null)
      calendarOraType = "";
  }
}
