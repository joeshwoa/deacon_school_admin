import 'package:flutter/material.dart';

/// Responsive breakpoints shared across the app.
abstract class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;
  static const double maxContent = 1100;
}

enum DeviceType { mobile, tablet, desktop }

extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;

  DeviceType get deviceType {
    final w = screenWidth;
    if (w >= Breakpoints.tablet) return DeviceType.desktop;
    if (w >= Breakpoints.mobile) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  bool get isMobile => deviceType == DeviceType.mobile;
  bool get isTablet => deviceType == DeviceType.tablet;
  bool get isDesktop => deviceType == DeviceType.desktop;

  /// Whether to use the wide (rail / side-nav) shell instead of bottom nav.
  bool get useWideLayout => screenWidth >= Breakpoints.mobile;

  /// Sensible column count for card grids.
  int get gridColumns {
    final w = screenWidth;
    if (w >= 1400) return 4;
    if (w >= Breakpoints.tablet) return 3;
    if (w >= Breakpoints.mobile) return 2;
    return 1;
  }
}

/// Constrains content to a comfortable reading width and centers it on large
/// screens, while staying edge-to-edge on phones.
class ResponsiveCenter extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  const ResponsiveCenter({
    super.key,
    required this.child,
    this.maxWidth = Breakpoints.maxContent,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
