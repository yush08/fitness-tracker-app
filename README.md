# GoFit

### A Modern Cross-Platform Fitness & Nutrition Tracker

GoFit is a cross-platform fitness tracking application built with **Flutter and Firebase**. It allows users to track physical activities and nutrition, set personal goals, and monitor their progress through a live, data-driven dashboard.

The application combines a polished, animation-rich interface with a real-time Firebase backend, custom data visualizations, and user-specific security controls.

---

## Features

### Authentication

* Email & password authentication
* Google Sign-In
* Password reset
* Persistent Firebase authentication sessions
* Automatic authentication state handling
* User profile initialization after first sign-in

### Fitness Tracking

* Log physical activities
* Track activity type, distance, and duration
* Live activity feed
* Activity history
* Delete activities
* Real-time Firestore updates

### Nutrition Tracking

* Log meals by category:

  * Breakfast
  * Lunch
  * Dinner
  * Snacks
* Track calories
* Track macronutrients:

  * Protein
  * Carbohydrates
  * Fat
* Daily calorie progress
* Macro visualization
* Delete meals with undo support

### Dashboard & Analytics

* Daily activity summaries
* Weekly activity charts
* 8-week statistics
* Activity heatmap
* Calorie progress
* Distance tracking
* Active-minute tracking
* Achievement system based on real activity totals

### Profile & Goals

* Personal information
* Age, height, weight and target weight
* Daily step goal
* Daily calorie goal
* Sleep goal
* Water goal
* Profile progress tracking

### UI/UX

* Material 3 design
* Custom design system
* Montserrat typography
* Light/dark theme
* Animated page transitions
* Onboarding animations
* Skeleton loading states
* Pull-to-refresh
* Swipe-to-delete with undo
* Hero animations
* Custom interactive charts
* Responsive layouts
* Haptic feedback

---

## Technology Stack

| Technology                  | Purpose                                    |
| --------------------------- | ------------------------------------------ |
| **Flutter**                 | Cross-platform application framework       |
| **Dart**                    | Primary programming language               |
| **Firebase Authentication** | User authentication                        |
| **Cloud Firestore**         | Real-time database                         |
| **Firebase App Check**      | Application integrity and abuse protection |
| **Google Sign-In**          | OAuth authentication                       |
| **Material 3**              | UI foundation                              |
| **Google Fonts**            | Montserrat typography                      |
| **CustomPainter**           | Custom data visualizations                 |
| **share_plus**              | Native sharing                             |
| **GitHub Actions**          | Security automation                        |
| **OSV Scanner**             | Dependency vulnerability scanning          |
| **Gradle / Kotlin**         | Android build system                       |

The project intentionally keeps its dependency set small and implements the visualization layer using Flutter's native `CustomPainter` instead of a dedicated charting library.

---

## Architecture

GoFit follows a **feature-first architecture** with a lightweight repository/service layer over Firebase.

```text
┌──────────────────────────┐
│        Flutter UI        │
│ Screens / Widgets        │
└────────────┬─────────────┘
             │
             ▼
┌──────────────────────────┐
│ Repositories / Services  │
│ AuthService              │
│ UserRepository           │
│ MealRepository           │
│ ActivityRepository       │
└────────────┬─────────────┘
             │
             ▼
┌──────────────────────────┐
│    FirestoreService      │
│ UID-scoped data access   │
└────────────┬─────────────┘
             │
             ▼
┌──────────────────────────┐
│      Firebase            │
│ Auth + Firestore         │
│ App Check                │
└────────────┬─────────────┘
             │
             ▼
┌──────────────────────────┐
│    Firestore Rules       │
│ Owner-only access        │
│ Schema validation        │
└──────────────────────────┘
```

### Architectural Patterns

The project uses:

* Repository Pattern
* Singleton services
* Facade Pattern
* Observer Pattern
* Adapter/Mapper Pattern
* Reactive Firestore streams
* Feature-first modular organization

Global state is intentionally lightweight, using `ValueNotifier` for theme and navigation state while screen-specific state uses `setState`.

---

## Data Model

GoFit uses Cloud Firestore with a per-user document structure:

```text
users/{uid}
│
├── Profile
│   ├── displayName
│   ├── email
│   ├── age
│   ├── heightCm
│   ├── weightKg
│   ├── targetWeightKg
│   └── goals
│
├── meals/{mealId}
│   ├── subtitle
│   ├── calories
│   ├── type
│   ├── loggedAt
│   ├── carbsG
│   ├── proteinG
│   └── fatG
│
└── activities/{activityId}
    ├── user
    ├── title
    ├── type
    ├── distanceKm
    ├── durationSec
    ├── likes
    ├── comments
    └── createdAt
```

