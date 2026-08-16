import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../shared/widgets/animations/entrance.dart';
import '../../../shared/widgets/animations/pressable.dart';

/// Third onboarding page — "FOCUS" / Smart Fitness Tracking / Let's Get Started.
class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

                // PAGE INDICATORS (third page active)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      _dot(),
                      const SizedBox(width: 8),
                      _dot(),
                      const SizedBox(width: 8),
                      Container(
                        width: 42,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 45),

                FadeSlideIn(
                  delay: const Duration(milliseconds: 80),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "FOCUS",
                        style: GoogleFonts.montserrat(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                FadeSlideIn(
                  delay: const Duration(milliseconds: 180),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Start your\nFitness\nJourney Now!",
                        style: GoogleFonts.montserrat(
                          fontSize: 44,
                          height: 1.10,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),

                // CLOCK + BOTTOM CARD
                Expanded(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Clock peeks out from behind the card (top-right).
                      Positioned(
                        top: 0,
                        right: -18,
                        child: Floating(
                          amplitude: 10,
                          period: const Duration(seconds: 4),
                          child: Image.asset(
                            'assets/images/clock2.png',
                            width: 200,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: FadeSlideIn(
                          delay: const Duration(milliseconds: 300),
                          offset: const Offset(0, 0.25),
                          child: _infoCard(context),
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
    );
  }

  Widget _dot() => Container(
        width: 14,
        height: 14,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      );

  Widget _infoCard(BuildContext context) {
    void goLogin() =>
        Navigator.pushReplacementNamed(context, AppRoutes.login);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(26, 26, 26, 26),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFE7E3F3).withOpacity(0.80),
            Colors.white.withOpacity(0.98),
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              style: GoogleFonts.montserrat(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
              children: const [
                TextSpan(text: "Go", style: TextStyle(color: Colors.black)),
                TextSpan(text: "Fit", style: TextStyle(color: Color(0xFF7B67EC))),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Smart Fitness\nTracking",
            style: GoogleFonts.montserrat(
              fontSize: 34,
              height: 1.1,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            "Analyze your performance with real-time "
            "insights. Track calories, steps, and workouts "
            "with precision.",
            style: GoogleFonts.montserrat(
              fontSize: 15,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 22),

          // ACTION ROW (inside the card so no gradient strip shows behind it)
          Row(
            children: [
              Expanded(
                child: Pressable(
                  onTap: goLogin,
                  child: Container(
                    height: 62,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      gradient: AppGradients.primaryButtonGradient,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7B67EC).withOpacity(0.4),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            "Let's Get Started",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Icon(
                          Icons.keyboard_double_arrow_right,
                          color: Colors.white,
                          size: 26,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Pressable(
                onTap: goLogin,
                child: Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF7B67EC).withOpacity(0.12),
                    border: Border.all(
                      color: const Color(0xFF7B67EC).withOpacity(0.5),
                    ),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Color(0xFF7B67EC),
                    size: 32,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
