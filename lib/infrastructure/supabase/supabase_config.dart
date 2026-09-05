import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Configuration holder and initializer for Supabase backend.
///
/// Obtains [url] and [anonKey] using `String.fromEnvironment`.
/// NEVER put service_role key, database password, or private credentials here.
class SupabaseConfig {
  SupabaseConfig._();

  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://ksfxdkyszagtgdtxmzqx.supabase.co',
  );

  static const String anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_PG1688oaXBdta0neB8zSHg_1-8rUPIk',
  );

  /// Initializes Supabase Flutter SDK during application startup.
  static Future<void> init() async {
    try {
      debugPrint('[SupabaseConfig] Initializing Supabase client...');

      await Supabase.initialize(
        url: url,
        anonKey: anonKey,
        debug: kDebugMode,
      );

      debugPrint('[SupabaseConfig] Supabase initialized successfully.');
    } catch (e, stackTrace) {
      debugPrint('[SupabaseConfig] Error initializing Supabase: $e');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }
}
