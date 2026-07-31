# GoFit

GoFit is a modern cross-platform fitness tracking application built with Flutter. The project focuses on delivering a polished UI/UX experience with a scalable feature-first architecture, custom data visualizations, and a reusable design system. It provides a complete front-end experience including onboarding, authentication flow, fitness dashboard, activity tracking, nutrition monitoring, and profile management.

> **Note:** This project is currently UI-focused and uses placeholder data. Backend services, authentication, and persistent storage are intentionally excluded.

---

## Features

### Authentication
- Login screen
- Sign Up flow
- Forgot Password
- User Details setup

### Dashboard
- Home dashboard
- Nutrition tracking
- Activity feed
- Statistics dashboard
- Profile management
- Settings page

### Fitness Components
- Calories overview
- Sleep tracking
- Heart rate visualization
- Weekly progress
- Achievement cards
- Personal goals

### Custom Visualizations
- Ring Gauge
- Donut Chart
- Line Chart
- Weekly Bar Chart
- Activity Heatmap
- Route Preview
- Segmented Progress Bar
- Interactive Ruler Picker

### Theme Support
- Light Mode
- Dark Mode
- Runtime theme switching

---

## Tech Stack

| Category | Technology |
|----------|------------|
| Framework | Flutter 3.41+ |
| Language | Dart 3.11+ |
| UI | Material 3 |
| Fonts | Google Fonts (Montserrat) |
| Navigation | Navigator 1.0 |
| State Management | setState, ValueNotifier |
| Graphics | CustomPainter |
| Linting | flutter_lints |

---

## Project Structure

```
lib/
├── core/
│   ├── routing/
│   ├── constants/
│   └── theme/
│
├── shared/
│   └── widgets/
│       ├── charts/
│       └── reusable components
│
├── features/
│   ├── onboarding/
│   ├── auth/
│   ├── home/
│   ├── nutrition/
│   ├── stats/
│   ├── activity/
│   ├── profile/
│   ├── settings/
│   └── main/
│
└── main.dart
```

---

## Architecture

GoFit follows a **Feature-First Architecture**.

- **core/** → Routing, themes, constants
- **shared/** → Reusable widgets and design system
- **features/** → Independent feature modules
- **CustomPainter** → Dependency-free charts
- **ValueNotifier** → Lightweight global state
- **Named Routes** → Navigation

This architecture keeps the codebase modular, scalable, and easy to maintain.

---

## Design Highlights

- Custom Design System
- Responsive Layout
- Glassmorphism Effects
- Smooth Animations
- Reusable Widgets
- Material 3
- Modern Fitness UI
- Consistent Typography

---

## Current Status

### Implemented

- Complete UI
- Navigation
- Authentication Flow
- Dashboard
- Custom Charts
- Theme Switching
- Responsive Layout
- Feature-first Architecture

### Planned

- Firebase Authentication
- Cloud Firestore
- Activity Persistence
- Workout Tracking
- Notifications
- Wearable Integration
- REST API Integration
- State Management (Riverpod/Bloc)

---

## Getting Started

### Prerequisites

- Flutter 3.41+
- Dart 3.11+
- Android Studio / VS Code

### Installation

```bash
git clone https://github.com/yush08/fitness-tracker-app

cd gofit

flutter pub get

flutter run
```

---

## Platform Support

- Android
- iOS
- Web
- Windows
- macOS
- Linux

---

## Dependencies

```yaml
flutter
google_fonts
cupertino_icons
```

The project intentionally keeps external dependencies minimal and implements all charts using Flutter's native `CustomPainter`.

---

## Future Improvements

- Firebase Authentication
- Cloud Firestore
- Local Storage
- REST API
- Riverpod / Bloc
- Unit Testing
- Widget Testing
- CI/CD
- Deep Linking
- Accessibility Improvements

---

## Skills Demonstrated

- Flutter Development
- Dart
- Feature-first Architecture
- Clean UI Engineering
- CustomPainter
- Material Design 3
- Responsive Design
- Design Systems
- Mobile UI/UX
- Navigation
- State Management
- Git & GitHub

---

## License

This project is intended for educational and portfolio purposes.
