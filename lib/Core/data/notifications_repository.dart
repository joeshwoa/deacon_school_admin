import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/app_notification.dart';
import '../services/supabase_service.dart';

class NotificationsRepository {
  SupabaseClient get _db => SupabaseService.client;

  Future<List<AppNotification>> fetchAll() async {
    if (!SupabaseService.isReady) throw const BackendNotConnected();
    final rows = await _db
        .from('notifications')
        .select('*, levels(name)')
        .order('created_at', ascending: false);
    return (rows as List)
        .map((e) =>
            AppNotification.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> create(AppNotification notification) async {
    if (!SupabaseService.isReady) throw const BackendNotConnected();
    await _db.from('notifications').insert(notification.toInsert());
  }

  Future<void> delete(String id) async {
    if (!SupabaseService.isReady) throw const BackendNotConnected();
    await _db.from('notifications').delete().eq('id', id);
  }
}
