/// Central place to read runtime configuration.
///
/// Values are provided at build time via `--dart-define` (or
/// `--dart-define-from-file=dart_defines.json`). A runtime `.env` is intentionally
/// not used: web hosts like Vercel do not serve dot-files, so a bundled `.env`
/// asset would 404 and the credentials would never load.
abstract class AppConfig {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  /// Whether Supabase has been configured with real credentials.
  static bool get hasSupabase =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
