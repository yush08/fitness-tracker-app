import 'package:flutter/material.dart';

/// A single logged meal shown in the Calorie Tracking list.
class Meal {
  final String name;
  final String subtitle;
  final int calories;
  final IconData icon;
  final Color iconColor;

  const Meal({
    required this.name,
    required this.subtitle,
    required this.calories,
    required this.icon,
    required this.iconColor,
  });
}
