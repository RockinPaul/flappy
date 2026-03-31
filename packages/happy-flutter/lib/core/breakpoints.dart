import 'package:flutter/widgets.dart';

/// Breakpoint definitions mirroring the React Native app's Unistyles config.
enum Breakpoint { xs, sm, md, lg, xl }

/// Breakpoint thresholds (in logical pixels).
class Breakpoints {
  const Breakpoints._();

  static const double xs = 0;
  static const double sm = 300;
  static const double md = 500;
  static const double lg = 800;
  static const double xl = 1200;

  /// Returns the current [Breakpoint] for the given width.
  static Breakpoint fromWidth(double width) {
    if (width >= xl) return Breakpoint.xl;
    if (width >= lg) return Breakpoint.lg;
    if (width >= md) return Breakpoint.md;
    if (width >= sm) return Breakpoint.sm;
    return Breakpoint.xs;
  }

  /// Whether the width qualifies as a tablet layout.
  static bool isTablet(double width) => width >= md;
}

/// Convenience extension on [BuildContext] for breakpoint queries.
extension BreakpointContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  Breakpoint get breakpoint => Breakpoints.fromWidth(screenWidth);
  bool get isTablet => Breakpoints.isTablet(screenWidth);
}
