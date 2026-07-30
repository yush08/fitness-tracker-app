# GoFit – Flutter Fitness App UI

A modern Flutter fitness application UI built with a scalable, feature-first architecture. The project currently focuses on delivering a polished onboarding experience with reusable UI components, custom theming, and a clean project structure that serves as the foundation for future fitness tracking features.

## Project Overview

GoFit is a Flutter-based mobile application designed to provide an engaging fitness experience. The current implementation showcases a professionally designed onboarding interface featuring glassmorphism effects, gradient backgrounds, reusable widgets, and a modular architecture. The project is structured for future expansion, including authentication, workout tracking, health monitoring, and backend integration.

## Features

### Implemented

* Modern onboarding screen
* Glassmorphism UI components
* Custom gradient backgrounds
* Responsive Flutter layout
* Reusable primary button component
* Reusable glass card widget
* Modular feature-first architecture
* Centralized design constants
* Google Fonts integration using Montserrat
* Cross-platform Flutter support

### Planned

* User authentication
* Login and signup screens
* Forgot password functionality
* Dashboard
* Activity tracking
* Workout management
* Step counter
* Calorie tracking
* Profile management
* State management
* Local data storage
* Backend integration
* Health API integration

## Tech Stack

| Technology      | Purpose                                |
| --------------- | -------------------------------------- |
| Flutter         | Cross-platform application development |
| Dart            | Programming language                   |
| Material Design | UI framework                           |
| Google Fonts    | Typography (Montserrat)                |
| Cupertino Icons | iOS-style icons                        |

## Project Structure

```text
lib/
├── core/
│   ├── constants/
│   │   └── app_sizes.dart
│   └── theme/
│       ├── app_colors.dart
│       ├── app_gradients.dart
│       ├── app_theme.dart
│       └── text_styles.dart
│
├── features/
│   ├── onboarding/
│   │   └── screens/
│   │       └── onboarding_screen.dart
│   │
│   └── auth/
│       └── screens/
│           ├── login_screen.dart
│           ├── signup_screen.dart
│           └── forgot_password_screen.dart
│
├── shared/
│   └── widgets/
│       ├── glass_card.dart
│       ├── primary_button.dart
│       ├── custom_textfield.dart
│       └── loading_indicator.dart
│
└── main.dart
```

## Application Architecture

The project follows a feature-first architecture for improved scalability and maintainability.

```text
lib
│
├── core
│   ├── Theme
│   ├── Constants
│   └── Global Styles
│
├── features
│   ├── Onboarding
│   └── Authentication
│
└── shared
    └── Reusable Widgets
```

## Current Screen

### Onboarding Screen

The application currently includes a fully designed onboarding interface featuring:

* Gradient background
* GoFit branding
* Motivational fitness headline
* Glassmorphism activity cards
* Custom illustration
* Page indicator
* Continue button
* Profile action button

## Reusable Components

### PrimaryButton

A reusable gradient button supporting customizable text and trailing widgets.

### GlassCard

A reusable glassmorphism container built using `BackdropFilter` for frosted-glass effects.

### Theme Utilities

* AppColors
* AppGradients
* AppTextStyles
* AppSizes

These files centralize styling and make future UI customization easier.

## Getting Started

### Prerequisites

* Flutter SDK 3.11 or later
* Dart SDK
* Android Studio or Visual Studio Code
* Flutter extension

### Installation

Clone the repository:

```bash
git clone https://github.com/your-username/gofit.git
```

Navigate to the project directory:

```bash
cd gofit
```

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons:
  google_fonts:
```

## Current Limitations

This project is currently a UI prototype.

The following functionality has not yet been implemented:

* Navigation
* Authentication
* State management
* Backend services
* API integration
* Database
* Local storage
* Workout tracking
* Health tracking
* Notifications
* User profile management

## Future Improvements

* Implement complete authentication flow
* Add navigation between screens
* Integrate Firebase Authentication
* Connect Cloud Firestore or Supabase
* Implement Provider, Riverpod, or Bloc
* Add workout planner
* Step counting
* Calorie tracking
* Activity dashboard
* Dark mode support
* Push notifications
* Google Fit and Apple Health integration
* Offline data synchronization

## Learning Objectives

This project demonstrates:

* Flutter UI development
* Modular project organization
* Reusable widget development
* Responsive layout design
* Glassmorphism implementation
* Gradient-based UI design
* Custom typography
* Clean project architecture

## Project Status

| Module              | Status      |
| ------------------- | ----------- |
| Project Setup       | Completed   |
| UI Design System    | Completed   |
| Onboarding Screen   | Completed   |
| Reusable Widgets    | Completed   |
| Rest of Development | In Progress |


## License

This project is intended for educational and portfolio purposes.
