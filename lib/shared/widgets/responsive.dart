import 'package:flutter/material.dart';

/// Caps body content to a comfortable reading width and centres it, so the
/// app's phone layout doesn't stretch edge-to-edge on tablets, foldables and
/// web. On a phone it's a no-op (the screen is narrower than [maxWidth]); on a
/// wide screen the columns stay the same size and gain side margins instead of
/// ballooning.
class MaxWidthBody extends StatelessWidget {
  const MaxWidthBody({
    super.key,
    required this.child,
    this.maxWidth = 560,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    // NOTE: inside a vertical scroll view the child gets an unbounded height.
    // A bare `Center`/`Align` shrink-wraps and can collapse the column, so we
    // cap width with a LayoutBuilder + symmetric padding instead — this keeps
    // the scroll child full-height and simply insets it on wide screens.
    return LayoutBuilder(
      builder: (context, constraints) {
        final overflow = constraints.maxWidth - maxWidth;
        final inset = overflow > 0 ? overflow / 2 : 0.0;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: inset),
          child: child,
        );
      },
    );
  }
}

/// Small responsive helpers keyed off the shortest screen edge, so spacing and
/// type breathe a touch on large phones and tablets without a full breakpoint
/// system. Clamped so tiny phones never shrink below the design and tablets
/// never blow the layout up.
extension ResponsiveContext on BuildContext {
  double get _shortestSide => MediaQuery.of(this).size.shortestSide;

  /// True on tablet-class widths — use to opt into roomier layouts.
  bool get isWide => _shortestSide >= 600;

  /// Multiplier (0.95–1.15) to gently scale a base dimension with screen size.
  double get sizeScale => (_shortestSide / 390).clamp(0.95, 1.15);

  /// Scale a base logical-pixel value by [sizeScale].
  double scaled(double base) => base * sizeScale;
}
