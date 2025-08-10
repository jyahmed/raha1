import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  final SharedPreferences prefs;

  SettingsProvider({required this.prefs}) {
    _loadPreferences();
  }

  bool _darkModeEnabled = false;
  String _language = 'ar';
  bool _notificationsEnabled = true;
  bool _autoThemeEnabled = false;
  String _themeMode = 'system'; // 'light', 'dark', 'system'

  bool get darkModeEnabled => _darkModeEnabled;
  String get language => _language;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get autoThemeEnabled => _autoThemeEnabled;
  String get themeMode => _themeMode;

  Future<void> _loadPreferences() async {
    _darkModeEnabled = prefs.getBool('darkMode') ?? false;
    _language = prefs.getString('language') ?? 'ar';
    _notificationsEnabled = prefs.getBool('notifications') ?? true;
    _autoThemeEnabled = prefs.getBool('autoTheme') ?? false;
    _themeMode = prefs.getString('themeMode') ?? 'system';
    notifyListeners();
  }

  Future<void> toggleDarkMode([bool? value]) async {
    if (value != null) {
      _darkModeEnabled = value;
    } else {
      _darkModeEnabled = !_darkModeEnabled;
    }

    // إذا تم تفعيل الوضع الليلي يدوياً، قم بإلغاء الوضع التلقائي
    if (_darkModeEnabled) {
      _themeMode = 'dark';
      _autoThemeEnabled = false;
      await prefs.setBool('autoTheme', false);
      await prefs.setString('themeMode', 'dark');
    } else {
      _themeMode = 'light';
      await prefs.setString('themeMode', 'light');
    }

    await prefs.setBool('darkMode', _darkModeEnabled);
    notifyListeners();
  }

  Future<void> setThemeMode(String mode) async {
    _themeMode = mode;
    await prefs.setString('themeMode', mode);

    if (mode == 'dark') {
      _darkModeEnabled = true;
      _autoThemeEnabled = false;
    } else if (mode == 'light') {
      _darkModeEnabled = false;
      _autoThemeEnabled = false;
    } else if (mode == 'system') {
      _autoThemeEnabled = true;
      // تحديد الوضع بناءً على إعدادات النظام
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      _darkModeEnabled = brightness == Brightness.dark;
    }

    await prefs.setBool('darkMode', _darkModeEnabled);
    await prefs.setBool('autoTheme', _autoThemeEnabled);
    notifyListeners();
  }

  Future<void> toggleAutoTheme(bool value) async {
    _autoThemeEnabled = value;
    await prefs.setBool('autoTheme', value);

    if (value) {
      _themeMode = 'system';
      await prefs.setString('themeMode', 'system');
      // تطبيق الوضع بناءً على إعدادات النظام
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      _darkModeEnabled = brightness == Brightness.dark;
      await prefs.setBool('darkMode', _darkModeEnabled);
    }

    notifyListeners();
  }

  Future<void> changeLanguage(String lang) async {
    _language = lang;
    await prefs.setString('language', lang);
    notifyListeners();
  }

  Future<void> toggleNotifications(bool value) async {
    _notificationsEnabled = value;
    await prefs.setBool('notifications', value);
    notifyListeners();
  }

  // دالة لتحديث الوضع تلقائياً عند تغيير إعدادات النظام
  void updateSystemTheme() {
    if (_autoThemeEnabled) {
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      final newDarkMode = brightness == Brightness.dark;

      if (newDarkMode != _darkModeEnabled) {
        _darkModeEnabled = newDarkMode;
        prefs.setBool('darkMode', _darkModeEnabled);
        notifyListeners();
      }
    }
  }

  // دالة للحصول على ThemeMode المناسب
  ThemeMode getThemeMode() {
    switch (_themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
}
