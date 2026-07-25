import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final languageProvider = NotifierProvider<LanguageNotifier, Locale>(() {
  return LanguageNotifier();
});

class LanguageNotifier extends Notifier<Locale> {
  static const _langKey = 'selected_language';

  @override
  Locale build() {
    _loadSavedLanguage();
    return const Locale('en'); // Default to English initially
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLang = prefs.getString(_langKey);
    if (savedLang != null) {
      state = Locale(savedLang);
    }
  }

  Future<void> setLanguage(String languageCode) async {
    state = Locale(languageCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, languageCode);
  }

  void toggleLanguage() {
    if (state.languageCode == 'en') {
      setLanguage('ta');
    } else {
      setLanguage('en');
    }
  }
}
