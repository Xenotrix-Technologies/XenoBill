import 'package:equatable/equatable.dart';
import '../../infrastructure/authentication/auth_service.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class Authenticated extends AuthState {
  final AuthUser user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}

class EmailVerificationRequired extends AuthState {
  final String email;

  const EmailVerificationRequired(this.email);

  @override
  List<Object?> get props => [email];
}

class AuthenticationError extends AuthState {
  final String message;

  const AuthenticationError(this.message);

  @override
  List<Object?> get props => [message];
}

class PasswordResetEmailSent extends AuthState {
  final String email;

  const PasswordResetEmailSent(this.email);

  @override
  List<Object?> get props => [email];
}
