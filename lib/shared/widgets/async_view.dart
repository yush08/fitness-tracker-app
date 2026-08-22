import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/text_styles.dart';

/// Renders a [Stream] with consistent loading / error / empty / data states,
/// cross-fading between them so data never "pops" in. Used by the live screens
/// (feed, meals, home summary) so they all load with the same smooth motion.
class AsyncView<T> extends StatelessWidget {
  final Stream<T> stream;
  final Widget Function(T data) builder;

  /// Optional: when the data is empty, show [empty] instead of [builder].
  final bool Function(T data)? isEmpty;
  final Widget? empty;
  final Widget? loading;

  const AsyncView({
    super.key,
    required this.stream,
    required this.builder,
    this.isEmpty,
    this.empty,
    this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        final Widget child;
        if (snapshot.hasError) {
          child = _Message(
            key: const ValueKey('error'),
            icon: Icons.cloud_off_rounded,
            text: 'Could not load. Check your connection.',
          );
        } else if (!snapshot.hasData) {
          child = loading ??
              const Padding(
                key: ValueKey('loading'),
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: SizedBox(
                    width: 26,
                    height: 26,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              );
        } else {
          final data = snapshot.data as T;
          if (isEmpty != null && isEmpty!(data) && empty != null) {
            child = KeyedSubtree(key: const ValueKey('empty'), child: empty!);
          } else {
            child = KeyedSubtree(key: const ValueKey('data'), child: builder(data));
          }
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: child,
        );
      },
    );
  }
}

/// A centred icon + line of text, used for the empty and error states.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String text;

  const EmptyState({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) =>
      _Message(icon: icon, text: text);
}

class _Message extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Message({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.textMuted, size: 34),
          const SizedBox(height: 12),
          Text(
            text,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}
