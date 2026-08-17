import 'package:flutter/material.dart';

/// One contiguous block of a [SegmentedBar].
class BarSegment {
  final int flex;
  final Color color;
  const BarSegment(this.flex, this.color);
}

/// Horizontal rounded bar split into proportional coloured segments
/// (e.g. the sleep Awake/Light/Deep timeline).
class SegmentedBar extends StatelessWidget {
  final List<BarSegment> segments;
  final double height;

  /// Left-to-right reveal duration. Set to [Duration.zero] to disable.
  final Duration duration;

  const SegmentedBar({
    super.key,
    required this.segments,
    this.height = 46,
    this.duration = const Duration(milliseconds: 800),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: duration,
        curve: Curves.easeOutCubic,
        builder: (context, t, child) => ClipRect(
          child: Align(
            alignment: Alignment.centerLeft,
            widthFactor: t,
            child: child,
          ),
        ),
        child: SizedBox(
          height: height,
          child: Row(
            children: [
              for (final s in segments)
                Expanded(flex: s.flex, child: Container(color: s.color)),
            ],
          ),
        ),
      ),
    );
  }
}
