import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/level.dart';
import '../services/supabase_service.dart';

class LevelsRepository {
  SupabaseClient get _db => SupabaseService.client;

  Future<List<Level>> fetchLevels() async {
    if (!SupabaseService.isReady) throw const BackendNotConnected();
    final rows = await _db
        .from('levels')
        .select('*, students(count)')
        .order('sort_order', ascending: true);
    return (rows as List).map((row) {
      final map = Map<String, dynamic>.from(row as Map);
      final students = map['students'];
      if (students is List && students.isNotEmpty && students.first is Map) {
        map['students_count'] =
            (students.first as Map)['count'] ?? students.length;
      }
      return Level.fromMap(map);
    }).toList();
  }

  Future<void> create(Level level) async {
    if (!SupabaseService.isReady) throw const BackendNotConnected();
    await _db.from('levels').insert(level.toInsert());
  }

  Future<void> update(Level level) async {
    if (!SupabaseService.isReady) throw const BackendNotConnected();
    await _db.from('levels').update(level.toInsert()).eq('id', level.id);
  }

  Future<void> delete(String id) async {
    if (!SupabaseService.isReady) throw const BackendNotConnected();
    await _db.from('levels').delete().eq('id', id);
  }
}
