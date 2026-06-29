import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../Core/data/contact_repository.dart';
import '../../../../../Core/services/shared_pref_services.dart';
import '../../../../../Core/theme/theme_cubit.dart';
import '../../../../../Core/translations/locale_keys.g.dart';
import '../../../../../Core/unit/app_routes.dart';
import '../../../../../Core/unit/constant_data.dart';
import '../../../../../Core/widget/app_dialogs.dart';
import '../../../../../Core/widget/form_sheet.dart';
import '../../../../Auth/presentation/cubit/auth_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final email = context.read<AuthCubit>().email;
    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 32),
      children: [
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: scheme.primary.withValues(alpha: 0.12),
                child: Icon(Icons.admin_panel_settings_rounded,
                    size: 46, color: scheme.primary),
              ),
              const SizedBox(height: 12),
              Text(email ?? LocaleKeys.profile.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700)),
              Text(LocaleKeys.appTagline.tr(),
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _SectionTitle(LocaleKeys.appearance.tr()),
        _ThemeSelector(),
        const SizedBox(height: 16),
        _SectionTitle(LocaleKeys.language.tr()),
        _LanguageSelector(),
        const SizedBox(height: 24),
        Card(
          child: ListTile(
            leading: Icon(Icons.mail_outline_rounded, color: scheme.primary),
            title: Text(LocaleKeys.contactUs.tr()),
            subtitle: Text(LocaleKeys.contactUsSubtitle.tr()),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => showAppFormSheet(
              context,
              builder: (_) => _ContactSheet(source: 'admin', name: email),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: Icon(Icons.logout_rounded, color: scheme.error),
            title: Text(LocaleKeys.logout.tr(),
                style: TextStyle(color: scheme.error)),
            onTap: () async {
              final ok = await AppDialogs.confirm(
                context,
                title: LocaleKeys.logout.tr(),
                message: LocaleKeys.logoutConfirm.tr(),
                confirmText: LocaleKeys.logout.tr(),
                destructive: true,
              );
              if (ok && context.mounted) {
                await context.read<AuthCubit>().logout();
                if (context.mounted) context.go(AppRouter.kLogin);
              }
            },
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text('${LocaleKeys.version.tr()} 1.0.0',
              style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    );
  }
}

class _ContactSheet extends StatefulWidget {
  final String source;
  final String? name;
  const _ContactSheet({required this.source, this.name});

  @override
  State<_ContactSheet> createState() => _ContactSheetState();
}

class _ContactSheetState extends State<_ContactSheet> {
  final _formKey = GlobalKey<FormState>();
  final _message = TextEditingController();
  final _reply = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _message.dispose();
    _reply.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final scheme = Theme.of(context).colorScheme;
    setState(() => _sending = true);
    try {
      await ContactRepository().sendMessage(
        message: _message.text.trim(),
        source: widget.source,
        name: widget.name,
        reply: _reply.text.trim(),
      );
      navigator.pop();
      messenger.showSnackBar(
        SnackBar(content: Text(LocaleKeys.messageSent.tr())),
      );
    } catch (_) {
      if (mounted) setState(() => _sending = false);
      messenger.showSnackBar(
        SnackBar(
          content: Text(LocaleKeys.messageSendFailed.tr()),
          backgroundColor: scheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FormSheetHeader(LocaleKeys.contactUs.tr()),
          TextFormField(
            controller: _message,
            minLines: 4,
            maxLines: 8,
            textInputAction: TextInputAction.newline,
            decoration: InputDecoration(
              labelText: LocaleKeys.yourMessage.tr(),
              alignLabelWithHint: true,
            ),
            validator: (v) => (v == null || v.trim().isEmpty)
                ? LocaleKeys.pleaseFillField.tr()
                : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _reply,
            decoration: InputDecoration(
              labelText: LocaleKeys.contactReply.tr(),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _sending ? null : _send,
            icon: _sending
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send_rounded),
            label: Text(LocaleKeys.send.tr()),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 6, 6, 8),
      child: Text(text,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              )),
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, mode) {
        return Card(
          child: Column(
            children: [
              _radio(context, LocaleKeys.themeSystem.tr(), ThemeMode.system,
                  mode, Icons.brightness_auto_rounded),
              _radio(context, LocaleKeys.themeLight.tr(), ThemeMode.light, mode,
                  Icons.light_mode_rounded),
              _radio(context, LocaleKeys.themeDark.tr(), ThemeMode.dark, mode,
                  Icons.dark_mode_rounded),
            ],
          ),
        );
      },
    );
  }

  Widget _radio(BuildContext context, String label, ThemeMode value,
      ThemeMode group, IconData icon) {
    return RadioListTile<ThemeMode>(
      value: value,
      // ignore: deprecated_member_use
      groupValue: group,
      // ignore: deprecated_member_use
      onChanged: (v) => context.read<ThemeCubit>().setMode(v!),
      title: Text(label),
      secondary: Icon(icon),
      dense: true,
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final current = context.locale.languageCode;
    return Card(
      child: Column(
        children: [
          _tile(context, LocaleKeys.arabic.tr(), 'ar', current),
          _tile(context, LocaleKeys.english.tr(), 'en', current),
        ],
      ),
    );
  }

  Widget _tile(
      BuildContext context, String label, String code, String current) {
    return RadioListTile<String>(
      value: code,
      // ignore: deprecated_member_use
      groupValue: current,
      // ignore: deprecated_member_use
      onChanged: (v) async {
        await context.setLocale(Locale(v!));
        await SharedPreferencesServices.setData(
            key: ConstantData.kLung, value: v);
      },
      title: Text(label),
      dense: true,
    );
  }
}
