import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:routine_planner/models/event.dart';
import 'package:routine_planner/models/routine.dart';
import 'package:routine_planner/models/routine_set.dart';
import 'package:routine_planner/models/task.dart';
import 'package:routine_planner/models/user.dart';
import 'package:routine_planner/models/challenge.dart';
import 'package:routine_planner/models/store_item.dart';

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

  // New method to get all tasks for the current user
  Stream<List<Task>> getAllTasksForCurrentUser() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _db.collection('users').doc(user.uid).collection('routines').snapshots().asyncMap((routineSnapshot) async {
      final allTasks = <Task>[];
      for (final routineDoc in routineSnapshot.docs) {
        final tasksSnapshot = await _db.collection('users').doc(user.uid).collection('routines').doc(routineDoc.id).collection('tasks').get();
        allTasks.addAll(tasksSnapshot.docs.map((doc) => Task.fromFirestore(doc, null)).toList());
      }
      return allTasks;
    });
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

  // --- Challenge Operations ---
  Future<void> addChallenge(ChallengeData challenge) async {
    await _db.collection('challenges').add(challenge.toFirestore());
  }

  Stream<List<ChallengeData>> getChallenges() {
    return _db.collection('challenges')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChallengeData.fromFirestore(doc, null))
            .toList());
  }

  Future<ChallengeData?> getChallenge(String challengeId) async {
    final doc = await _db.collection('challenges').doc(challengeId).get();
    if (doc.exists) {
      return ChallengeData.fromFirestore(doc, null);
    }
    return null;
  }

  Future<void> updateChallenge(ChallengeData challenge) async {
    if (challenge.id.isEmpty) return;
    await _db.collection('challenges').doc(challenge.id).update(challenge.toFirestore());
  }

  // --- Leaderboard Operations ---
  Stream<List<LeaderboardUser>> getLeaderboard({int limit = 10}) {
    return _db.collection('leaderboard')
        .orderBy('points', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => LeaderboardUser.fromFirestore(doc, null))
            .toList());
  }

  Future<void> updateUserPoints(String userId, int points) async {
    final userRef = _db.collection('leaderboard').doc(userId);
    final userDoc = await userRef.get();
    
    if (userDoc.exists) {
      await userRef.update({'points': FieldValue.increment(points)});
    } else {
      final user = await getUser(userId);
      if (user != null) {
        await userRef.set({
          'name': user.displayName ?? 'Anonymous',
          'points': points,
          'completedChallenges': 0,
          'avatar': user.displayName?.substring(0, 2).toUpperCase() ?? 'AN',
          'colorValue': Colors.blue.value,
          'rank': 0,
        });
      }
    }
  }

  // --- Store Operations ---
  Future<void> addStoreItem(StoreItem item) async {
    await _db.collection('store_items').add(item.toFirestore());
  }

  Stream<List<StoreItem>> getStoreItems() {
    return _db.collection('store_items')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => StoreItem.fromFirestore(doc, null))
            .toList());
  }

  Future<void> updateStoreItem(StoreItem item) async {
    if (item.id.isEmpty) return;
    await _db.collection('store_items').doc(item.id).update(item.toFirestore());
  }

  // --- User Points Operations ---
  Future<int> getUserPoints() async {
    final user = _auth.currentUser;
    if (user == null) return 0;
    
    final doc = await _db.collection('users').doc(user.uid).get();
    if (doc.exists) {
      return doc.data()?['points'] ?? 0;
    }
    return 0;
  }

  Future<void> addUserPoints(int points) async {
    final user = _auth.currentUser;
    if (user == null) return;
    
    await _db.collection('users').doc(user.uid).update({
      'points': FieldValue.increment(points),
    });
    
    // Update leaderboard as well
    await updateUserPoints(user.uid, points);
  }
}
