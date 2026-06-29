import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/lecture.dart';
import '../services/supabase_service.dart';

class LecturesRepository {
  SupabaseClient get _db => SupabaseService.client;

  Future<List<Lecture>> fetchAll() async {
    if (!SupabaseService.isReady) throw const BackendNotConnected();
    final rows = await _db
        .from('lectures')
        .select()
        .order('sort_order', ascending: true)
        .order('title', ascending: true);
    return (rows as List)
        .map((e) => Lecture.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> create(Lecture lecture) async {
    if (!SupabaseService.isReady) throw const BackendNotConnected();
    await _db.from('lectures').insert(lecture.toInsert());
  }

  Future<void> update(Lecture lecture) async {
    if (!SupabaseService.isReady) throw const BackendNotConnected();
    await _db.from('lectures').update(lecture.toInsert()).eq('id', lecture.id);
  }

  Future<void> delete(String id) async {
    if (!SupabaseService.isReady) throw const BackendNotConnected();
    await _db.from('lectures').delete().eq('id', id);
  }
}
