import '../Utils/Saver.dart';
import 'dart:convert' show utf8, json;
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
}