Each user's data is scoped by their Firebase Authentication UID. Firestore rules enforce owner-only access and validate stored data against expected types and bounds.

---

## Real-Time Data Flow

GoFit uses Firestore streams to keep the application reactive.

```text
User performs an action
        ↓
Flutter Screen
        ↓
Repository
        ↓
FirestoreService
        ↓
Cloud Firestore
        ↓
Firestore Snapshot
        ↓
StreamBuilder / AsyncView
        ↓
Updated UI
```

For example, when a meal is added, the Firestore stream automatically propagates the updated data to screens that are listening to the same collection.

---

## Analytics Engine

One of the key technical components is the `ActivitySummary` aggregation system.

Instead of making multiple database queries for every dashboard statistic, the application processes the activity stream in a **single O(n) pass**.

It derives:

* Today's activity
* Last 7 days
* Weekly distance
* 8-week statistics
* All-time totals
* Activity heatmap
* Achievement progress

This approach reduces query complexity and avoids requiring additional composite Firestore indexes.

---

## Custom Visualization System

GoFit does not rely on an external charting library.

The application uses Flutter's `CustomPainter` to render:

* Ring gauges
* Bar charts
* Line charts
* Donut charts
* Activity heatmaps
* Route previews

Animations are implemented using Flutter animation APIs such as `TweenAnimationBuilder`, while `shouldRepaint` guards help prevent unnecessary painting.

---

## Security

Security is implemented using multiple layers of protection.

### Firestore Security

* Owner-only access
* Deny-by-default rules
* Server-side schema validation
* Numeric bounds
* String length restrictions

### Firebase App Check

App Check is configured using:

* Play Integrity on Android
* App Attest on Apple platforms
* reCAPTCHA v3 for web

### Storage

Storage rules are configured as:

* Deny by default
* Owner-only access
* Image restrictions
* Maximum file size limits

### Hosting

Firebase Hosting configuration includes security headers such as:

* HSTS
* X-Frame-Options
* X-Content-Type-Options
* Referrer-Policy
* Permissions-Policy

### CI Security

GitHub Actions performs security-related checks including:

* Flutter analysis
* Dependency status checks
* OSV vulnerability scanning

The security model follows a defense-in-depth approach rather than relying on Firebase client configuration alone.

---

## Project Structure

```text
fitness-tracker-app-main/
│
├── android/
├── ios/
├── web/
├── windows/
├── macos/
├── linux/
│
├── assets/
│   └── images/
│
├── docs/
│   └── firestore-model.md
│
├── lib/
│   ├── main.dart
│   ├── firebase_options.dart
│   │
│   ├── core/
│   │   ├── constants/
│   │   ├── data/
│   │   ├── routing/
│   │   └── theme/
│   │
│   ├── shared/
│   │   ├── utils/
│   │   └── widgets/
│   │       ├── animations/
│   │       └── charts/
│   │
│   └── features/
│       ├── onboarding/
│       ├── auth/
│       ├── home/
│       ├── nutrition/
│       ├── activity/
│       ├── stats/
│       ├── profile/
│       ├── settings/
│       └── main/
│
├── test/
├── firestore.rules
├── storage.rules
├── firebase.json
├── pubspec.yaml
├── analysis_options.yaml
└── README.md
```

---

## Application Flow

```text
App Launch
    ↓
Firebase Initialization
    ↓
App Check
    ↓
AuthGate
    │
    ├── Signed Out
    │      ↓
    │   Onboarding
    │      ↓
    │   Authentication
    │
    └── Signed In
           ↓
      Ensure User Document
           ↓
        Main Shell
           │
     ┌─────┼────────┬────────┬─────────┬──────────┐
     ↓     ↓        ↓        ↓         ↓          ↓
   Home  Calorie   Stats    Feed     Profile   Settings
```

The main application contains six primary tabs:

* Home
* Calorie
* Statistics
* Activity Feed
* Profile
* Settings

---

## Setup

### Prerequisites

* Flutter 3.41+
* Dart 3.11+
* Android Studio
* Android SDK
* JDK 21 / Android Studio bundled JBR
* Firebase account
* FlutterFire CLI

For iOS/macOS development, Xcode is also required.

### 1. Clone the repository

