import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme.dart';
import 'router.dart';

/// Root application widget.
class HappyApp extends ConsumerWidget {
  const HappyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Replace with auth state from provider
    const isAuthenticated = false;

    final router = buildRouter(isAuthenticated: isAuthenticated);

    return MaterialApp.router(
      title: 'Happy Coder',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
