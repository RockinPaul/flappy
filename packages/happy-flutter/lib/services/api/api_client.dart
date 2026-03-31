import '../../core/config.dart';

/// Base API client for communicating with the Happy server.
///
/// Will be expanded in Phase 3 with all API endpoints
/// (sessions, messages, friends, artifacts, voice, etc.).
class ApiClient {
  ApiClient({required this.config});

  final AppConfig config;

  String get baseUrl => config.serverUrl;

  // TODO: Initialize Dio with auth interceptor, base URL, etc.
}
