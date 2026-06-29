import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../Core/models/level.dart';
import '../../../../../Core/models/student.dart';
import '../../../../../Core/translations/locale_keys.g.dart';
import '../../../../../Core/widget/app_dialogs.dart';
import '../../../../../Core/widget/form_sheet.dart';
import '../../cubit/students_cubit.dart';

Future<void> showStudentForm(
  BuildContext context, {
  required List<Level> levels,
  String? defaultLevelId,
  Student? existing,
}) async {
  final cubit = context.read<StudentsCubit>();
  await showAppFormSheet(
    context,
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: _StudentForm(
        levels: levels,
        defaultLevelId: defaultLevelId,
        existing: existing,
      ),
    ),
  );
}

class _StudentForm extends StatefulWidget {
  final List<Level> levels;
  final String? defaultLevelId;
  final Student? existing;
  const _StudentForm({
    required this.levels,
    this.defaultLevelId,
    this.existing,
  });

  @override
  State<_StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<_StudentForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _guardian;
  late final TextEditingController _code;
  late final TextEditingController _avatar;
  String? _levelId;
  bool _saving = false;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.existing?.name ?? '');
    _phone = TextEditingController(text: widget.existing?.phone ?? '');
    _guardian =
        TextEditingController(text: widget.existing?.guardianPhone ?? '');
    _code = TextEditingController();
    _avatar = TextEditingController(text: widget.existing?.avatarUrl ?? '');
    _levelId = widget.existing?.levelId ?? widget.defaultLevelId;
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _guardian.dispose();
    _code.dispose();
    _avatar.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final student = Student(
      id: widget.existing?.id ?? '',
      name: _name.text.trim(),
      phone: _phone.text.trim(),
      guardianPhone:
          _guardian.text.trim().isEmpty ? null : _guardian.text.trim(),
      levelId: _levelId,
      avatarUrl: _avatar.text.trim().isEmpty ? null : _avatar.text.trim(),
    );
    final ok = await context.read<StudentsCubit>().save(
          student,
          accessCode: _code.text.trim().isEmpty ? null : _code.text.trim(),
        );
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
          FormSheetHeader(
              _isEdit ? LocaleKeys.editStudent.tr() : LocaleKeys.addStudent.tr()),
          TextFormField(
            controller: _name,
            decoration: InputDecoration(labelText: LocaleKeys.studentName.tr()),
            validator: (v) => (v == null || v.trim().isEmpty)
                ? LocaleKeys.pleaseFillField.tr()
                : null,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _phone,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(labelText: LocaleKeys.phone.tr()),
            validator: (v) => (v == null || v.trim().length < 6)
                ? LocaleKeys.invalidPhone.tr()
                : null,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _guardian,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText:
                  '${LocaleKeys.guardianPhone.tr()} (${LocaleKeys.optional.tr()})',
            ),
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(
            initialValue: _levelId,
            decoration: InputDecoration(labelText: LocaleKeys.level.tr()),
            items: [
              for (final l in widget.levels)
                DropdownMenuItem(value: l.id, child: Text(l.name)),
            ],
            onChanged: (v) => setState(() => _levelId = v),
            validator: (v) =>
                v == null ? LocaleKeys.pleaseFillField.tr() : null,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _code,
            decoration: InputDecoration(
              labelText: _isEdit
                  ? '${LocaleKeys.accessCode.tr()} (${LocaleKeys.optional.tr()})'
                  : LocaleKeys.accessCode.tr(),
              helperText: LocaleKeys.accessCodeHint.tr(),
            ),
            validator: (v) {
              if (_isEdit) return null;
              return (v == null || v.trim().length < 4)
                  ? LocaleKeys.pleaseFillField.tr()
                  : null;
            },
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _avatar,
            decoration: InputDecoration(
              labelText:
                  '${LocaleKeys.coverImageUrl.tr()} (${LocaleKeys.optional.tr()})',
            ),
          ),
          const SizedBox(height: 24),
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
