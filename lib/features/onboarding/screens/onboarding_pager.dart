import 'package:flutter/material.dart';

import 'onboarding_screen.dart';
import 'onboarding_screen_2.dart';
import 'onboarding_screen_3.dart';

/// Hosts the three onboarding pages in a swipeable [PageView].
///
/// You can drag between pages, and each page's "Continue" button animates the
/// pager forward via its `onNext` callback — so the button and the swipe share
/// one motion instead of the buttons pushing separate routes.
///
/// Rather than a flat slide, each page is transformed by its live distance from
/// the viewport centre: the leaving page eases back (scales down + dims) while
/// the arriving one settles forward, so the swipe reads as layered depth. A
/// soft backdrop sits behind the pages so the brief seam never flashes black.
class OnboardingPager extends StatefulWidget {
  const OnboardingPager({super.key});

  @override
  State<OnboardingPager> createState() => _OnboardingPagerState();
}

class _OnboardingPagerState extends State<OnboardingPager> {
  final _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    _controller.nextPage(
      duration: const Duration(milliseconds: 480),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      OnboardingScreen(onNext: _next),
      NextOnboardingScreen(onNext: _next),
      const OnboardingScreen3(),
    ];

    return Container(
      // Sits behind the pages; only visible in the hair-thin seam mid-swipe,
      // tinted to the onboarding palette so it never flashes black.
      color: const Color(0xFF9385D8),
      child: PageView.builder(
        controller: _controller,
        physics: const BouncingScrollPhysics(),
        itemCount: pages.length,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              // Signed distance of this page from the viewport centre:
              // 0 = centred, +1 = one page right, -1 = one page left.
              double delta = 0;
              if (_controller.position.hasContentDimensions &&
                  _controller.position.hasPixels) {
                delta = (_controller.page ?? index.toDouble()) - index;
              }
              final d = delta.abs().clamp(0.0, 1.0);

              // Most of the change happens near the centre for a soft settle.
              final e = Curves.easeOut.transform(d);
              final scale = 1 - e * 0.06; // recede a touch as it leaves
              final opacity = 1 - e * 0.30; // dim a touch as it leaves

              return Opacity(
                opacity: opacity,
                child: Transform.scale(scale: scale, child: child),
              );
            },
            child: pages[index],
          );
        },
      ),
    );
  }
}
