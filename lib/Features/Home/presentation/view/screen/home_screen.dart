import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../Core/models/level.dart';
import '../../../../../Core/state/data_state.dart';
import '../../../../../Core/translations/locale_keys.g.dart';
import '../../../../../Core/widget/app_shell.dart';
import '../../../../Levels/presentation/cubit/levels_cubit.dart';
import '../../../../Lectures/presentation/view/screen/lectures_screen.dart';
import '../../../../Lectures/presentation/view/widgets/lecture_form_sheet.dart';
import '../../../../Levels/presentation/view/screen/levels_screen.dart';
import '../../../../Levels/presentation/view/widgets/level_form_sheet.dart';
import '../../../../Notifications/presentation/view/screen/notifications_screen.dart';
import '../../../../Notifications/presentation/view/widgets/notification_form_sheet.dart';
import '../../../../Profile/presentation/view/screen/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  List<Level> _levels(BuildContext context) {
    final s = context.read<LevelsCubit>().state;
    return s is DataLoaded<List<Level>> ? s.data : const [];
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      tabs: [
        ShellTab(
          label: LocaleKeys.lectures.tr(),
          icon: Icons.library_music_outlined,
          selectedIcon: Icons.library_music_rounded,
          body: const LecturesScreen(),
          fab: Builder(
            builder: (ctx) => FloatingActionButton.extended(
              onPressed: () =>
                  showLectureForm(ctx, levels: _levels(ctx)),
              icon: const Icon(Icons.add_rounded),
              label: Text(LocaleKeys.addLecture.tr()),
            ),
          ),
        ),
        ShellTab(
          label: LocaleKeys.levels.tr(),
          icon: Icons.school_outlined,
          selectedIcon: Icons.school_rounded,
          body: const LevelsScreen(),
          fab: Builder(
            builder: (ctx) => FloatingActionButton.extended(
              onPressed: () => showLevelForm(ctx),
              icon: const Icon(Icons.add_rounded),
              label: Text(LocaleKeys.addLevel.tr()),
            ),
          ),
        ),
        ShellTab(
          label: LocaleKeys.notifications.tr(),
          icon: Icons.notifications_outlined,
          selectedIcon: Icons.notifications_rounded,
          body: const NotificationsScreen(),
          fab: Builder(
            builder: (ctx) => FloatingActionButton.extended(
              onPressed: () =>
                  showNotificationForm(ctx, levels: _levels(ctx)),
              icon: const Icon(Icons.add_rounded),
              label: Text(LocaleKeys.addNotification.tr()),
            ),
          ),
        ),
        ShellTab(
          label: LocaleKeys.profile.tr(),
          icon: Icons.person_outline_rounded,
          selectedIcon: Icons.person_rounded,
          body: const ProfileScreen(),
        ),
      ],
    );
  }
}
