import 'package:flutter/material.dart';

/// Central colour tokens for Scroll the Geeta.
///
/// Every widget must reference these tokens via [AppColors] or through
/// [ThemeData] extensions. Never hardcode hex values in individual widgets.
class AppColors {
  AppColors._();

  // ── Light theme ──────────────────────────────────────────────────────
  static const Color lightBackground = Color(0xFFF8F5EF);
  static const Color lightPrimarySurface = Color(0xFFFFFDF8);
  static const Color lightSecondarySurface = Color(0xFFF1EBE0);
  static const Color lightElevatedSurface = Color(0xFFFFFFFF);
  static const Color lightPrimaryText = Color(0xFF27251F);
  static const Color lightSecondaryText = Color(0xFF777064);
  static const Color lightPrimaryAccent = Color(0xFFA87943);
  static const Color lightMutedTerracotta = Color(0xFFB66F58);
  static const Color lightSubtleBorder = Color(0xFFE7DFD2);
  static const Color lightSuccess = Color(0xFF617A60);
  static const Color lightDisabled = Color(0xFFCBC4B8);
  static const Color lightShimmerBase = Color(0xFFEDE8DF);
  static const Color lightShimmerHighlight = Color(0xFFF8F5EF);

  // ── Dark theme ───────────────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF1C1A17);
  static const Color darkPrimarySurface = Color(0xFF252320);
  static const Color darkSecondarySurface = Color(0xFF2E2B27);
  static const Color darkElevatedSurface = Color(0xFF353230);
  static const Color darkPrimaryText = Color(0xFFF3EDE4);
  static const Color darkSecondaryText = Color(0xFF9E9588);
  static const Color darkPrimaryAccent = Color(0xFFD4A06A);
  static const Color darkMutedTerracotta = Color(0xFFCF8B72);
  static const Color darkSubtleBorder = Color(0xFF3D3A36);
  static const Color darkSuccess = Color(0xFF7FA07E);
  static const Color darkDisabled = Color(0xFF5A564F);
  static const Color darkShimmerBase = Color(0xFF2E2B27);
  static const Color darkShimmerHighlight = Color(0xFF3D3A36);
}
