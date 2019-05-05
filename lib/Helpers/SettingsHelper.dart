import '../Utils/Saver.dart';
import 'dart:convert' show utf8, json;
import '../globals.dart';
import 'dart:async';

class SettingsHelper {
  Future<Map<String, dynamic>> _getSettings() async {
    Map<String, dynamic> settings = new Map();
    settings = await readSettings();
    return settings;
  }

  void _setSettings(Map<String, dynamic> settings) {
    saveSettings(json.encode(settings));
  }

  void _setPropertyBool(String name, dynamic value) async {
    Map<String, dynamic> settings = new Map();
    settings.addAll(await _getSettings());
    settings[name] = value;
    _setSettings(settings);
  }

  dynamic _getProperty(String name, dynamic defaultValue) async {
    Map<String, dynamic> settings = await _getSettings();
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

  void setCanSyncOnData(bool canSyncOnData) {
    _setPropertyBool("canSyncOnData", canSyncOnData);
  }

  Future<bool> getCanSyncOnData() async {
    return await _getProperty("canSyncOnData", true);
  }
}
