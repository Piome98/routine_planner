import 'package:cloud_firestore/cloud_firestore.dart';

class Routine {
  final String? id;
  final String userId;
  final String name;
  final String? description;
  final List<String> frequency;
  final String startTime;
  final String? endTime;
  final bool isActive;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  Routine({
    this.id,
    required this.userId,
    required this.name,
    this.description,
    required this.frequency,
    required this.startTime,
    this.endTime,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Routine.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();
    return Routine(
      id: snapshot.id,
      userId: data?['userId'],
      name: data?['name'],
      description: data?['description'],
      frequency: List<String>.from(data?['frequency'] ?? []),
      startTime: data?['startTime'],
      endTime: data?['endTime'],
      isActive: data?['isActive'] ?? true,
      createdAt: data?['createdAt'],
      updatedAt: data?['updatedAt'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'name': name,
      if (description != null) 'description': description,
      'frequency': frequency,
      'startTime': startTime,
      if (endTime != null) 'endTime': endTime,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory Routine.fromMap(Map<String, dynamic> data) {
    return Routine(
      id: data['id'],
      userId: data['userId'],
      name: data['name'],
      description: data['description'],
      frequency: List<String>.from(data['frequency'] ?? []),
      startTime: data['startTime'],
      endTime: data['endTime'],
      isActive: data['isActive'] ?? true,
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'description': description,
      'frequency': frequency,
      'startTime': startTime,
      'endTime': endTime,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
