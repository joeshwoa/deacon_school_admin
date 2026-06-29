import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../Core/models/level.dart';
import '../../../../../Core/models/student.dart';
import '../../../../../Core/state/data_state.dart';
import '../../../../../Core/translations/locale_keys.g.dart';
import '../../../../../Core/unit/app_routes.dart';
import '../../../../../Core/widget/app_dialogs.dart';
import '../../../../../Core/widget/async_view.dart';
import '../../../../Levels/presentation/cubit/levels_cubit.dart';
import '../../cubit/students_cubit.dart';
import '../widgets/student_form_sheet.dart';

class LevelStudentsScreen extends StatefulWidget {
  final Level level;
  const LevelStudentsScreen({super.key, required this.level});

  @override
  State<LevelStudentsScreen> createState() => _LevelStudentsScreenState();
}

class _LevelStudentsScreenState extends State<LevelStudentsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudentsCubit>().loadByLevel(widget.level.id);
    });
  }

  List<Level> get _levels {
    final s = context.read<LevelsCubit>().state;
    return s is DataLoaded<List<Level>> ? s.data : [widget.level];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.level.name)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showStudentForm(
          context,
          levels: _levels,
          defaultLevelId: widget.level.id,
        ),
        icon: const Icon(Icons.person_add_rounded),
        label: Text(LocaleKeys.addStudent.tr()),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: BlocBuilder<StudentsCubit, DataState<List<Student>>>(
              builder: (context, state) {
                return AsyncView<List<Student>>(
                  state: state,
                  isEmpty: (d) => d.isEmpty,
                  emptyText: LocaleKeys.noStudents.tr(),
                  emptyIcon: Icons.groups_rounded,
                  onRetry: () =>
                      context.read<StudentsCubit>().loadByLevel(widget.level.id),
                  builder: (students) => RefreshIndicator(
                    onRefresh: () => context
                        .read<StudentsCubit>()
                        .loadByLevel(widget.level.id),
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 96),
                      itemCount: students.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) =>
                          _StudentTile(student: students[i], levels: _levels),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _StudentTile extends StatelessWidget {
  final Student student;
  final List<Level> levels;
  const _StudentTile({required this.student, required this.levels});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        onTap: () => context.push(AppRouter.kStudentGrades, extra: student),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: scheme.primary.withValues(alpha: 0.12),
          backgroundImage: (student.avatarUrl != null &&
                  student.avatarUrl!.isNotEmpty)
              ? NetworkImage(student.avatarUrl!)
              : null,
          child: (student.avatarUrl == null || student.avatarUrl!.isEmpty)
              ? Icon(Icons.person_rounded, color: scheme.primary)
              : null,
        ),
        title: Text(student.name,
            style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(student.phone),
        trailing: PopupMenuButton<String>(
          onSelected: (v) async {
            if (v == 'edit') {
              showStudentForm(context, levels: levels, existing: student);
            } else if (v == 'grades') {
              context.push(AppRouter.kStudentGrades, extra: student);
            } else if (v == 'delete') {
              final ok = await AppDialogs.confirm(context, destructive: true);
              if (ok && context.mounted) {
                await context.read<StudentsCubit>().remove(student.id);
              }
            }
          },
          itemBuilder: (_) => [
            PopupMenuItem(
                value: 'grades',
                child: Row(children: [
                  const Icon(Icons.assessment_rounded, size: 20),
                  const SizedBox(width: 8),
                  Text(LocaleKeys.grades.tr()),
                ])),
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
                  Icon(Icons.delete_rounded, size: 20, color: scheme.error),
                  const SizedBox(width: 8),
                  Text(LocaleKeys.delete.tr()),
                ])),
          ],
        ),
      ),
    );
  }
}
