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

  const SegmentedBar({super.key, required this.segments, this.height = 46});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: SizedBox(
        height: height,
        child: Row(
          children: [
            for (final s in segments)
              Expanded(flex: s.flex, child: Container(color: s.color)),
          ],
        ),
      ),
    );
  }
}
