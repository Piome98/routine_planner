import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:routine_planner/screens/login_screen.dart';
import 'package:routine_planner/screens/signup_screen.dart';
import 'package:routine_planner/screens/onboarding_screen.dart';
import 'package:routine_planner/screens/task_spa_screen.dart';
import 'package:routine_planner/screens/calendar_spa_screen.dart';
import 'package:routine_planner/models/user_preferences.dart';
import 'package:routine_planner/services/auth_service.dart';

// This widget decides which screen to show based on the authentication state.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key}); // Use super.key

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (_, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            // User is not logged in, show authentication screens
            return const AuthPage();
          } else {
            // User is logged in, check preferences and route accordingly
            return FutureBuilder<UserPreferences?>(
              future: _getUserPreferences(user.uid),
              builder: (context, prefSnapshot) {
                if (prefSnapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                
                final preferences = prefSnapshot.data;
                if (preferences == null) {
                  // No preferences found, show onboarding
                  return const OnboardingScreen();
                } else {
                  // Preferences exist, route to preferred SPA
                  return preferences.preferredInterface == PreferredInterface.taskManagement
                      ? const TaskSpaScreen()
                      : const CalendarSpaScreen();
                }
              },
            );
          }
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Future<UserPreferences?> _getUserPreferences(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('preferences')
          .doc('main')
          .get();
      
      if (doc.exists) {
        return UserPreferences.fromFirestore(doc, null);
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching user preferences: $e');
      return null;
    }
  }
}

// This widget handles toggling between login and register pages
class AuthPage extends StatefulWidget {
  const AuthPage({super.key}); // Use super.key

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = true;

  void toggleScreens() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginScreen(showRegisterPage: toggleScreens);
    } else {
      return SignUpScreen(showLoginPage: toggleScreens);
    }
  }
}

