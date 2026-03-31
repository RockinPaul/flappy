import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Authentication state for the app.
///
/// Will be expanded in Phase 2 to support QR auth, challenge-response,
/// and secret key restore flows.
class AuthState {
  const AuthState({
    this.isAuthenticated = false,
    this.token,
    this.secret,
  });

  final bool isAuthenticated;
  final String? token;
  final String? secret;

  AuthState copyWith({
    bool? isAuthenticated,
    String? token,
    String? secret,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      token: token ?? this.token,
      secret: secret ?? this.secret,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  Future<void> login({required String token, required String secret}) async {
    // TODO: Store credentials securely (flutter_secure_storage)
    state = AuthState(isAuthenticated: true, token: token, secret: secret);
  }

  Future<void> logout() async {
    // TODO: Clear secure storage
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
