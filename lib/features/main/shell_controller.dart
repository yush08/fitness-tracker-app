import 'package:flutter/foundation.dart';

import '../../shared/widgets/app_bottom_nav.dart';

/// Holds the selected dashboard tab so any screen can switch tabs
/// (e.g. Home's "View All" jumps to Stats). Plain [ValueNotifier], no package.
class ShellController {
  ShellController._();

  static final ValueNotifier<int> index = ValueNotifier<int>(0);

  static void go(int i) => index.value = i;
  static void goTo(AppTab tab) => index.value = tab.index;
}
