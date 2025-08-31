# Flutter Routine Planner - Module Interaction Diagram

## 🏗️ **High-Level SPA Architecture**

```
┌─────────────────────────────────────────────────────────────────┐
│                    FLUTTER ROUTINE PLANNER                     │
│                      SPA ARCHITECTURE                          │
├─────────────────────────────────────────────────────────────────┤
│  main.dart (Entry Point)                                       │
│  ├─ Firebase Initialization                                    │
│  ├─ MultiProvider (AuthService, FirestoreService)              │
│  └─ AuthWrapper (Root Routing Logic)                           │
│                            ↓                                   │
│  User Authentication Check                                      │
│  ├─ Not Authenticated → AuthPage (Login/Signup)                │
│  └─ Authenticated → UserPreferences Check                      │
│                      ├─ No Preferences → OnboardingScreen     │
│                      └─ Has Preferences → SPA Selection        │
│                          ├─ Task Management → TaskSpaScreen    │
│                          └─ Calendar View → CalendarSpaScreen  │
└─────────────────────────────────────────────────────────────────┘
```

## 📊 **Data Models & Relations**

```
FIREBASE FIRESTORE STRUCTURE:

users/{uid}
├─ AppUser (Core user profile)
├─ preferences/main
│  └─ UserPreferences (theme, language, interface choice)
├─ routines/{routineId}
│  ├─ Routine (name, description, frequency, schedule)
│  └─ tasks/{taskId}
│      └─ Task (name, duration, completion tracking)
├─ events/{eventId}
│  └─ Event (calendar events with type categorization)
└─ routine_sets/{setId}
    └─ RoutineSet (grouped routines)

RELATIONSHIPS:
AppUser (1) ←→ (1) UserPreferences
AppUser (1) ←→ (*) Routine
Routine (1) ←→ (*) Task  
AppUser (1) ←→ (*) Event
AppUser (1) ←→ (*) RoutineSet
```

## 🔄 **Service Layer & Data Flow**

```
SERVICE LAYER:

AuthService                    FirestoreService
├─ Firebase Auth              ├─ Firestore Database
├─ Google Sign-In             ├─ CRUD Operations
├─ Facebook Login             ├─ Real-time Streams  
├─ User Management            └─ Collection Management
└─ Stream<User?> user              ↓
          ↓                   Stream<List<T>> data
    Authentication                   ↓
    State Changes              StreamBuilder Widgets
          ↓                         ↓
    Route to SPA               Real-time UI Updates
```

## 🖥️ **SPA Screen Architecture**

```
SPA SCREENS:

TaskSpaScreen                 CalendarSpaScreen
├─ SpaAppBar                  ├─ SpaAppBar
├─ Statistics Cards           ├─ TableCalendar Widget
├─ Routine List               ├─ Event Type Color Coding
├─ Task Completion Toggle     ├─ View Toggle (Calendar/List)
└─ Filter Options             └─ Routine Management

        ↓                             ↓
   Profile Dropdown              Profile Dropdown
        ↓                             ↓
   SettingsScreen ←→ UserPreferences Storage
```

## 🎨 **Widget Hierarchy & Reusability**

```
REUSABLE COMPONENTS:

SpaAppBar (Shared Navigation)
├─ Title Display
├─ Custom Action Buttons
└─ User Profile Dropdown
    ├─ Profile (Coming Soon)
    ├─ Settings → SettingsScreen
    └─ Sign Out → AuthService.signOut()

OnboardingScreen (4-Step Flow)
├─ Welcome Step
├─ Language Selection (8 languages)
├─ Interface Preference Selection
└─ Theme Selection (6 themes)
```

## 🌐 **Integration & Features**

```
CROSS-SYSTEM INTEGRATIONS:

Theme System:
UserPreferences → AppTheme → MaterialApp ThemeData
├─ 6 Color Schemes (Indigo, Emerald, Rose, Amber, Purple, Blue)
└─ Applied Globally

Internationalization:
UserPreferences → AppLocale → AppLocalizations
├─ 8 Languages (EN, KO, JA, CN, ES, FR, DE, PT)
└─ Real-time Language Switching

Social Authentication:
Google/Facebook → Firebase Auth → AuthService → User Creation
└─ Automatic AppUser document creation in Firestore
```

