import 'package:flutter/material.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../shared/widgets/animations/entrance.dart';
import '../../../shared/widgets/app_logo.dart';
import '../../../shared/widgets/async_view.dart';
import '../../../shared/widgets/dark_card.dart';
import '../../../shared/widgets/stat_progress_bar.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../../activity/services/activity_repository.dart';
import '../../nutrition/models/meal.dart';
import '../../nutrition/services/meal_repository.dart';
import '../models/user_profile.dart';
import '../services/user_repository.dart';
import '../widgets/profile_menu_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: StaggerReveal(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        step: const Duration(milliseconds: 55),
        children: [
          const AppLogo(),
          const SizedBox(height: 20),
          AsyncView<UserProfile>(
            stream: UserRepository.instance.watchProfile(),
            builder: (profile) {
              final name = profile.displayName.trim().isEmpty
                  ? 'Athlete'
                  : profile.displayName.trim();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: UserAvatar(
                      name: profile.displayName,
                      photoUrl: profile.photoUrl,
                      radius: 44,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Center(
                    child: Text(name, style: AppTextStyles.screenTitle),
                  ),
                  const SizedBox(height: 20),
                  // Real progress toward today's goals, from logged data.
                  AsyncView<ActivitySummary>(
                    stream: ActivityRepository.instance.summary(),
                    builder: (summary) => AsyncView<List<Meal>>(
                      stream: MealRepository.instance.todaysMeals(),
                      builder: (meals) {
                        final consumed =
                            meals.fold<int>(0, (s, m) => s + m.calories);
                        final calGoal = profile.goals.dailyCalories;
                        return DarkCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Today's Progress",
                                  style: AppTextStyles.cardTitle),
                              const SizedBox(height: 16),
                              StatProgressBar(
                                label: 'Calories',
                                valueText: '$consumed / $calGoal',
                                progress: calGoal == 0
                                    ? 0
                                    : (consumed / calGoal).clamp(0.0, 1.0),
                                fillColor: AppColors.accentBlue,
                              ),
                              const SizedBox(height: 16),
                              StatProgressBar(
                                label: 'Distance',
                                valueText:
                                    '${summary.todayKm.toStringAsFixed(1)} km',
                                progress:
                                    (summary.todayKm / 10).clamp(0.0, 1.0),
                                fillColor: AppColors.chartRed,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),

          ProfileMenuItem(
            label: 'Personal Details',
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.personalDetails),
          ),
          ProfileMenuItem(
            label: 'Personal Goals',
            onTap: () => Navigator.pushNamed(context, AppRoutes.personalGoals),
          ),
          ProfileMenuItem(
            label: 'Privacy',
            onTap: () => Navigator.pushNamed(context, AppRoutes.privacy),
          ),
          ProfileMenuItem(
            label: 'About Me',
            onTap: () => Navigator.pushNamed(context, AppRoutes.aboutMe),
          ),
          ProfileMenuItem(
            label: 'Connect Watch',
            onTap: () => Navigator.pushNamed(context, AppRoutes.connectWatch),
          ),
        ],
        ),
      ),
    );
  }
}
