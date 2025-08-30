import 'package:flutter/material.dart';

class AppLocale {
  final String languageCode;
  final String countryCode;
  final String nativeName;
  final String englishName;
  final String flag;

  const AppLocale({
    required this.languageCode,
    required this.countryCode,
    required this.nativeName,
    required this.englishName,
    required this.flag,
  });

  Locale get locale => Locale(languageCode, countryCode);

  static const List<AppLocale> supportedLocales = [
    AppLocale(
      languageCode: 'en',
      countryCode: 'US',
      nativeName: 'English',
      englishName: 'English',
      flag: '🇺🇸',
    ),
    AppLocale(
      languageCode: 'ko',
      countryCode: 'KR',
      nativeName: '한국어',
      englishName: 'Korean',
      flag: '🇰🇷',
    ),
    AppLocale(
      languageCode: 'ja',
      countryCode: 'JP',
      nativeName: '日本語',
      englishName: 'Japanese',
      flag: '🇯🇵',
    ),
    AppLocale(
      languageCode: 'zh',
      countryCode: 'CN',
      nativeName: '中文',
      englishName: 'Chinese (Simplified)',
      flag: '🇨🇳',
    ),
    AppLocale(
      languageCode: 'es',
      countryCode: 'ES',
      nativeName: 'Español',
      englishName: 'Spanish',
      flag: '🇪🇸',
    ),
    AppLocale(
      languageCode: 'fr',
      countryCode: 'FR',
      nativeName: 'Français',
      englishName: 'French',
      flag: '🇫🇷',
    ),
    AppLocale(
      languageCode: 'de',
      countryCode: 'DE',
      nativeName: 'Deutsch',
      englishName: 'German',
      flag: '🇩🇪',
    ),
    AppLocale(
      languageCode: 'pt',
      countryCode: 'BR',
      nativeName: 'Português',
      englishName: 'Portuguese (Brazil)',
      flag: '🇧🇷',
    ),
  ];

  static AppLocale getLocale(String languageCode, String countryCode) {
    return supportedLocales.firstWhere(
      (locale) => 
          locale.languageCode == languageCode && 
          locale.countryCode == countryCode,
      orElse: () => supportedLocales.first,
    );
  }

  static AppLocale getLocaleByCode(String languageCode) {
    return supportedLocales.firstWhere(
      (locale) => locale.languageCode == languageCode,
      orElse: () => supportedLocales.first,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppLocale &&
          runtimeType == other.runtimeType &&
          languageCode == other.languageCode &&
          countryCode == other.countryCode;

  @override
  int get hashCode => languageCode.hashCode ^ countryCode.hashCode;
}