## 🔄 **Real-time Data Patterns**

```
FIREBASE STREAMS:

AuthService.user Stream
├─ Triggers: Login/Logout events
└─ Effects: Route authentication state changes

FirestoreService Streams
├─ getRoutines() → Real-time routine updates
├─ getTasksForRoutine() → Live task completion tracking  
├─ getEvents() → Calendar event synchronization
└─ getUserPreferences() → Live settings updates

StreamBuilder Pattern:
Data Change → Firebase → Service Stream → UI Rebuild
```

## 🎯 **Key Architectural Benefits**

1. **📱 SPA Design**: User choice between Task-focused or Calendar-focused interfaces
2. **🔄 Real-time Sync**: Live Firebase integration for instant updates
3. **🌍 Personalization**: Theme, language, and interface customization
4. **🔐 Multi-Auth**: Email, Google, and Facebook authentication options
5. **📊 Hierarchical Data**: Clear user → routine → task relationships
6. **♻️ Reusable Components**: Shared widgets across SPAs
7. **🎨 Consistent Design**: Theme system applied globally
8. **📈 Scalable Structure**: Clean separation of concerns with service layers

## 📋 **Detailed Component Relationships**

### 1. Core Entry & Dependency Injection

```
main.dart
├─ Initializes: Firebase
├─ Provides: MultiProvider
│  ├─ AuthService (Singleton)
│  └─ FirestoreService (Singleton)
├─ Root Widget: AuthWrapper
└─ Localization: AppLocalizations
```

### 2. Authentication & User Flow Architecture

```
AuthWrapper (Root Decision Point)
├─ StreamBuilder<User?>: authService.user
├─ Decision Logic:
│  ├─ No User → AuthPage (Login/Signup Toggle)
│  │  ├─ LoginScreen
│  │  │  ├─ Email/Password Authentication
│  │  │  ├─ Google Sign-In Integration
│  │  │  ├─ Facebook Login Integration
│  │  │  └─ Navigation to SignUpScreen
│  │  └─ SignUpScreen
│  │     ├─ User Registration
│  │     ├─ Social Authentication
│  │     └─ Navigation to LoginScreen
│  │
│  └─ Authenticated User → Preference-Based Routing
│     ├─ StreamBuilder<UserPreferences?>
│     ├─ No Preferences → OnboardingScreen
│     └─ Has Preferences → SPA Selection
│        ├─ TaskManagement → TaskSpaScreen
│        └─ CalendarView → CalendarSpaScreen
```

### 3. Data Models & Relationships

```
DATA MODELS HIERARCHY:

AppUser (Core User Model)
├─ Properties: uid, email, displayName, createdAt, lastLoginAt
├─ Firestore Path: users/{uid}
└─ Used by: AuthService, FirestoreService

UserPreferences (User Settings)
├─ Properties: preferredInterface, focusAreas, selectedTheme, languageCode, etc.
├─ Firestore Path: users/{uid}/preferences/main
├─ Dependencies: AppThemeType, AppLocale, PreferredInterface
└─ Used by: AuthWrapper, OnboardingScreen, SettingsScreen

Routine (Core Task Container)
├─ Properties: name, description, frequency, startTime, isActive
├─ Firestore Path: users/{uid}/routines/{routineId}
├─ Relationships: One-to-Many with Task
└─ Used by: FirestoreService, TaskSpaScreen, CalendarSpaScreen

Task (Individual Task Items)
├─ Properties: routineId, name, durationMinutes, order, isCompleted (date-based)
├─ Firestore Path: users/{uid}/routines/{routineId}/tasks/{taskId}
├─ Parent: Routine
└─ Used by: FirestoreService, TaskSpaScreen

Event (Calendar Events)
├─ Properties: title, description, dateTime, type, isCompleted
├─ Firestore Path: users/{uid}/events/{eventId}
└─ Used by: FirestoreService, CalendarSpaScreen

RoutineSet (Grouped Routines)
├─ Properties: name, routines[]
├─ Firestore Path: users/{uid}/routine_sets/{setId}
└─ Contains: List<Routine>

AppTheme (Theme Configuration)
├─ Properties: type, colors, styling
├─ Types: indigo, emerald, rose, amber, purple, blue
└─ Used by: UserPreferences, ThemeData generation

AppLocale (Internationalization)
├─ Properties: languageCode, countryCode, nativeName, flag
├─ Supported: 8 languages (EN, KO, JA, CN, ES, FR, DE, PT)
└─ Used by: UserPreferences, Localization
```

