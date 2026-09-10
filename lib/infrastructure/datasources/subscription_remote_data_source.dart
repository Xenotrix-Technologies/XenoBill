import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/subscription_details.dart';
import '../../domain/entities/subscription_transaction.dart';
import '../supabase/supabase_client.dart';

abstract class SubscriptionRemoteDataSource {
  Future<SubscriptionDetails?> fetchSubscriptionDetails(String userId);
  Future<SubscriptionDetails> upsertSubscriptionDetails(SubscriptionDetails details);
  Future<List<SubscriptionTransaction>> fetchTransactions(String userId);
  Future<SubscriptionTransaction> recordTransaction(SubscriptionTransaction transaction);
}

class SubscriptionRemoteDataSourceImpl implements SubscriptionRemoteDataSource {
  final SupabaseClient? _customClient;

  SubscriptionRemoteDataSourceImpl({SupabaseClient? client}) : _customClient = client;

  SupabaseClient get _client => _customClient ?? SupabaseClientManager.instance.client;

  @override
  Future<SubscriptionDetails?> fetchSubscriptionDetails(String userId) async {
    try {
      debugPrint('[SubscriptionRemoteDataSource] Fetching subscription for user: $userId');
      final response = await _client
          .from('subscriptions')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) {
        debugPrint('[SubscriptionRemoteDataSource] No existing remote subscription found for user: $userId');
        return null;
      }

      return SubscriptionDetails.fromJson(response);
    } catch (e) {
      debugPrint('[SubscriptionRemoteDataSource] Error fetching subscription from Supabase: $e');
      return null;
    }
  }

  @override
  Future<SubscriptionDetails> upsertSubscriptionDetails(SubscriptionDetails details) async {
    try {
      debugPrint('[SubscriptionRemoteDataSource] Upserting subscription for user: ${details.userId}');
      final response = await _client
          .from('subscriptions')
          .upsert(details.toJson(), onConflict: 'user_id')
          .select()
          .single();

      return SubscriptionDetails.fromJson(response);
    } catch (e) {
      debugPrint('[SubscriptionRemoteDataSource] Error upserting subscription to Supabase: $e');
      return details;
    }
  }

  @override
  Future<List<SubscriptionTransaction>> fetchTransactions(String userId) async {
    try {
      debugPrint('[SubscriptionRemoteDataSource] Fetching transactions for user: $userId');
      final response = await _client
          .from('subscription_transactions')
          .select()
          .eq('user_id', userId)
          .order('date', ascending: false);

      final List list = response as List;
      return list.map((item) => SubscriptionTransaction.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      debugPrint('[SubscriptionRemoteDataSource] Error fetching transactions: $e');
      return [];
    }
  }

  @override
  Future<SubscriptionTransaction> recordTransaction(SubscriptionTransaction transaction) async {
    try {
      debugPrint('[SubscriptionRemoteDataSource] Recording transaction: ${transaction.id}');
      final response = await _client
          .from('subscription_transactions')
          .insert(transaction.toJson())
          .select()
          .single();

      return SubscriptionTransaction.fromJson(response);
    } catch (e) {
      debugPrint('[SubscriptionRemoteDataSource] Error recording transaction: $e');
      return transaction;
    }
  }
}
