import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:locale_chat/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeneralChangeNotifier extends ChangeNotifier {
  Map<String, dynamic> _languageMap = {};
  Locale _currentLocale = const Locale('en');

  Map<String, dynamic> get languageMap => _languageMap;
  Locale get currentLocale => _currentLocale;

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  GeneralChangeNotifier() {
    _loadLanguage();
    _loadThemeMode();
  }

  Future<void> _loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguageCode = prefs.getString('selectedLanguage');

      if (savedLanguageCode != null) {
        await _loadLanguageFile(savedLanguageCode);
      } else {
        final String languageCode =
            PlatformDispatcher.instance.locale.languageCode;
        await _loadLanguageFile(languageCode);
      }
    } catch (e) {
      print('Dil yüklenirken hata: $e');
      await _loadLanguageFile('en'); // Varsayılan olarak İngilizce
    }
  }

  // Dil dosyasını yükleme
  Future<void> _loadLanguageFile(String languageCode) async {
    try {
      final jsonString =
          await rootBundle.loadString('assets/languages/$languageCode.json');
      _languageMap = json.decode(jsonString);
      _currentLocale = Locale(languageCode);
      notifyListeners();
    } catch (e) {
      print('Dil dosyası yüklenirken hata: $e');
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    if (_currentLocale.languageCode != languageCode) {
      await _loadLanguageFile(languageCode);
      // Save the selected language
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedLanguage', languageCode);
      notifyListeners();
    }
  }

  // Çeviri getir
  String translate(String key) {
    try {
      // Nokta notasyonu ile iç içe değerlere erişim (örn: "home.title")
      final keys = key.split('.');
      dynamic value = _languageMap;

      for (var k in keys) {
        value = value[k];
      }

      return value?.toString() ?? key;
    } catch (e) {
      print('Çeviri bulunamadı: $key');
      return key;
    }
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    updateThemeColors(_isDarkMode);
    notifyListeners();
  }

  Future<void> toggleThemeMode() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    updateThemeColors(_isDarkMode);
    notifyListeners();
  }
}
