import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsViewModel extends ChangeNotifier {
  static const String _kTempUnit = 'temp_unit';
  static const String _kWindUnt = 'wind_unit';
  static const String _kThemeMode = 'theme_mode';
  static const String _kNotifications = 'notifications_enabled';

  String tempUnit = 'C';
  String windUnit = 'm/s';
  String themeMode = 'system';
  bool notificationsEnabled = true;

  SettingsViewModel() {
    loadSettings();
  }

  Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? temp = prefs.getString(_kTempUnit);
    String? wind = prefs.getString(_kWindUnt);
    String? theme = prefs.getString(_kThemeMode);
    bool? notis = prefs.getBool(_kNotifications);

    if (temp != null) {
      tempUnit = temp;
    }

    if (wind != null) {
      windUnit = wind;
    }

    if (theme != null) {
      themeMode = theme;
    }

    if (notis != null) {
      notificationsEnabled = notis;
    }
    notifyListeners();
  }

  Future<void> setTempUnit (String unit) async {
    tempUnit = unit;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kTempUnit, unit);
    notifyListeners();
  }

  Future<void> setWindUnit (String unit) async {
    windUnit = unit;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kWindUnt, unit);
    notifyListeners();
  }

  Future<void> setThemeMode (String mode) async {
    themeMode = mode;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kThemeMode, mode);
    notifyListeners();
  }

  Future<void> setNotificationsEnabled (bool enabled) async {
    notificationsEnabled = enabled;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kNotifications, enabled);
    notifyListeners();
  }

  ThemeMode getThemeMode() {
    if (themeMode == 'light') {
      return ThemeMode.light;
    } else if (themeMode == 'dark') {
      return ThemeMode.dark;
    } else {
      return ThemeMode.system;
    }
  }

  bool get isCelcius {
    return tempUnit == 'C';
  }

  bool get isMS {
    return windUnit == 'm/s';
  }
}