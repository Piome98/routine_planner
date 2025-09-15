import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:routine_planner/l10n/app_localizations.dart';
import 'package:routine_planner/screens/login_screen.dart';
import 'package:routine_planner/screens/signup_screen.dart';
import 'package:routine_planner/screens/onboarding_screen.dart';
import 'package:routine_planner/screens/main_layout.dart';
import 'package:routine_planner/models/user_preferences.dart';
import 'package:routine_planner/services/auth_service.dart';

// This widget decides which screen to show based on the authentication state.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (_, AsyncSnapshot<User?> userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final User? user = userSnapshot.data;
        if (user == null) {
          // User not logged in. Build MaterialApp for Auth pages.
          return MaterialApp(
            title: 'Routine Planner',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              useMaterial3: true,
              fontFamily: 'NotoSans',
            ),
            home: const AuthPage(),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
          );
        } else {
          // User is logged in. Fetch preferences and build MaterialApp.
          return StreamBuilder<UserPreferences?>(
            stream: _getUserPreferencesStream(user.uid),
            builder: (context, prefSnapshot) {
              Widget home;
              Locale? locale;

              if (prefSnapshot.connectionState == ConnectionState.waiting) {
                home = const Scaffold(body: Center(child: CircularProgressIndicator()));
              } else {
                final preferences = prefSnapshot.data;
                if (preferences == null) {
                  home = const OnboardingScreen();
                  // Default to English if no prefs
                  locale = const Locale('en', 'US');
                } else {
                  home = const MainLayout();
                  locale = Locale(preferences.languageCode, preferences.countryCode);
                }
              }

              // Build the main MaterialApp
              return MaterialApp(
                title: 'Routine Planner',
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
                  useMaterial3: true,
                  fontFamily: 'NotoSans',
                ),
                locale: locale,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                home: home,
              );
            },
          );
        }
      },
    );
  }

  Stream<UserPreferences?> _getUserPreferencesStream(String uid) {
    try {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('preferences')
          .doc('main')
          .snapshots()
          .map((doc) {
        if (doc.exists) {
          return UserPreferences.fromFirestore(doc, null);
        }
        return null;
      });
    } catch (e) {
      debugPrint('Error fetching user preferences: $e');
      return Stream.value(null);
    }
  }
}

// This widget handles toggling between login and register pages
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

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