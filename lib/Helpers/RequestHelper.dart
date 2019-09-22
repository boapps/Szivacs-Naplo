import 'dart:async';
import 'dart:convert' show utf8, json;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:native_http_request/native_http_request.dart' as nhttp;

import '../Datas/User.dart';
import '../Utils/Saver.dart';

class RequestHelper {

  Future<String> getInstitutes() async {
    final String url =
        "https://kretaglobalmobileapi.ekreta.hu/api/v1/Institute";

    var r = nhttp.NativeHttpRequest.getRequest(url, headers: {
      "HOST": "kretaglobalmobileapi.ekreta.hu",
      "apiKey": "7856d350-1fda-45f5-822d-e1a2f3f1acf0"
    });

    return r;
    //return json.decode(await response.transform(utf8.decoder).join());
  }

  Future<String> getStuffFromUrl(String url, String accessToken, String schoolCode) async {

    HttpClient client = new HttpClient();

    final HttpClientRequest request = await client.getUrl(Uri.parse(url))
      ..headers.add("HOST", schoolCode + ".e-kreta.hu")
      ..headers.add("Authorization", "Bearer " + accessToken);

    return await (await request.close()).transform(utf8.decoder).join();
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

  Future<http.Response> getBearer(String jsonBody, String schoolCode) {
    try {
      return http.post("https://" + schoolCode + ".e-kreta.hu/idp/api/v1/Token",
          headers: {
            "HOST": schoolCode + ".e-kreta.hu",
            "Content-Type": "application/x-www-form-urlencoded; charset=utf-8"
          },
          body: jsonBody);
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: "Hálózati hiba",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return null;
    }
  }

  void seeMessage(int id, User user) async {
    try {
      String jsonBody =
          "institute_code=" + user.schoolCode +
              "&userName=" + user.username +
              "&password=" + user.password +
              "&grant_type=password&client_id=919e0c1c-76a2-4646-a2fb-7085bbbf3c56";

      Map<String, dynamic> bearerMap = json.decode(
          (await RequestHelper().getBearer(jsonBody, user.schoolCode))
              .body);
      String code = bearerMap.values.toList()[0];

      await http.post("https://eugyintezes.e-kreta.hu//integration-kretamobile-api/v1/kommunikacio/uzenetek/olvasott",
          headers: {
        "Authorization": ("Bearer " + code),
          },
          body: "{\"isOlvasott\":true,\"uzenetAzonositoLista\":[$id]}");
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: "Hálózati hiba",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return null;
    }
  }

  Future<String> getStudentString(User user, {bool showErrors=true}) async {
    String instCode = user.schoolCode;
    String userName = user.username;
    String password = user.password;

    String jsonBody = "institute_code=" +
        instCode +
        "&userName=" +
        userName +
        "&password=" +
        password +
        "&grant_type=password&client_id=919e0c1c-76a2-4646-a2fb-7085bbbf3c56";

    Map<String, dynamic> bearerMap;
    try {
      bearerMap = json.decode((await getBearer(jsonBody, instCode)).body);
    } catch (SocketException) {
      if (showErrors)
        Fluttertoast.showToast(
            msg: "Hálózati hiba",
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
    }

    if (bearerMap["error"] == "invalid_grant"){
      Fluttertoast.showToast(
          msg: "Hibás jelszó vagy felhasználónév",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } else {
      String code = bearerMap["access_token"];

      String evaluationsString =
      (await getEvaluations(code, instCode));

      return evaluationsString;
    }
    return null;
  }

  Future<String> getEventsString(User user) async {
    String instCode = user.schoolCode;
    String userName = user.username;
    String password = user.password;

    String jsonBody = "institute_code=" +
        instCode +
        "&userName=" +
        userName +
        "&password=" +
        password +
        "&grant_type=password&client_id=919e0c1c-76a2-4646-a2fb-7085bbbf3c56";
    Map<String, dynamic> bearerMap;
    try {
      bearerMap =
          json.decode((await getBearer(jsonBody, instCode)).body);
    } catch (e) {
      print(e);
    }

    String code = bearerMap.values.toList()[0];

    String eventsString = await getEvents(code, instCode);

    saveEvents(eventsString, user);

    return eventsString;
  }

}