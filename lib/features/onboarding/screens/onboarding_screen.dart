import 'package:flutter/material.dart';

import '../../../core/theme/app_gradients.dart';

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
                      height: 1.05,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}