import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:routine_planner/models/app_locale.dart';
import 'package:routine_planner/models/routine_suggestion_level.dart';

enum PreferredInterface { taskManagement, calendarView }

class UserPreferences {
  final String userId;
  final PreferredInterface preferredInterface;
  final List<String> focusAreas;
  final bool enableNotifications;
  final String timeZone;
  final RoutineSuggestionLevel routineSuggestionLevel;
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
    required this.routineSuggestionLevel,
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
      routineSuggestionLevel: RoutineSuggestionLevel.values.firstWhere(
        (level) => level.value == (data?['routineSuggestionLevel'] ?? 'medium'),
        orElse: () => RoutineSuggestionLevel.medium,
      ),
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
      'routineSuggestionLevel': routineSuggestionLevel.value,
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


  UserPreferences copyWith({
    String? userId,
    PreferredInterface? preferredInterface,
    List<String>? focusAreas,
    bool? enableNotifications,
    String? timeZone,
    RoutineSuggestionLevel? routineSuggestionLevel,
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
      routineSuggestionLevel: routineSuggestionLevel ?? this.routineSuggestionLevel,
      languageCode: languageCode ?? this.languageCode,
      countryCode: countryCode ?? this.countryCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  AppLocale get locale => AppLocale.getLocale(languageCode, countryCode);
}