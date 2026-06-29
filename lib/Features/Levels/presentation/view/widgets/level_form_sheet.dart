import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../Core/models/level.dart';
import '../../../../../Core/translations/locale_keys.g.dart';
import '../../../../../Core/widget/app_dialogs.dart';
import '../../../../../Core/widget/form_sheet.dart';
import '../../cubit/levels_cubit.dart';

Future<void> showLevelForm(BuildContext context, {Level? existing}) async {
  final cubit = context.read<LevelsCubit>();
  await showAppFormSheet(
    context,
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: _LevelForm(existing: existing),
    ),
  );
}

class _LevelForm extends StatefulWidget {
  final Level? existing;
  const _LevelForm({this.existing});

  @override
  State<_LevelForm> createState() => _LevelFormState();
}

class _LevelFormState extends State<_LevelForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _order;
  late final TextEditingController _description;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.existing?.name ?? '');
    _order = TextEditingController(
        text: (widget.existing?.sortOrder ?? 0).toString());
    _description =
        TextEditingController(text: widget.existing?.description ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _order.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final level = Level(
      id: widget.existing?.id ?? '',
      name: _name.text.trim(),
      description: _description.text.trim().isEmpty
          ? null
          : _description.text.trim(),
      sortOrder: int.tryParse(_order.text.trim()) ?? 0,
    );
    final ok = await context.read<LevelsCubit>().save(level);
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
              ? LocaleKeys.addLevel.tr()
              : LocaleKeys.editLevel.tr()),
          TextFormField(
            controller: _name,
            decoration: InputDecoration(labelText: LocaleKeys.levelName.tr()),
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
                  '${LocaleKeys.lectureDescription.tr()} (${LocaleKeys.optional.tr()})',
            ),
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _order,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: LocaleKeys.sortOrder.tr()),
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
