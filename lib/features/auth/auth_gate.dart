import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main/screens/main_shell.dart';
import '../onboarding/screens/onboarding_pager.dart';
import '../profile/services/user_repository.dart';
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
        final user = snapshot.data;
        if (user != null) return _SignedInApp(user: user);
        return const OnboardingPager();
      },
    );
  }
}

/// Wraps the app for a signed-in user, making sure their Firestore profile
/// document exists before (and while) the dashboard renders. The screens read
/// through live streams that tolerate a missing doc, so we don't block on this
/// write — it just seeds defaults the first time a user signs in (covers the
/// Google-sign-in path too, which never touches the sign-up form).
class _SignedInApp extends StatefulWidget {
  final User user;
  const _SignedInApp({required this.user});

  @override
  State<_SignedInApp> createState() => _SignedInAppState();
}

class _SignedInAppState extends State<_SignedInApp> {
  @override
  void initState() {
    super.initState();
    // Fire-and-forget: a failure here (e.g. offline) just means the doc is
    // seeded on the next launch; the UI still works off defaults meanwhile.
    UserRepository.instance.ensureUserDoc(widget.user).catchError((_) {});
  }

  @override
  Widget build(BuildContext context) => const MainShell();
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
