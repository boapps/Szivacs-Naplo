import 'dart:async';
import 'dart:convert' show utf8, json;
import 'dart:io';

import 'package:native_http_request/native_http_request.dart' as nhttp;
import 'package:http/http.dart' as http;

class RequestHelper {
  Future<Map<String, dynamic>> getInstitutes(HttpClient client) async {
    final String url =
        "https://kretaglobalmobileapi.ekreta.hu/api/v1/Institute";

    final HttpClientRequest request = await client.getUrl(Uri.parse(url))
      ..headers.add("HOST", "kretaglobalmobileapi.ekreta.hu")
      ..headers.add("apiKey", "7856d350-1fda-45f5-822d-e1a2f3f1acf0");

    final HttpClientResponse response = await request.close();

    return json.decode(await response.transform(utf8.decoder).join());
  }

  Future<http.Response> getStuffFromUrl(String url, String accessToken, String schoolCode){
    return http.get(
      url,
      headers: {
          "Authorization": "Bearer " + accessToken,
          "HOST": schoolCode + ".e-kreta.hu"
      },
    );
  }

  Future<http.Response> getEvaluations(String accessToken, String schoolCode) =>
      getStuffFromUrl("https://" + schoolCode + ".e-kreta.hu"
      + "/mapi/api/v1/Student", accessToken, schoolCode);

  Future<http.Response> getHomework(String accessToken, String schoolCode,
      int id) => getStuffFromUrl("https://" + schoolCode +
      ".e-kreta.hu/mapi/api/v1/HaziFeladat/TanuloHaziFeladatLista/" +
      id.toString(), accessToken, schoolCode);

  Future<http.Response> getHomeworkByTeacher(String accessToken,
      String schoolCode, int id) => getStuffFromUrl("https://" + schoolCode +
      ".e-kreta.hu/mapi/api/v1/HaziFeladat/TanarHaziFeladat/" + id.toString(),
      accessToken, schoolCode);

  Future<http.Response> getEvents(String accessToken, String schoolCode) =>
      getStuffFromUrl("https://" + schoolCode + ".e-kreta.hu/mapi/api/v1/Event",
      accessToken, schoolCode);

  Future<http.Response> getNotes(String accessToken, String schoolCode) =>
      getStuffFromUrl("https://" + schoolCode + ".e-kreta.hu/mapi/api/v1/Event",
      accessToken, schoolCode);

  Future<http.Response> getTimeTable(
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
            "HOST": schoolCode + ".e-kreta.hu"
          },
          body: jsonBody);
    } catch (e) {
      //todo: handle error
    }
  }

  //todo: get schools with NativeHttpRequest. Can't do it with dart, because Kréta does not use follow http standards with it's requests, as the "apiKey" header is not lowercase :(

}