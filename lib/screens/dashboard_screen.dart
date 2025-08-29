import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:routine_planner/services/auth_service.dart';
import 'package:routine_planner/services/firestore_service.dart';
import 'package:routine_planner/models/routine.dart';
import 'package:routine_planner/models/event.dart';
import 'package:routine_planner/models/task.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final firestoreService = FirestoreService();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Banner
          StreamBuilder<User?>(
            stream: authService.user,
            builder: (context, snapshot) {
              final user = snapshot.data;
              final userName = user?.displayName ?? user?.email?.split('@').first ?? 'User';
              final timeOfDay = _getGreeting();
              
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$timeOfDay, $userName!',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'You have 3 routines scheduled today with 5 tasks to complete.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          
          const SizedBox(height: 24),
          
          // Main Content Grid
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Today's Routines (Left Column)
              Expanded(
                flex: 2,
                child: _buildTodaysRoutines(firestoreService),
              ),
              
              const SizedBox(width: 24),
              
              // Right Column (Events + Stats)
              Expanded(
                child: Column(
                  children: [
                    _buildUpcomingEvents(firestoreService),
                    const SizedBox(height: 24),
                    _buildQuickStats(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTodaysRoutines(FirestoreService firestoreService) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.05).round()),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Today\'s Routines',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF4F46E5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Routines List
          StreamBuilder<List<Routine>>(
            stream: firestoreService.getRoutines(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final routines = snapshot.data!.where((r) => r.isActive).take(3).toList();
                if (routines.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('No active routines found.'),
                  );
                }
                
                return Column(
                  children: routines.asMap().entries.map((entry) {
                    final index = entry.key;
                    final routine = entry.value;
                    return Column(
                      children: [
                        if (index > 0) const Divider(height: 1, color: Color(0xFFE5E7EB)),
                        _buildRoutineCard(routine, firestoreService),
                      ],
                    );
                  }).toList(),
                );
              }
              return const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRoutineCard(Routine routine, FirestoreService firestoreService) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Routine Header
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
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${routine.startTime}${routine.endTime != null ? ' - ${routine.endTime}' : ''} • ${routine.frequency.join(', ')}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Active',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF16A34A),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.more_vert,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Tasks List
          StreamBuilder<List<Task>>(
            stream: firestoreService.getTasksForRoutine(routine.id!),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final tasks = snapshot.data!.take(3).toList();
                return Column(
                  children: tasks.map((task) => _buildTaskItem(task)).toList(),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          
          // Add Task Button
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () => _showAddTaskDialog(context, routine.id!),
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Add Task'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF4F46E5),
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(Task task) {
    final isCompleted = task.isCompleted[DateFormat('yyyy-MM-dd').format(DateTime.now())] ?? false;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              // Toggle completion
            },
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isCompleted ? const Color(0xFF4F46E5) : null,
                border: isCompleted ? null : Border.all(color: const Color(0xFFD1D5DB), width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 12)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1F2937),
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                if (task.durationMinutes != null)
                  Text(
                    '${task.durationMinutes} minutes',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
              ],
            ),
          ),
          Icon(
            Icons.edit_outlined,
            color: Colors.grey.shade400,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingEvents(FirestoreService firestoreService) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.05).round()),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Upcoming Events',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF4F46E5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Events List
          StreamBuilder<List<Event>>(
            stream: firestoreService.getEvents(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final events = snapshot.data!.take(3).toList();
                if (events.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('No upcoming events.'),
                  );
                }
                
                return Column(
                  children: events.asMap().entries.map((entry) {
                    final index = entry.key;
                    final event = entry.value;
                    return Column(
                      children: [
                        if (index > 0) const Divider(height: 1, color: Color(0xFFE5E7EB)),
                        _buildEventItem(event),
                      ],
                    );
                  }).toList(),
                );
              }
              return const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              );
            },
          ),
          
          // Add Event Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFFE5E7EB)),
              ),
            ),
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add Event'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF4F46E5),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventItem(Event event) {
    return Padding(
      padding: const EdgeInsets.all(24),
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
                      event.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MMM dd, HH:mm').format(event.dateTime.toDate()),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.more_vert,
                color: Colors.grey.shade400,
                size: 20,
              ),
            ],
          ),
          if (event.description != null) ...[
            const SizedBox(height: 12),
            Text(
              event.description!,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF4B5563),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getEventTypeColor(event.type).withAlpha((255 * 0.1).round()),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              event.type,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _getEventTypeColor(event.type),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.05).round()),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Stats',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _buildStatCard('Active Routines', '5', const Color(0xFF4F46E5)),
                _buildStatCard('Completed Today', '12', const Color(0xFF10B981)),
                _buildStatCard('Upcoming Events', '3', const Color(0xFF3B82F6)),
                _buildStatCard('Streak', '7 days', const Color(0xFF8B5CF6)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha((255 * 0.1).round()),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  Color _getEventTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'appointment':
        return const Color(0xFF3B82F6);
      case 'deadline':
        return const Color(0xFFEF4444);
      case 'meeting':
        return const Color(0xFF8B5CF6);
      default:
        return const Color(0xFF6B7280);
    }
  }

  void _showAddTaskDialog(BuildContext context, String routineId) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController durationController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Task Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: durationController,
              decoration: const InputDecoration(
                labelText: 'Duration (minutes)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.trim().isEmpty) return;
              
              final firestoreService = FirestoreService();
              final task = Task(
                routineId: routineId,
                name: nameController.text.trim(),
                durationMinutes: int.tryParse(durationController.text),
                order: 0,
                isCompleted: {},
              );
              
              try {
                await firestoreService.addTaskToRoutine(routineId, task);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Task added successfully')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error adding task: $e')),
                );
              }
            },
            child: const Text('Add Task'),
          ),
        ],
      ),
    );
  }
}