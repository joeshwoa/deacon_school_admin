import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';

/// Thin wrapper around the Supabase client so the rest of the app does not
/// depend on the SDK directly and can run before the backend is connected.
abstract class SupabaseService {
  static bool _initialized = false;

  static bool get isReady => _initialized && AppConfig.hasSupabase;

  static Future<void> init() async {
    if (!AppConfig.hasSupabase) {
      // No credentials yet – skip initialization. Repositories handle this
      // gracefully by surfacing a "backend not connected" state.
      return;
    }
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
    );
    _initialized = true;
  }

  static SupabaseClient get client => Supabase.instance.client;
}

/// Thrown by repositories when the backend is not yet connected.
class BackendNotConnected implements Exception {
  const BackendNotConnected();
  @override
  String toString() => 'Backend not connected';
}
