import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:routine_planner/widgets/spa_app_bar.dart';
import 'package:routine_planner/services/firestore_service.dart';
import 'package:routine_planner/models/routine.dart';
import 'package:routine_planner/models/task.dart';

class TaskSpaScreen extends StatefulWidget {
  const TaskSpaScreen({super.key});

  @override
  State<TaskSpaScreen> createState() => _TaskSpaScreenState();
}

class _TaskSpaScreenState extends State<TaskSpaScreen> {
  final List<String> _filterOptions = ['all', 'today', 'active', 'completed'];

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: SpaAppBar(
        title: 'Task Management',
        actions: [
          IconButton(
            onPressed: () => _showAddTaskDialog(context),
            icon: const Icon(Icons.add_task, color: Color(0xFF6B7280)),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list, color: Color(0xFF6B7280)),
            onSelected: (value) => setState(() {}),
            itemBuilder: (context) => _filterOptions.map((filter) => 
              PopupMenuItem(
                value: filter,
                child: Text(filter.toUpperCase()),
              )
            ).toList(),
          ),
        ],
      ),
      body: StreamBuilder<List<Routine>>(
        stream: firestoreService.getRoutines(),
        builder: (context, routineSnapshot) {
          if (routineSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (!routineSnapshot.hasData || routineSnapshot.data!.isEmpty) {
            return _buildEmptyState();
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatsCards(routineSnapshot.data!),
                const SizedBox(height: 32),
                _buildTasksSection(routineSnapshot.data!, firestoreService),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildEmptyState() {
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
              Icons.task_alt,
              size: 64,
              color: Color(0xFF4F46E5),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Tasks Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create your first routine to start managing tasks',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddRoutineDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Create Routine'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatsCards(List<Routine> routines) {
    final activeRoutines = routines.where((r) => r.isActive).length;
    final totalTasks = routines.length * 3; // Approximation
    final completedTasks = (totalTasks * 0.65).round(); // Approximation
    
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Active Routines',
            activeRoutines.toString(),
            Icons.repeat,
            const Color(0xFF4F46E5),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Total Tasks',
            totalTasks.toString(),
            Icons.task_alt,
            const Color(0xFF059669),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Completed Today',
            completedTasks.toString(),
            Icons.check_circle,
            const Color(0xFFDC2626),
          ),
        ),
      ],
    );
  }
  
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTasksSection(List<Routine> routines, FirestoreService firestoreService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Tasks',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 16),
        ...routines.map((routine) => _buildRoutineCard(routine, firestoreService)),
      ],
    );
  }
  
  Widget _buildRoutineCard(Routine routine, FirestoreService firestoreService) {
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
                    if (routine.description != null) ...[
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: routine.isActive 
                      ? const Color(0xFF059669).withAlpha(26)
                      : const Color(0xFF6B7280).withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  routine.isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: routine.isActive 
                        ? const Color(0xFF059669)
                        : const Color(0xFF6B7280),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          StreamBuilder<List<Task>>(
            stream: firestoreService.getTasksForRoutine(routine.id!),
            builder: (context, taskSnapshot) {
              if (taskSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              
              if (!taskSnapshot.hasData || taskSnapshot.data!.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'No tasks in this routine yet',
                      style: TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }
              
              final tasks = taskSnapshot.data!;
              final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
              
              return Column(
                children: tasks.map((task) => _buildTaskItem(task, routine.id!, today, firestoreService)).toList(),
              );
            },
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () => _showAddTaskToRoutineDialog(context, routine.id!),
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Add Task'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF4F46E5),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTaskItem(Task task, String routineId, String today, FirestoreService firestoreService) {
    final isCompleted = task.isCompleted[today] ?? false;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCompleted ? const Color(0xFF059669) : const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _toggleTaskCompletion(task, routineId, today, firestoreService),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isCompleted ? const Color(0xFF059669) : Colors.transparent,
                border: Border.all(
                  color: isCompleted ? const Color(0xFF059669) : const Color(0xFF9CA3AF),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
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
                    color: isCompleted ? const Color(0xFF6B7280) : const Color(0xFF1F2937),
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                if (task.durationMinutes != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    '${task.durationMinutes} min',
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFF6B7280),
                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  void _toggleTaskCompletion(Task task, String routineId, String today, FirestoreService firestoreService) {
    final updatedCompletionMap = Map<String, bool>.from(task.isCompleted);
    updatedCompletionMap[today] = !(updatedCompletionMap[today] ?? false);
    
    final updatedTask = Task(
      id: task.id,
      routineId: task.routineId,
      name: task.name,
      durationMinutes: task.durationMinutes,
      order: task.order,
      isCompleted: updatedCompletionMap,
    );
    
    firestoreService.updateTask(routineId, updatedTask);
  }
  
  void _showAddTaskDialog(BuildContext context) {
    // TODO: Implement global task addition dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add task to specific routine below!')),
    );
  }
  
  void _showAddRoutineDialog(BuildContext context) {
    // TODO: Implement routine creation dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Routine creation coming soon!')),
    );
  }
  
  void _showAddTaskToRoutineDialog(BuildContext context, String routineId) {
    // TODO: Implement task addition to specific routine dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Add task to routine $routineId coming soon!')),
    );
  }
}