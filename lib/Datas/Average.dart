import 'User.dart';

class Average {
  String subject;
  String subjectCategory;
  String subjectCategoryName;
  double value;
  double classValue;
  double difference;
  User owner;

  Average(this.subject, this.subjectCategory, this.subjectCategoryName,
      this.value, this.classValue, this.difference);

  Average.fromJson(Map json){
    subject = json["Subject"];
    subjectCategory = json["SubjectCategory"];
    subjectCategoryName = json["SubjectCategoryName"];
    value = json["Value"];
    classValue = json["ClassValue"];
    difference = json["Difference"];
  }
}