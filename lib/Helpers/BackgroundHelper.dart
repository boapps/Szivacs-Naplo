import 'SettingsHelper.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../Helpers/SettingsHelper.dart';
import '../globals.dart' as globals;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:background_fetch/background_fetch.dart';
import '../Datas/Evaluation.dart';
import '../Helpers/TimetableHelper.dart';
import '../Utils/StringFormatter.dart';
import '../Utils/AccountManager.dart';
import '../Datas/User.dart';
import '../Datas/Account.dart';
import '../Datas/Note.dart';
import '../Datas/Lesson.dart';
import '../Datas/Absence.dart';
import 'package:connectivity/connectivity.dart';


class BackgroundHelper {
  Future<bool> get canSyncOnData async =>
      await SettingsHelper().getCanSyncOnData();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  void doEvaluations(Account account) async {
    await account.refreshEvaluations(true, true);
    List<Evaluation> offlineEvals = account.evaluations;
    await account.refreshEvaluations(true, false);
    List<Evaluation> evals = account.evaluations;

    for (Evaluation e in evals) {
      bool exist = false;
      for (Evaluation o in offlineEvals)
        if (e.id == o.id)
          exist = true;
      if (!exist) {
        var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
            'evaluations', 'jegyek', 'értesítések a jegyekről',
            importance: Importance.Max,
            priority: Priority.High,
            color: Colors.blue);
        var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
        var platformChannelSpecifics = new NotificationDetails(
            androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
        flutterLocalNotificationsPlugin.show(
            e.id,
            e.subject + " - " +
                (e.numericValue != 0 ? e.numericValue.toString() : e.value),
            e.owner.name + ", " + (e.theme ?? ""), platformChannelSpecifics,
            payload: e.id.toString());
      }

      //todo jegyek változása
      //todo új házik
      //todo ha óra elmarad/helyettesítés
    }
  }

  void doNotes(Account account) async {
    await account.refreshNotes(true, true);
    List<Note> offlineNotes = account.notes;
    await account.refreshNotes(true, false);
    List<Note> notes = account.notes;

    for (Note n in notes) {
      bool exist = false;
      for (Note o in offlineNotes)
        if (n.id == o.id)
          exist = true;
      if (!exist) {
        var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
            'notes', 'feljegyzések', 'értesítések a feljegyzésekről',
            importance: Importance.Max,
            priority: Priority.High,
            style: AndroidNotificationStyle.BigText,
            color: Colors.blue);
        var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
        var platformChannelSpecifics = new NotificationDetails(
            androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
        flutterLocalNotificationsPlugin.show(
            n.id,
            n.title + " - " + n.type,
            n.content, platformChannelSpecifics,
            payload: n.id.toString());
      }
    }
  }

  void doAbsences(Account account) async {
    await account.refreshAbsents(false, true);
    Map<String, List<Absence>> offlineAbsences = account.absents;
    await account.refreshAbsents(false, false);
    Map<String, List<Absence>> absences = account.absents;

    if (absences != null)
      absences.forEach((String date, List<Absence> absenceList) {
        for (Absence absence in absenceList) {
          bool exist = false;
          offlineAbsences.forEach((String dateOffline, List<Absence> absenceList2) {
            for (Absence offlineAbsence in absenceList2)
              if (absence.id == offlineAbsence.id)
                exist = true;
          });
          if (!exist) {
            var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
              'absences', 'mulasztások', 'értesítések a hiányzásokról',
              importance: Importance.Max,
              priority: Priority.High,
              color: Colors.blue,
              groupKey: account.user.id.toString() + absence.type,);
            var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
            var platformChannelSpecifics = new NotificationDetails(
                androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
            flutterLocalNotificationsPlugin.show(
              absence.id,
              absence.subject + " " + absence.typeName,
              absence.owner.name +
                  (absence.delayMinutes != 0 ? (", " + absence.delayMinutes.toString() +
                      " perc késés") : ""), platformChannelSpecifics,
              payload: absence.id.toString(),);
          }
        }
      });
  }

  void doLessons(Account account) async {
    DateTime startDate = new DateTime.now();
    startDate = startDate.add(
        new Duration(days: (-1 * startDate.weekday + 1)));

    List<Lesson> lessonsOffline = await getLessonsOffline(
        startDate, startDate.add(new Duration(days: 7)), account.user);
    List<Lesson> lessons = await getLessons(
        startDate, startDate.add(new Duration(days: 7)), account.user);

    for (Lesson lesson in lessons) {
      bool exist = false;
      for (Lesson offlineLesson in lessonsOffline) {
        exist = (lesson.id == offlineLesson.id &&
            ((lesson.isMissed && !offlineLesson.isMissed) ||
                (lesson.isSubstitution && !offlineLesson.isSubstitution)));
      }
      if (exist) {
        var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
            'lessons', 'órák', 'értesítések elmaradt/helyettesített órákról',
            importance: Importance.Max,
            priority: Priority.High,
            style: AndroidNotificationStyle.BigText,
            color: Colors.blue);
        var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
        var platformChannelSpecifics = new NotificationDetails(
            androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
        flutterLocalNotificationsPlugin.show(
            lesson.id,
            lesson.subject + " " +
                lesson.date.toIso8601String().substring(0, 10) + " (" +
                dateToWeekDay(lesson.date) + ")",
            lesson.stateName + " " + lesson.depTeacher,
            platformChannelSpecifics,
            payload: lesson.id.toString());
      }
    }
  }

  void doBackground() async {
    List accounts = List();
    for (User user in await AccountManager().getUsers())
      accounts.add(Account(user));
    for (Account account in globals.accounts) {
      doEvaluations(account);
      doNotes(account);
      doAbsences(account);
      doLessons(account);
    }
  }

  Future<int> backgroundTask() async {
    await Connectivity().checkConnectivity().then((
        ConnectivityResult result) async {
      if (result == ConnectivityResult.mobile && await canSyncOnData || result == ConnectivityResult.wifi)
        doBackground();
    });

    return 0;
  }


  void backgroundFetchHeadlessTask() async {
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('notification_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    await backgroundTask().then((int finished) {
      BackgroundFetch.finish();
    });
  }

  Future<void> configure() async {
    await SettingsHelper().getRefreshNotification().then((int _refreshNotification){
      BackgroundFetch.configure(BackgroundFetchConfig(
        minimumFetchInterval: _refreshNotification,
        stopOnTerminate: false,
        forceReload: false,
        enableHeadless: true,
        startOnBoot: true,
      ), backgroundFetchHeadlessTask);
    });
  }

  void register() {
    BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  }

}