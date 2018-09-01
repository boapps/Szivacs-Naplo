import 'User.dart';

class Evaluation {
  int _id;
  String _form;
  String _range;
  String _type;
  String _subject;
  String _subjectCategory;
  String _mode;
  String _weight;
  String _value;
  int _numericValue;
  String _teacher;
  String _date;
  String _creationDate;
  String _theme;
  User owner;

  Evaluation(this._id, this._form, this._range, this._type, this._subject,
      this._subjectCategory, this._mode, this._weight, this._value,
      this._numericValue, this._teacher, this._date, this._creationDate,
      this._theme);

  Evaluation.fromJson(Map json){
    this._id = json["EvaluationId"];
    this._form = json ["Form"];
    this._range = json ["FormName"];
    this._type = json ["Type"];
    this._subject = json ["Subject"];
    this._subjectCategory = json ["SubjectCategoryName"];
    this._mode = json ["Mode"];
    this._weight = json ["Weight"];
    this._value = json ["Value"];
    this._numericValue = json ["NumberValue"];
    this._teacher = json ["Teacher"];
    this._date = json ["Date"];
    this._creationDate = json ["CreatingTime"];
    this._theme = json ["Theme"];
    owner = json ["user"];
  }

  String get theme => _theme;

  set theme(String value) {
    _theme = value;
  }

  String get creationDate => _creationDate;

  set creationDate(String value) {
    _creationDate = value;
  }

  String get date => _date;

  set date(String value) {
    _date = value;
  }

  String get teacher => _teacher;

  set teacher(String value) {
    _teacher = value;
  }

  int get numericValue => _numericValue;

  set numericValue(int value) {
    _numericValue = value;
  }

  String get value => _value;

  set value(String value) {
    _value = value;
  }

  String get weight => _weight;

  set weight(String value) {
    _weight = value;
  }

  String get mode => _mode;

  set mode(String value) {
    _mode = value;
  }

  String get subjectCategory => _subjectCategory;

  set subjectCategory(String value) {
    _subjectCategory = value;
  }

  String get subject => _subject;

  set subject(String value) {
    _subject = value;
  }

  String get type => _type;

  set type(String value) {
    _type = value;
  }

  String get range => _range;

  set range(String value) {
    _range = value;
  }

  String get form => _form;

  set form(String value) {
    _form = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }


}
