import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../shared/widgets/app_sub_screen.dart';
import '../../../shared/widgets/dark_card.dart';

class ConnectWatchScreen extends StatefulWidget {
  const ConnectWatchScreen({super.key});

  @override
  State<ConnectWatchScreen> createState() => _ConnectWatchScreenState();
}

class _ConnectWatchScreenState extends State<ConnectWatchScreen> {
  static const _devices = [
    (Icons.watch, 'Apple Watch'),
    (Icons.watch_outlined, 'Wear OS'),
    (Icons.fitness_center, 'Fitbit'),
    (Icons.directions_run, 'Garmin'),
  ];

  String? _connected;

  @override
  Widget build(BuildContext context) {
    return AppSubScreen(
      title: 'Connect Watch',
      children: [
        Text(
          'Sync steps, heart rate and workouts automatically from your '
          'wearable.',
          style: AppTextStyles.body,
        ),
        const SizedBox(height: 18),
        for (final d in _devices)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: DarkCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(d.$1, color: AppColors.textPrimary, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      d.$2,
                      style: AppTextStyles.small.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  _connectButton(d.$2),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _connectButton(String device) {
    final connected = _connected == device;
    return GestureDetector(
      onTap: () {
        setState(() => _connected = connected ? null : device);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(connected ? '$device disconnected' : '$device connected'),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: connected ? AppColors.success : AppColors.accent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (connected) ...[
              const Icon(Icons.check, color: Colors.white, size: 15),
              const SizedBox(width: 4),
            ],
            Text(
              connected ? 'Connected' : 'Connect',
              style: AppTextStyles.caption.copyWith(
                color: connected ? Colors.white : AppColors.onAccent,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
