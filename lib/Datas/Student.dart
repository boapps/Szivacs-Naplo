// Ennek a nagyrészét valamelyik json to dart pluginnal generáltattam.

import 'package:flutter/material.dart';
import 'User.dart';

class Student {
  int StudentId;
  int SchoolYearId;
  String Name;
  String NameOfBirth;
  String PlaceOfBirth;
  String MothersName;
  List<String> AddressDataList;
  String DateOfBirthUtc;
  String InstituteName;
  String InstituteCode;
  List<Evaluation> Evaluations;
  List<SubjectAveragesBean> SubjectAverages;
  List<Absence> Absences;
  List<NotesBean> Notes;
  dynamic Lessons;
  dynamic Events;
  FormTeacherBean FormTeacher;
  List<TutelariesBean> Tutelaries;

  static Student fromMap(Map<String, dynamic> map, User owner) {
    if (map == null) return null;
    Student studentBean = Student();
    studentBean.StudentId = map['StudentId'];
    studentBean.SchoolYearId = map['SchoolYearId'];
    studentBean.Name = map['Name'];
    studentBean.NameOfBirth = map['NameOfBirth'];
    studentBean.PlaceOfBirth = map['PlaceOfBirth'];
    studentBean.MothersName = map['MothersName'];
    studentBean.AddressDataList = List()
      ..addAll(
          (map['AddressDataList'] as List ?? []).map((o) => o.toString())
      );
    studentBean.DateOfBirthUtc = map['DateOfBirthUtc'];
    studentBean.InstituteName = map['InstituteName'];
    studentBean.InstituteCode = map['InstituteCode'];
    studentBean.Evaluations = List()
      ..addAll(
          (map['Evaluations'] as List ?? []).map((o) =>
              Evaluation.fromMap(o, owner))
      );
    studentBean.SubjectAverages = List()
      ..addAll(
          (map['SubjectAverages'] as List ?? []).map((o) =>
              SubjectAveragesBean.fromMap(o))
      );
    studentBean.Absences = List()
      ..addAll(
          (map['Absences'] as List ?? []).map((o) => Absence.fromMap(o, owner))
      );
    studentBean.Notes = List()
      ..addAll(
          (map['Notes'] as List ?? []).map((o) => NotesBean.fromMap(o))
      );
    studentBean.Lessons = map['Lessons'];
    studentBean.Events = map['Events'];
    studentBean.FormTeacher = FormTeacherBean.fromMap(map['FormTeacher']);
    studentBean.Tutelaries = List()
      ..addAll(
          (map['Tutelaries'] as List ?? []).map((o) =>
              TutelariesBean.fromMap(o))
      );
    return studentBean;
  }

  Map toJson() =>
      {
        "StudentId": StudentId,
        "SchoolYearId": SchoolYearId,
        "Name": Name,
        "NameOfBirth": NameOfBirth,
        "PlaceOfBirth": PlaceOfBirth,
        "MothersName": MothersName,
        "AddressDataList": AddressDataList,
        "DateOfBirthUtc": DateOfBirthUtc,
        "InstituteName": InstituteName,
        "InstituteCode": InstituteCode,
        "Evaluations": Evaluations,
        "SubjectAverages": SubjectAverages,
        "Absences": Absences,
        "Notes": Notes,
        "Lessons": Lessons,
        "Events": Events,
        "FormTeacher": FormTeacher,
        "Tutelaries": Tutelaries,
      };
}

class TutelariesBean {
  int TutelaryId;
  String Name;
  String Email;
  String PhoneNumber;

  static TutelariesBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    TutelariesBean tutelariesBean = TutelariesBean();
    tutelariesBean.TutelaryId = map['TutelaryId'];
    tutelariesBean.Name = map['Name'];
    tutelariesBean.Email = map['Email'];
    tutelariesBean.PhoneNumber = map['PhoneNumber'];
    return tutelariesBean;
  }

  Map toJson() =>
      {
        "TutelaryId": TutelaryId,
        "Name": Name,
        "Email": Email,
        "PhoneNumber": PhoneNumber,
      };
}

