import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_client.dart';

/// Low-level authentication service interacting directly with [SupabaseClient.auth].
class SupabaseAuthService {
  final SupabaseClient _client;

  SupabaseAuthService({SupabaseClient? client})
      : _client = client ?? SupabaseClientManager.instance.client;

  /// Returns the current active [Session] if present.
  Session? get currentSession => _client.auth.currentSession;

  /// Returns the current active [User] if present.
  User? get currentUser => _client.auth.currentUser;

  /// Stream of Supabase [AuthState] change events.
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  /// Checks if current user's email is confirmed.
  bool get isEmailVerified {
    final user = currentUser;
    if (user == null) return false;
    return user.emailConfirmedAt != null;
  }

  /// Authenticates user with email & password.
  Future<AuthResponse> signInWithPassword({
    required String email,
    required String password,
  }) async {
    debugPrint('[SupabaseAuthService] Signing in user: $email');
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Registers a new user with email & password.
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    debugPrint('[SupabaseAuthService] Registering user: $email');
    return await _client.auth.signUp(
      email: email,
      password: password,
      data: data,
    );
  }

  /// Triggers a password reset email for [email].
  Future<void> resetPasswordForEmail(String email, {String? redirectTo}) async {
    debugPrint('[SupabaseAuthService] Triggering password reset for: $email');
    await _client.auth.resetPasswordForEmail(
      email,
      redirectTo: redirectTo,
    );
  }

  /// Signs out the current active session.
  Future<void> signOut() async {
    debugPrint('[SupabaseAuthService] Signing out current user.');
    await _client.auth.signOut();
  }
}
