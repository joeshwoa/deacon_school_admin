import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../Core/models/lecture.dart';
import '../../../../../Core/translations/locale_keys.g.dart';
import '../../../../../Core/unit/app_routes.dart';

class LectureContentScreen extends StatelessWidget {
  final Lecture lecture;
  const LectureContentScreen({super.key, required this.lecture});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(lecture.title)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      color: scheme.primary.withValues(alpha: 0.10),
                      child: (lecture.coverUrl != null &&
                              lecture.coverUrl!.isNotEmpty)
                          ? Image.network(lecture.coverUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                  Icons.library_music_rounded,
                                  size: 64,
                                  color: scheme.primary))
                          : Icon(Icons.library_music_rounded,
                              size: 64, color: scheme.primary),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(lecture.title,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w800)),
                if (lecture.description != null &&
                    lecture.description!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(lecture.description!,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: scheme.onSurfaceVariant,
                          )),
                ],
                const SizedBox(height: 24),
                _ActionCard(
                  icon: Icons.menu_book_rounded,
                  title: LocaleKeys.lectureText.tr(),
                  enabled: lecture.hasPdf,
                  onTap: () =>
                      context.push(AppRouter.kLecturePdf, extra: lecture),
                ),
                const SizedBox(height: 12),
                _ActionCard(
                  icon: Icons.headphones_rounded,
                  title: LocaleKeys.lectureAudio.tr(),
                  enabled: lecture.hasAudio,
                  onTap: () => context.push(AppRouter.kAudio, extra: lecture),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool enabled;
  final VoidCallback onTap;
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Card(
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            radius: 26,
            backgroundColor: scheme.primary.withValues(alpha: 0.12),
            child: Icon(icon, color: scheme.primary),
          ),
          title: Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 17)),
          trailing: enabled
              ? const Icon(Icons.arrow_forward_ios_rounded, size: 16)
              : Text(LocaleKeys.mediaNotAvailable.tr(),
                  style: Theme.of(context).textTheme.bodySmall),
          onTap: enabled ? onTap : null,
        ),
      ),
    );
  }
}
