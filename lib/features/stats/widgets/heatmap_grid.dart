import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// GitHub-style activity heatmap (days × weeks). Intensities are placeholder
/// values passed in by the screen; purely presentational.
class HeatmapGrid extends StatelessWidget {
  final int weeks;
  final int days;
  final List<int> intensities; // 0-4, length == weeks*days

  const HeatmapGrid({
    super.key,
    this.weeks = 15,
    this.days = 7,
    required this.intensities,
  });

  Color _cellColor(int level) {
    if (level <= 0) return AppColors.surface;
    return AppColors.accentBlue.withOpacity(0.25 + level * 0.18);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 4.0;
        final cell = (constraints.maxWidth - gap * (weeks - 1)) / weeks;
        return Column(
          children: [
            for (int d = 0; d < days; d++)
              Padding(
                padding: EdgeInsets.only(bottom: d == days - 1 ? 0 : gap),
                child: Row(
                  children: [
                    for (int w = 0; w < weeks; w++)
                      Padding(
                        padding:
                            EdgeInsets.only(right: w == weeks - 1 ? 0 : gap),
                        child: Container(
                          width: cell,
                          height: cell,
                          decoration: BoxDecoration(
                            color: _cellColor(intensities[w * days + d]),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
