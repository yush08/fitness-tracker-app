import 'package:flutter/material.dart';

import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/signup_details_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/activity/screens/start_activity_screen.dart';
import '../../features/main/screens/main_shell.dart';
import '../../features/nutrition/screens/food_details_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
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
        page = const OnboardingScreen();
        break;
      case onboarding2:
        page = const NextOnboardingScreen();
        break;
      case onboarding3:
        page = const OnboardingScreen3();
        break;
      case login:
        page = const LoginScreen();
        break;
      case signup:
        page = const SignupScreen();
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
        page = const OnboardingScreen();
    }
    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }
}
