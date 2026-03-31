/// App environment configuration.
///
/// Mirrors the APP_ENV system from the React Native app with
/// dev / preview / production variants.
enum AppEnvironment { development, preview, production }

class AppConfig {
  const AppConfig._({
    required this.environment,
    required this.serverUrl,
    required this.appName,
  });

  final AppEnvironment environment;
  final String serverUrl;
  final String appName;

  bool get isDevelopment => environment == AppEnvironment.development;
  bool get isPreview => environment == AppEnvironment.preview;
  bool get isProduction => environment == AppEnvironment.production;

  static const development = AppConfig._(
    environment: AppEnvironment.development,
    serverUrl: 'https://dev.happy.engineering',
    appName: 'Happy Dev',
  );

  static const preview = AppConfig._(
    environment: AppEnvironment.preview,
    serverUrl: 'https://preview.happy.engineering',
    appName: 'Happy Preview',
  );

  static const production = AppConfig._(
    environment: AppEnvironment.production,
    serverUrl: 'https://happy.engineering',
    appName: 'Happy Coder',
  );

  /// Resolve config from build-time flavor or const string.
  static AppConfig fromEnvironment([String env = const String.fromEnvironment('APP_ENV', defaultValue: 'development')]) {
    switch (env) {
      case 'production':
        return production;
      case 'preview':
        return preview;
      default:
        return development;
    }
  }
}
