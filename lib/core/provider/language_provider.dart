import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = Locale('en');

  Locale get locale => _locale;

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('language_code');

    if (languageCode == null) {
      languageCode = WidgetsBinding.instance.window.locale.languageCode;
      await prefs.setString('language_code', languageCode);
    }
    print(languageCode);
    _locale = Locale(languageCode);
    notifyListeners();
  }

  Future<void> changeLanguage(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    print("change");
    _locale = locale;
    notifyListeners();
  }
}
