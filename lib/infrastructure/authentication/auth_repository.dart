import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthUser;
import 'package:xenobill_flutter/infrastructure/supabase/supabase_client.dart';
import '../supabase/supabase_auth_service.dart';
import 'auth_service.dart';


abstract class AuthRepository {
  AuthUser? get currentUser;
  Session? get currentSession;
  Stream<AuthState> get authStateChanges;
  bool get isEmailVerified;

  Future<AuthUser> signInWithPassword({
    required String email,
    required String password,
  });

  Future<AuthUser?> signUp({
    required String email,
    required String password,
    String? name,
    String? phone,
    String? whatsappNumber,
    String? businessName,
    String? businessType,
    String? addressLine1,
    String? addressLine2,
  });

  Future<bool> isEmailRegistered(String email);

  Future<void> resetPassword(String email);
  Future<void> signOut();
}

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseAuthService _authService;

  AuthRepositoryImpl({SupabaseAuthService? authService})
      : _authService = authService ?? SupabaseAuthService();

  @override
  AuthUser? get currentUser {
    final user = _authService.currentUser;
    if (user == null) return null;
    return _mapSupabaseUserToAuthUser(user);
  }

  @override
  Session? get currentSession => _authService.currentSession;

  @override
  Stream<AuthState> get authStateChanges => _authService.authStateChanges;

  @override
  bool get isEmailVerified => _authService.isEmailVerified;

  @override
  Future<AuthUser> signInWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authService.signInWithPassword(
        email: email.trim(),
        password: password,
      );

      final user = response.user;
      if (user == null) {
        throw const InvalidCredentialsFailure();
      }

      return _mapSupabaseUserToAuthUser(user);
    } on AuthException catch (e) {
      debugPrint('[AuthRepository] AuthException: ${e.message} (status: ${e.statusCode})');
      final msg = e.message.toLowerCase();
      if (msg.contains('invalid login credentials') || msg.contains('invalid credentials')) {
        throw const InvalidCredentialsFailure();
      } else if (msg.contains('email not confirmed')) {
        throw const EmailNotConfirmedFailure();
      } else {
        throw UnknownAuthFailure(e.message);
      }
    } on SocketException catch (e) {
      debugPrint('[AuthRepository] SocketException: $e');
      throw const NetworkFailure();
    } catch (e) {
      if (e is AuthFailure) rethrow;
      debugPrint('[AuthRepository] Unexpected Auth Error: $e');
      throw const UnknownAuthFailure();
    }
  }

  @override
  Future<AuthUser?> signUp({
    required String email,
    required String password,
    String? name,
    String? phone,
    String? whatsappNumber,
    String? businessName,
    String? businessType,
    String? addressLine1,
    String? addressLine2,
  }) async {
    try {
      final metaData = <String, dynamic>{};
      if (name != null && name.trim().isNotEmpty) {
        metaData['full_name'] = name.trim();
        metaData['owner_name'] = name.trim();
      }
      if (phone != null && phone.trim().isNotEmpty) {
        metaData['phone'] = phone.trim();
      }
      if (whatsappNumber != null && whatsappNumber.trim().isNotEmpty) {
        metaData['whatsapp_number'] = whatsappNumber.trim();
      }
      if (businessName != null && businessName.trim().isNotEmpty) {
        metaData['business_name'] = businessName.trim();
      }
      if (businessType != null && businessType.trim().isNotEmpty) {
        metaData['business_type'] = businessType.trim();
      }
      if (addressLine1 != null && addressLine1.trim().isNotEmpty) {
        metaData['address_line_1'] = addressLine1.trim();
      }
      if (addressLine2 != null && addressLine2.trim().isNotEmpty) {
        metaData['address_line_2'] = addressLine2.trim();
      }

      final response = await _authService.signUp(
        email: email.trim(),
        password: password,
        data: metaData.isNotEmpty ? metaData : null,
      );

      final user = response.user;
      if (user == null) {
        return null;
      }

      return _mapSupabaseUserToAuthUser(user);
    } on AuthException catch (e) {
      debugPrint('[AuthRepository] AuthException during signup: ${e.message}');
      final msg = e.message.toLowerCase();
      if (msg.contains('already registered') || msg.contains('user already exists')) {
        throw const UserAlreadyExistsFailure();
      } else if (msg.contains('password should be at least')) {
        throw const WeakPasswordFailure();
      } else if (msg.contains('rate limit')) {
        throw const UnknownAuthFailure(
          'Email rate limit exceeded. Please wait a few minutes before trying again, or disable "Confirm Email" in your Supabase Auth settings during development.',
        );
      } else {
        throw UnknownAuthFailure(e.message);
      }
    } on SocketException catch (e) {
      debugPrint('[AuthRepository] SocketException: $e');
      throw const NetworkFailure();
    } catch (e) {
      if (e is AuthFailure) rethrow;
      debugPrint('[AuthRepository] Unexpected SignUp Error: $e');
      throw const UnknownAuthFailure();
    }
  }

  @override
  Future<bool> isEmailRegistered(String email) async {
    final cleanEmail = email.trim().toLowerCase();
    if (cleanEmail.isEmpty) return false;

    try {
      final client = SupabaseClientManager.instance.client;
      try {
        final rpcRes = await client.rpc('check_email_exists', params: {'p_email': cleanEmail});
        if (rpcRes is bool) return rpcRes;
      } catch (_) {}

      final res = await client
          .from('accounts')
          .select('id')
          .eq('email', cleanEmail)
          .maybeSingle();

      return res != null;
    } catch (e) {
      debugPrint('[AuthRepository] Error checking email existence: $e');
      return false;
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _authService.resetPasswordForEmail(email.trim());
    } on AuthException catch (e) {
      debugPrint('[AuthRepository] AuthException during resetPassword: ${e.message}');
      throw UnknownAuthFailure(e.message);
    } on SocketException {
      throw const NetworkFailure();
    } catch (e) {
      if (e is AuthFailure) rethrow;
      throw const UnknownAuthFailure();
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      debugPrint('[AuthRepository] Error signing out: $e');
    }
  }

  AuthUser _mapSupabaseUserToAuthUser(User user) {
    final metadata = user.userMetadata ?? {};
    final fullName = metadata['full_name'] as String? ?? metadata['name'] as String?;

    return AuthUser(
      id: user.id,
      email: user.email ?? '',
      name: fullName,
      isEmailVerified: user.emailConfirmedAt != null,
    );
  }
}
