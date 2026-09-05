import 'package:equatable/equatable.dart';

/// Represents a domain-level Auth User entity abstraction.
class AuthUser extends Equatable {
  final String id;
  final String email;
  final String? name;
  final bool isEmailVerified;

  const AuthUser({
    required this.id,
    required this.email,
    this.name,
    this.isEmailVerified = false,
  });

  @override
  List<Object?> get props => [id, email, name, isEmailVerified];
}

/// Abstract representation of Authentication Failures mapped to friendly user messages.
abstract class AuthFailure extends Equatable {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure()
      : super('Email or password is incorrect.');
}

class EmailNotConfirmedFailure extends AuthFailure {
  const EmailNotConfirmedFailure()
      : super('Please verify your email before signing in.');
}

class UserAlreadyExistsFailure extends AuthFailure {
  const UserAlreadyExistsFailure()
      : super('An account already exists with this email.');
}

class WeakPasswordFailure extends AuthFailure {
  const WeakPasswordFailure()
      : super('Password must be at least 6 characters long.');
}

class NetworkFailure extends AuthFailure {
  const NetworkFailure()
      : super('Unable to connect. Please check your internet connection.');
}

class UnknownAuthFailure extends AuthFailure {
  const UnknownAuthFailure([String? message])
      : super(message ?? 'Something went wrong. Please try again.');
}
