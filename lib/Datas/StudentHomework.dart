import 'User.dart';

class StudentHomework {
  int id;
  String studentName;
  String uploadDate;
  String text;
  int uploaderId;
  bool studentDeleted;
  bool teacherDeleted;
  User owner;

  StudentHomework(this.id, this.studentName, this.uploadDate, this.text,
      this.uploaderId, this.studentDeleted, this.teacherDeleted, this.owner);

  StudentHomework.fromJson(Map json) {
    this.id = json["Id"];
    this.studentName = json["TanuloNev"];
    this.uploadDate = json["FeladasDatuma"];
    this.text = json["FeladatSzovege"];
    this.uploaderId = json["RogzitoId"];
    this.studentDeleted = json["TanuloAltalTorolt"];
    this.teacherDeleted = json["TanarAltalTorolt"];
    this.owner = json["user"];
  }
}
