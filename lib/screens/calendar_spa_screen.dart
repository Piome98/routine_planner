import 'package:flutter/material.dart';

class CalendarSpaScreen extends StatefulWidget {
  const CalendarSpaScreen({super.key});

  @override
  State<CalendarSpaScreen> createState() => _CalendarSpaScreenState();
}

class _CalendarSpaScreenState extends State<CalendarSpaScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today,
              size: 80,
              color: Color(0xFF3B82F6),
            ),
            SizedBox(height: 16),
            Text(
              'Calendar Routine Management SPA',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Coming soon...',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}