### 4. Service Layer Architecture

```
SERVICE LAYER:

AuthService
├─ Dependencies: FirebaseAuth, GoogleSignIn, FacebookAuth, FirestoreService
├─ Methods:
│  ├─ registerWithEmailAndPassword()
│  ├─ signInWithEmailAndPassword()
│  ├─ signInWithGoogle()
│  ├─ signInWithFacebook()
│  └─ signOut()
├─ Streams: Stream<User?> user
├─ User Management: Creates AppUser documents via FirestoreService
└─ Used by: All authentication screens, SpaAppBar

FirestoreService
├─ Dependencies: FirebaseFirestore, FirebaseAuth
├─ Operations:
│  ├─ User: addUser(), getUser(), updateUserLastLogin()
│  ├─ Routines: addRoutine(), getRoutines(), updateRoutine(), deleteRoutine()
│  ├─ Tasks: addTaskToRoutine(), getTasksForRoutine(), updateTask(), deleteTask()
│  ├─ Events: addEvent(), getEvents(), updateEvent(), deleteEvent()
│  └─ RoutineSets: addRoutineSet(), getRoutineSets()
├─ Streams: Real-time data via Firestore snapshots
└─ Used by: All screens requiring data operations
```

### 5. Screen Components & Navigation

```
SPA ARCHITECTURE:

TaskSpaScreen (Task Management Interface)
├─ Dependencies: FirestoreService, SpaAppBar
├─ Features:
│  ├─ Statistics Dashboard (Active Routines, Total Tasks, Completed Today)
│  ├─ Routine Cards with Nested Tasks
│  ├─ Task Completion Toggle (date-based tracking)
│  └─ Filter Options (all, today, active, completed)
├─ Streams: getRoutines(), getTasksForRoutine()
└─ Navigation: Profile dropdown → SettingsScreen

CalendarSpaScreen (Calendar-Based Routine Management)
├─ Dependencies: FirestoreService, SpaAppBar, TableCalendar
├─ Features:
│  ├─ Calendar View with Event Markers
│  ├─ Event Type Color Coding
│  ├─ Routine List View Toggle
│  └─ Day-specific Event Display
├─ Streams: getEvents(), getRoutines()
└─ Views: Calendar View ↔ Routine List View

OnboardingScreen (4-Step Setup Process)
├─ Steps:
│  ├─ Welcome → Language Selection → Interface Preference → Theme Selection
│  ├─ Progress Tracking & Validation
│  └─ Firebase Preference Storage
├─ Dependencies: UserPreferences, AppLocale, AppTheme
└─ Navigation: Completion → Preferred SPA

SettingsScreen (User Profile Management)
├─ Features:
│  ├─ Account Information & Sign-Out
│  ├─ Language, Theme, Interface Switching
│  ├─ Notification Settings
│  └─ About & Support Links
├─ Dependencies: UserPreferences, AuthService
└─ Navigation: Back to SPA via Navigator.pop()
```

### 6. Widget Architecture & Reusability

