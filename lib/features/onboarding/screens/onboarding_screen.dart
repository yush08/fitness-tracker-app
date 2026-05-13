import 'package:flutter/material.dart';

import '../../../core/theme/app_gradients.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/widgets/glass_card.dart';
import 'dart:ui';

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

              // Top Indicators
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
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

                    // Skip Button
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(40),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.25),
                            Colors.white.withOpacity(0.05),
                          ],
                        ),
                      ),
                      child: const Text(
                        'SKIP',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 60),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'GoFit',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Start your\nFitness\nJourney Now!',
                    style: TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'montserrat',
                      height: 1.05,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [

                    // Clock Image
                    Positioned(
                      top: 40,
                      child: Image.asset(
                        'assets/images/clock.png',
                        width: 320,
                      ),
                    ),

                    // Left Glass Card
                    Positioned(
                      right: -20,
                      top: 140,
                      child: Transform.rotate(
                        angle: -0.3,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(49),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 12,
                              sigmaY: 12,
                            ),
                            child: Container(
                              width: 248,
                              height: 244,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.40),
                                borderRadius: BorderRadius.circular(49),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.40),
                                  width: 1,
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.orange.withOpacity(0.40),
                                    Colors.deepOrange.withOpacity(0.40),
                                  ],
                                ),
                              ),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Container(
                                    width: 72,
                                    height: 72,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.40),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.gps_fixed,
                                      size: 34,
                                      color: Colors.white,
                                    ),
                                  ),

                                  const Spacer(),

                                  const Text(
                                    'Stay Active',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  const Text(
                                    "You haven't logged any\nworkout today. Let's get\nmoving!",
                                    style: TextStyle(
                                      fontSize: 14,
                                      height: 1.4,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Right Card
                    Positioned(
                      right: -10,
                      top: 220,
                      child: Transform.rotate(
                        angle: 0.45,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(49),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 12,
                              sigmaY: 12,
                            ),
                            child: Container(
                              width: 248,
                              height: 244,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.40),
                                borderRadius: BorderRadius.circular(49),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.40),
                                  width: 1,
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.orange.withOpacity(0.40),
                                    Colors.deepOrange.withOpacity(0.40),
                                  ],
                                ),
                              ),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Container(
                                    width: 72,
                                    height: 72,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.40),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.gps_fixed,
                                      size: 34,
                                      color: Colors.white,
                                    ),
                                  ),

                                  const Spacer(),

                                  const Text(
                                    'Stay Active',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  const Text(
                                    "You haven't logged any\nworkout today. Let's get\nmoving!",
                                    style: TextStyle(
                                      fontSize: 14,
                                      height: 1.4,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
    );
  }
}
