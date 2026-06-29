import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../Core/translations/locale_keys.g.dart';
import '../../../../../Core/unit/app_routes.dart';
import '../../../../../Core/widget/app_dialogs.dart';
import '../../../../../generated/assets.dart';
import '../../cubit/auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final ok = await context.read<AuthCubit>().login(
          email: _email.text.trim(),
          password: _password.text,
        );
    if (!mounted) return;
    if (ok) {
      context.go(AppRouter.kHome);
    }
  }

  Future<void> _forgot() async {
    if (_email.text.trim().isEmpty) {
      AppDialogs.snack(context, LocaleKeys.invalidEmail.tr(), error: true);
      return;
    }
    final ok = await context.read<AuthCubit>().sendReset(_email.text.trim());
    if (!mounted) return;
    AppDialogs.snack(
      context,
      ok ? LocaleKeys.resetLinkSent.tr() : LocaleKeys.somethingWentWrong.tr(),
      error: !ok,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  final loading = state.status == AuthStatus.loading;
                  return Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: Image.asset(
                            Assets.imageIcLauncherForeground,
                            height: 140,
                            color: scheme.primary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          LocaleKeys.adminLoginTitle.tr(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          LocaleKeys.adminLoginSubtitle.tr(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 28),
                        TextFormField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: LocaleKeys.email.tr(),
                            prefixIcon: const Icon(Icons.email_rounded),
                          ),
                          validator: (v) {
                            final value = v?.trim() ?? '';
                            if (value.isEmpty || !value.contains('@')) {
                              return LocaleKeys.invalidEmail.tr();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _password,
                          obscureText: !state.showPassword,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _submit(),
                          decoration: InputDecoration(
                            labelText: LocaleKeys.password.tr(),
                            prefixIcon: const Icon(Icons.lock_rounded),
                            suffixIcon: IconButton(
                              icon: Icon(state.showPassword
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility_rounded),
                              onPressed:
                                  context.read<AuthCubit>().togglePassword,
                            ),
                          ),
                          validator: (v) => (v == null || v.isEmpty)
                              ? LocaleKeys.pleaseFillField.tr()
                              : null,
                        ),
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: TextButton(
                            onPressed: loading ? null : _forgot,
                            child: Text(LocaleKeys.forgotPassword.tr()),
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (state.status == AuthStatus.error &&
                            state.errorKey != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              state.errorKey!.tr(),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: scheme.error),
                            ),
                          ),
                        FilledButton(
                          onPressed: loading ? null : _submit,
                          child: loading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2.6),
                                )
                              : Text(LocaleKeys.login.tr()),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
