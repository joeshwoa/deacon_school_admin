class Lecture {
  final String id;
  final String title;
  final String? description;
  final String? levelId;
  final String? pdfUrl;
  final String? audioUrl;
  final String? coverUrl;
  final bool isPublished;
  final int sortOrder;

  const Lecture({
    required this.id,
    required this.title,
    this.description,
    this.levelId,
    this.pdfUrl,
    this.audioUrl,
    this.coverUrl,
    this.isPublished = true,
    this.sortOrder = 0,
  });

  bool get hasPdf => (pdfUrl ?? '').isNotEmpty;
  bool get hasAudio => (audioUrl ?? '').isNotEmpty;

  factory Lecture.fromMap(Map<String, dynamic> map) => Lecture(
        id: map['id'].toString(),
        title: (map['title'] ?? '').toString(),
        description: map['description']?.toString(),
        levelId: map['level_id']?.toString(),
        pdfUrl: map['pdf_url']?.toString(),
        audioUrl: map['audio_url']?.toString(),
        coverUrl: map['cover_url']?.toString(),
        isPublished: map['is_published'] == true,
        sortOrder: (map['sort_order'] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toInsert() => {
        'title': title,
        'description': description,
        'level_id': levelId,
        'pdf_url': pdfUrl,
        'audio_url': audioUrl,
        'cover_url': coverUrl,
        'is_published': isPublished,
        'sort_order': sortOrder,
      };
}
