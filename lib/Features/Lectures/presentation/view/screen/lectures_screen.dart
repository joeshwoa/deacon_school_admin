import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../Core/models/lecture.dart';
import '../../../../../Core/models/level.dart';
import '../../../../../Core/state/data_state.dart';
import '../../../../../Core/translations/locale_keys.g.dart';
import '../../../../../Core/unit/app_routes.dart';
import '../../../../../Core/widget/app_dialogs.dart';
import '../../../../../Core/widget/async_view.dart';
import '../../../../Levels/presentation/cubit/levels_cubit.dart';
import '../../cubit/lectures_cubit.dart';
import '../widgets/lecture_form_sheet.dart';

class LecturesScreen extends StatefulWidget {
  const LecturesScreen({super.key});

  @override
  State<LecturesScreen> createState() => _LecturesScreenState();
}

class _LecturesScreenState extends State<LecturesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LecturesCubit>().load();
      context.read<LevelsCubit>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LecturesCubit, DataState<List<Lecture>>>(
      builder: (context, state) {
        return AsyncView<List<Lecture>>(
          state: state,
          isEmpty: (d) => d.isEmpty,
          emptyText: LocaleKeys.noLectures.tr(),
          emptyIcon: Icons.library_music_rounded,
          onRetry: context.read<LecturesCubit>().load,
          builder: (lectures) => RefreshIndicator(
            onRefresh: context.read<LecturesCubit>().load,
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(4, 12, 4, 96),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 420,
                mainAxisExtent: 108,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: lectures.length,
              itemBuilder: (context, i) => _LectureCard(lecture: lectures[i]),
            ),
          ),
        );
      },
    );
  }
}

class _LectureCard extends StatelessWidget {
  final Lecture lecture;
  const _LectureCard({required this.lecture});

  List<Level> _levels(BuildContext context) {
    final s = context.read<LevelsCubit>().state;
    return s is DataLoaded<List<Level>> ? s.data : const [];
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => context.push(AppRouter.kLectureContent, extra: lecture),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 76,
                  width: 76,
                  color: scheme.primary.withValues(alpha: 0.10),
                  child: (lecture.coverUrl != null &&
                          lecture.coverUrl!.isNotEmpty)
                      ? Image.network(lecture.coverUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                              Icons.library_music_rounded,
                              color: scheme.primary))
                      : Icon(Icons.library_music_rounded, color: scheme.primary),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(lecture.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        if (lecture.hasPdf)
                          _Tag(
                              icon: Icons.picture_as_pdf_rounded,
                              label: LocaleKeys.lectureText.tr()),
                        if (lecture.hasAudio)
                          _Tag(
                              icon: Icons.audiotrack_rounded,
                              label: LocaleKeys.lectureAudio.tr()),
                        if (!lecture.isPublished)
                          _Tag(
                              icon: Icons.visibility_off_rounded,
                              label: LocaleKeys.draft.tr()),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (v) async {
                  if (v == 'edit') {
                    showLectureForm(context,
                        levels: _levels(context), existing: lecture);
                  } else if (v == 'delete') {
                    final ok =
                        await AppDialogs.confirm(context, destructive: true);
                    if (ok && context.mounted) {
                      await context.read<LecturesCubit>().remove(lecture.id);
                    }
                  }
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                      value: 'edit',
                      child: Row(children: [
                        const Icon(Icons.edit_rounded, size: 20),
                        const SizedBox(width: 8),
                        Text(LocaleKeys.edit.tr()),
                      ])),
                  PopupMenuItem(
                      value: 'delete',
                      child: Row(children: [
                        Icon(Icons.delete_rounded,
                            size: 20, color: scheme.error),
                        const SizedBox(width: 8),
                        Text(LocaleKeys.delete.tr()),
                      ])),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Tag({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: scheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: scheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}
