import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/business.dart';
import '../datasources/business_local_data_source.dart';
import '../datasources/business_remote_data_source.dart';
import '../supabase/supabase_client.dart';

class BusinessSyncService {
  final BusinessLocalDataSource _localDataSource;
  final BusinessRemoteDataSource? _customRemoteDataSource;
  final SupabaseClient? _customSupabaseClient;

  BusinessSyncService({
    BusinessLocalDataSource? localDataSource,
    BusinessRemoteDataSource? remoteDataSource,
    SupabaseClient? supabaseClient,
  })  : _localDataSource = localDataSource ?? BusinessLocalDataSourceImpl(),
        _customRemoteDataSource = remoteDataSource,
        _customSupabaseClient = supabaseClient;

  BusinessRemoteDataSource get _remoteDataSource =>
      _customRemoteDataSource ?? BusinessRemoteDataSourceImpl();

  SupabaseClient get _supabaseClient =>
      _customSupabaseClient ?? SupabaseClientManager.instance.client;

  /// Runs initial synchronization on application startup.
  ///
  /// Safe for offline mode: if network/Supabase is unavailable,
  /// logs error and permits UI to read existing cached Drift records.
  Future<void> syncOnAppStart() async {
    final user = _supabaseClient.auth.currentUser;
    if (user == null) {
      debugPrint('[BusinessSyncService] No authenticated user. Skipping cloud sync.');
      return;
    }

    try {
      debugPrint('[BusinessSyncService] Starting sync for user: ${user.id}');
      
      // 1. Get or create Supabase Account UUID
      final accountId = await _remoteDataSource.getOrCreateAccountId(user.id);

      // 2. Push any pending local Drift modifications first
      await pushPendingLocalChanges(accountId);

      // 3. Fetch primary business from Supabase
      final remoteBiz = await _remoteDataSource.fetchPrimaryBusiness(accountId);

      if (remoteBiz != null) {
        final localBiz = await _localDataSource.getBusinessById(remoteBiz.id);

        if (localBiz == null) {
          // Store remote business into Drift
          await _localDataSource.saveBusiness(
            remoteBiz.copyWith(accountId: accountId),
            syncStatus: 'synced',
            lastSyncedAt: DateTime.now(),
          );
        } else {
          // Conflict Resolution: compare timestamps
          final localTime = localBiz.clientUpdatedAt ?? localBiz.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final remoteTime = remoteBiz.updatedAt ?? remoteBiz.clientUpdatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);

          if (remoteTime.isAfter(localTime) && localBiz.syncStatus != 'pending') {
            debugPrint('[BusinessSyncService] Supabase version is newer. Updating Drift.');
            await _localDataSource.saveBusiness(
              remoteBiz.copyWith(accountId: accountId),
              syncStatus: 'synced',
              lastSyncedAt: DateTime.now(),
            );
          } else if (localBiz.syncStatus == 'pending') {
            debugPrint('[BusinessSyncService] Local version has pending changes. Uploading to Supabase.');
            final updatedRemote = await _remoteDataSource.updateBusinessRemote(localBiz, accountId);
            await _localDataSource.saveBusiness(
              updatedRemote.copyWith(accountId: accountId),
              syncStatus: 'synced',
              lastSyncedAt: DateTime.now(),
            );
          }
        }
      }

      debugPrint('[BusinessSyncService] Sync completed successfully.');
    } on SocketException catch (e) {
      debugPrint('[BusinessSyncService] Device offline ($e). Using cached Drift database.');
    } on AuthException catch (e) {
      debugPrint('[BusinessSyncService] Auth error during sync: ${e.message}');
    } catch (e, stackTrace) {
      debugPrint('[BusinessSyncService] Unexpected error during sync: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  /// Pushes all locally created or modified records marked as 'pending' to Supabase.
  Future<void> pushPendingLocalChanges(String accountId) async {
    final pendingList = await _localDataSource.getPendingSyncBusinesses();
    if (pendingList.isEmpty) return;

    debugPrint('[BusinessSyncService] Found ${pendingList.length} pending local records to push.');

    for (final localBiz in pendingList) {
      try {
        final syncedRemote = await _remoteDataSource.updateBusinessRemote(localBiz, accountId);
        await _localDataSource.saveBusiness(
          syncedRemote.copyWith(accountId: accountId),
          syncStatus: 'synced',
          lastSyncedAt: DateTime.now(),
        );
      } catch (e) {
        debugPrint('[BusinessSyncService] Failed to push local business ${localBiz.id}: $e');
        await _localDataSource.updateSyncStatus(
          localBiz.id,
          'failed',
          syncError: e.toString(),
        );
      }
    }
  }

  /// Saves a business locally into Drift immediately (local-first write)
  /// and queues background sync to Supabase.
  Future<void> saveLocalAndSyncCloud(Business business) async {
    final now = DateTime.now();
    final updatedBiz = business.copyWith(clientUpdatedAt: now);

    // 1. Write to Drift database immediately (UI updates reactively)
    await _localDataSource.saveBusiness(
      updatedBiz,
      syncStatus: 'pending',
    );

    // 2. Attempt background upload to Supabase
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user != null) {
        final accountId = await _remoteDataSource.getOrCreateAccountId(user.id);
        final syncedRemote = await _remoteDataSource.createBusinessRemote(updatedBiz, accountId);

        // Update Drift record as synced
        await _localDataSource.saveBusiness(
          syncedRemote.copyWith(accountId: accountId),
          syncStatus: 'synced',
          lastSyncedAt: DateTime.now(),
        );
        debugPrint('[BusinessSyncService] Cloud sync completed successfully for: ${business.id}');
      }
    } catch (e) {
      debugPrint('[BusinessSyncService] Cloud upload deferred/failed (offline mode): $e');
      await _localDataSource.updateSyncStatus(
        business.id,
        'pending',
        syncError: e.toString(),
      );
    }
  }
}
