class AppNotification {
  final String id;
  final String title;
  final String? body;
  final String? levelId;
  final String? levelName;
  final DateTime? createdAt;
  final bool isRead;

  const AppNotification({
    required this.id,
    required this.title,
    this.body,
    this.levelId,
    this.levelName,
    this.createdAt,
    this.isRead = false,
  });

  factory AppNotification.fromMap(Map<String, dynamic> map) {
    String? levelName;
    final level = map['levels'] ?? map['level'];
    if (level is Map) levelName = level['name']?.toString();
    return AppNotification(
      id: map['id'].toString(),
      title: (map['title'] ?? '').toString(),
      body: map['body']?.toString(),
      levelId: map['level_id']?.toString(),
      levelName: levelName,
      createdAt: DateTime.tryParse(map['created_at']?.toString() ?? ''),
      isRead: map['is_read'] == true,
    );
  }

  Map<String, dynamic> toInsert() => {
        'title': title,
        'body': body,
        'level_id': levelId,
      };
}
