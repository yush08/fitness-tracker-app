import 'package:flutter/material.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_gradients.dart';
import '../widgets/onboarding_bottom_bar.dart';

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

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 28),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "FOCUS",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 28),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Start your\nFitness\nJourney Now!",
                    style: TextStyle(
                      fontSize: 44,
                      height: 1.10,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              // CLOCK + BOTTOM CARD
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: -10,
                      right: -30,
                      child: Image.asset(
                        'assets/images/clock.png',
                        width: 300,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: _infoCard(),
                    ),
                  ],
                ),
              ),

              OnboardingBottomBar(
                label: "Let's Get Started",
                onContinue: () =>
                    Navigator.pushReplacementNamed(context, AppRoutes.login),
                onProfile: () =>
                    Navigator.pushReplacementNamed(context, AppRoutes.login),
              ),
            ],
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

  Widget _infoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(28, 26, 28, 30),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.55),
            Colors.white.withOpacity(0.9),
          ],
        ),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "GoFit",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "Smart Fitness\nTracking",
            style: TextStyle(
              fontSize: 34,
              height: 1.1,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          Text(
            "Analyze your performance with real-time "
            "insights. Track calories, steps, and workouts "
            "with precision.",
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
