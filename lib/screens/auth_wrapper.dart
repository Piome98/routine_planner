import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routine_planner/screens/login_screen.dart';
import 'package:routine_planner/screens/signup_screen.dart';
import 'package:routine_planner/screens/main_layout.dart';
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
            // User is logged in, show main layout with dashboard
            return const MainLayout();
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

