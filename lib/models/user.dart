import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String email;
  final String? displayName;
  final Timestamp createdAt;
  final Timestamp lastLoginAt;

  AppUser({
    required this.uid,
    required this.email,
    this.displayName,
    required this.createdAt,
    required this.lastLoginAt,
  });

  factory AppUser.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();
    return AppUser(
      uid: snapshot.id,
      email: data?['email'],
      displayName: data?['displayName'],
      createdAt: data?['createdAt'],
      lastLoginAt: data?['lastLoginAt'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      if (displayName != null) 'displayName': displayName,
      'createdAt': createdAt,
      'lastLoginAt': lastLoginAt,
    };
  }
}