class FormTeacherBean {
  int TeacherId;
  String Name;
  dynamic Email;
  dynamic PhoneNumber;

  static FormTeacherBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    FormTeacherBean formTeacherBean = FormTeacherBean();
    formTeacherBean.TeacherId = map['TeacherId'];
    formTeacherBean.Name = map['Name'];
    formTeacherBean.Email = map['Email'];
    formTeacherBean.PhoneNumber = map['PhoneNumber'];
    return formTeacherBean;
  }

  Map toJson() =>
      {
        "TeacherId": TeacherId,
        "Name": Name,
        "Email": Email,
        "PhoneNumber": PhoneNumber,
      };
}

class NotesBean {
  int NoteId;
  String Type;
  String Title;
  String Content;
  dynamic SeenByTutelaryUTC;
  String Teacher;
  String Date;
  String CreatingTime;

  static NotesBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    NotesBean notesBean = NotesBean();
    notesBean.NoteId = map['NoteId'];
    notesBean.Type = map['Type'];
    notesBean.Title = map['Title'];
    notesBean.Content = map['Content'];
    notesBean.SeenByTutelaryUTC = map['SeenByTutelaryUTC'];
    notesBean.Teacher = map['Teacher'];
    notesBean.Date = map['Date'];
    notesBean.CreatingTime = map['CreatingTime'];
    return notesBean;
  }

  Map toJson() =>
      {
        "NoteId": NoteId,
        "Type": Type,
        "Title": Title,
        "Content": Content,
        "SeenByTutelaryUTC": SeenByTutelaryUTC,
        "Teacher": Teacher,
        "Date": Date,
        "CreatingTime": CreatingTime,
      };
}

class Absence {
  int AbsenceId;
  String Type;
  String TypeName;
  String Mode;
  String ModeName;
  String Subject;
  dynamic SubjectCategory;
  String SubjectCategoryName;
  int DelayTimeMinutes;
  String Teacher;
  DateTime LessonStartTime;
  int NumberOfLessons;
  DateTime CreatingTime;
  String JustificationState;
  String JustificationStateName;
  String JustificationType;
  String JustificationTypeName;
  dynamic SeenByTutelaryUTC;

  User owner;
  static const PARENTAL = "Parental";

  static const JUSTIFIED = "Justified";
  static const BE_JUSTIFIED = "BeJustified";
  static const UNJUSTIFIED = "UnJustified";

  bool isParental() => JustificationType == PARENTAL;

  bool isJustified() => JustificationState == JUSTIFIED;

  bool isBeJustified() => JustificationState == BE_JUSTIFIED;

  bool isUnjustified() => JustificationState == UNJUSTIFIED;

  static Absence fromMap(Map<String, dynamic> map, User owner) {
    if (map == null) return null;
    Absence absencesBean = Absence();
    absencesBean.AbsenceId = map['AbsenceId'];
    absencesBean.Type = map['Type'];
    absencesBean.TypeName = map['TypeName'];
    absencesBean.Mode = map['Mode'];
    absencesBean.ModeName = map['ModeName'];
    absencesBean.Subject = map['Subject'];
    absencesBean.SubjectCategory = map['SubjectCategory'];
    absencesBean.SubjectCategoryName = map['SubjectCategoryName'];
    absencesBean.DelayTimeMinutes = map['DelayTimeMinutes'];
    absencesBean.Teacher = map['Teacher'];
    absencesBean.LessonStartTime = DateTime.parse(map['LessonStartTime']);
    absencesBean.NumberOfLessons = map['NumberOfLessons'];
    absencesBean.CreatingTime = DateTime.parse(map['CreatingTime']);
    absencesBean.JustificationState = map['JustificationState'];
    absencesBean.JustificationStateName = map['JustificationStateName'];
    absencesBean.JustificationType = map['JustificationType'];
    absencesBean.JustificationTypeName = map['JustificationTypeName'];
    absencesBean.SeenByTutelaryUTC = map['SeenByTutelaryUTC'];

    if (map.containsKey("owner"))
      absencesBean.owner = User.fromJson(map['owner']);
    else
      absencesBean.owner = owner;

    return absencesBean;
  }

