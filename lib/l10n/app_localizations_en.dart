// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get calendarRoutineTitle => 'Calendar Routine';

  @override
  String get today => 'Today';

  @override
  String get calendarView => 'Calendar View';

  @override
  String get routineList => 'Routine List';

  @override
  String get addEvent => 'Add Event';

  @override
  String get addRoutine => 'Add Routine';

  @override
  String get noEventsForThisDay => 'No events for this day';

  @override
  String eventsFor(Object date) {
    return 'Events for $date';
  }

  @override
  String get noRoutinesYet => 'No Routines Yet';

  @override
  String get createRoutinesToOrganize =>
      'Create routines to organize your daily activities';
}
