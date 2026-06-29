import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/layout_cubit.dart';
import '../responsive/responsive.dart';

class ShellTab {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final Widget body;
  final Widget? fab;
  final List<Widget> actions;

  const ShellTab({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.body,
    this.fab,
    this.actions = const [],
  });
}

/// Adaptive scaffold: bottom navigation on phones, a navigation rail on
/// tablet / desktop / web. Hosts the main tabs in an [IndexedStack].
class AppShell extends StatelessWidget {
  final List<ShellTab> tabs;
  const AppShell({super.key, required this.tabs});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LayoutCubit, int>(
      builder: (context, index) {
        final safeIndex = index.clamp(0, tabs.length - 1);
        final tab = tabs[safeIndex];
        final wide = context.useWideLayout;

        final scaffold = Scaffold(
          appBar: AppBar(
            title: Text(tab.label),
            actions: tab.actions,
          ),
          body: SafeArea(
            child: IndexedStack(
              index: safeIndex,
              children: [
                for (final t in tabs)
                  ResponsiveCenter(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: t.body,
                  ),
              ],
            ),
          ),
          floatingActionButton: tab.fab,
          bottomNavigationBar: wide
              ? null
              : NavigationBar(
                  selectedIndex: safeIndex,
                  onDestinationSelected:
                      context.read<LayoutCubit>().changePage,
                  destinations: [
                    for (final t in tabs)
                      NavigationDestination(
                        icon: Icon(t.icon),
                        selectedIcon: Icon(t.selectedIcon),
                        label: t.label,
                      ),
                  ],
                ),
        );

        if (!wide) return scaffold;

        return Scaffold(
          body: SafeArea(
            child: Row(
              children: [
                NavigationRail(
                  extended: context.screenWidth >= 1200,
                  minExtendedWidth: 200,
                  selectedIndex: safeIndex,
                  onDestinationSelected:
                      context.read<LayoutCubit>().changePage,
                  labelType: context.screenWidth >= 1200
                      ? NavigationRailLabelType.none
                      : NavigationRailLabelType.all,
                  destinations: [
                    for (final t in tabs)
                      NavigationRailDestination(
                        icon: Icon(t.icon),
                        selectedIcon: Icon(t.selectedIcon),
                        label: Text(t.label),
                      ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(child: scaffold),
              ],
            ),
          ),
        );
      },
    );
  }
}
