import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../Core/models/lecture.dart';
import '../../../../../Core/models/level.dart';
import '../../../../../Core/services/drive_link.dart';
import '../../../../../Core/translations/locale_keys.g.dart';
import '../../../../../Core/widget/app_dialogs.dart';
import '../../../../../Core/widget/form_sheet.dart';
import '../../cubit/lectures_cubit.dart';

Future<void> showLectureForm(
  BuildContext context, {
  required List<Level> levels,
  Lecture? existing,
}) async {
  final cubit = context.read<LecturesCubit>();
  await showAppFormSheet(
    context,
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: _LectureForm(levels: levels, existing: existing),
    ),
  );
}

class _LectureForm extends StatefulWidget {
  final List<Level> levels;
  final Lecture? existing;
  const _LectureForm({required this.levels, this.existing});

  @override
  State<_LectureForm> createState() => _LectureFormState();
}

class _LectureFormState extends State<_LectureForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _description;
  late final TextEditingController _pdf;
  late final TextEditingController _audio;
  late final TextEditingController _cover;
  String? _levelId;
  late bool _published;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.existing?.title ?? '');
    _description =
        TextEditingController(text: widget.existing?.description ?? '');
    _pdf = TextEditingController(text: widget.existing?.pdfUrl ?? '');
    _audio = TextEditingController(text: widget.existing?.audioUrl ?? '');
    _cover = TextEditingController(text: widget.existing?.coverUrl ?? '');
    _levelId = widget.existing?.levelId;
    _published = widget.existing?.isPublished ?? true;
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _pdf.dispose();
    _audio.dispose();
    _cover.dispose();
    super.dispose();
  }

  String? _driveValidator(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    return DriveLink.isValid(v.trim()) ? null : LocaleKeys.invalidDriveLink.tr();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final lecture = Lecture(
      id: widget.existing?.id ?? '',
      title: _title.text.trim(),
      description:
          _description.text.trim().isEmpty ? null : _description.text.trim(),
      levelId: _levelId,
      pdfUrl: _pdf.text.trim().isEmpty ? null : _pdf.text.trim(),
      audioUrl: _audio.text.trim().isEmpty ? null : _audio.text.trim(),
      coverUrl: _cover.text.trim().isEmpty ? null : _cover.text.trim(),
      isPublished: _published,
      sortOrder: widget.existing?.sortOrder ?? 0,
    );
    final ok = await context.read<LecturesCubit>().save(lecture);
    if (!mounted) return;
    setState(() => _saving = false);
    Navigator.pop(context);
    AppDialogs.snack(
      context,
      ok ? LocaleKeys.savedSuccessfully.tr() : LocaleKeys.somethingWentWrong.tr(),
      error: !ok,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FormSheetHeader(widget.existing == null
              ? LocaleKeys.addLecture.tr()
              : LocaleKeys.editLecture.tr()),
          TextFormField(
            controller: _title,
            decoration: InputDecoration(labelText: LocaleKeys.lectureTitle.tr()),
            validator: (v) => (v == null || v.trim().isEmpty)
                ? LocaleKeys.pleaseFillField.tr()
                : null,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _description,
            maxLines: 2,
            decoration: InputDecoration(
                labelText:
                    '${LocaleKeys.lectureDescription.tr()} (${LocaleKeys.optional.tr()})'),
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String?>(
            initialValue: _levelId,
            decoration: InputDecoration(labelText: LocaleKeys.level.tr()),
            items: [
              DropdownMenuItem(value: null, child: Text(LocaleKeys.allLevels.tr())),
              for (final l in widget.levels)
                DropdownMenuItem(value: l.id, child: Text(l.name)),
            ],
            onChanged: (v) => setState(() => _levelId = v),
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _pdf,
            decoration: InputDecoration(
              labelText: LocaleKeys.pdfDriveLink.tr(),
              helperText: LocaleKeys.driveLinkHint.tr(),
              prefixIcon: const Icon(Icons.picture_as_pdf_rounded),
            ),
            validator: _driveValidator,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _audio,
            decoration: InputDecoration(
              labelText: LocaleKeys.audioDriveLink.tr(),
              helperText: LocaleKeys.driveLinkHint.tr(),
              prefixIcon: const Icon(Icons.audiotrack_rounded),
            ),
            validator: _driveValidator,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _cover,
            decoration: InputDecoration(
              labelText:
                  '${LocaleKeys.coverImageUrl.tr()} (${LocaleKeys.optional.tr()})',
              prefixIcon: const Icon(Icons.image_rounded),
            ),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(LocaleKeys.published.tr()),
            value: _published,
            onChanged: (v) => setState(() => _published = v),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.4),
                  )
                : Text(LocaleKeys.save.tr()),
          ),
        ],
      ),
    );
  }
}
