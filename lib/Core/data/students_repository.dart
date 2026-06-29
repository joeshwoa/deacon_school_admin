import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/student.dart';
import '../services/supabase_service.dart';

class StudentsRepository {
  SupabaseClient get _db => SupabaseService.client;

  Future<List<Student>> fetchByLevel(String levelId) async {
    if (!SupabaseService.isReady) throw const BackendNotConnected();
    final rows = await _db
        .from('students')
        .select('*, levels(name)')
        .eq('level_id', levelId)
        .order('name', ascending: true);
    return (rows as List)
        .map((e) => Student.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<List<Student>> search(String query) async {
    if (!SupabaseService.isReady) throw const BackendNotConnected();
    final rows = await _db
        .from('students')
        .select('*, levels(name)')
        .or('name.ilike.%$query%,phone.ilike.%$query%')
        .order('name', ascending: true)
        .limit(50);
    return (rows as List)
        .map((e) => Student.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> create(Student student, {required String accessCode}) async {
    if (!SupabaseService.isReady) throw const BackendNotConnected();
    await _db.rpc('admin_create_student', params: {
      'p_name': student.name,
      'p_phone': student.phone,
      'p_guardian_phone': student.guardianPhone,
      'p_level_id': student.levelId,
      'p_avatar_url': student.avatarUrl,
      'p_access_code': accessCode,
    });
  }

  Future<void> update(Student student, {String? accessCode}) async {
    if (!SupabaseService.isReady) throw const BackendNotConnected();
    await _db.rpc('admin_update_student', params: {
      'p_id': student.id,
      'p_name': student.name,
      'p_phone': student.phone,
      'p_guardian_phone': student.guardianPhone,
      'p_level_id': student.levelId,
      'p_avatar_url': student.avatarUrl,
      'p_access_code': accessCode,
    });
  }

  Future<void> delete(String id) async {
    if (!SupabaseService.isReady) throw const BackendNotConnected();
    await _db.from('students').delete().eq('id', id);
  }
}
