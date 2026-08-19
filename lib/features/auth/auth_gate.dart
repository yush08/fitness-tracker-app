import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main/screens/main_shell.dart';
import '../onboarding/screens/onboarding_pager.dart';
import 'services/auth_service.dart';

/// Top-level router that reacts to the Firebase session.
///
/// A signed-in user is dropped straight into the app; everyone else starts at
/// onboarding, which flows into the auth screen. Because this listens to
/// [AuthService.authStateChanges], signing out anywhere in the app pops the
/// whole navigation stack back here automatically — no manual route juggling.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _AuthSplash();
        }
        if (snapshot.hasData) return const MainShell();
        return const OnboardingPager();
      },
    );
  }
}

/// Neutral placeholder shown for the brief moment before the first auth state
/// arrives, so the app never flashes onboarding at an already-signed-in user.
class _AuthSplash extends StatelessWidget {
  const _AuthSplash();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
