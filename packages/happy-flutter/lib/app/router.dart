import 'package:go_router/go_router.dart';

import '../ui/auth/login_screen.dart';
import '../ui/sessions/home_screen.dart';
import '../ui/sessions/session_screen.dart';
import '../ui/settings/settings_screen.dart';

/// Route paths mirroring the Expo Router file-based routes.
class AppRoutes {
  const AppRoutes._();

  static const home = '/';
  static const login = '/login';
  static const restore = '/restore';
  static const restoreManual = '/restore/manual';
  static const session = '/session/:id';
  static const sessionInfo = '/session/:id/info';
  static const sessionFiles = '/session/:id/files';
  static const settings = '/settings';
  static const settingsAccount = '/settings/account';
  static const settingsAppearance = '/settings/appearance';
  static const settingsLanguage = '/settings/language';
  static const settingsVoice = '/settings/voice';
  static const friends = '/friends';
  static const friendsSearch = '/friends/search';
  static const inbox = '/inbox';
  static const artifacts = '/artifacts';
  static const newSession = '/new';
  static const changelog = '/changelog';
}

/// Build the [GoRouter] for the app.
///
/// [isAuthenticated] controls the initial redirect.
GoRouter buildRouter({required bool isAuthenticated}) {
  return GoRouter(
    initialLocation: isAuthenticated ? AppRoutes.home : AppRoutes.login,
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.session,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return SessionScreen(sessionId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    redirect: (context, state) {
      final loggingIn = state.matchedLocation == AppRoutes.login;
      if (!isAuthenticated && !loggingIn) return AppRoutes.login;
      if (isAuthenticated && loggingIn) return AppRoutes.home;
      return null;
    },
  );
}
