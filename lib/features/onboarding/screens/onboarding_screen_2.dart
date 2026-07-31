import 'package:flutter/material.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_gradients.dart';

class NextOnboardingScreen extends StatelessWidget {
  const NextOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,

        decoration: const BoxDecoration(
          gradient: AppGradients.onboardingBackgroundGradient,
        ),

        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [

                const SizedBox(height: 20),

                // TOP SECTION
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

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
                              borderRadius:
                              BorderRadius.circular(20),
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
                      Container(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 26,
                          vertical: 14,
                        ),

                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(40),

                          border: Border.all(
                            color:
                            Colors.white.withOpacity(0.4),
                            width: 1.4,
                          ),

                          gradient: LinearGradient(
                            colors: [
                              Colors.deepOrange
                                  .withOpacity(0.25),

                              Colors.deepOrange
                                  .withOpacity(0.05),
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

                const SizedBox(height: 90),

                // STACKED CARDS
                SizedBox(
                  height: 260,

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
                            color: Colors.orange.shade200,

                            borderRadius:
                            BorderRadius.circular(38),

                            border: Border.all(
                              color: Colors.white,
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
                            color: Colors.orange.shade100,

                            borderRadius:
                            BorderRadius.circular(38),

                            border: Border.all(
                              color: Colors.white,
                              width: 1,
                            ),
                          ),
                        ),
                      ),

                      // MAIN CARD
                      Container(
                        width: 280,
                        height: 210,
                        padding: const EdgeInsets.all(24),

                        decoration: BoxDecoration(
                          color: const Color(0xFFF1E7C8),

                          borderRadius:
                          BorderRadius.circular(40),
                        ),

                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [

                            // TAG
                            Container(
                              padding:
                              const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),

                              decoration: BoxDecoration(
                                color: Colors.black,

                                borderRadius:
                                BorderRadius.circular(18),
                              ),

                              child: const Text(
                                "Stay Active",

                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight:
                                  FontWeight.w500,
                                ),
                              ),
                            ),

                            const SizedBox(height: 40),

                            // DESCRIPTION
                            const Text(
                              "Hit your daily goals,\nburn calories, and\nkeep moving every day.",

                              style: TextStyle(
                                fontSize: 18,
                                height: 1.45,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // GOFIT
                const Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 24),

                  child: Align(
                    alignment: Alignment.centerLeft,

                    child: Text(
                      "GoFit",

                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // HEADING
                const Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 24),

                  child: Align(
                    alignment: Alignment.centerLeft,

                    child: Text(
                      "All Activity in One\nPlace",

                      style: TextStyle(
                        fontSize: 44,
                        height: 1.10,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // DESCRIPTION
                const Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 24),

                  child: Text(
                    "Track your steps, workouts,\ncalories, and progress in a\nsingle dashboard.",

                    style: TextStyle(
                      fontSize: 18,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                ),

                const SizedBox(height: 60),

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
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.onboarding3,
                          ),
                          child: Container(
                          height: 66,

                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(40),

                            gradient:
                            const LinearGradient(
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
                          ),

                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,

                            children: const [

                              Text(
                                "Continue",

                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),

                              SizedBox(width: 20),

                              Icon(
                                Icons
                                    .keyboard_double_arrow_right,

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
                            color:
                            Colors.white.withOpacity(
                              0.55,
                            ),
                          ),

                          color:
                          Colors.white.withOpacity(0.20),
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
      ),
    );
  }
}