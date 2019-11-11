import 'dart:async';
import 'dart:convert' show json, utf8;
import 'dart:math';

import 'package:e_szivacs/Datas/Lesson.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../Datas/User.dart';
import '../Utils/Saver.dart';
import '../Utils/StringFormatter.dart';
import '../globals.dart' as globals;

class RequestHelper {

  static const String CLIENT_ID = "919e0c1c-76a2-4646-a2fb-7085bbbf3c56";
  static const String GRANT_TYPE = "password";
  static const String SETTINGS_API_URL = "https://www.e-szivacs.org/mirror/settings.json";
  static const String INSTITUTES_API_URL = "https://www.e-szivacs.org/mirror/school-list.json";
  static const String FAQ_API_URL = "https://raw.githubusercontent.com/boapps/e-Szivacs-2/master/gyik.md";
  static const String TOS_API_URL = "https://www.e-szivacs.org/adatkezeles_es_feltetelek.html";

  void showError(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  void showSuccess(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  Future<String> getInstitutes() async {
    String institutesBody = utf8.decode((await http.get(INSTITUTES_API_URL)).bodyBytes);
    return institutesBody;
  }

  void refreshSzivacsSettigns() async {
    try {
      String settings = utf8.decode((await http.get(SETTINGS_API_URL)).bodyBytes);
      Map settingsJson = json.decode(settings);
      globals.latestVersion = globals.isBeta ? settingsJson["BetaVersion"] : settingsJson["CurrentAppVersion"];
    } catch (e) {
      print(e);
    }
  }

  Future<String> getFAQ() async {
    String faq = (await http.get(FAQ_API_URL)).body;
    return faq;
  }

  Future<String> getTOS() async {
    String tos = utf8.decode((await http.get(TOS_API_URL)).bodyBytes);
    return tos;
  }

  Future<String> getStuffFromUrl(String url, String accessToken, String schoolCode) async {
    if (accessToken != null) {
      http.Response response = await http.get(
          url,
          headers: {
            "HOST": schoolCode + ".e-kreta.hu",
            "User-Agent": "szivacs_naplo",
            "Authorization": "Bearer " + accessToken
          });

      return response.body;
    }
  }

  Future<String> getTests(String accessToken, String schoolCode) =>
      getStuffFromUrl("https://" + schoolCode + ".e-kreta.hu/mapi/api/v1/BejelentettSzamonkeres?DatumTol=null&DatumIg=null", accessToken, schoolCode);

  Future<String> getMessages(String accessToken, String schoolCode) =>
      getStuffFromUrl("https://eugyintezes.e-kreta.hu/integration-kretamobile-api/v1/kommunikacio/postaladaelemek/sajat", accessToken, schoolCode);

  Future<String> getMessageById(int id, String accessToken, String schoolCode) =>
      getStuffFromUrl("https://eugyintezes.e-kreta.hu/integration-kretamobile-api/v1/kommunikacio/postaladaelemek/$id", accessToken, schoolCode);

  Future<String> getEvaluations(String accessToken, String schoolCode) =>
      getStuffFromUrl("https://" + schoolCode + ".e-kreta.hu"
          + "/mapi/api/v1/Student", accessToken, schoolCode);

  Future<String> getHomework(String accessToken, String schoolCode,
      int id) => getStuffFromUrl("https://" + schoolCode +
      ".e-kreta.hu/mapi/api/v1/HaziFeladat/TanuloHaziFeladatLista/" +
      id.toString(), accessToken, schoolCode);

  Future<String> getHomeworkByTeacher(String accessToken,
      String schoolCode, int id) => getStuffFromUrl("https://" + schoolCode +
      ".e-kreta.hu/mapi/api/v1/HaziFeladat/TanarHaziFeladat/" + id.toString(),
      accessToken, schoolCode);

  Future<String> getEvents(String accessToken, String schoolCode) =>
      getStuffFromUrl("https://" + schoolCode + ".e-kreta.hu/mapi/api/v1/Event",
          accessToken, schoolCode);

  Future<String> getTimeTable(
      String from, String to, String accessToken, String schoolCode) =>
      getStuffFromUrl("https://" +
          schoolCode +
          ".e-kreta.hu/mapi/api/v1/Lesson?fromDate=" +
          from +
          "&toDate=" +
          to, accessToken, schoolCode);

  Future<String> getBearer(String jsonBody, String schoolCode, bool showErrors) async {
    http.Response response;
    try {
      response = await http.post("https://" + schoolCode + ".e-kreta.hu/idp/api/v1/Token",
          headers: {
            "HOST": schoolCode + ".e-kreta.hu",
            "Content-Type": "application/x-www-form-urlencoded; charset=utf-8",
            "User-Agent": "szivacs_naplo"
          },
          body: jsonBody);

      return response.body;
    } catch (e) {
      if (showErrors)
        showError("Hálózati hiba");
      return null;
    }
  }

  void uploadHomework(String homework, Lesson lesson, User user) async {
    Map body = {
      "OraId": lesson.id.toString(),
      "OraDate": dateToHuman(lesson.date) + "00:00:00",
      "OraType": lesson.calendarOraType,
      "HataridoUtc": dateToHuman(lesson.date.add(Duration(days: 2))) + "23:00:00",
      "FeladatSzovege": homework
    };

    String token = await getBearerToken(user, true);
    String jsonBody = json.encode(body);

    try {
      http.Response response = await http.post("https://" + user.schoolCode + ".e-kreta.hu/mapi/api/v1/HaziFeladat/CreateTanuloHaziFeladat",
          headers: {
            "HOST": user.schoolCode + ".e-kreta.hu",
            "Authorization": "Bearer " + token,
            "Content-Type": "application/json; charset=utf-8",
            "User-Agent": "szivacs_naplo"
          },
          body: jsonBody);
      if (response.statusCode == 200)
        showSuccess("Házi sikeresen feltöltve");
      else
        showError("Hiba történt");
    } catch (e) {
      print(e);
      showError("Hálózati hiba");
      return null;
    }

  }

  Future<String> getBearerToken(User user, bool showErrors) async {
    String body =
        "institute_code=${user.schoolCode}&"
        "userName=${user.username}&"
        "password=${user.password}&"
        "grant_type=$GRANT_TYPE&"
        "client_id=$CLIENT_ID";

    try {
      String bearerResponse = await RequestHelper().getBearer(
          body, user.schoolCode, showErrors);

      if (bearerResponse != null) {
        Map<String, dynamic> bearerMap = json.decode(bearerResponse);
        if (bearerMap["error"] == "invalid_grant" && showErrors)
          showError("Hibás jelszó vagy felhasználónév");

        String code = bearerMap["access_token"];

        return code;
      }
    } catch (e) {
      if (showErrors)
        showError("hiba");
      print(e);
    }

    return null;
  }

  void seeMessage(int id, User user) async {
    try {
      String code = await getBearerToken(user, true);

      await http.post("https://eugyintezes.e-kreta.hu//integration-kretamobile-api/v1/kommunikacio/uzenetek/olvasott",
          headers: {
            "Authorization": ("Bearer " + code),
          },
          body: "{\"isOlvasott\":true,\"uzenetAzonositoLista\":[$id]}");
    } catch (e) {
      print(e);
      showError("Hálózati hiba");
      return null;
    }
  }

  Future<String> getStudentString(User user, bool showErrors) async {
    String code = await getBearerToken(user, showErrors);

    String evaluationsString = await getEvaluations(code, user.schoolCode);

    return evaluationsString;
  }

  Future<String> getEventsString(User user, bool showErrors) async {
    String code = await getBearerToken(user, showErrors);

    String eventsString = await getEvents(code, user.schoolCode);

    saveEvents(eventsString, user);

    return eventsString;
  }

}