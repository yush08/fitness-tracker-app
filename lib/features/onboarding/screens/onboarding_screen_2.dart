import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../shared/widgets/animations/entrance.dart';
import '../../../shared/widgets/animations/pressable.dart';

class NextOnboardingScreen extends StatelessWidget {
  /// When hosted in the swipeable [OnboardingPager], advances to the next page.
  /// Falls back to a normal route push when shown standalone.
  final VoidCallback? onNext;

  const NextOnboardingScreen({super.key, this.onNext});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppGradients.onboardingBackgroundGradientReversed,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // LEFT INDICATORS
                      Row(
                        children: [
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
                        ],
                      ),

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
                            color: Colors.white.withOpacity(0.4),
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

                const Spacer(flex: 2),

                // STACKED CARDS
                FadeSlideIn(
                  delay: const Duration(milliseconds: 120),
                  child: Floating(
                    amplitude: 6,
                    child: SizedBox(
                      height: 258,
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          // BACK CARD 1
                          Transform.rotate(
                            angle: -0.15,
                            child: Container(
                              width: 260,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.35),
                                borderRadius: BorderRadius.circular(38),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.6),
                                  width: 1,
                                ),
                              ),
                            ),
                          ),

                          // BACK CARD 2
                          Transform.rotate(
                            angle: -0.07,
                            child: Container(
                              width: 270,
                              height: 205,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(38),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.7),
                                  width: 1,
                                ),
                              ),
                            ),
                          ),

                          // MAIN CARD
                          Container(
                            width: 280,
                            height: 228,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F1EC).withOpacity(0.95),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // TAG
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF7B67EC),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Text(
                                    "Stay Active",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 22),
                                // DESCRIPTION
                                Text(
                                  "Hit your daily goals, burn\ncalories, and keep moving.\nYour fitness journey\nstarts now.",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    height: 1.4,
                                    color: Colors.black87,
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

                const Spacer(flex: 2),

                // GOFIT
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

                const SizedBox(height: 14),

                // HEADING
                FadeSlideIn(
                  delay: const Duration(milliseconds: 320),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "All Activity in One\nPlace",
                        style: GoogleFonts.montserrat(
                          fontSize: 44,
                          height: 1.10,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),

                const Spacer(flex: 1),

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
                              Navigator.pushNamed(context, AppRoutes.onboarding3);
                            }
                          },
                          child: Container(
                            height: 66,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.5),
                                width: 1,
                              ),
                              gradient: AppGradients.primaryButtonGradient,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF7B67EC)
                                      .withOpacity(0.45),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Continue",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                const Icon(
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
                            color: Colors.white.withOpacity(0.55),
                          ),
                          color: Colors.white.withOpacity(0.20),
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
