import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../Core/models/app_notification.dart';
import '../../../../../Core/models/level.dart';
import '../../../../../Core/translations/locale_keys.g.dart';
import '../../../../../Core/widget/app_dialogs.dart';
import '../../../../../Core/widget/form_sheet.dart';
import '../../cubit/notifications_cubit.dart';

Future<void> showNotificationForm(
  BuildContext context, {
  required List<Level> levels,
}) async {
  final cubit = context.read<NotificationsCubit>();
  await showAppFormSheet(
    context,
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: _NotificationForm(levels: levels),
    ),
  );
}

class _NotificationForm extends StatefulWidget {
  final List<Level> levels;
  const _NotificationForm({required this.levels});

  @override
  State<_NotificationForm> createState() => _NotificationFormState();
}

class _NotificationFormState extends State<_NotificationForm> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _body = TextEditingController();
  String? _levelId;
  bool _saving = false;

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final ok = await context.read<NotificationsCubit>().create(
          AppNotification(
            id: '',
            title: _title.text.trim(),
            body: _body.text.trim().isEmpty ? null : _body.text.trim(),
            levelId: _levelId,
          ),
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
          FormSheetHeader(LocaleKeys.addNotification.tr()),
          TextFormField(
            controller: _title,
            decoration: InputDecoration(
                labelText: LocaleKeys.notificationTitleField.tr()),
            validator: (v) => (v == null || v.trim().isEmpty)
                ? LocaleKeys.pleaseFillField.tr()
                : null,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _body,
            maxLines: 3,
            decoration:
                InputDecoration(labelText: LocaleKeys.notificationBody.tr()),
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String?>(
            initialValue: _levelId,
            decoration: InputDecoration(labelText: LocaleKeys.sendToLevel.tr()),
            items: [
              DropdownMenuItem(
                  value: null, child: Text(LocaleKeys.sendToAll.tr())),
              for (final l in widget.levels)
                DropdownMenuItem(value: l.id, child: Text(l.name)),
            ],
            onChanged: (v) => setState(() => _levelId = v),
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