```bash
git clone https://github.com/yush08/fitness-tracker-app
cd fitness-tracker-app-main
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Configure Firebase

Install FlutterFire CLI:

```bash
dart pub global activate flutterfire_cli
```

Then configure Firebase:

```bash
flutterfire configure
```

This generates the required Firebase configuration files.

### 4. Configure Firebase Authentication

Enable:

* Email/Password
* Google Sign-In

in the Firebase Console.

### 5. Deploy Firestore and Storage rules

```bash
firebase deploy --only firestore:rules
firebase deploy --only storage
```

### 6. Run the application

```bash
flutter run
```

For web App Check, provide the reCAPTCHA configuration through a Dart define:

```bash
flutter run --dart-define=RECAPTCHA_V3_SITE_KEY=<your-key>
```

The project does not require a Firestore index file for its current query design.

---

## Build

### Android APK

```bash
flutter build apk
```

### Android App Bundle

```bash
flutter build appbundle
```

### Web

```bash
flutter build web
```

### iOS

```bash
flutter build ios
```

Additional Flutter platform builds are available for Windows, macOS and Linux.

---

## Current Implementation Status

### Fully implemented

* Firebase authentication
* Google authentication flow
* Password reset
* User profiles
* Personal goals
* Activity logging
* Activity feed
* Nutrition tracking
* Macro tracking
* Live dashboard
* Statistics
* Heatmap
* Achievements
* Custom charts
* Theme switching
* Sharing
* Pull-to-refresh
* Swipe-to-delete with undo

### Partial / Placeholder

Some secondary functionality is intentionally incomplete:

* Apple Sign-In
* Wearable/watch integration
* Privacy persistence
* Notification settings
* Unit settings persistence
* About Me statistics
* Food Details
* Route tracking
* Heart-rate tracking

Health-related metrics such as Steps, Heart Rate and Sleep were intentionally removed rather than presenting fabricated data, because real integration would require Health Connect or HealthKit.

---

## Performance Considerations

The application already benefits from:

* Single-stream activity aggregation
* No unnecessary composite indexes
* `IndexedStack` for tab state preservation
* `shouldRepaint` optimizations
* Skeleton loading
* Lightweight state management

Known areas for future optimization include:

* Pagination for the activity feed
* Limiting historical activity queries
* Sharing/caching Firestore streams
* Bundling fonts locally
* Reducing unnecessary rebuilds

The current activity feed can read an unbounded number of activities as the user's history grows, making pagination the most important scalability improvement.

---

## Testing

The project currently has very limited automated test coverage.

The existing Flutter test is the default generated counter test and is not representative of the actual application. High-value tests should be added for:

* `ActivitySummary`
* Firestore models
* Authentication error mapping
* Unit conversions
* Repository behavior
* Critical widgets
* Chart rendering

This is currently the largest engineering gap identified in the project.

---

## Roadmap

Potential future improvements include:

* [ ] Comprehensive unit and widget testing
* [ ] CI test execution
* [ ] Activity feed pagination
* [ ] Bounded analytics queries
* [ ] Persistent settings
* [ ] Persistent theme preference
* [ ] Real wearable integration
* [ ] Health Connect integration
* [ ] HealthKit integration
* [ ] Edit meals and activities
* [ ] Crash reporting
* [ ] Production application identifiers
* [ ] Development/production Firebase flavors
* [ ] Automated production deployment
* [ ] Improved accessibility semantics
* [ ] Updated project documentation

---

## Security Note

Firebase configuration files containing project-specific configuration should **not** be committed unnecessarily.

The repository previously contained Firebase configuration files in Git history. These were subsequently removed, but historical commits still contained them. The associated Firebase project was reported as deleted, making those historical keys inactive; if the project is ever revived, credentials/configuration should be rotated and Git history should be cleaned.

---

## Engineering Highlights

The project demonstrates practical experience with:

* Cross-platform Flutter development
* Firebase BaaS architecture
* Real-time Firestore streams
* Authentication and authorization
* Secure NoSQL data modeling
* Server-side Firestore validation
* App integrity verification
* Repository architecture
* Reactive UI development
* Custom graphics programming
* Client-side analytics
* Performance-aware database design
* CI security automation
* Responsive UI/UX
* Animation systems

---

## Why GoFit?

GoFit was designed around a simple principle:

> **Display real data rather than simulated progress.**

The dashboard, statistics, achievements and activity visualizations are derived from actual user data stored in Firestore. Features requiring external sensor data were intentionally avoided or left incomplete rather than presenting fabricated health metrics.

This makes the project both a polished UI showcase and a practical demonstration of Flutter application architecture, Firebase integration and secure real-time data handling.

---

## License

This project is intended for educational and portfolio purposes.


---

## Author

**Kumar Ayush**

Built with Flutter, Firebase and a focus on modern mobile UI/UX.

