import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Preferences service for app settings persistence.
class PreferencesService extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  static const String _languageKey = 'preferred_language';
  static const String _showTransliterationKey = 'show_transliteration';
  static const String _fontSizeKey = 'font_size_scale';
  static const String _showSanskritKey = 'show_sanskrit';

  // Defaults
  String _themeMode = 'system'; // 'light', 'dark', 'system'
  String _preferredLanguage = 'english'; // 'hindi', 'english'
  bool _showTransliteration = true;
  double _fontSizeScale = 1.0;
  bool _showSanskrit = true;
  bool _initialized = false;

  String get themeMode => _themeMode;
  String get preferredLanguage => _preferredLanguage;
  bool get showTransliteration => _showTransliteration;
  double get fontSizeScale => _fontSizeScale;
  bool get showSanskrit => _showSanskrit;

  Future<void> init() async {
    if (_initialized) return;
    final prefs = await SharedPreferences.getInstance();
    _themeMode = prefs.getString(_themeKey) ?? 'system';
    _preferredLanguage = prefs.getString(_languageKey) ?? 'english';
    _showTransliteration = prefs.getBool(_showTransliterationKey) ?? true;
    _fontSizeScale = prefs.getDouble(_fontSizeKey) ?? 1.0;
    _showSanskrit = prefs.getBool(_showSanskritKey) ?? true;
    _initialized = true;
    notifyListeners();
  }

  Future<void> setThemeMode(String mode) async {
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode);
  }

  Future<void> setPreferredLanguage(String lang) async {
    _preferredLanguage = lang;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, lang);
  }

  Future<void> setShowTransliteration(bool show) async {
    _showTransliteration = show;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showTransliterationKey, show);
  }

  Future<void> setFontSizeScale(double scale) async {
    _fontSizeScale = scale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fontSizeKey, scale);
  }

  Future<void> setShowSanskrit(bool show) async {
    _showSanskrit = show;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showSanskritKey, show);
  }
}