  Map toJson() =>
      {
        "AbsenceId": AbsenceId,
        "Type": Type,
        "TypeName": TypeName,
        "Mode": Mode,
        "ModeName": ModeName,
        "Subject": Subject,
        "SubjectCategory": SubjectCategory,
        "SubjectCategoryName": SubjectCategoryName,
        "DelayTimeMinutes": DelayTimeMinutes,
        "Teacher": Teacher,
        "LessonStartTime": LessonStartTime,
        "NumberOfLessons": NumberOfLessons,
        "CreatingTime": CreatingTime,
        "JustificationState": JustificationState,
        "JustificationStateName": JustificationStateName,
        "JustificationType": JustificationType,
        "JustificationTypeName": JustificationTypeName,
        "SeenByTutelaryUTC": SeenByTutelaryUTC,
      };
}

class SubjectAveragesBean {
  int SubjectId;
  String Subject;
  dynamic SubjectCategory;
  String SubjectCategoryName;
  double Value;
  double ClassValue;
  double Difference;

  static SubjectAveragesBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    SubjectAveragesBean subjectAveragesBean = SubjectAveragesBean();
    subjectAveragesBean.SubjectId = map['SubjectId'];
    subjectAveragesBean.Subject = map['Subject'];
    subjectAveragesBean.SubjectCategory = map['SubjectCategory'];
    subjectAveragesBean.SubjectCategoryName = map['SubjectCategoryName'];
    subjectAveragesBean.Value = map['Value'];
    subjectAveragesBean.ClassValue = map['ClassValue'];
    subjectAveragesBean.Difference = map['Difference'];
    return subjectAveragesBean;
  }

  Map toJson() =>
      {
        "SubjectId": SubjectId,
        "Subject": Subject,
        "SubjectCategory": SubjectCategory,
        "SubjectCategoryName": SubjectCategoryName,
        "Value": Value,
        "ClassValue": ClassValue,
        "Difference": Difference,
      };
}

class Evaluation {
  int EvaluationId;
  String Form;
  String FormName;
  String Type;
  String TypeName;
  String Subject;
  dynamic SubjectCategory;
  String SubjectCategoryName;
  String Theme;
  bool IsAtlagbaBeleszamit;
  String Mode;
  String Weight;
  String Value;
  int NumberValue;
  dynamic SeenByTutelaryUTC;
  String Teacher;
  DateTime Date;
  DateTime CreatingTime;
  JellegBean Jelleg;
  String JellegNev;
  ErtekFajtaBean ErtekFajta;

  User owner;
  
  static const String MID_YEAR = "MidYear";
  static const String TEXT = "Text";
  static const String PERCENTAGE = "Percentage"; //Nem biztos, hogy így van, de hátha :D

  static const String HALF_YEAR = "HalfYear";
  static const String END_YEAR = "EndYear";
  static const String FIRST_QUARTER = "IQuarterEvaluation";
  static const String THIRD_QUARTER = "IIIQuarterEvaluation";

  bool isMidYear() => Type == MID_YEAR;
  bool isText() => Type == TEXT;
  bool isPercentage() => Type == PERCENTAGE;

  bool isHalfYear() => Type == HALF_YEAR;
  bool isEndYear() => Type == END_YEAR;
  bool isFirstQuarter() => Type == FIRST_QUARTER;
  bool isThirdQuarter() => Type == THIRD_QUARTER;
  bool isSummaryEvaluation() => (isHalfYear() || isEndYear() || isFirstQuarter() || isThirdQuarter());


  int trueID() =>
      int.parse(EvaluationId.toString() + Jelleg.Id
          .toString()); // Az EvaluationId nem egyedi azonosító (van, hogy két jegy ugyanazt kapja!), ezért kellett egy igazi ID.
  int get realValue {
    if (NumberValue != 0)
      return NumberValue;
    else {
      switch (Value) {
        case "Példás":
          return 5;
        case "Jó":
          return 4;
        case "Változó":
          return 3;
        case "Hanyag": //Szorgalom
          return 2;
        case "Rossz": //Magatartás
          return 2;
      }
    }
    return 0;
  }


