import '../services/supabase_service.dart';

/// Sends a contact/feedback message to the school admin inbox through the
/// `send-email` Supabase Edge Function (which wraps Resend server-side).
class ContactRepository {
  Future<void> sendMessage({
    required String message,
    required String source,
    String? name,
    String? reply,
  }) async {
    if (!SupabaseService.isReady) throw const BackendNotConnected();
    final res = await SupabaseService.client.functions.invoke(
      'send-email',
      body: {
        'message': message,
        'name': name ?? '',
        'reply': reply ?? '',
        'source': source,
      },
    );
    if (res.status < 200 || res.status >= 300) {
      throw Exception('send_failed:${res.status}');
    }
  }
}
