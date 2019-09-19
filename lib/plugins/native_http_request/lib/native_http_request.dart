import 'dart:async';

import 'package:flutter/services.dart';

class NativeHttpRequest {
  static const MethodChannel _channel =
      const MethodChannel('native_http_request');

  static Future<String> getRequest(String url,
      {Map<String, String> headers}) async {
    if (headers == null) headers = new Map();
    final String response = await _channel
        .invokeMethod('getRequest', {"url": url, "headers": headers});
    return response;
  }

  static Future<String> postRequest(String url,
      {String data = "", Map<String, String> headers}) async {
    if (headers == null) headers = new Map();
    final String response = await _channel.invokeMethod(
        'postRequest', {"url": url, "headers": headers, "data": data});
    return response;
  }
}
