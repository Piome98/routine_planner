import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String? id;
  final String userId;
  final String title;
  final String? description;
  final Timestamp dateTime;
  final bool isCompleted;
  final String type;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  Event({
    this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.dateTime,
    required this.isCompleted,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Event.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();
    return Event(
      id: snapshot.id,
      userId: data?['userId'],
      title: data?['title'],
      description: data?['description'],
      dateTime: data?['dateTime'],
      isCompleted: data?['isCompleted'] ?? false,
      type: data?['type'],
      createdAt: data?['createdAt'],
      updatedAt: data?['updatedAt'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      if (description != null) 'description': description,
      'dateTime': dateTime,
      'isCompleted': isCompleted,
      'type': type,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
