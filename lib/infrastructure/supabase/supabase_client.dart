import 'package:supabase_flutter/supabase_flutter.dart';

/// Centralized manager exposing a single, reusable [SupabaseClient] instance.
///
/// Avoids instantiating multiple client instances across repositories or services.
class SupabaseClientManager {
  SupabaseClientManager._();

  static final SupabaseClientManager instance = SupabaseClientManager._();

  /// Access the global [SupabaseClient] initialized via [Supabase.initialize].
  SupabaseClient get client => Supabase.instance.client;
}
