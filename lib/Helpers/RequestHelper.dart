import 'dart:async';
import 'dart:convert' show utf8, json;
import 'dart:io';

import 'package:http/http.dart' as http;

class RequestHelper {
  Future<Map<String, dynamic>> getInstitutes(HttpClient client) async {
    final String url =
        "https://kretaglobalmobileapi.ekreta.hu/api/v1/Institute";

    final HttpClientRequest request = await client.getUrl(Uri.parse(url))
      ..headers.add("Accept", "application/json")
      ..headers.add("HOST", "kretaglobalmobileapi.ekreta.hu")
      ..headers.add("apiKey", "7856d350-1fda-45f5-822d-e1a2f3f1acf0")
      ..headers.add("Connection", "keep-alive");

    final HttpClientResponse response = await request.close();

    return json.decode(await response.transform(utf8.decoder).join());
  }

  Future<http.Response> getEvaluations(String accessToken, String schoolCode) {
    return http.get("https://" + schoolCode + ".e-kreta.hu/mapi/api/v1/Student",
        // Send authorization headers to your backend
        headers: {
          "Authorization": "Bearer " + accessToken,
          "Content-Type": "application/x-www-form-urlencoded",
          "Accept": "application/json",
          "HOST": schoolCode + ".e-kreta.hu"
        });
  }

  Future<http.Response> getEvents(String accessToken, String schoolCode) {
    return http.get("https://" + schoolCode + ".e-kreta.hu/mapi/api/v1/Event",
        // Send authorization headers to your backend
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/x-www-form-urlencoded",
          "Accept": "application/json",
          "HOST": "$schoolCode.e-kreta.hu"
        });
  }

  Future<http.Response> getNotes(String accessToken, String schoolCode) {
    return http.get("https://" + schoolCode + ".e-kreta.hu/mapi/api/v1/Event",
        // Send authorization headers to your backend
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/x-www-form-urlencoded",
          "Accept": "application/json",
          "HOST": "$schoolCode.e-kreta.hu"
        });
  }

  Future<http.Response> getTimeTable(
      String from, String to, String accessToken, String schoolCode) {
    return http.get(
        "https://" +
            schoolCode +
            ".e-kreta.hu/mapi/api/v1/Lesson?fromDate=" +
            from +
            "&toDate=" +
            to,
        // Send authorization headers to your backend
        headers: {
          "Authorization": "Bearer " + accessToken,
          "Content-Type": "application/x-www-form-urlencoded",
          "Accept": "application/json",
          "HOST": schoolCode + ".e-kreta.hu"
        });
  }

  Future<http.Response> getBearer(String jsonBody, String schoolCode) {
    try {
      return http.post("https://" + schoolCode + ".e-kreta.hu/idp/api/v1/Token",
          // Send authorization headers to your backend
          headers: {
            //        "apiKey": "7856d350-1fda-45f5-822d-e1a2f3f1acf0",
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept": "application/json",
            "HOST": schoolCode + ".e-kreta.hu"
          },
          body: jsonBody);
    } catch (e) {
    }
  }

  Future<http.Response> getPushRegId(
      String schoolCode, String instituteUserId, String handle) {
    try {
      return http.post(
        "https://kretaglobalmobileapi.ekreta.hu/api/v1/Registration?instituteCode=" + schoolCode +
            "&instituteUserId=" + instituteUserId +
            "&platform=Gcm&notificationType=1&handle=" + handle,
        // Send authorization headers to your backend
        headers: {
          "apiKey": "7856d350-1fda-45f5-822d-e1a2f3f1acf0",
          "Content-Type": "application/x-www-form-urlencoded",
          "Accept": "application/json",
          "HOST": "kretaglobalmobileapi.ekreta.hu"
        },
      );
    } catch (e) {
    }
  }

  void sockettest() async {
    var server = await ServerSocket.bind("52.174.184.18", 443);
    server.listen((socket) async {
      int port = server.port;
      socket.write("HTTP/1.1 200 OK\r\n"
          "apiKey: 7856d350-1fda-45f5-822d-e1a2f3f1acf0\r\n"
          "host: kretaglobalmobileapi.ekreta.hu\r\n"
          "Accept: application/json\r\n"
          "Connection: keep-alive\r\n");
      var body = new StringBuffer();
      await for (var data in socket) {
        body.write(new String.fromCharCodes(data));
      }
      socket.close();
      server.close();
    });
  }

  Future<http.Response> fetchPost() {
    return http.get("https://kretaglobalmobileapi.ekreta.hu/api/v1/Institute",
        // Send authorization headers to your backend
        headers: {
          "apiKey": "7856d350-1fda-45f5-822d-e1a2f3f1acf0",
          "Connection": "keep-alive",
          "Accept": "application/json",
          "HOST": "kretaglobalmobileapi.ekreta.hu"
        });
  }
}
