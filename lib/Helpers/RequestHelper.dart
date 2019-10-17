import 'dart:async';
import 'dart:convert' show json;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../globals.dart' as globals;

import '../Datas/User.dart';
import '../Utils/Saver.dart';

class RequestHelper {

  static const String CLIENT_ID = "919e0c1c-76a2-4646-a2fb-7085bbbf3c56";
  static const String GRANT_TYPE = "password";
  static const String INSTITUTES_API_URL = "https://raw.githubusercontent.com/boapps/kreta-api-mirror/master/school-list.json";
  static const String USER_AGENT_API_URL = "https://raw.githubusercontent.com/boapps/kreta-api-mirror/master/user-agent";

  void showError(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  Future<String> getInstitutes() async {
    String institutesBody = (await http.get(INSTITUTES_API_URL)).body;
    return institutesBody;
  }

  Future<String> getUserAgent() async {
    String userAgent = (await http.get(USER_AGENT_API_URL)).body;
    return userAgent.trim();
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