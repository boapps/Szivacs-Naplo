import 'dart:async';

import 'package:flutter/material.dart';

import '../globals.dart';
import 'DBHelper.dart';

class SettingsHelper {
  void _setPropertyBool(String name, dynamic value) async {
    Map<String, dynamic> settings = new Map();
    try {
      settings.addAll(await DBHelper().getSettingsMap());
    } catch (e) {
      print(e);
    }
    settings[name] = value;
    DBHelper().saveSettingsMap(settings);
  }

  dynamic _getProperty(String name, dynamic defaultValue) async {
    Map<String, dynamic> settings = await DBHelper().getSettingsMap();
    if (settings==null)
      settings = new Map();
    if (settings.containsKey(name))
      return (settings[name]);
    return defaultValue;
  }

  void setColoredMainPage(bool value) {
    _setPropertyBool("ColoredMainPage", value);
  }

  Future<bool> getColoredMainPage() async {
    return await _getProperty("ColoredMainPage", true);
  }

  void setDarkTheme(bool value) {
    _setPropertyBool("DarkTheme", value);
  }

  Future<bool> getDarkTheme() async {
    return await _getProperty("DarkTheme", false);
  }

  void setAmoled(bool value) {
    _setPropertyBool("Amoled", value);
  }

  Future<bool> getAmoled() async {
    return await _getProperty("Amoled", false);
  }

  void setNotification(bool value) {
    _setPropertyBool("Notification", value);
  }

  Future<bool> getNotification() async {
    return await _getProperty("Notification", false);
  }

  void setLogo(bool value) {
    isLogo = value;
    _setPropertyBool("Logo", value);
  }

  Future<bool> getLogo() async {
    return await _getProperty("Logo", true);
  }

  void setRefreshNotification(int value) {
    _setPropertyBool("RefreshNotification", value);
  }

  Future<int> getRefreshNotification() async {
    return await _getProperty("RefreshNotification", 15);
  }

  void setSingleUser(bool value) {
    _setPropertyBool("SingleUser", value);
  }

  Future<bool> getSingleUser() async {
    return await _getProperty("SingleUser", false);
  }

  void setLang(String lang) {
    _setPropertyBool("lang", lang);
  }

  Future<String> getLang() async {
    return await _getProperty("lang", "auto");
  }

  void setTheme(int theme) {
    _setPropertyBool("theme", theme);
  }

  Future<int> getTheme() async {
    return await _getProperty("theme", 0);
  }

  void setNextLesson(bool nextLesson) {
    _setPropertyBool("next_lesson", nextLesson);
  }

  Future<bool> getNextLesson() async {
    return await _getProperty("next_lesson", true);
  }

  void setCanSyncOnData(bool canSyncOnData) {
    _setPropertyBool("canSyncOnData", canSyncOnData);
  }

  Future<bool> getCanSyncOnData() async {
    return await _getProperty("canSyncOnData", true);
  }

  void setEvalColor(int eval, Color color) {
    _setPropertyBool("grade_${eval}_color", color.value);
  }

  static const List<Color> COLORS = [
    Colors.red,
    Colors.brown,
    Colors.orange,
    Color.fromARGB(255, 255, 241, 118),
    Colors.green
  ];

  Future<Color> getEvalColor(int eval) async {
    return Color(await _getProperty("grade_${eval}_color", COLORS[eval].value));
  }
}