  static Evaluation fromMap(Map<String, dynamic> map, User owner) {
    if (map == null) return null;
    Evaluation evaluationsBean = Evaluation();
    evaluationsBean.EvaluationId = map['EvaluationId'];
    evaluationsBean.Form = map['Form'];
    evaluationsBean.FormName = map['FormName'];
    evaluationsBean.Type = map['Type'];
    evaluationsBean.TypeName = map['TypeName'];
    evaluationsBean.Subject = map['Subject'];
    evaluationsBean.SubjectCategory = map['SubjectCategory'];
    evaluationsBean.SubjectCategoryName = map['SubjectCategoryName'];
    evaluationsBean.Theme = map['Theme'];
    evaluationsBean.IsAtlagbaBeleszamit = map['IsAtlagbaBeleszamit'];
    evaluationsBean.Mode = map['Mode'];
    evaluationsBean.Weight = map['Weight'];
    evaluationsBean.Value = map['Value'];
    evaluationsBean.NumberValue = map['NumberValue'];
    evaluationsBean.SeenByTutelaryUTC = map['SeenByTutelaryUTC'];
    evaluationsBean.Teacher = map['Teacher'];
    evaluationsBean.Date = DateTime.parse(map['Date']);
    evaluationsBean.CreatingTime = DateTime.parse(map['CreatingTime']);
    evaluationsBean.Jelleg = JellegBean.fromMap(map['Jelleg']);
    evaluationsBean.JellegNev = map['JellegNev'];
    evaluationsBean.ErtekFajta = ErtekFajtaBean.fromMap(map['ErtekFajta']);

    if (map.containsKey("owner"))
      evaluationsBean.owner = User.fromJson(map['owner']);
    else
      evaluationsBean.owner = owner;

    return evaluationsBean;
  }

  Map toJson() =>
      {
        "EvaluationId": EvaluationId,
        "Form": Form,
        "FormName": FormName,
        "Type": Type,
        "TypeName": TypeName,
        "Subject": Subject,
        "SubjectCategory": SubjectCategory,
        "SubjectCategoryName": SubjectCategoryName,
        "Theme": Theme,
        "IsAtlagbaBeleszamit": IsAtlagbaBeleszamit,
        "Mode": Mode,
        "Weight": Weight,
        "Value": Value,
        "NumberValue": NumberValue,
        "SeenByTutelaryUTC": SeenByTutelaryUTC,
        "Teacher": Teacher,
        "Date": Date,
        "CreatingTime": CreatingTime,
        "Jelleg": Jelleg,
        "JellegNev": JellegNev,
        "ErtekFajta": ErtekFajta,
        "owner": owner,
      };

  Color get color {
    switch (Weight) {
      case "100%":
        return Colors.white;
        break;
      case "200%":
        return Colors.redAccent;
        break;
      case "300%":
        return Colors.blueAccent;
        break;
      case "400%":
        return Colors.green;
        break;
      default:
        return null;
        break;
    }
  }

}

class ErtekFajtaBean {
  int Id;
  String Nev;
  String Leiras;

  static ErtekFajtaBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ErtekFajtaBean ertekFajtaBean = ErtekFajtaBean();
    ertekFajtaBean.Id = map['Id'];
    ertekFajtaBean.Nev = map['Nev'];
    ertekFajtaBean.Leiras = map['Leiras'];
    return ertekFajtaBean;
  }

  Map toJson() =>
      {
        "Id": Id,
        "Nev": Nev,
        "Leiras": Leiras,
      };
}

class JellegBean {
  int Id;
  String Nev;
  String Leiras;

  static JellegBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    JellegBean jellegBean = JellegBean();
    jellegBean.Id = map['Id'];
    jellegBean.Nev = map['Nev'];
    jellegBean.Leiras = map['Leiras'];
    return jellegBean;
  }

  Map toJson() =>
      {
        "Id": Id,
        "Nev": Nev,
        "Leiras": Leiras,
      };
}