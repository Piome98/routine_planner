// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get calendarRoutineTitle => '캘린더 루틴';

  @override
  String get today => '오늘';

  @override
  String get calendarView => '캘린더 보기';

  @override
  String get routineList => '루틴 목록';

  @override
  String get addEvent => '이벤트 추가';

  @override
  String get addRoutine => '루틴 추가';

  @override
  String get noEventsForThisDay => '이 날에는 이벤트가 없습니다';

  @override
  String eventsFor(Object date) {
    return '$date의 이벤트';
  }

  @override
  String get noRoutinesYet => '아직 루틴이 없습니다';

  @override
  String get createRoutinesToOrganize => '루틴을 만들어 일상 활동을 정리하세요';
}
