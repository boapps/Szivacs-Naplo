import 'dart:async';
import 'dart:convert' show json, utf8;

import 'package:e_szivacs/Datas/Lesson.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../globals.dart' as globals;
import '../Utils/StringFormatter.dart';

import '../Datas/User.dart';
import '../Utils/Saver.dart';

class RequestHelper {

  static const String CLIENT_ID = "919e0c1c-76a2-4646-a2fb-7085bbbf3c56";
  static const String GRANT_TYPE = "password";
  static const String SETTINGS_API_URL = "https://www.e-szivacs.org/mirror/settings.json";
  static const String INSTITUTES_API_URL = "https://www.e-szivacs.org/mirror/school-list.json";
  static const String FAQ_API_URL = "https://raw.githubusercontent.com/boapps/e-Szivacs-2/master/gyik.md";

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
      globals.userAgent = settingsJson["CurrentUserAgent"];
      globals.latestVersion = settingsJson["CurrentAppVersion"];
    } catch (e) {
      print(e);
    }
  }

  Future<String> getFAQ() async {
    String faq = (await http.get(FAQ_API_URL)).body;
    return faq;
  }

  Future<String> getStuffFromUrl(String url, String accessToken, String schoolCode) async {
    http.Response response = await http.get(
        url,
        headers: {
          "HOST": schoolCode + ".e-kreta.hu",
          "User-Agent": globals.userAgent,
          "Authorization": "Bearer " + accessToken
        });

    return response.body;
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

  Future<http.Response> getBearer(String jsonBody, String schoolCode) async {
    try {
      return http.post("https://" + schoolCode + ".e-kreta.hu/idp/api/v1/Token",
          headers: {
            "HOST": schoolCode + ".e-kreta.hu",
            "Content-Type": "application/x-www-form-urlencoded; charset=utf-8",
            "User-Agent": globals.userAgent
          },
          body: jsonBody);
    } catch (e) {
      print(e);
      showError("Hálózati hiba");
      return null;
    }
  }

  void uploadHomework(String homework, String deadline, Lesson lesson, User user) async {
    Map body = {
      "OraId": lesson.id.toString(),
      "OraDate": dateToHuman(lesson.date) + "00:00:00",
      "OraType": lesson.calendarOraType,
      "HataridoUtc": deadline,
      "FeladatSzovege": homework
    };

    String token = await getBearerToken(user);
    String jsonBody = json.encode(body);

    try {
      http.Response response = await http.post("https://" + user.schoolCode + ".e-kreta.hu/mapi/api/v1/HaziFeladat/CreateTanuloHaziFeladat",
          headers: {
            "HOST": user.schoolCode + ".e-kreta.hu",
            "Authorization": "Bearer " + token,
            "Content-Type": "application/json; charset=utf-8",
            "User-Agent": globals.userAgent
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

  Future<String> getBearerToken(User user, {bool showErrors=true}) async {
    String body =
        "institute_code=${user.schoolCode}&"
        "userName=${user.username}&"
        "password=${user.password}&"
        "grant_type=$GRANT_TYPE&"
        "client_id=$CLIENT_ID";

    http.Response bearerResponse = await RequestHelper().getBearer(
        body, user.schoolCode);

    try {
      Map<String, dynamic> bearerMap = json.decode(bearerResponse.body);
      if (bearerMap["error"] == "invalid_grant" && showErrors)
        showError("Hibás jelszó vagy felhasználónév");

      String code = bearerMap["access_token"];

      return code;
    } catch (e) {
      if (showErrors)
        showError("hiba");
      print(e);
    }

    return null;
  }

  void seeMessage(int id, User user) async {
    try {
      String code = await getBearerToken(user);

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

  Future<String> getStudentString(User user, {bool showErrors=true}) async {
      String code = await getBearerToken(user, showErrors: showErrors);

      String evaluationsString = await getEvaluations(code, user.schoolCode);

      return evaluationsString;
  }

  Future<String> getEventsString(User user) async {
    String code = await getBearerToken(user);

    String eventsString = await getEvents(code, user.schoolCode);

    saveEvents(eventsString, user);

    return eventsString;
  }

}