import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:xenobill_flutter/domain/entities/business.dart';
import 'package:xenobill_flutter/domain/entities/business_type.dart';
import 'package:xenobill_flutter/infrastructure/database/drift_database.dart';
import 'package:xenobill_flutter/infrastructure/datasources/business_local_data_source.dart';
import 'package:xenobill_flutter/infrastructure/mappers/business_mapper.dart';
import 'package:xenobill_flutter/infrastructure/repositories/repository_impls.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift/drift.dart' hide isNotNull;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDriftDatabase db;
  late BusinessLocalDataSource localDataSource;
  late BusinessRepositoryImpl repository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    db = AppDriftDatabase(NativeDatabase.memory());
    localDataSource = BusinessLocalDataSourceImpl(db: db);
    repository = BusinessRepositoryImpl(localDataSource: localDataSource);
  });

  tearDown(() async {
    await db.close();
  });

  group('Drift Business Data Architecture Tests', () {
    final sampleBusiness = Business(
      id: 'biz_123',
      accountId: 'acc_456',
      name: 'Xenobiz Retail Store',
      businessType: BusinessType.retail,
      phone: '9876543210',
      alternatePhone: '9876543211',
      email: 'owner@xenobiz.com',
      address: '123 Tech Street',
      city: 'Bengaluru',
      state: 'Karnataka',
      country: 'India',
      pinCode: '560001',
      gstRegistrationType: 'Regular',
      gstEnabled: true,
      gstin: '29ABCDE1234F1Z5',
      pan: 'ABCDE1234F',
      currency: '₹',
      invoicePrefix: 'XB',
      nextInvoiceNumber: 1005,
      logoUrl: 'https://example.com/logo.png',
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 9, 5),
      clientUpdatedAt: DateTime(2026, 9, 5),
      syncStatus: 'local',
    );

    test('Local First Architecture: UI reads business directly from Drift stream', () async {
      // Save business to Drift
      await localDataSource.saveBusiness(sampleBusiness, syncStatus: 'local');

      // Watch current business stream from Drift
      final currentBizStream = repository.watchCurrentBusiness();

      expect(currentBizStream, emits(isA<Business>()));

      final retrieved = await localDataSource.getCurrentBusiness();
      expect(retrieved, isNotNull);
      expect(retrieved!.id, equals('biz_123'));
      expect(retrieved.name, equals('Xenobiz Retail Store'));
      expect(retrieved.phone, equals('9876543210'));
      expect(retrieved.city, equals('Bengaluru'));
      expect(retrieved.gstin, equals('29ABCDE1234F1Z5'));
    });

    test('Local-First Save: Updating business saves data in Drift', () async {
      final updatedBusiness = sampleBusiness.copyWith(
        name: 'Xenobiz Supermarket Updated',
        phone: '9999999999',
      );

      // Perform local update
      await repository.updateBusiness(updatedBusiness);

      // Verify that data is saved immediately in Drift
      final retrieved = await localDataSource.getCurrentBusiness();
      expect(retrieved, isNotNull);
      expect(retrieved!.name, equals('Xenobiz Supermarket Updated'));
      expect(retrieved.phone, equals('9999999999'));
    });

    test('BusinessMapper: Conversion between Domain and Drift Companion', () {
      final companion = BusinessMapper.toDriftCompanion(
        sampleBusiness,
        syncStatus: 'local',
        syncError: null,
      );
      expect(companion.id.value, equals('biz_123'));
      expect(companion.businessName.value, equals('Xenobiz Retail Store'));
      expect(companion.syncStatus.value, equals('local'));
    });
  });
}
