import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthState;

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Checks current Supabase session on application startup.
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Dispatched when user submits the login form.
class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Dispatched when user submits registration form.
class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;

  const AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object?> get props => [email, password, name];
}

/// Dispatched when user requests password reset.
class AuthPasswordResetRequested extends AuthEvent {
  final String email;

  const AuthPasswordResetRequested(this.email);

  @override
  List<Object?> get props => [email];
}

/// Dispatched when user requests sign out.
class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

/// Internal event fired when Supabase auth state stream emits a change.
class AuthSessionStateChanged extends AuthEvent {
  final AuthState sessionState;

  const AuthSessionStateChanged(this.sessionState);

  @override
  List<Object?> get props => [sessionState];
}
