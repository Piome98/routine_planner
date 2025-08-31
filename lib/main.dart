import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:routine_planner/services/auth_service.dart';
import 'package:routine_planner/screens/auth_wrapper.dart';
import 'package:routine_planner/firebase_options.dart';

import 'package:routine_planner/services/firestore_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<FirestoreService>(create: (_) => FirestoreService()),
      ],
      child: const AuthWrapper(),
    ),
  );
}