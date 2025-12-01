import 'package:flutter/material.dart';

class AppSettings extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  String _language = 'zh_TW'; // 'zh_TW' or 'en'

  ThemeMode get themeMode => _themeMode;
  String get language => _language;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setLanguage(String lang) {
    _language = lang;
    notifyListeners();
  }

  String getThemeModeText() {
    switch (_themeMode) {
      case ThemeMode.light:
        return _language == 'zh_TW' ? '淺色' : 'Light';
      case ThemeMode.dark:
        return _language == 'zh_TW' ? '深色' : 'Dark';
      case ThemeMode.system:
        return _language == 'zh_TW' ? '跟隨系統' : 'Follow System';
    }
  }

  String getCurrentLanguageText() {
    return _language == 'zh_TW' ? '繁體中文' : 'English';
  }
}
