import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Theme mode preference: light, dark, or system (adaptive).
///
/// Mirrors the themePreference from the React Native app's persistence layer.
final themeModeProvider = StateProvider<ThemeMode>((ref) {
  // Default to system/adaptive, same as the RN app
  return ThemeMode.system;
});
