import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../Core/models/app_notification.dart';
import '../../../../../Core/state/data_state.dart';
import '../../../../../Core/translations/locale_keys.g.dart';
import '../../../../../Core/widget/app_dialogs.dart';
import '../../../../../Core/widget/async_view.dart';
import '../../cubit/notifications_cubit.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationsCubit>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, DataState<List<AppNotification>>>(
      builder: (context, state) {
        return AsyncView<List<AppNotification>>(
          state: state,
          isEmpty: (d) => d.isEmpty,
          emptyText: LocaleKeys.noNotifications.tr(),
          emptyIcon: Icons.notifications_off_rounded,
          onRetry: context.read<NotificationsCubit>().load,
          builder: (items) => RefreshIndicator(
            onRefresh: context.read<NotificationsCubit>().load,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 96),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) => _NotificationTile(item: items[i]),
            ),
          ),
        );
      },
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final AppNotification item;
  const _NotificationTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: scheme.secondary.withValues(alpha: 0.18),
          child: Icon(Icons.campaign_rounded, color: scheme.secondary),
        ),
        title: Text(item.title,
            style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.body != null && item.body!.isNotEmpty) Text(item.body!),
            const SizedBox(height: 2),
            Text(
              item.levelName ?? LocaleKeys.sendToAll.tr(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        isThreeLine: item.body != null && item.body!.isNotEmpty,
        trailing: IconButton(
          icon: Icon(Icons.delete_outline_rounded, color: scheme.error),
          onPressed: () async {
            final ok = await AppDialogs.confirm(context, destructive: true);
            if (ok && context.mounted) {
              await context.read<NotificationsCubit>().remove(item.id);
            }
          },
        ),
      ),
    );
  }
}
