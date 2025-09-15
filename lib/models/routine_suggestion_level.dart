import 'package:flutter/material.dart';

enum RoutineSuggestionLevel {
  none,
  low,
  medium,
  high,
}

extension RoutineSuggestionLevelExtension on RoutineSuggestionLevel {
  String get displayName {
    switch (this) {
      case RoutineSuggestionLevel.none:
        return '제안하지 않음';
      case RoutineSuggestionLevel.low:
        return '하';
      case RoutineSuggestionLevel.medium:
        return '중';
      case RoutineSuggestionLevel.high:
        return '상';
    }
  }

  String get description {
    switch (this) {
      case RoutineSuggestionLevel.none:
        return '루틴 제안을 받지 않습니다';
      case RoutineSuggestionLevel.low:
        return '가끔씩 간단한 루틴을 제안받습니다';
      case RoutineSuggestionLevel.medium:
        return '적절한 빈도로 루틴을 제안받습니다';
      case RoutineSuggestionLevel.high:
        return '적극적으로 다양한 루틴을 제안받습니다';
    }
  }

  IconData get icon {
    switch (this) {
      case RoutineSuggestionLevel.none:
        return Icons.notifications_off;
      case RoutineSuggestionLevel.low:
        return Icons.notifications_none;
      case RoutineSuggestionLevel.medium:
        return Icons.notifications;
      case RoutineSuggestionLevel.high:
        return Icons.notifications_active;
    }
  }

  Color get color {
    switch (this) {
      case RoutineSuggestionLevel.none:
        return Colors.grey;
      case RoutineSuggestionLevel.low:
        return Colors.blue;
      case RoutineSuggestionLevel.medium:
        return Colors.orange;
      case RoutineSuggestionLevel.high:
        return Colors.red;
    }
  }

  String get value => toString().split('.').last;

  static RoutineSuggestionLevel fromValue(String value) {
    return RoutineSuggestionLevel.values.firstWhere(
      (level) => level.value == value,
      orElse: () => RoutineSuggestionLevel.medium,
    );
  }
}