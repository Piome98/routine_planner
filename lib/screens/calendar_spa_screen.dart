import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:routine_planner/widgets/spa_app_bar.dart';
import 'package:routine_planner/services/firestore_service.dart';
import 'package:routine_planner/models/event.dart';
import 'package:routine_planner/models/routine.dart';
import 'package:routine_planner/l10n/app_localizations.dart';

class CalendarSpaScreen extends StatefulWidget {
  const CalendarSpaScreen({super.key});

  @override
  State<CalendarSpaScreen> createState() => _CalendarSpaScreenState();
}

class _CalendarSpaScreenState extends State<CalendarSpaScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String _currentView = 'calendar'; // 'calendar' or 'routines'

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: SpaAppBar(
        title: l10n.calendarRoutineTitle,
        actions: [
          IconButton(
            onPressed: () => setState(() => _focusedDay = DateTime.now()),
            icon: const Icon(Icons.today, color: Color(0xFF6B7280)),
            tooltip: l10n.today,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.view_module, color: Color(0xFF6B7280)),
            onSelected: (value) => setState(() => _currentView = value),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'calendar',
                child: Row(
                  children: [
                    const Icon(Icons.calendar_view_month, size: 18),
                    const SizedBox(width: 8),
                    Text(l10n.calendarView),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'routines',
                child: Row(
                  children: [
                    const Icon(Icons.list, size: 18),
                    const SizedBox(width: 8),
                    Text(l10n.routineList),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _currentView == 'calendar'
          ? _buildCalendarView(firestoreService)
          : _buildRoutineListView(firestoreService),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context),
        backgroundColor: const Color(0xFF4F46E5),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(_currentView == 'calendar' ? l10n.addEvent : l10n.addRoutine),
      ),
    );
  }

  Widget _buildCalendarView(FirestoreService firestoreService) {
    return StreamBuilder<List<Event>>(
      stream: firestoreService.getEvents(),
      builder: (context, eventSnapshot) {
        if (eventSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final events = eventSnapshot.data ?? [];
        final eventsByDay = <DateTime, List<Event>>{};

        for (final event in events) {
          final day = DateTime(
            event.dateTime.toDate().year,
            event.dateTime.toDate().month,
            event.dateTime.toDate().day,
          );
          eventsByDay[day] = (eventsByDay[day] ?? [])..add(event);
        }

        List<Event> getEventsForDay(DateTime day) {
          return eventsByDay[DateTime(day.year, day.month, day.day)] ?? [];
        }

        return Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(13),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TableCalendar<Event>(
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onFormatChanged: (format) {
                  setState(() => _calendarFormat = format);
                },
                onPageChanged: (focusedDay) {
                  setState(() => _focusedDay = focusedDay);
                },
                eventLoader: getEventsForDay,
                calendarStyle: const CalendarStyle(
                  outsideDaysVisible: false,
                  weekendTextStyle: TextStyle(color: Color(0xFF4F46E5)),
                  holidayTextStyle: TextStyle(color: Color(0xFFDC2626)),
                  selectedDecoration: BoxDecoration(
                    color: Color(0xFF4F46E5),
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Color(0xFF059669),
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: BoxDecoration(
                    color: Color(0xFFDC2626),
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
            ),
            Expanded(
              child: _buildEventsList(getEventsForDay(_selectedDay ?? _focusedDay)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEventsList(List<Event> events) {
    final l10n = AppLocalizations.of(context)!;
    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFEDE9FE),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.event_note,
                size: 48,
                color: Color(0xFF4F46E5),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noEventsForThisDay,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              l10n.eventsFor(DateFormat('MMM dd, yyyy').format(_selectedDay ?? _focusedDay)),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return _buildEventCard(event);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(Event event) {
    final eventDate = event.dateTime.toDate();
    final timeStr = DateFormat('HH:mm').format(eventDate);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getEventTypeColor(event.type).withAlpha(51)),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: _getEventTypeColor(event.type),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getEventTypeColor(event.type).withAlpha(26),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        event.type.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: _getEventTypeColor(event.type),
                        ),
                      ),
                    ),
                  ],
                ),
                if (event.description != null && event.description!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    event.description!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  timeStr,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4F46E5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutineListView(FirestoreService firestoreService) {
    return StreamBuilder<List<Routine>>(
      stream: firestoreService.getRoutines(),
      builder: (context, routineSnapshot) {
        if (routineSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!routineSnapshot.hasData || routineSnapshot.data!.isEmpty) {
          return _buildEmptyRoutineState();
        }

        final routines = routineSnapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: routines.length,
          itemBuilder: (context, index) {
            final routine = routines[index];
            return _buildRoutineCard(routine);
          },
        );
      },
    );
  }

  Widget _buildEmptyRoutineState() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFEDE9FE),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.repeat,
              size: 64,
              color: Color(0xFF4F46E5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.noRoutinesYet,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.createRoutinesToOrganize,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRoutineCard(Routine routine) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      routine.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    if (routine.description != null && routine.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        routine.description!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Switch(
                value: routine.isActive,
                onChanged: (value) => _toggleRoutineActive(routine, value),
                activeColor: const Color(0xFF059669),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.schedule,
                size: 16,
                color: const Color(0xFF6B7280),
              ),
              const SizedBox(width: 4),
              Text(
                '${routine.startTime}${routine.endTime != null ? ' - ${routine.endTime}' : ''}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: routine.frequency.map((freq) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF4F46E5).withAlpha(26),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                freq,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4F46E5),
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Color _getEventTypeColor(String type) {
    switch (type) {
      case 'personal':
        return const Color(0xFF4F46E5);
      case 'work':
        return const Color(0xFFDC2626);
      case 'health':
        return const Color(0xFF059669);
      case 'social':
        return const Color(0xFFF59E0B);
      case 'education':
        return const Color(0xFF7C3AED);
      case 'other':
        return const Color(0xFF6B7280);
      default:
        return const Color(0xFF6B7280);
    }
  }

  void _toggleRoutineActive(Routine routine, bool isActive) {
    // TODO: Implement routine active state toggle
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Toggle routine ${routine.name} to ${isActive ? "active" : "inactive"}')),
    );
  }

  void _showAddDialog(BuildContext context) {
    // TODO: Implement add dialog based on current view
    final l10n = AppLocalizations.of(context)!;
    final message = _currentView == 'calendar' ? l10n.addEvent : l10n.addRoutine;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$message dialog coming soon!')),
    );
  }
}
