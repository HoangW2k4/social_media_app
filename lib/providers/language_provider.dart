import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('vi');

  Locale get locale => _locale;

  bool get isVietnamese => _locale.languageCode == 'vi';

  void toggleLanguage() {
    _locale = _locale.languageCode == 'vi'
        ? const Locale('en')
        : const Locale('vi');
    notifyListeners();
  }

  void setLocale(Locale locale) {
    if (!['en', 'vi'].contains(locale.languageCode)) return;
    _locale = locale;
    notifyListeners();
  }
}
