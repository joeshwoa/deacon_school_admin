class Student {
  final String id;
  final String name;
  final String phone;
  final String? guardianPhone;
  final String? levelId;
  final String? levelName;
  final String? avatarUrl;

  const Student({
    required this.id,
    required this.name,
    required this.phone,
    this.guardianPhone,
    this.levelId,
    this.levelName,
    this.avatarUrl,
  });

  factory Student.fromMap(Map<String, dynamic> map) {
    String? levelName;
    final level = map['levels'] ?? map['level'];
    if (level is Map) levelName = level['name']?.toString();
    return Student(
      id: map['id'].toString(),
      name: (map['name'] ?? '').toString(),
      phone: (map['phone'] ?? '').toString(),
      guardianPhone: map['guardian_phone']?.toString(),
      levelId: map['level_id']?.toString(),
      levelName: levelName ?? map['level_name']?.toString(),
      avatarUrl: map['avatar_url']?.toString(),
    );
  }

  Map<String, dynamic> toInsert({String? accessCode}) => {
        'name': name,
        'phone': phone,
        'guardian_phone': guardianPhone,
        'level_id': levelId,
        'avatar_url': avatarUrl,
        if (accessCode != null && accessCode.isNotEmpty) 'access_code': accessCode,
      };
}
