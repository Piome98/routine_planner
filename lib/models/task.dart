import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String? id;
  final String routineId;
  final String name;
  final int? durationMinutes;
  final int order;
  final Map<String, bool> isCompleted;
  final String priority; // Added priority field

  Task({
    this.id,
    required this.routineId,
    required this.name,
    this.durationMinutes,
    required this.order,
    required this.isCompleted,
    this.priority = '보통', // Default priority
  });

  factory Task.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();
    return Task(
      id: snapshot.id,
      routineId: data?['routineId'],
      name: data?['name'],
      durationMinutes: data?['durationMinutes'],
      order: data?['order'],
      isCompleted: Map<String, bool>.from(data?['isCompleted'] ?? {}),
      priority: data?['priority'] ?? '보통', // Read priority from Firestore
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'routineId': routineId,
      'name': name,
      if (durationMinutes != null) 'durationMinutes': durationMinutes,
      'order': order,
      'isCompleted': isCompleted,
      'priority': priority, // Write priority to Firestore
    };
  }

  Task copyWith({
    String? id,
    String? routineId,
    String? name,
    int? durationMinutes,
    int? order,
    Map<String, bool>? isCompleted,
    String? priority,
  }) {
    return Task(
      id: id ?? this.id,
      routineId: routineId ?? this.routineId,
      name: name ?? this.name,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      order: order ?? this.order,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
    );
  }
}