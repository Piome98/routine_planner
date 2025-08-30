timport 'package:flutter/material.dart';

class TaskSpaScreen extends StatefulWidget {
  const TaskSpaScreen({super.key});

  @override
  State<TaskSpaScreen> createState() => _TaskSpaScreenState();
}

class _TaskSpaScreenState extends State<TaskSpaScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt,
              size: 80,
              color: Color(0xFF4F46E5),
            ),
            SizedBox(height: 16),
            Text(
              'Task Management SPA',
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