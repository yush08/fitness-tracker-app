import 'package:flutter/material.dart';

import '../../features/auth/screens/auth_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/signup_details_screen.dart';
import '../../features/activity/screens/start_activity_screen.dart';
import '../../features/main/screens/main_shell.dart';
import '../../features/nutrition/screens/food_details_screen.dart';
import '../../features/onboarding/screens/onboarding_pager.dart';
import '../../features/onboarding/screens/onboarding_screen_2.dart';
import '../../features/onboarding/screens/onboarding_screen_3.dart';
import '../../features/profile/screens/about_me_screen.dart';
import '../../features/profile/screens/connect_watch_screen.dart';
import '../../features/profile/screens/personal_details_screen.dart';
import '../../features/profile/screens/personal_goals_screen.dart';
import '../../features/profile/screens/privacy_screen.dart';

/// Central route table. Kept package-free using [onGenerateRoute].
class AppRoutes {
  static const String onboarding = '/';
  static const String onboarding2 = '/onboarding/2';
  static const String onboarding3 = '/onboarding/3';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String signupDetails = '/signup/details';
  static const String forgotPassword = '/forgot-password';
  static const String main = '/main';
  static const String foodDetails = '/food-details';
  static const String startActivity = '/start-activity';
  static const String personalDetails = '/personal-details';
  static const String personalGoals = '/personal-goals';
  static const String privacy = '/privacy';
  static const String aboutMe = '/about-me';
  static const String connectWatch = '/connect-watch';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    Widget page;
    switch (settings.name) {
      case onboarding:
        page = const OnboardingPager();
        break;
      case onboarding2:
        page = const NextOnboardingScreen();
        break;
      case onboarding3:
        page = const OnboardingScreen3();
        break;
      case login:
        page = const AuthScreen(initialIndex: 0);
        break;
      case signup:
        page = const AuthScreen(initialIndex: 1);
        break;
      case signupDetails:
        page = const SignupDetailsScreen();
        break;
      case forgotPassword:
        page = const ForgotPasswordScreen();
        break;
      case main:
        page = const MainShell();
        break;
      case foodDetails:
        page = const FoodDetailsScreen();
        break;
      case startActivity:
        page = const StartActivityScreen();
        break;
      case personalDetails:
        page = const PersonalDetailsScreen();
        break;
      case personalGoals:
        page = const PersonalGoalsScreen();
        break;
      case privacy:
        page = const PrivacyScreen();
        break;
      case aboutMe:
        page = const AboutMeScreen();
        break;
      case connectWatch:
        page = const ConnectWatchScreen();
        break;
      default:
        page = const OnboardingPager();
    }
    return _buildRoute(page, settings);
  }

  /// Shared-axis (horizontal) page transition used app-wide: the incoming page
  /// fades in while sliding a touch from the right, and the outgoing page eases
  /// slightly left — the Material motion pattern for forward/back flows. One
  /// transition everywhere keeps navigation feeling like a single system.
  static Route<dynamic> _buildRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder<dynamic>(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 420),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeOutCubic;

        // Incoming: fade + slide in from the right.
        final fadeIn = CurvedAnimation(
          parent: animation,
          curve: const Interval(0.15, 1.0, curve: Curves.easeOut),
        );
        final slideIn = Tween<Offset>(
          begin: const Offset(0.06, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: curve));

        // Outgoing: ease a little to the left as the new page takes over.
        final slideOut = Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(-0.04, 0),
        ).animate(CurvedAnimation(parent: secondaryAnimation, curve: curve));

        return SlideTransition(
          position: slideOut,
          child: FadeTransition(
            opacity: fadeIn,
            child: SlideTransition(position: slideIn, child: child),
          ),
        );
      },
    );
  }
}
