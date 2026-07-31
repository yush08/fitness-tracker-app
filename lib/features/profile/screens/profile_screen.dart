import 'package:flutter/material.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../shared/widgets/app_logo.dart';
import '../../../shared/widgets/dark_card.dart';
import '../../../shared/widgets/stat_progress_bar.dart';
import '../widgets/profile_menu_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          const AppLogo(),
          const SizedBox(height: 20),
          Center(
            child: CircleAvatar(
              radius: 44,
              backgroundColor: AppColors.cardBackground,
              child:
                  Icon(Icons.person, size: 46, color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 14),
          Center(
            child: Text('Kumar Ayush', style: AppTextStyles.screenTitle),
          ),
          const SizedBox(height: 20),

          DarkCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Personal Goals', style: AppTextStyles.cardTitle),
                const SizedBox(height: 16),
                StatProgressBar(
                  label: 'Daily Steps',
                  valueText: '10,000',
                  progress: 0.7,
                  fillColor: AppColors.accentBlue,
                ),
                const SizedBox(height: 16),
                StatProgressBar(
                  label: 'Sleep Hours',
                  valueText: '8h',
                  progress: 0.8,
                  fillColor: AppColors.chartRed,
                ),
              ],
            ),
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
    );
  }
}
