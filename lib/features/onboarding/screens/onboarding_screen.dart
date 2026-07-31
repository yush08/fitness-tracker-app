import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/theme/app_gradients.dart';
import 'onboarding_screen_2.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

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
                    Container(
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
                        gradient: LinearGradient(
                          colors: [
                            Colors.deepOrange.withOpacity(0.25),
                            Colors.deepOrange.withOpacity(0.05),
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
                  ],
                ),
              ),

              const SizedBox(height: 55),

              // GOFIT TEXT
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 28),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "GoFit",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // HEADING
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

              // STACK AREA
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [

                    // CLOCK IMAGE
                    Positioned(
                      top: -130,
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

                    // RIGHT GLASS CARD
                    Positioned(
                      right: 00,
                      top: 220,
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
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const NextOnboardingScreen(),
                        ),
                      );
                      },
                    child: Container(
                      height: 66,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          color: Colors.yellow.withOpacity(0.5),
                          width: 1,
                        ),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFF8BD00),
                            Color(0xFFFC900D),
                            Color(0xFFFC940B),
                            Color(0xFFFC900D),
                            Color(0xFFF8BD00),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.35),
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
                    Container(
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
                  ],
                ),
              ),
            ],
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
            color: Colors.white.withOpacity(0.50),
            width: 1,
          ),

          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey.withOpacity(0.30),
              Colors.grey.withOpacity(0.20),
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
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.20),
              ),

              child: Icon(
                icon,
                color: Colors.white,
                size: 25,
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
                color: Colors.white.withOpacity(0.88),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}