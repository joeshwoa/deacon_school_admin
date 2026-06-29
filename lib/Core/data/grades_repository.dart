import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/grade.dart';
import '../services/supabase_service.dart';

class GradesRepository {
  SupabaseClient get _db => SupabaseService.client;

  Future<List<GradeCategory>> fetchCategories() async {
    if (!SupabaseService.isReady) throw const BackendNotConnected();
    final rows = await _db
        .from('grade_categories')
        .select()
        .order('sort_order', ascending: true);
    return (rows as List)
        .map((e) => GradeCategory.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  /// Returns every category with the student's value (0 when not yet set).
  Future<List<StudentGrade>> fetchStudentGrades(String studentId) async {
    if (!SupabaseService.isReady) throw const BackendNotConnected();
    final categories = await fetchCategories();
    final rows = await _db
        .from('student_grades')
        .select()
        .eq('student_id', studentId);
    final valueByCategory = <String, double>{};
    for (final row in rows as List) {
      final map = Map<String, dynamic>.from(row as Map);
      valueByCategory[map['category_id'].toString()] =
          (map['value'] as num?)?.toDouble() ?? 0;
    }
    return categories
        .map((c) => StudentGrade(
              category: c,
              value: valueByCategory[c.id] ?? 0,
            ))
        .toList();
  }

  Future<void> upsertGrade({
    required String studentId,
    required String categoryId,
    required double value,
  }) async {
    if (!SupabaseService.isReady) throw const BackendNotConnected();
    await _db.from('student_grades').upsert({
      'student_id': studentId,
      'category_id': categoryId,
      'value': value,
    }, onConflict: 'student_id,category_id');
  }

  Future<List<PointEntry>> fetchPoints(String studentId) async {
    if (!SupabaseService.isReady) throw const BackendNotConnected();
    final rows = await _db
        .from('point_entries')
        .select()
        .eq('student_id', studentId)
        .order('created_at', ascending: false);
    return (rows as List)
        .map((e) => PointEntry.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> addPoint({
    required String studentId,
    required String title,
    required double value,
    String? note,
  }) async {
    if (!SupabaseService.isReady) throw const BackendNotConnected();
    await _db.from('point_entries').insert({
      'student_id': studentId,
      'title': title,
      'value': value,
      'note': note,
    });
  }

  Future<void> deletePoint(String id) async {
    if (!SupabaseService.isReady) throw const BackendNotConnected();
    await _db.from('point_entries').delete().eq('id', id);
  }
}
