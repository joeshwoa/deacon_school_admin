class Level {
  final String id;
  final String name;
  final String? description;
  final int sortOrder;
  final int? studentsCount;

  const Level({
    required this.id,
    required this.name,
    this.description,
    this.sortOrder = 0,
    this.studentsCount,
  });

  factory Level.fromMap(Map<String, dynamic> map) => Level(
        id: map['id'].toString(),
        name: (map['name'] ?? '').toString(),
        description: map['description']?.toString(),
        sortOrder: (map['sort_order'] as num?)?.toInt() ?? 0,
        studentsCount: (map['students_count'] as num?)?.toInt(),
      );

  Map<String, dynamic> toInsert() => {
        'name': name,
        'description': description,
        'sort_order': sortOrder,
      };
}
