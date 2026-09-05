import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/business.dart';
import '../supabase/supabase_client.dart';
import '../mappers/business_mapper.dart';

abstract class BusinessRemoteDataSource {
  Future<String> getOrCreateAccountId(String userId);
  Future<Business?> fetchPrimaryBusiness(String accountId);
  Future<Business?> fetchBusinessById(String businessId);
  Future<Business> createBusinessRemote(Business business, String accountId);
  Future<Business> updateBusinessRemote(Business business, String accountId);
  Future<void> setPrimaryBusiness(String accountId, String businessId);
}

class BusinessRemoteDataSourceImpl implements BusinessRemoteDataSource {
  final SupabaseClient? _customClient;

  BusinessRemoteDataSourceImpl({SupabaseClient? client}) : _customClient = client;

  SupabaseClient get _client => _customClient ?? SupabaseClientManager.instance.client;

  @override
  Future<String> getOrCreateAccountId(String userId) async {
    debugPrint('[BusinessRemoteDataSource] Fetching account for user: $userId');
    final response = await _client
        .from('accounts')
        .select('id, user_id, primary_business_id')
        .eq('user_id', userId)
        .maybeSingle();

    if (response != null) {
      return response['id'] as String;
    }

    debugPrint('[BusinessRemoteDataSource] Account missing. Creating account for user: $userId');
    final inserted = await _client
        .from('accounts')
        .insert({'user_id': userId})
        .select('id')
        .single();

    return inserted['id'] as String;
  }

  @override
  Future<Business?> fetchPrimaryBusiness(String accountId) async {
    debugPrint('[BusinessRemoteDataSource] Fetching primary business for account: $accountId');
    final accountRes = await _client
        .from('accounts')
        .select('primary_business_id')
        .eq('id', accountId)
        .maybeSingle();

    final primaryId = accountRes?['primary_business_id'] as String?;

    if (primaryId != null) {
      return await fetchBusinessById(primaryId);
    }

    // Fallback: fetch any business associated with this account
    final businesses = await _client
        .from('businesses')
        .select()
        .eq('account_id', accountId)
        .order('created_at', ascending: false)
        .limit(1);

    if (businesses.isNotEmpty) {
      return BusinessMapper.fromSupabaseJson(businesses.first);
    }

    return null;
  }

  @override
  Future<Business?> fetchBusinessById(String businessId) async {
    final response = await _client
        .from('businesses')
        .select()
        .eq('id', businessId)
        .maybeSingle();

    if (response == null) return null;
    return BusinessMapper.fromSupabaseJson(response);
  }

  @override
  Future<Business> createBusinessRemote(Business business, String accountId) async {
    debugPrint('[BusinessRemoteDataSource] Creating business in Supabase: ${business.name}');
    final jsonPayload = BusinessMapper.toSupabaseJson(business, accountId);

    try {
      final response = await _client
          .from('businesses')
          .upsert(jsonPayload)
          .select()
          .single();

      final created = BusinessMapper.fromSupabaseJson(response);
      await setPrimaryBusiness(accountId, created.id);
      return created;
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST204' || e.message.contains('client_updated_at')) {
        debugPrint('[BusinessRemoteDataSource] client_updated_at column absent in remote schema. Retrying payload without client_updated_at...');
        final fallbackPayload = Map<String, dynamic>.from(jsonPayload)..remove('client_updated_at');
        final response = await _client
            .from('businesses')
            .upsert(fallbackPayload)
            .select()
            .single();
        final created = BusinessMapper.fromSupabaseJson(response);
        await setPrimaryBusiness(accountId, created.id);
        return created;
      }
      rethrow;
    }
  }

  @override
  Future<Business> updateBusinessRemote(Business business, String accountId) async {
    debugPrint('[BusinessRemoteDataSource] Updating business in Supabase: ${business.id}');
    final jsonPayload = BusinessMapper.toSupabaseJson(business, accountId);

    try {
      final response = await _client
          .from('businesses')
          .upsert(jsonPayload)
          .select()
          .single();

      return BusinessMapper.fromSupabaseJson(response);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST204' || e.message.contains('client_updated_at')) {
        debugPrint('[BusinessRemoteDataSource] client_updated_at column absent in remote schema. Retrying payload without client_updated_at...');
        final fallbackPayload = Map<String, dynamic>.from(jsonPayload)..remove('client_updated_at');
        final response = await _client
            .from('businesses')
            .upsert(fallbackPayload)
            .select()
            .single();
        return BusinessMapper.fromSupabaseJson(response);
      }
      rethrow;
    }
  }

  @override
  Future<void> setPrimaryBusiness(String accountId, String businessId) async {
    await _client
        .from('accounts')
        .update({'primary_business_id': businessId})
        .eq('id', accountId);
  }
}
