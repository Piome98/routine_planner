import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:routine_planner/models/routine.dart';

class RoutineSet {
  final String? id;
  final String name;
  final List<Routine> routines;

  RoutineSet({
    this.id,
    required this.name,
    required this.routines,
  });

  factory RoutineSet.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return RoutineSet(
      id: snapshot.id,
      name: data?['name'],
      routines: (data?['routines'] as List<dynamic>)
          .map((routine) => Routine.fromMap(routine))
          .toList(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'routines': routines.map((routine) => routine.toMap()).toList(),
    };
  }
}
