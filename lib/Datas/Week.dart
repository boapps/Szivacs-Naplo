import 'package:flutter/material.dart';
import '../Datas/Lesson.dart';
import 'package:e_szivacs/generated/i18n.dart';


class Week {
  List<Lesson> monday;
  List<Lesson> tuesday;
  List<Lesson> wednesday;
  List<Lesson> thursday;
  List<Lesson> friday;
  List<Lesson> saturday;
  List<Lesson> sunday;
  DateTime startDay;

  List<List<Lesson>> dayList(){
    List<List<Lesson>> days = new List();
    if (monday.isNotEmpty)
      days.add(monday);
    if (tuesday.isNotEmpty)
      days.add(tuesday);
    if (wednesday.isNotEmpty)
      days.add(wednesday);
    if (thursday.isNotEmpty)
      days.add(thursday);
    if (friday.isNotEmpty)
      days.add(friday);
    if (saturday.isNotEmpty)
      days.add(saturday);
    if (sunday.isNotEmpty)
      days.add(sunday);
    return days;
  }

  List<String> dayStrings(BuildContext context){
    List<String> days = new List();
    if (monday.isNotEmpty)
      days.add(S
          .of(context)
          .short_monday);
    if (tuesday.isNotEmpty)
      days.add(S
          .of(context)
          .short_tuesday);
    if (wednesday.isNotEmpty)
      days.add(S
          .of(context)
          .short_wednesday);
    if (thursday.isNotEmpty)
      days.add(S
          .of(context)
          .short_thursday);
    if (friday.isNotEmpty)
      days.add(S
          .of(context)
          .short_friday);
    if (saturday.isNotEmpty)
      days.add(S
          .of(context)
          .short_saturday);
    if (sunday.isNotEmpty)
      days.add(S
          .of(context)
          .short_sunday);
    return days;
  }

  Week(this.monday, this.tuesday, this.wednesday, this.thursday, this.friday,
      this.saturday, this.sunday, this.startDay);
}