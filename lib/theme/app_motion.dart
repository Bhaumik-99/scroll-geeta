import 'package:flutter/material.dart';

/// Motion tokens for consistent animation across the app.
class AppMotion {
  AppMotion._();

  // ── Durations ──────────────────────────────────────────────────────
  static const Duration buttonFeedback = Duration(milliseconds: 140);
  static const Duration stateChange = Duration(milliseconds: 200);
  static const Duration contentTransition = Duration(milliseconds: 280);
  static const Duration pageTransition = Duration(milliseconds: 320);
  static const Duration staggerDelay = Duration(milliseconds: 60);
  static const Duration shimmerDuration = Duration(milliseconds: 1500);

  // ── Curves ─────────────────────────────────────────────────────────
  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve entranceCurve = Curves.easeOutQuart;
  static const Curve exitCurve = Curves.easeInCubic;
  static const Curve bounceCurve = Curves.elasticOut;

  // ── Page transition builder ────────────────────────────────────────
  static Widget fadeThrough(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: defaultCurve,
      ),
      child: child,
    );
  }

  /// Shared-axis vertical transition
  static Widget sharedAxisVertical(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: entranceCurve));

    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: defaultCurve),
      child: SlideTransition(
        position: offsetAnimation,
        child: child,
      ),
    );
  }
}
