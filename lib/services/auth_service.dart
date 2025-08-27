import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:routine_planner/models/user.dart';
import 'package:routine_planner/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Keep this import for Timestamp

import 'package:flutter/foundation.dart'; // Import for debugPrint

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get current user stream
  Stream<User?> get user => _auth.authStateChanges();

  // Register with email and password
  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      if (user != null) {
        // Create a new user document in Firestore
        AppUser newUser = AppUser(
          uid: user.uid,
          email: user.email ?? email, // Use provided email as fallback
          createdAt: Timestamp.now(),
          lastLoginAt: Timestamp.now(),
        );
        await _firestoreService.addUser(newUser);
      }
      return user;
    } catch (e) {
      debugPrint('AuthService register error: $e'); // Use debugPrint
      return null;
    }
  }

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      if (user != null) {
        // Update last login time using the new method
        await _firestoreService.updateUserLastLogin(user.uid);
      }
      return user;
    } catch (e) {
      debugPrint('AuthService sign-in error: $e'); // Use debugPrint
      return null;
    }
  }

  // Sign in with Google
  Future<User?> signInWithGoogle() async {
    try {
      // Trigger Google Sign In authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // User cancelled the sign-in
        return null;
      }

      // Obtain auth details from request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with Google credentials
      UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;

      if (user != null) {
        // Check if user exists in Firestore, if not create new user document
        final existingUser = await _firestoreService.getUser(user.uid);
        if (existingUser == null) {
          AppUser newUser = AppUser(
            uid: user.uid,
            email: user.email ?? 'no-email-${user.uid}@example.com',
            displayName: user.displayName,
            createdAt: Timestamp.now(),
            lastLoginAt: Timestamp.now(),
          );
          await _firestoreService.addUser(newUser);
        } else {
          // Update last login time
          await _firestoreService.updateUserLastLogin(user.uid);
        }
      }

      return user;
    } catch (e) {
      debugPrint('AuthService Google sign-in error: $e');
      return null;
    }
  }

  // Sign in with Facebook
  Future<User?> signInWithFacebook() async {
    try {
      // Trigger Facebook authentication flow
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        // Create a credential from the access token
        final OAuthCredential facebookAuthCredential = 
            FacebookAuthProvider.credential(result.accessToken!.tokenString);

        // Sign in to Firebase with Facebook credentials
        UserCredential userCredential = 
            await _auth.signInWithCredential(facebookAuthCredential);
        User? user = userCredential.user;

        if (user != null) {
          // Check if user exists in Firestore, if not create new user document
          final existingUser = await _firestoreService.getUser(user.uid);
          if (existingUser == null) {
            AppUser newUser = AppUser(
              uid: user.uid,
              email: user.email ?? 'no-email-${user.uid}@example.com',
              displayName: user.displayName,
              createdAt: Timestamp.now(),
              lastLoginAt: Timestamp.now(),
            );
            await _firestoreService.addUser(newUser);
          } else {
            // Update last login time
            await _firestoreService.updateUserLastLogin(user.uid);
          }
        }

        return user;
      } else {
        debugPrint('Facebook login failed: ${result.status}');
        return null;
      }
    } catch (e) {
      debugPrint('AuthService Facebook sign-in error: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      // Sign out from Google
      await _googleSignIn.signOut();
      
      // Sign out from Facebook
      await FacebookAuth.instance.logOut();
      
      // Sign out from Firebase
      return await _auth.signOut();
    } catch (e) {
      debugPrint('AuthService sign-out error: $e'); // Use debugPrint
      // No return null for void method
    }
  }
}