```
REUSABLE WIDGETS:

SpaAppBar (Standard App Bar for SPAs)
├─ Features:
│  ├─ Title Display
│  ├─ Custom Actions Support
│  └─ User Profile Dropdown Menu
├─ Menu Options: Profile, Settings, Sign Out
├─ Dependencies: AuthService
└─ Used by: TaskSpaScreen, CalendarSpaScreen

Sidebar (Legacy Navigation - Deprecated)
├─ Features: User profile, Navigation items, Routine list
├─ Status: Deprecated in SPA architecture
└─ Replaced by: SpaAppBar profile dropdown

Custom UI Components:
├─ Statistics Cards (TaskSpaScreen)
├─ Routine Cards with Task Lists
├─ Event Cards with Type Indicators
├─ Theme Preview Cards (OnboardingScreen)
└─ Language Selection with Flags
```

### 7. Data Flow Patterns

```
FIREBASE INTEGRATION PATTERNS:

Real-time Data Streams:
AuthService.user → StreamBuilder<User?>
├─ Triggers: Authentication state changes
└─ Effects: Route to appropriate screen

FirestoreService Streams → StreamBuilder<List<T>>
├─ getRoutines() → List<Routine>
├─ getTasksForRoutine() → List<Task>
├─ getEvents() → List<Event>
└─ Updates: Real-time UI refreshes

Provider Pattern:
MultiProvider (main.dart)
├─ AuthService: Authentication management
├─ FirestoreService: Database operations
└─ Consumption: Provider.of<T>(context) in widgets

Firestore Collections Structure:
users/{uid}/
├─ preferences/main (UserPreferences)
├─ routines/{routineId}/ (Routine)
│  └─ tasks/{taskId} (Task)
├─ events/{eventId} (Event)
└─ routine_sets/{setId} (RoutineSet)
```

### 8. State Management & Updates

```
STATE MANAGEMENT PATTERNS:

Provider-based Dependency Injection:
├─ Services injected at app root level
├─ Accessed via Provider.of<T>(context)
└─ Shared across all widgets

StreamBuilder Pattern:
├─ Authentication State: AuthService.user stream
├─ User Preferences: Firestore snapshots
├─ Data Collections: Real-time Firestore streams
└─ Automatic UI rebuilds on data changes

Local State Management:
├─ StatefulWidget for form inputs
├─ Page controllers for onboarding
├─ Filter states and UI toggles
└─ Loading and saving states

Data Mutation Flow:
User Action → Service Method → Firestore Update → Stream Notification → UI Refresh
```

### 9. Feature Integration Points

```
CROSS-FEATURE INTEGRATIONS:

Theme System:
UserPreferences.selectedTheme → AppTheme → ThemeData
├─ Applied at MaterialApp level
├─ 6 predefined color schemes
└─ Consistent across all screens

Internationalization:
UserPreferences.locale → AppLocalizations
├─ 8 supported languages
├─ Automatic fallback to English
└─ Native name displays with flags

Social Authentication:
AuthService → Google/Facebook SDKs → Firebase Auth
├─ Credential conversion and user creation
├─ Automatic user document creation
└─ Seamless integration with existing users

Preference-based Routing:
AuthWrapper → UserPreferences → SPA Selection
├─ Dynamic routing based on user choice
├─ Task Management vs Calendar interface
└─ Settings allow interface switching
```

## 🎯 **Key Architectural Patterns**

1. **Single Page Application (SPA) Design**: Two main interfaces based on user preference
2. **Provider Pattern**: Dependency injection for services
3. **StreamBuilder Pattern**: Real-time data synchronization with Firebase
4. **Repository Pattern**: FirestoreService as data access layer
5. **Preference-driven Experience**: Theme, language, and interface customization
6. **Social Authentication Integration**: Multiple OAuth providers
7. **Hierarchical Data Structure**: Users → Preferences/Routines → Tasks
8. **Real-time Collaboration Ready**: Firebase streams enable live updates

---

*The architecture provides a scalable, maintainable foundation with clear separation of concerns, real-time capabilities, and a user-centric design that adapts to individual preferences and workflows.*

**Generated:** 2025-01-31
**Status:** Phase 2 SPA Implementation Complete ✅