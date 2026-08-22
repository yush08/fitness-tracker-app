import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Circular user avatar: the account photo when there is one, otherwise the
/// person's initials on a colour derived from their name (so every user gets a
/// stable, distinct tint instead of an anonymous grey silhouette).
class UserAvatar extends StatelessWidget {
  final String? name;
  final String? photoUrl;
  final double radius;

  const UserAvatar({
    super.key,
    required this.name,
    this.photoUrl,
    this.radius = 22,
  });

  static final List<Color> _palette = [
    AppColors.accentBlue,
    AppColors.violet,
    AppColors.chartRed,
    AppColors.chartGreen,
    AppColors.chartYellow,
    AppColors.accent,
  ];

  String get _initials {
    final parts = (name ?? '')
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }

  Color get _tint {
    final key = (name ?? '').trim();
    if (key.isEmpty) return AppColors.surface;
    return _palette[key.codeUnits.fold(0, (a, b) => a + b) % _palette.length];
  }

  @override
  Widget build(BuildContext context) {
    final url = photoUrl?.trim() ?? '';
    if (url.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.surface,
        backgroundImage: NetworkImage(url),
        // If the image fails to load, the coloured initials show through.
        onBackgroundImageError: (_, _) {},
        child: _initials.isEmpty
            ? Icon(Icons.person, size: radius, color: AppColors.textSecondary)
            : null,
      );
    }

    final initials = _initials;
    return CircleAvatar(
      radius: radius,
      backgroundColor: initials.isEmpty ? AppColors.surface : _tint,
      child: initials.isEmpty
          ? Icon(Icons.person,
              size: radius, color: AppColors.textSecondary)
          : Text(
              initials,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: radius * 0.8,
              ),
            ),
    );
  }
}
