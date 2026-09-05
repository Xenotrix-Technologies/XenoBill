import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import '../../domain/entities/business.dart';
import '../database/drift_database.dart';
import '../mappers/business_mapper.dart';

abstract class BusinessLocalDataSource {
  Stream<Business?> watchCurrentBusiness();
  Stream<Business?> watchBusinessById(String id);
  Future<Business?> getCurrentBusiness();
  Future<Business?> getBusinessById(String id);
  Future<void> saveBusiness(
    Business business, {
    String syncStatus = 'synced',
    DateTime? lastSyncedAt,
    String? syncError,
  });
  Future<List<Business>> getPendingSyncBusinesses();
  Future<void> updateSyncStatus(
    String id,
    String status, {
    DateTime? lastSyncedAt,
    String? syncError,
  });
  Future<void> deleteBusiness(String id);
}

class BusinessLocalDataSourceImpl implements BusinessLocalDataSource {
  final BusinessDao _dao;

  BusinessLocalDataSourceImpl({BusinessDao? dao, AppDriftDatabase? db})
      : _dao = dao ?? (db ?? AppDriftDatabase()).businessDao;

  @override
  Stream<Business?> watchCurrentBusiness() {
    return _dao.watchCurrentBusiness().map((row) {
      if (row == null) return null;
      return BusinessMapper.fromDrift(row);
    });
  }

  @override
  Stream<Business?> watchBusinessById(String id) {
    return _dao.watchBusinessById(id).map((row) {
      if (row == null) return null;
      return BusinessMapper.fromDrift(row);
    });
  }

  @override
  Future<Business?> getCurrentBusiness() async {
    final row = await _dao.getCurrentBusiness();
    if (row == null) return null;
    return BusinessMapper.fromDrift(row);
  }

  @override
  Future<Business?> getBusinessById(String id) async {
    final row = await _dao.getBusiness(id);
    if (row == null) return null;
    return BusinessMapper.fromDrift(row);
  }

  @override
  Future<void> saveBusiness(
    Business business, {
    String syncStatus = 'synced',
    DateTime? lastSyncedAt,
    String? syncError,
  }) async {
    debugPrint('[BusinessLocalDataSource] Upserting business to Drift: ${business.id} ($syncStatus)');
    final companion = BusinessMapper.toDriftCompanion(
      business,
      syncStatus: syncStatus,
      lastSyncedAt: lastSyncedAt,
      syncError: syncError,
    );
    await _dao.upsertBusiness(companion);
  }

  @override
  Future<List<Business>> getPendingSyncBusinesses() async {
    final all = await _dao.select(_dao.businessTable).get();
    return all
        .where((row) => row.syncStatus == 'pending')
        .map((row) => BusinessMapper.fromDrift(row))
        .toList();
  }

  @override
  Future<void> updateSyncStatus(
    String id,
    String status, {
    DateTime? lastSyncedAt,
    String? syncError,
  }) async {
    final existing = await _dao.getBusiness(id);
    if (existing != null) {
      final companion = BusinessTableCompanion(
        id: Value(id),
        syncStatus: Value(status),
        lastSyncedAt: Value(lastSyncedAt ?? existing.lastSyncedAt),
        syncError: Value(syncError),
      );
      await _dao.updateBusinessRecord(companion);
    }
  }

  @override
  Future<void> deleteBusiness(String id) async {
    await _dao.deleteBusiness(id);
  }
}
