import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

/// Thin wrapper over `share_plus` so screens don't touch the SDK directly.
///
/// Opens the OS share sheet with [message]. The origin rect is derived from the
/// calling widget's render box, which iPad needs to anchor the share popover
/// (harmless everywhere else).
class AppShare {
  const AppShare._();

  static Future<void> text(
    BuildContext context,
    String message, {
    String? subject,
  }) async {
    final box = context.findRenderObject() as RenderBox?;
    final origin = (box != null && box.hasSize)
        ? box.localToGlobal(Offset.zero) & box.size
        : null;
    await SharePlus.instance.share(
      ShareParams(text: message, subject: subject, sharePositionOrigin: origin),
    );
  }
}
