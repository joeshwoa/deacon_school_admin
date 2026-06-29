import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../helper/loading_app_custom.dart';
import '../state/data_state.dart';
import '../translations/locale_keys.g.dart';

/// Renders the four canonical states (loading / error / empty / data) for any
/// [DataState] in a consistent, theme-aware way.
class AsyncView<T> extends StatelessWidget {
  final DataState<T> state;
  final Widget Function(T data) builder;
  final bool Function(T data)? isEmpty;
  final String? emptyText;
  final IconData emptyIcon;
  final Future<void> Function()? onRetry;

  const AsyncView({
    super.key,
    required this.state,
    required this.builder,
    this.isEmpty,
    this.emptyText,
    this.emptyIcon = Icons.inbox_rounded,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final s = state;
    if (s is DataLoading<T> || s is DataInitial<T>) {
      return const Center(child: LoadingAppCustom(size: 54));
    }
    if (s is DataError<T>) {
      return _StateMessage(
        icon: s.notConnected
            ? Icons.cloud_off_rounded
            : Icons.error_outline_rounded,
        message: s.notConnected
            ? LocaleKeys.backendNotConnected.tr()
            : LocaleKeys.somethingWentWrong.tr(),
        onRetry: onRetry,
      );
    }
    if (s is DataLoaded<T>) {
      final empty = isEmpty?.call(s.data) ?? false;
      if (empty) {
        return _StateMessage(
          icon: emptyIcon,
          message: emptyText ?? LocaleKeys.noData.tr(),
          onRetry: onRetry,
        );
      }
      return builder(s.data);
    }
    return const SizedBox.shrink();
  }
}

class _StateMessage extends StatelessWidget {
  final IconData icon;
  final String message;
  final Future<void> Function()? onRetry;

  const _StateMessage({
    required this.icon,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: scheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(LocaleKeys.retry.tr()),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(140, 44),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
