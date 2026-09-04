import 'package:flutter_test/flutter_test.dart';
import 'package:xenobill_flutter/infrastructure/database/app_database.dart';

void main() {
  group('Demo Mode Tests', () {
    test('loadDemoData initializes demo state, business, and sample items correctly', () {
      final db = AppDatabase.instance;
      db.loadDemoData();

      expect(db.isDemoMode, isTrue);
      expect(db.isLoggedIn, isTrue);
      expect(db.isBusinessConfigured, isTrue);
      expect(db.currentBusiness, isNotNull);
      expect(db.currentBusiness?.name, equals('Demo Store & Services'));
      expect(db.items.isNotEmpty, isTrue);
    });
  });
}
