import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/business.dart';
import '../../domain/entities/business_type.dart';
import '../database/app_database.dart';
import '../datasources/business_local_data_source.dart';
import '../supabase/supabase_client.dart';

class BusinessSyncService {
  final BusinessLocalDataSource _localDataSource;

  BusinessSyncService({
    BusinessLocalDataSource? localDataSource,
  }) : _localDataSource = localDataSource ?? BusinessLocalDataSourceImpl();

  /// Runs cloud fetch and local setup on application startup or login.
  Future<void> syncOnAppStart() async {
    try {
      final user = SupabaseClientManager.instance.client.auth.currentUser;
      
      // 1. If logged in via Supabase, fetch account record from cloud public.accounts table
      if (user != null) {
        try {
          final res = await SupabaseClientManager.instance.client
              .from('accounts')
              .select('*')
              .eq('user_id', user.id)
              .maybeSingle();

          if (res != null) {
            final cloudBiz = Business.fromSupabaseJson(Map<String, dynamic>.from(res as Map));
            
            // Preserve local logoUrl if present in local Drift
            final existingLocal = await _localDataSource.getCurrentBusiness(accountId: user.id);
            final mergedBiz = cloudBiz.copyWith(
              logoUrl: cloudBiz.logoUrl ?? existingLocal?.logoUrl,
            );

            await _localDataSource.saveBusiness(
              mergedBiz,
              syncStatus: 'synced',
              lastSyncedAt: DateTime.now(),
            );

            AppDatabase.instance.currentBusiness = mergedBiz;
            AppDatabase.instance.isBusinessConfigured = true;
            await AppDatabase.instance.saveLocalState();

            debugPrint('[BusinessSyncService] Cloud account loaded for user ${user.id}: ${mergedBiz.name}');
            return;
          }
        } catch (e) {
          debugPrint('[BusinessSyncService] Cloud account fetch error: $e');
        }
      }

      // 2. Fallback to local Drift database if offline or not in cloud yet
      final currentBiz = await _localDataSource.getCurrentBusiness(accountId: user?.id);
      if (currentBiz != null) {
        AppDatabase.instance.currentBusiness = currentBiz;
        AppDatabase.instance.isBusinessConfigured = true;
        await AppDatabase.instance.saveLocalState();
        return;
      }

      // 3. Create default initial business if completely new
      final defaultName = (user != null && user.email != null && user.email!.contains('@'))
          ? "${user.email!.split('@').first}'s Business"
          : "My Business";

      final ownerFullName = (user != null && user.userMetadata?['full_name'] is String)
          ? user.userMetadata!['full_name'] as String
          : ((user != null && user.email != null && user.email!.contains('@'))
              ? user.email!.split('@').first
              : '');

      final newBiz = Business(
        id: const Uuid().v4(),
        accountId: user?.id,
        name: defaultName,
        ownerName: ownerFullName,
        businessType: BusinessType.retail,
        phone: '',
        whatsappNumber: '',
        email: user?.email ?? '',
        addressLine1: '',
        addressLine2: '',
        gstEnabled: false,
        gstin: '',
      );

      await saveLocalAndSyncCloud(newBiz);
      debugPrint('[BusinessSyncService] Created and synced default business: ${newBiz.name}');
    } catch (e, stackTrace) {
      debugPrint('[BusinessSyncService] Error during app start sync: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  /// Saves a business locally into Drift database and syncs to Supabase public.accounts cloud table.
  Future<void> saveLocalAndSyncCloud(Business business) async {
    final now = DateTime.now();
    final updatedBiz = business.copyWith(
      clientUpdatedAt: now,
      lastUsedAt: now,
      updatedAt: now,
    );

    // Save locally first
    await _localDataSource.saveBusiness(
      updatedBiz,
      syncStatus: 'pending',
      lastSyncedAt: now,
    );
    AppDatabase.instance.currentBusiness = updatedBiz;
    AppDatabase.instance.isBusinessConfigured = true;
    await AppDatabase.instance.saveLocalState();

    // Sync to Supabase cloud public.accounts table
    final user = SupabaseClientManager.instance.client.auth.currentUser;
    if (user != null) {
      try {
        final payload = updatedBiz.copyWith(accountId: user.id).toSupabaseJson();
        await SupabaseClientManager.instance.client
            .from('accounts')
            .upsert(payload, onConflict: 'user_id');

        await _localDataSource.updateSyncStatus(
          updatedBiz.id,
          'synced',
          lastSyncedAt: DateTime.now(),
        );
        debugPrint('[BusinessSyncService] Successfully synced business to Supabase accounts: ${updatedBiz.id}');
      } catch (e) {
        debugPrint('[BusinessSyncService] Cloud sync failed (will retry on next launch): $e');
        await _localDataSource.updateSyncStatus(
          updatedBiz.id,
          'pending',
          syncError: e.toString(),
        );
      }
    }
  }
}

