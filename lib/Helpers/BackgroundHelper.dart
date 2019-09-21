import 'dart:async';
import 'dart:math';

import 'package:background_fetch/background_fetch.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../Datas/Account.dart';
import '../Datas/Lesson.dart';
import '../Datas/Note.dart';
import '../Datas/Student.dart';
import '../Datas/User.dart';
import '../Helpers/DBHelper.dart';
import '../Helpers/SettingsHelper.dart';
import '../Helpers/TimetableHelper.dart';
import '../Helpers/encrypt_codec.dart';
import '../Utils/AccountManager.dart';
import '../Utils/StringFormatter.dart';
import '../globals.dart' as globals;
import 'SettingsHelper.dart';


class BackgroundHelper {
  Future<bool> get canSyncOnData async =>
      await SettingsHelper().getCanSyncOnData();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  void doEvaluations(List<Evaluation> offlineEvals, List<Evaluation> evals) async {
    print("TEST 2");

    for (Evaluation e in evals) {
      bool exist = false;
      for (Evaluation o in offlineEvals)
        if (e.trueID() == o.trueID())
          exist = true;
      if (!exist) {
        var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
          'evaluations', 'jegyek', 'értesítések a jegyekről',
          importance: Importance.Max,
          priority: Priority.High,
          color: Colors.blue,
        );
        var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
        var platformChannelSpecifics = new NotificationDetails(
            androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
        flutterLocalNotificationsPlugin.show(
            e.trueID(),
            e.Subject + " - " +
                (e.NumberValue != 0 ? e.NumberValue.toString() : e.Value),
            e.owner.name + ", " + (e.Theme ?? ""), platformChannelSpecifics,
            payload: e.trueID().toString());
      }

      //todo jegyek változása
      //todo új házik
      //todo ha óra elmarad/helyettesítés
    }
  }

  void doNotes(List<Note> offlineNotes, List<Note> notes) async {
    for (Note n in notes) {
      if (!offlineNotes.map((Note note) => note.id).contains(n.id)) {
        print(offlineNotes.map((Note note) => note.id).toList());
        print(n.id);
        var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
            'notes', 'feljegyzések', 'értesítések a feljegyzésekről',
            importance: Importance.Max,
            priority: Priority.High,
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

  void doAbsences(Map<String, List<Absence>> offlineAbsences, Map<String, List<Absence>> absences) async {
    if (absences != null)
      absences.forEach((String date, List<Absence> absenceList) {
        for (Absence absence in absenceList) {
          bool exist = false;
          offlineAbsences.forEach((String dateOffline, List<Absence> absenceList2) {
            for (Absence offlineAbsence in absenceList2)
              if (absence.AbsenceId == offlineAbsence.AbsenceId)
                exist = true;
          });
          if (!exist) {
            var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
              'absences', 'mulasztások', 'értesítések a hiányzásokról',
              importance: Importance.Max,
              priority: Priority.High,
              color: Colors.blue,
              groupKey: absenceList.first.owner.id.toString() + absence.Type,);
            var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
            var platformChannelSpecifics = new NotificationDetails(
                androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
            flutterLocalNotificationsPlugin.show(
              absence.AbsenceId,
              absence.Subject + " " + absence.TypeName,
              absence.owner.name +
                  (absence.DelayTimeMinutes != 0 ? (", " +
                      absence.DelayTimeMinutes.toString() +
                      " perc késés") : ""), platformChannelSpecifics,
              payload: absence.AbsenceId.toString(),);
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

      // Értesítés a következő óráról WIP

      if (false) {
        print("1");
        if (lesson.date.isAfter(DateTime.now()) && lesson.id != lessons.last.id) {
          print("2");
          int index = lessons.indexOf(lesson);
          print("index: " + index.toString());
          if (lessons[index].date == lessons[index+1].date) {
            print("3");
            print(lesson.end.toIso8601String());
            print(lessons[index+1].subject);
            var scheduledNotificationDateTime = lesson.end;
            var androidPlatformChannelSpecifics = new AndroidNotificationDetails('next-lesson', 'Következő óra', 'Értesítés a következő óráról', playSound: false,);
            var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
            NotificationDetails platformChannelSpecifics = new NotificationDetails(
                androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
            await flutterLocalNotificationsPlugin.schedule(
                0,
                'Következő óra: ' + lessons[index+1].subject + " " + (lessons[index+1].start.minute - DateTime.now().minute).toString() + " perc",
                lessons[index+1].room,
                scheduledNotificationDateTime,
                platformChannelSpecifics,
              androidAllowWhileIdle: true
            );
          }
        }
      }

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
    final storage = new FlutterSecureStorage();
    String value = await storage.read(key: "db_key");
    if (value == null) {
      int randomNumber = Random.secure().nextInt(4294967296);
      await storage.write(key: "db_key", value: randomNumber.toString());
      value = await storage.read(key: "db_key");
    }

    var codec = getEncryptSembastCodec(password: value);

    globals.db = await globals.dbFactory.openDatabase(
        (await DBHelper().localFolder) + DBHelper().dbPath,
        codec: codec);

    List accounts = List();
    for (User user in await AccountManager().getUsers())
      accounts.add(Account(user));
    print("accounts.length: " + accounts.length.toString());
    for (Account account in accounts) {
      try {
        print(account.user.name);
        await account.refreshStudentString(true);

        List<Evaluation> offlineEvals = account.student.Evaluations;
        print(offlineEvals.length);
        // testing:
        //offlineEvals.removeAt(0);
        List<Note> offlineNotes = account.notes;
        // testing:
        //offlineNotes.removeAt(0);
        Map<String, List<Absence>> offlineAbsences = account.absents;
        // testing:
        //offlineAbsences.remove(offlineAbsences.keys.first);

        await account.refreshStudentString(false);

        List<Evaluation> evals = account.student.Evaluations;
        List<Note> notes = account.notes;
        Map<String, List<Absence>> absences = account.absents;

        doEvaluations(offlineEvals, evals);
        doNotes(offlineNotes, notes);
        doAbsences(offlineAbsences, absences);
      } catch (e) {
        print(e);
      }

      try {
        doLessons(account);
      } catch (e) {
        print(e);
      }
    }
  }

  Future<int> backgroundTask() async {
    await Connectivity().checkConnectivity().then((ConnectivityResult result) async {
      try {
        if (result == ConnectivityResult.mobile && await canSyncOnData ||
            result == ConnectivityResult.wifi)
          doBackground();
      } catch (e) {
        print(e);
      }
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
    if (await SettingsHelper().getNotification()) {
      await SettingsHelper().getRefreshNotification().then((int _refreshNotification) {
        BackgroundFetch.configure(BackgroundFetchConfig(
          minimumFetchInterval: _refreshNotification,
          stopOnTerminate: false,
          forceReload: false,
          enableHeadless: true,
          startOnBoot: true,
        ), backgroundFetchHeadlessTask);
      });
    }
  }

  Future<void> register() async {
    if (await SettingsHelper().getNotification()) {
      BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
    }
  }

}