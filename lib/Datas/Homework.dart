import 'User.dart';

class Homework {
  int id;
  String classGroup;
  String subject;
  String uploader;
  bool byTeacher;
  int lessonId;
  int lessonCount; //oraszam
  String text;
  String uploadDate;
  String deadline;
  String isStudentHomeworkEnabled;
  User owner;

  Homework(
      this.id,
      this.classGroup,
      this.subject,
      this.uploader,
      this.byTeacher,
      this.lessonCount,
      this.text,
      this.uploadDate,
      this.deadline,
      this.isStudentHomeworkEnabled,
      this.owner); //todo figure out what this does

  Homework.fromJson(Map json) {
    this.id = json["Id"];
    this.classGroup = json["OsztalyCsoport"];
    this.subject = json["Tantargy"];
    if (this.subject == null) this.subject = json["subject"];
    this.uploader = json["Rogzito"];
    if (this.uploader == null) this.uploader = json["TanuloNev"];
    this.byTeacher = json["IsTanarRogzitette"];
    this.lessonCount = json["Oraszam"];
    this.lessonId = json["TanitasiOraId"];
    this.text = json["Szoveg"];
    if (this.text == null) this.text = json["FeladatSzovege"];
    this.uploadDate = json["FeladasDatuma"];
    this.deadline = json["Hatarido"];
    //this.isStudentHomeworkEnabled = json["IsTanuloHaziFeladatEnabled"] as String;
    this.owner = json["user"];
  }
}
