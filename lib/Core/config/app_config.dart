import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Central place to read runtime configuration.
///
/// Values are read from a bundled `.env` file when present. The app is designed
/// to boot safely even when the `.env` file (or Supabase credentials) is missing
/// so the UI can still be developed/demoed before the backend is provisioned.
abstract class AppConfig {
  static String _env(String key) {
    try {
      if (dotenv.isInitialized) {
        return dotenv.env[key] ?? '';
      }
    } catch (_) {
      // dotenv not initialized – fall through to compile-time defaults.
    }
    return const String.fromEnvironment('placeholder');
  }

  static String get supabaseUrl {
    final fromEnv = _env('SUPABASE_URL');
    if (fromEnv.isNotEmpty) return fromEnv;
    return const String.fromEnvironment('SUPABASE_URL');
  }

  static String get supabaseAnonKey {
    final fromEnv = _env('SUPABASE_ANON_KEY');
    if (fromEnv.isNotEmpty) return fromEnv;
    return const String.fromEnvironment('SUPABASE_ANON_KEY');
  }

  /// Whether Supabase has been configured with real credentials.
  static bool get hasSupabase =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
