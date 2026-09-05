import 'package:flutter_test/flutter_test.dart';
import 'package:xenobill_flutter/infrastructure/authentication/auth_service.dart';

void main() {
  group('AuthUser & AuthFailure Unit Tests', () {
    test('AuthUser properties and equality', () {
      const user1 = AuthUser(
        id: 'user_123',
        email: 'test@example.com',
        name: 'John Doe',
        isEmailVerified: true,
      );

      const user2 = AuthUser(
        id: 'user_123',
        email: 'test@example.com',
        name: 'John Doe',
        isEmailVerified: true,
      );

      expect(user1, equals(user2));
      expect(user1.id, 'user_123');
      expect(user1.email, 'test@example.com');
      expect(user1.isEmailVerified, isTrue);
    });

    test('AuthFailure user-friendly error messages', () {
      const invalidCreds = InvalidCredentialsFailure();
      expect(invalidCreds.message, 'Email or password is incorrect.');

      const emailNotConfirmed = EmailNotConfirmedFailure();
      expect(emailNotConfirmed.message, 'Please verify your email before signing in.');

      const networkFailure = NetworkFailure();
      expect(networkFailure.message, 'Unable to connect. Please check your internet connection.');

      const userExists = UserAlreadyExistsFailure();
      expect(userExists.message, 'An account already exists with this email.');
    });
  });
}
