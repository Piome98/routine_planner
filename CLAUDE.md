# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

**Build & Run:**
- `flutter run` - Run the app in debug mode
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build iOS app (macOS only)

**Testing & Analysis:**
- `flutter test` - Run unit and widget tests
- `flutter analyze` - Run static analysis using rules from analysis_options.yaml
- `dart fix --apply` - Apply automatic fixes for lint issues

**Dependencies:**
- `flutter pub get` - Install dependencies from pubspec.yaml
- `flutter pub upgrade` - Upgrade all dependencies

**Code Generation (if using build_runner):**
- `dart run build_runner build` - Generate code files

## Architecture

This is a Flutter routine/task management app with Firebase backend integration.

**Core Architecture:**
- **State Management:** Provider pattern for dependency injection and state management
- **Backend:** Firebase (Authentication + Firestore NoSQL database)
- **Authentication:** Firebase Auth with email/password
- **Data Layer:** Repository pattern via FirestoreService

**Project Structure:**
- `lib/main.dart` - App entry point with Firebase initialization and Provider setup
- `lib/models/` - Data models (User, Routine, Task, Event) with Firestore serialization
- `lib/services/` - Business logic layer (AuthService, FirestoreService)
- `lib/screens/` - UI screens including main layout and dashboard
- `lib/widgets/` - Reusable UI components including sidebar navigation

**Database Schema (Firestore):**
- `users/{uid}` - User profiles
- `users/{uid}/routines/{routineId}` - User's routines
- `users/{uid}/routines/{routineId}/tasks/{taskId}` - Tasks within routines
- `users/{uid}/events/{eventId}` - User's events/todos

**Key Dependencies:**
- Firebase: `firebase_core`, `firebase_auth`, `cloud_firestore`
- Social Auth: `google_sign_in`, `flutter_facebook_auth`
- State Management: `provider`
- Utilities: `intl` for internationalization

**Authentication Flow:**
AuthWrapper → AuthPage (login/signup toggle) → MainLayout (authenticated with sidebar navigation)
- Supports email/password, Google, and Facebook authentication

**Firebase Setup:**
The app uses Firebase with configuration files already present:
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- `lib/firebase_options.dart`

**UI Architecture:**
The app features a modern dashboard-style interface with:
- **MainLayout:** Primary app layout with sidebar + content area structure
- **Sidebar:** Navigation menu with user profile, nav items, and dynamic routine list
- **DashboardScreen:** Main dashboard with personalized greeting, today's routines, upcoming events, and quick stats
- **Modular Screens:** Separate screens for Dashboard, Routines, Events, and Statistics accessible via sidebar

**Design System:**
- **Color Scheme:** Indigo primary (`#4F46E5`), with purple accents and semantic colors
- **Layout:** Card-based design with subtle shadows and rounded corners
- **Typography:** Clean hierarchy with proper font weights and spacing
- **Interactive Elements:** Hover states, loading indicators, and form validation
- **Responsive Design:** Optimized for desktop and mobile layouts

**Key UI Components:**
- `Sidebar` - Navigation with routine management and user profile
- `_AddRoutineDialog` - Full-featured routine creation modal
- Task completion toggles with visual feedback
- Event type badges and status indicators
- Quick stats cards with color-coded metrics

**Development Notes:**
- Use `debugPrint()` instead of `print()` for logging
- All models have `fromFirestore()` and `toFirestore()` methods
- User data is stored in subcollections under individual user documents
- The app follows Material 3 design principles with custom styling
- Real-time data updates via Firestore streams
- Form validation and error handling throughout UI components

## Recent Updates

**Code Quality Improvements (Latest):**
- ✅ Fixed all Dart analyzer warnings and hints
- ✅ Applied prefer_const_constructors optimizations
- ✅ Implemented prefer_const_literals_to_create_immutables
- ✅ Added prefer_single_quotes rule (enabled in analysis_options.yaml)
- ✅ Optimized string interpolations (removed unnecessary .toString())
- ✅ Enhanced null safety throughout the codebase

**Social Authentication Integration:**
- ✅ Google Sign-In implementation with proper error handling
- ✅ Facebook Login integration with credential management
- ✅ Updated AuthService with social auth methods
- ✅ Enhanced UI with social login buttons in both login and signup screens
- ✅ Proper Firebase user creation for social auth users

**UI Enhancements:**
- ✅ Modern dashboard layout with sidebar navigation
- ✅ Responsive card-based design with proper spacing
- ✅ Real-time routine management with add/edit functionality
- ✅ Task completion tracking with visual feedback
- ✅ Event management with type-based color coding
- ✅ Quick stats dashboard with key metrics

**Performance Optimizations:**
- ✅ Const constructors for reduced widget rebuilds
- ✅ Optimized color handling with .withAlpha() instead of .withOpacity()
- ✅ Efficient list rendering with proper const declarations
- ✅ Memory leak prevention with proper controller disposal

**Git Repository Integration:**
- ✅ Connected to GitHub repository: https://github.com/Piome98/routine_planner.git
- ✅ Successfully pushed all commits with proper merge handling
- ✅ Repository structure organized with proper .gitignore settings

**Testing Phase Setup (2025-01-27):**
- ⏳ Began module testing phase to verify component functionality
- ⏳ Flutter test environment setup - identified Firebase initialization needed for tests
- ⏳ Dependencies verified: Flutter SDK 3.32.7, all Firebase packages properly installed
- ⏳ Ready for Firebase connection testing and transaction verification

**Next Steps (Pending):**
- 🔄 Test Firebase connection and authentication flow
- 🔄 Test Firestore database operations (CRUD)
- 🔄 Test social authentication (Google, Facebook)
- 🔄 Test real-time data synchronization
- 🔄 Test UI components and navigation flow
- 🔄 Run flutter analyze and fix any remaining issues
- 🔄 Test app build for different platforms (Android/iOS)

**Notes:**
- All core features implemented and code quality optimized
- Firebase integration ready for live testing
- Social authentication (Google/Facebook) implemented
- Modern UI with dashboard and sidebar navigation complete
- Repository successfully connected to GitHub with all commits pushed