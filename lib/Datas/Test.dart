// for upcoming test
import 'User.dart';

class Test {
  String uid; //Uid
  int id; //Id
  DateTime date; //Datum
  String dayOfWeek; //HetNapja
  int lessonNumber; //Oraszam
  String subject; //Tantargy
  String teacher; //Tanar
  String title; //SzamonkeresMegnevezese
  String mode; //SzamonkeresModja
  DateTime creationDate; //BejelentesDatuma
  User owner;

  Test(this.uid, this.id, this.date, this.dayOfWeek, this.lessonNumber,
      this.subject, this.teacher, this.title, this.mode, this.creationDate,
      this.owner);

  Test.fromJson(Map json) {
    this.uid = json["Uid"];
    this.id = json["Id"];
    this.date = DateTime.parse(json["Datum"]);
    this.dayOfWeek = json["HetNapja"];
    this.lessonNumber = json["Oraszam"];
    this.subject = json["Tantargy"];
    this.teacher = json["Tanar"];
    this.title = json["SzamonkeresMegnevezese"];
    this.mode = json["SzamonkeresModja"];
    this.creationDate = DateTime.parse(json["BejelentesDatuma"]);
  }
}
