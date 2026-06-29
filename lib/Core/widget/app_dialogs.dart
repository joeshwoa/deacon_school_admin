import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../translations/locale_keys.g.dart';

abstract class AppDialogs {
  /// Returns true when the user confirms.
  static Future<bool> confirm(
    BuildContext context, {
    String? title,
    String? message,
    String? confirmText,
    bool destructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title ?? LocaleKeys.confirm.tr()),
        content: Text(message ?? LocaleKeys.deleteConfirm.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(LocaleKeys.cancel.tr()),
          ),
          FilledButton(
            style: destructive
                ? FilledButton.styleFrom(
                    backgroundColor: Theme.of(ctx).colorScheme.error,
                  )
                : null,
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(confirmText ?? LocaleKeys.confirm.tr()),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  static void snack(BuildContext context, String message, {bool error = false}) {
    final scheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: error ? scheme.error : null,
        ),
      );
  }
}
