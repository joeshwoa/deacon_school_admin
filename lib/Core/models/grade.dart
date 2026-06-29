class GradeCategory {
  final String id;
  final String name;
  final double maxValue;
  final int sortOrder;

  const GradeCategory({
    required this.id,
    required this.name,
    this.maxValue = 100,
    this.sortOrder = 0,
  });

  factory GradeCategory.fromMap(Map<String, dynamic> map) => GradeCategory(
        id: map['id'].toString(),
        name: (map['name'] ?? '').toString(),
        maxValue: (map['max_value'] as num?)?.toDouble() ?? 100,
        sortOrder: (map['sort_order'] as num?)?.toInt() ?? 0,
      );
}

/// A category joined with the current student's value.
class StudentGrade {
  final GradeCategory category;
  final double value;

  const StudentGrade({required this.category, required this.value});

  factory StudentGrade.fromMap(Map<String, dynamic> map) => StudentGrade(
        category: GradeCategory.fromMap(
          map['grade_categories'] is Map
              ? Map<String, dynamic>.from(map['grade_categories'])
              : map,
        ),
        value: (map['value'] as num?)?.toDouble() ?? 0,
      );
}

class PointEntry {
  final String id;
  final String title;
  final double value;
  final String? note;
  final DateTime? createdAt;

  const PointEntry({
    required this.id,
    required this.title,
    required this.value,
    this.note,
    this.createdAt,
  });

  factory PointEntry.fromMap(Map<String, dynamic> map) => PointEntry(
        id: map['id'].toString(),
        title: (map['title'] ?? '').toString(),
        value: (map['value'] as num?)?.toDouble() ?? 0,
        note: map['note']?.toString(),
        createdAt: DateTime.tryParse(map['created_at']?.toString() ?? ''),
      );
}
