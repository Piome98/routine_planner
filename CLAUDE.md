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

**SPA Architecture Refactoring (2025-01-30):**
- 🔄 **Major UI Architecture Change:** Transitioning from multi-screen sidebar navigation to Single Page Application (SPA) approach
- 🔄 **New User Flow:** Authentication → Onboarding (preferences) → Choice between Task Management SPA or Calendar Routine SPA
- 🔄 **Deprecated Files:** `main_layout.dart`, `dashboard_screen.dart`, `routines_screen.dart`, `statistics_screen.dart`
- 🔄 **Retained Files:** `auth_wrapper.dart`, `login_screen.dart`, `signup_screen.dart`, `events_screen.dart` (calendar functionality)
- 🔄 **New Files to Create:**
  - `onboarding_screen.dart` - User preference setup after signup
  - `task_spa_screen.dart` - Task-focused management interface
  - `calendar_spa_screen.dart` - Calendar-based routine management interface

**SPA Implementation Plan:**
1. ✅ **Analysis Phase:** Identified deprecated vs retained screen files
2. ✅ **Enhanced Onboarding System:** Complete 4-step onboarding implementation
   - Welcome → Language Selection → Interface Selection → Theme Selection
   - 8 language support with native names and flag indicators
   - 6 dynamic theme options with gradient previews
   - Comprehensive validation and progress tracking
   - Firebase Firestore integration for preference storage
3. ✅ **Settings Screen:** Full user profile management system
   - Account management with user info and sign-out
   - Dynamic language, theme, and interface switching
   - Notification preferences with toggle controls
   - About section with app information and support links
4. 🔄 **Task Management SPA:** Consolidated task management interface with integrated statistics
5. 🔄 **Calendar Routine SPA:** Calendar-based routine management using existing events_screen.dart calendar functionality
6. 🔄 **Routing Update:** Implement preference-based routing logic
7. 🔄 **Cleanup:** Remove deprecated screen files

**Current Development (2025-01-30):**
- ✅ **Enhanced Onboarding System:** Complete 4-step onboarding process implemented
  - Step 1: Welcome screen with app introduction
  - Step 2: Language selection (8 supported languages with native names and flags)
  - Step 3: Interface preference (Task Management vs Calendar View)
  - Step 4: Theme selection (6 color themes with live preview)
  - Real-time progress indicator and validation for each step
- ✅ **Settings Screen:** Comprehensive user profile management system
  - Account management with sign-out functionality
  - Dynamic language switching with flag indicators
  - Theme selection with gradient previews
  - Interface preference switching
  - Notification settings toggle
  - About section with app info and help links
- ✅ **Data Models & Services:**
  - `AppLocale` model with 8 language support (EN, KO, JA, CN, ES, FR, DE, PT)
  - `AppTheme` model with 6 color themes (Indigo, Emerald, Rose, Amber, Purple, Blue)
  - Enhanced `UserPreferences` model with theme and locale fields
  - Firebase Firestore integration for all preference storage

**Implementation Status:**
- ✅ Enhanced onboarding system with 4-step flow completed
- ✅ Settings screen with comprehensive user management completed
- ✅ Theme and localization system implemented
- ✅ Firebase integration for all user preferences completed
- ✅ Code analysis and critical error fixes completed (27 → 8 minor issues)

**Development Roadmap (Phase 2 - SPA Implementation):**

**✅ Phase 2.1: App Routing Structure Update (COMPLETED)**
- ✅ Updated AuthWrapper to integrate onboarding flow with preference checking
- ✅ Implemented preference-based automatic routing (Task SPA vs Calendar SPA)
- ✅ Transitioned from main_layout.dart to new SPA routing system
- ✅ Added settings access through profile dropdown in SPAs
- ✅ Created SpaAppBar component with user profile dropdown menu
- ✅ Integration: AuthWrapper → OnboardingScreen → User Preferences → Preferred SPA

**🔄 Phase 2.2: Task Management SPA Development**
- Transform task_spa_screen.dart from basic template to full interface
- Features to implement:
  - Task list view with routine-based grouping
  - Task completion toggle with visual feedback
  - Integrated statistics dashboard
  - Profile dropdown with settings access
  - Real-time Firebase synchronization
  - Responsive design for desktop/mobile

**🔄 Phase 2.3: Calendar Routine Management SPA Development**
- Transform calendar_spa_screen.dart from basic template to full interface
- Integrate existing events_screen.dart calendar functionality
- Features to implement:
  - Calendar-based routine scheduling interface
  - Drag & drop routine management
  - Month/Week/Day view switching
  - Profile dropdown with settings access
  - Real-time routine updates

**🔄 Phase 2.4: Cleanup & Optimization**
- Remove deprecated screen files:
  - main_layout.dart
  - dashboard_screen.dart
  - routines_screen.dart
  - statistics_screen.dart
- Final code analysis and optimization
- End-to-end testing of SPA flow

**Current Focus:**
- 🎯 Ready to begin Phase 2.2: Task Management SPA Development

**Phase 2.1 Implementation Details:**
- **New Files Created:**
  - `lib/widgets/spa_app_bar.dart` - Reusable AppBar with profile dropdown
- **Modified Files:**
  - `lib/screens/auth_wrapper.dart` - Added onboarding + preference-based routing
  - `lib/screens/task_spa_screen.dart` - Added SpaAppBar integration
  - `lib/screens/calendar_spa_screen.dart` - Added SpaAppBar integration
- **User Flow:** Login → Check Preferences → (No Preferences: Onboarding) → Preferred SPA
- **Settings Access:** Profile dropdown in both SPAs leads to settings screen

**Notes:**
- Models and backend services (FirestoreService, AuthService) remain unchanged
- Existing calendar and statistics functionality will be integrated into new SPA interfaces
- Focus on creating seamless single-page user experience based on user preferences