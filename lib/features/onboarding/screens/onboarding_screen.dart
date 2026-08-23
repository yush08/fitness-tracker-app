import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../shared/widgets/animations/entrance.dart';
import '../../../shared/widgets/animations/pressable.dart';
import 'onboarding_screen_2.dart';

class OnboardingScreen extends StatelessWidget {
  /// When hosted in the swipeable [OnboardingPager], advances to the next page.
  /// Falls back to a normal route push when shown standalone.
  final VoidCallback? onNext;

  const OnboardingScreen({super.key, this.onNext});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Light background → dark status-bar icons.
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppGradients.onboardingBackgroundGradient,
        ),

        child: SafeArea(
          child: DefaultTextStyle.merge(
            style: GoogleFonts.montserrat(),
            child: Column(
            children: [

              const SizedBox(height: 20),

              // TOP SECTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [

                    // INDICATOR
                    Container(
                      width: 42,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),

                    const SizedBox(width: 8),

                    Container(
                      width: 14,
                      height: 14,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(width: 8),

                    Container(
                      width: 14,
                      height: 14,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),

                    const Spacer(),

                    // SKIP BUTTON
                    Pressable(
                      onTap: () => Navigator.pushReplacementNamed(
                          context, AppRoutes.login),
                      child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 26,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.4),
                          width: 1.4,
                        ),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF9C8BF5),
                            Color(0xFF7B67EC),
                          ],
                        ),
                      ),

                      child: const Text(
                        "SKIP",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // GOFIT TEXT
              FadeSlideIn(
                delay: const Duration(milliseconds: 220),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text.rich(
                      TextSpan(
                        style: GoogleFonts.montserrat(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                        children: const [
                          TextSpan(
                            text: "Go",
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: "Fit",
                            style: TextStyle(color: Color(0xFF7B67EC)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // HEADING
              const FadeSlideIn(
                delay: Duration(milliseconds: 180),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Start your\nFitness\nJourney Now!",
                      style: TextStyle(
                        fontSize: 44,
                        height: 1.10,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),

              // STACK AREA
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [

                    // CLOCK IMAGE
                    Positioned(
                      top: -75,
                      child: Image.asset(
                        'assets/images/clock.png',
                        width: 420,
                        fit: BoxFit.contain,
                      ),
                    ),

                    // LEFT GLASS CARD
                    Positioned(
                      left: -10,
                      top: 170,
                      child: FadeSlideIn(
                        delay: const Duration(milliseconds: 320),
                        offset: const Offset(-0.2, 0.1),
                        child: Floating(
                          amplitude: 7,
                          child: Transform.rotate(
                            angle: 0.25,
                            child: _glassCard(
                              title: "Today's Activity",
                              subtitle:
                              "Track your steps, calories,\nand progress in real-time.",
                              icon: Icons.watch_later_outlined,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // RIGHT GLASS CARD
                    Positioned(
                      right: 00,
                      top: 220,
                      child: FadeSlideIn(
                        delay: const Duration(milliseconds: 440),
                        offset: const Offset(0.2, 0.1),
                        child: Floating(
                          amplitude: 9,
                          phase: 0.5,
                          child: Transform.rotate(
                            angle: -0.35,
                            child: _glassCard(
                              title: "Stay Active",
                              subtitle:
                              "You haven't logged any\nworkout today. Let's get\nmoving!",
                              icon: Icons.gps_fixed,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // BOTTOM BUTTONS
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 22,
                ),
                child: Row(
                  children: [

                // CONTINUE BUTTON
                Expanded(
                  child: Pressable(
                    onTap: () {
                      if (onNext != null) {
                        onNext!();
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NextOnboardingScreen(),
                          ),
                        );
                      }
                      },
                    child: Container(
                      height: 66,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.5),
                          width: 1,
                        ),
                        gradient: AppGradients.primaryButtonGradient,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7B67EC).withValues(alpha: 0.45),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Continue",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 20),
                          Icon(
                            Icons.keyboard_double_arrow_right,
                            color: Colors.white,
                            size: 28,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                    const SizedBox(width: 16),

                    // PROFILE BUTTON
                    Pressable(
                      onTap: () => Navigator.pushReplacementNamed(
                          context, AppRoutes.login),
                      child: Container(
                      width: 66,
                      height: 66,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.55),
                        ),
                        color: Colors.white.withValues(alpha: 0.20),
                      ),

                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          ),
        ),
      ),
      ),
    );
  }
}

// GLASS CARD WIDGET
Widget _glassCard({
  required String title,
  required String subtitle,
  required IconData icon,

}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(42),
    child: BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 14,
        sigmaY: 14,
      ),
      child: Container(
        width: 220,
        height: 210,
        padding: const EdgeInsets.all(22),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),

          border: Border.all(
            color: Colors.white.withValues(alpha: 0.50),
            width: 1,
          ),

          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey.withValues(alpha: 0.30),
              Colors.grey.withValues(alpha: 0.20),
            ],
          ),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ICON
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),

              child: Icon(
                icon,
                color: const Color(0xFF2A2A33),
                size: 26,
              ),
            ),

            const Spacer(),

            // TITLE
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 8),

            // SUBTITLE
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: Colors.white.withValues(alpha: 0.88),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}