import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:routine_planner/models/event.dart';
import 'package:routine_planner/models/routine.dart';
import 'package:routine_planner/models/routine_set.dart';
import 'package:routine_planner/models/task.dart';
import 'package:routine_planner/models/user.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // --- User Operations ---
  Future<void> addUser(AppUser user) async {
    await _db.collection('users').doc(user.uid).set(user.toFirestore());
  }

  Future<AppUser?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      return AppUser.fromFirestore(doc, null);
    }
    return null;
  }

  Future<void> updateUserLastLogin(String uid) async {
    await _db.collection('users').doc(uid).update({'lastLoginAt': Timestamp.now()});
  }

  // --- Routine Set Operations ---
  Future<void> addRoutineSet(RoutineSet routineSet) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _db.collection('users').doc(user.uid).collection('routine_sets').add(routineSet.toFirestore());
  }

  Stream<List<RoutineSet>> getRoutineSets() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);
    return _db.collection('users').doc(user.uid).collection('routine_sets').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => RoutineSet.fromFirestore(doc, null)).toList());
  }

  // --- Routine Operations ---
  Future<void> addRoutine(Routine routine) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _db.collection('users').doc(user.uid).collection('routines').add(routine.toFirestore());
  }

  Stream<List<Routine>> getRoutines() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);
    return _db.collection('users').doc(user.uid).collection('routines').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Routine.fromFirestore(doc, null)).toList());
  }

  Future<void> updateRoutine(Routine routine) async {
    final user = _auth.currentUser;
    if (user == null || routine.id == null) return;
    await _db.collection('users').doc(user.uid).collection('routines').doc(routine.id).update(routine.toFirestore());
  }

  Future<void> deleteRoutine(String routineId) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _db.collection('users').doc(user.uid).collection('routines').doc(routineId).delete();
  }

  // --- Task Operations (Subcollection of Routine) ---
  Future<void> addTaskToRoutine(String routineId, Task task) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _db.collection('users').doc(user.uid).collection('routines').doc(routineId).collection('tasks').add(task.toFirestore());
  }

  Stream<List<Task>> getTasksForRoutine(String routineId) {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);
    return _db.collection('users').doc(user.uid).collection('routines').doc(routineId).collection('tasks').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Task.fromFirestore(doc, null)).toList());
  }

  Future<void> updateTask(String routineId, Task task) async {
    final user = _auth.currentUser;
    if (user == null || task.id == null) return;
    await _db.collection('users').doc(user.uid).collection('routines').doc(routineId).collection('tasks').doc(task.id).update(task.toFirestore());
  }

  Future<void> deleteTask(String routineId, String taskId) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _db.collection('users').doc(user.uid).collection('routines').doc(routineId).collection('tasks').doc(taskId).delete();
  }

  // --- Event Operations ---
  Future<void> addEvent(Event event) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _db.collection('users').doc(user.uid).collection('events').add(event.toFirestore());
  }

  Stream<List<Event>> getEvents() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);
    return _db.collection('users').doc(user.uid).collection('events').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Event.fromFirestore(doc, null)).toList());
  }

  Future<void> updateEvent(Event event) async {
    final user = _auth.currentUser;
    if (user == null || event.id == null) return;
    await _db.collection('users').doc(user.uid).collection('events').doc(event.id).update(event.toFirestore());
  }

  Future<void> deleteEvent(String eventId) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _db.collection('users').doc(user.uid).collection('events').doc(eventId).delete();
  }
}
