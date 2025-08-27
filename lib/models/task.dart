import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String? id;
  final String routineId;
  final String name;
  final int? durationMinutes;
  final int order;
  final Map<String, bool> isCompleted;

  Task({
    this.id,
    required this.routineId,
    required this.name,
    this.durationMinutes,
    required this.order,
    required this.isCompleted,
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
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'routineId': routineId,
      'name': name,
      if (durationMinutes != null) 'durationMinutes': durationMinutes,
      'order': order,
      'isCompleted': isCompleted,
    };
  }
}
