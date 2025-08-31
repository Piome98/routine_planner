import 'package:flutter/material.dart';

enum AppThemeType { 
  indigo, 
  emerald, 
  rose, 
  amber, 
  purple, 
  blue 
}

class AppTheme {
  final AppThemeType type;
  final String name;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color backgroundColor;
  final Color surfaceColor;
  final Color textColor;
  final Color secondaryTextColor;

  const AppTheme({
    required this.type,
    required this.name,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.backgroundColor,
    required this.surfaceColor,
    required this.textColor,
    required this.secondaryTextColor,
  });

  static const Map<AppThemeType, AppTheme> themes = {
    AppThemeType.indigo: AppTheme(
      type: AppThemeType.indigo,
      name: 'Indigo',
      primaryColor: Color(0xFF4F46E5),
      secondaryColor: Color(0xFF7C3AED),
      accentColor: Color(0xFFEDE9FE),
      backgroundColor: Color(0xFFF9FAFB),
      surfaceColor: Colors.white,
      textColor: Color(0xFF1F2937),
      secondaryTextColor: Color(0xFF6B7280),
    ),
    AppThemeType.emerald: AppTheme(
      type: AppThemeType.emerald,
      name: 'Emerald',
      primaryColor: Color(0xFF10B981),
      secondaryColor: Color(0xFF059669),
      accentColor: Color(0xFFD1FAE5),
      backgroundColor: Color(0xFFF0FDF4),
      surfaceColor: Colors.white,
      textColor: Color(0xFF1F2937),
      secondaryTextColor: Color(0xFF6B7280),
    ),
    AppThemeType.rose: AppTheme(
      type: AppThemeType.rose,
      name: 'Rose',
      primaryColor: Color(0xFFE11D48),
      secondaryColor: Color(0xFFBE185D),
      accentColor: Color(0xFFFFE4E6),
      backgroundColor: Color(0xFFFFF1F2),
      surfaceColor: Colors.white,
      textColor: Color(0xFF1F2937),
      secondaryTextColor: Color(0xFF6B7280),
    ),
    AppThemeType.amber: AppTheme(
      type: AppThemeType.amber,
      name: 'Amber',
      primaryColor: Color(0xFFD97706),
      secondaryColor: Color(0xFFB45309),
      accentColor: Color(0xFFFEF3C7),
      backgroundColor: Color(0xFFFFFBEB),
      surfaceColor: Colors.white,
      textColor: Color(0xFF1F2937),
      secondaryTextColor: Color(0xFF6B7280),
    ),
    AppThemeType.purple: AppTheme(
      type: AppThemeType.purple,
      name: 'Purple',
      primaryColor: Color(0xFF8B5CF6),
      secondaryColor: Color(0xFF7C3AED),
      accentColor: Color(0xFFF3E8FF),
      backgroundColor: Color(0xFFFAF5FF),
      surfaceColor: Colors.white,
      textColor: Color(0xFF1F2937),
      secondaryTextColor: Color(0xFF6B7280),
    ),
    AppThemeType.blue: AppTheme(
      type: AppThemeType.blue,
      name: 'Blue',
      primaryColor: Color(0xFF3B82F6),
      secondaryColor: Color(0xFF1D4ED8),
      accentColor: Color(0xFFDDEAFE),
      backgroundColor: Color(0xFFEFF6FF),
      surfaceColor: Colors.white,
      textColor: Color(0xFF1F2937),
      secondaryTextColor: Color(0xFF6B7280),
    ),
  };

  ThemeData toThemeData() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,

      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: textColor,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
      scaffoldBackgroundColor: backgroundColor,
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  static AppTheme getTheme(AppThemeType type) {
    return themes[type] ?? themes[AppThemeType.indigo]!;
  }

  static List<AppTheme> getAllThemes() {
    return themes.values.toList();
  }
}