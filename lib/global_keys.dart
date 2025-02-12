
import 'package:flutter/material.dart';

sealed class GlobalKeys {
  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  static final navigatorKey = GlobalKey<NavigatorState>();
  static final ValueNotifier<Brightness> themeNotifier = ValueNotifier(Brightness.light);

  static ColorScheme? get colorScheme => navigatorKey.currentContext == null ? null : Theme.of(navigatorKey.currentContext!).colorScheme;
}
