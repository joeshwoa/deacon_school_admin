import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../Core/models/level.dart';
import '../../../../../Core/state/data_state.dart';
import '../../../../../Core/translations/locale_keys.g.dart';
import '../../../../../Core/unit/app_routes.dart';
import '../../../../../Core/widget/app_dialogs.dart';
import '../../../../../Core/widget/async_view.dart';
import '../../cubit/levels_cubit.dart';
import '../widgets/level_form_sheet.dart';

class LevelsScreen extends StatefulWidget {
  const LevelsScreen({super.key});

  @override
  State<LevelsScreen> createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LevelsCubit>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LevelsCubit, DataState<List<Level>>>(
      builder: (context, state) {
        return AsyncView<List<Level>>(
          state: state,
          isEmpty: (d) => d.isEmpty,
          emptyText: LocaleKeys.noLevels.tr(),
          emptyIcon: Icons.school_rounded,
          onRetry: context.read<LevelsCubit>().load,
          builder: (levels) => RefreshIndicator(
            onRefresh: context.read<LevelsCubit>().load,
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(4, 12, 4, 96),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 380,
                mainAxisExtent: 120,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: levels.length,
              itemBuilder: (context, i) => _LevelCard(level: levels[i]),
            ),
          ),
        );
      },
    );
  }
}

class _LevelCard extends StatelessWidget {
  final Level level;
  const _LevelCard({required this.level});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => context.push(AppRouter.kLevelStudents, extra: level),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: scheme.primary.withValues(alpha: 0.12),
                child: Icon(Icons.school_rounded, color: scheme.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      level.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${LocaleKeys.studentsCount.tr()}: ${level.studentsCount ?? 0}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (v) async {
                  if (v == 'edit') {
                    showLevelForm(context, existing: level);
                  } else if (v == 'delete') {
                    final ok = await AppDialogs.confirm(context,
                        destructive: true);
                    if (ok && context.mounted) {
                      await context.read<LevelsCubit>().remove(level.id);
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
                    ]),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(children: [
                      Icon(Icons.delete_rounded,
                          size: 20, color: scheme.error),
                      const SizedBox(width: 8),
                      Text(LocaleKeys.delete.tr()),
                    ]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
