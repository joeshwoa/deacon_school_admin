import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../Core/models/grade.dart';
import '../../../../../Core/models/student.dart';
import '../../../../../Core/state/data_state.dart';
import '../../../../../Core/translations/locale_keys.g.dart';
import '../../../../../Core/widget/async_view.dart';
import '../../../../../Core/widget/form_sheet.dart';
import '../../cubit/grades_cubit.dart';

class StudentGradesScreen extends StatefulWidget {
  final Student student;
  const StudentGradesScreen({super.key, required this.student});

  @override
  State<StudentGradesScreen> createState() => _StudentGradesScreenState();
}

class _StudentGradesScreenState extends State<StudentGradesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GradesCubit>().load(widget.student.id);
    });
  }

  Future<void> _editGrade(StudentGrade g) async {
    final cubit = context.read<GradesCubit>();
    final controller =
        TextEditingController(text: g.value.toStringAsFixed(0));
    final value = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(g.category.name),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText:
                '${LocaleKeys.value.tr()} (0 - ${g.category.maxValue.toStringAsFixed(0)})',
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(LocaleKeys.cancel.tr())),
          FilledButton(
            onPressed: () => Navigator.pop(
                ctx, double.tryParse(controller.text.trim()) ?? g.value),
            child: Text(LocaleKeys.save.tr()),
          ),
        ],
      ),
    );
    if (value != null) {
      final clamped = value.clamp(0, g.category.maxValue).toDouble();
      await cubit.setGrade(g.category.id, clamped);
    }
  }

  Future<void> _addPoint() async {
    final cubit = context.read<GradesCubit>();
    final titleCtrl = TextEditingController();
    final valueCtrl = TextEditingController(text: '1');
    final noteCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();
    await showAppFormSheet(
      context,
      builder: (sheetCtx) => Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FormSheetHeader(LocaleKeys.addPoints.tr()),
            TextFormField(
              controller: titleCtrl,
              decoration:
                  InputDecoration(labelText: LocaleKeys.pointTitle.tr()),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? LocaleKeys.pleaseFillField.tr()
                  : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: valueCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(signed: true),
              decoration: InputDecoration(labelText: LocaleKeys.value.tr()),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: noteCtrl,
              decoration: InputDecoration(
                  labelText:
                      '${LocaleKeys.pointNote.tr()} (${LocaleKeys.optional.tr()})'),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                await cubit.addPoint(
                  titleCtrl.text.trim(),
                  double.tryParse(valueCtrl.text.trim()) ?? 0,
                  noteCtrl.text.trim().isEmpty ? null : noteCtrl.text.trim(),
                );
                if (sheetCtx.mounted) Navigator.pop(sheetCtx);
              },
              child: Text(LocaleKeys.save.tr()),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.student.name)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addPoint,
        icon: const Icon(Icons.add_rounded),
        label: Text(LocaleKeys.addPoints.tr()),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: BlocBuilder<GradesCubit, DataState<GradesData>>(
              builder: (context, state) {
                return AsyncView<GradesData>(
                  state: state,
                  onRetry: () =>
                      context.read<GradesCubit>().load(widget.student.id),
                  builder: (data) => RefreshIndicator(
                    onRefresh: () =>
                        context.read<GradesCubit>().load(widget.student.id),
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 96),
                      children: [
                        _Header(student: widget.student, total: data.totalPoints),
                        const SizedBox(height: 16),
                        Text(LocaleKeys.grades.tr(),
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        for (final g in data.grades)
                          _GradeTile(grade: g, onTap: () => _editGrade(g)),
                        const SizedBox(height: 20),
                        Text(LocaleKeys.points.tr(),
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        if (data.points.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(LocaleKeys.noGrades.tr(),
                                style: Theme.of(context).textTheme.bodyMedium),
                          ),
                        for (final p in data.points)
                          _PointTile(
                            point: p,
                            onDelete: () =>
                                context.read<GradesCubit>().deletePoint(p.id),
                          ),
                      ],
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

class _Header extends StatelessWidget {
  final Student student;
  final double total;
  const _Header({required this.student, required this.total});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: scheme.primary.withValues(alpha: 0.12),
              child: Icon(Icons.person_rounded, color: scheme.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(student.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700)),
                  if (student.levelName != null)
                    Text(student.levelName!,
                        style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            Column(
              children: [
                Text(total.toStringAsFixed(0),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: scheme.primary,
                          fontWeight: FontWeight.w800,
                        )),
                Text(LocaleKeys.points.tr(),
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GradeTile extends StatelessWidget {
  final StudentGrade grade;
  final VoidCallback onTap;
  const _GradeTile({required this.grade, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final pct = grade.category.maxValue == 0
        ? 0.0
        : (grade.value / grade.category.maxValue).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(grade.category.name,
                          style: const TextStyle(fontWeight: FontWeight.w600))),
                  Text(
                      '${grade.value.toStringAsFixed(0)} / ${grade.category.maxValue.toStringAsFixed(0)}'),
                  const SizedBox(width: 6),
                  Icon(Icons.edit_rounded, size: 18, color: scheme.primary),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: pct,
                  minHeight: 8,
                  backgroundColor: scheme.surfaceContainerHighest,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PointTile extends StatelessWidget {
  final PointEntry point;
  final VoidCallback onDelete;
  const _PointTile({required this.point, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final positive = point.value >= 0;
    return Card(
      child: ListTile(
        title: Text(point.title),
        subtitle: point.note != null ? Text(point.note!) : null,
        leading: CircleAvatar(
          backgroundColor: (positive ? scheme.primary : scheme.error)
              .withValues(alpha: 0.12),
          child: Text(
            '${positive ? '+' : ''}${point.value.toStringAsFixed(0)}',
            style: TextStyle(
              color: positive ? scheme.primary : scheme.error,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete_outline_rounded, color: scheme.error),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
