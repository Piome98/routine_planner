import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:routine_planner/models/app_theme.dart';
import 'package:routine_planner/models/app_locale.dart';

enum PreferredInterface { taskManagement, calendarView }

class UserPreferences {
  final String userId;
  final PreferredInterface preferredInterface;
  final List<String> focusAreas;
  final bool enableNotifications;
  final String timeZone;
  final AppThemeType selectedTheme;
  final String languageCode;
  final String countryCode;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  UserPreferences({
    required this.userId,
    required this.preferredInterface,
    required this.focusAreas,
    required this.enableNotifications,
    required this.timeZone,
    required this.selectedTheme,
    required this.languageCode,
    required this.countryCode,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserPreferences.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();
    return UserPreferences(
      userId: data?['userId'] ?? '',
      preferredInterface: _parsePreferredInterface(data?['preferredInterface']),
      focusAreas: List<String>.from(data?['focusAreas'] ?? []),
      enableNotifications: data?['enableNotifications'] ?? true,
      timeZone: data?['timeZone'] ?? 'UTC',
      selectedTheme: _parseThemeType(data?['selectedTheme']),
      languageCode: data?['languageCode'] ?? 'en',
      countryCode: data?['countryCode'] ?? 'US',
      createdAt: data?['createdAt'] ?? Timestamp.now(),
      updatedAt: data?['updatedAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'preferredInterface': preferredInterface.name,
      'focusAreas': focusAreas,
      'enableNotifications': enableNotifications,
      'timeZone': timeZone,
      'selectedTheme': selectedTheme.name,
      'languageCode': languageCode,
      'countryCode': countryCode,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  static PreferredInterface _parsePreferredInterface(String? value) {
    switch (value) {
      case 'taskManagement':
        return PreferredInterface.taskManagement;
      case 'calendarView':
        return PreferredInterface.calendarView;
      default:
        return PreferredInterface.taskManagement;
    }
  }

  static AppThemeType _parseThemeType(String? value) {
    switch (value) {
      case 'indigo':
        return AppThemeType.indigo;
      case 'emerald':
        return AppThemeType.emerald;
      case 'rose':
        return AppThemeType.rose;
      case 'amber':
        return AppThemeType.amber;
      case 'purple':
        return AppThemeType.purple;
      case 'blue':
        return AppThemeType.blue;
      default:
        return AppThemeType.indigo;
    }
  }

  UserPreferences copyWith({
    String? userId,
    PreferredInterface? preferredInterface,
    List<String>? focusAreas,
    bool? enableNotifications,
    String? timeZone,
    AppThemeType? selectedTheme,
    String? languageCode,
    String? countryCode,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return UserPreferences(
      userId: userId ?? this.userId,
      preferredInterface: preferredInterface ?? this.preferredInterface,
      focusAreas: focusAreas ?? this.focusAreas,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      timeZone: timeZone ?? this.timeZone,
      selectedTheme: selectedTheme ?? this.selectedTheme,
      languageCode: languageCode ?? this.languageCode,
      countryCode: countryCode ?? this.countryCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  AppLocale get locale => AppLocale.getLocale(languageCode, countryCode);
  AppTheme get theme => AppTheme.getTheme(selectedTheme);
}