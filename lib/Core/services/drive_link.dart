/// Helpers to turn a public Google Drive share link (the kind an admin copies
/// from the Drive UI) into URLs the app can actually stream / preview.
abstract class DriveLink {
  static final List<RegExp> _idPatterns = [
    RegExp(r'/file/d/([a-zA-Z0-9_-]{10,})'),
    RegExp(r'/d/([a-zA-Z0-9_-]{10,})'),
    RegExp(r'[?&]id=([a-zA-Z0-9_-]{10,})'),
  ];

  static bool isDriveLink(String url) =>
      url.contains('drive.google.com') || url.contains('docs.google.com');

  /// Extracts the Drive file id from any of the common share-link shapes.
  static String? extractId(String url) {
    final trimmed = url.trim();
    for (final pattern in _idPatterns) {
      final match = pattern.firstMatch(trimmed);
      if (match != null) return match.group(1);
    }
    return null;
  }

  /// Direct-download endpoint, suitable for audio playback and as a PDF source.
  static String toDirectDownload(String url) {
    final id = extractId(url);
    if (id == null) return url.trim();
    return 'https://drive.google.com/uc?export=download&id=$id';
  }

  /// Embeddable preview URL (used as a fallback / external open for PDFs).
  static String toPreview(String url) {
    final id = extractId(url);
    if (id == null) return url.trim();
    return 'https://drive.google.com/file/d/$id/preview';
  }

  /// Validates that a string is a usable media link (Drive share link or any
  /// direct http(s) url).
  static bool isValid(String url) {
    final trimmed = url.trim();
    if (trimmed.isEmpty) return false;
    if (isDriveLink(trimmed)) return extractId(trimmed) != null;
    final uri = Uri.tryParse(trimmed);
    return uri != null && (uri.isScheme('http') || uri.isScheme('https'));
  }
}
