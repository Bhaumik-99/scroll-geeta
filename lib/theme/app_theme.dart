import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// Central ThemeData factory for Scroll the Geeta.
class AppTheme {
  AppTheme._();

  static const double cardRadius = 16.0;
  static const double chipRadius = 24.0;
  static const double buttonRadius = 12.0;
  static const double bottomNavRadius = 24.0;
  static const double inputRadius = 14.0;

  // ── Light theme ──────────────────────────────────────────────────────
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightPrimaryAccent,
        onPrimary: Colors.white,
        secondary: AppColors.lightMutedTerracotta,
        onSecondary: Colors.white,
        surface: AppColors.lightPrimarySurface,
        onSurface: AppColors.lightPrimaryText,
        surfaceContainerHighest: AppColors.lightSecondarySurface,
        outline: AppColors.lightSubtleBorder,
        error: Color(0xFFB3261E),
        onError: Colors.white,
      ),
      fontFamily: AppTypography.sansFontFamily,
      textTheme: _buildTextTheme(Brightness.light),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        foregroundColor: AppColors.lightPrimaryText,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightPrimarySurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
          side: const BorderSide(color: AppColors.lightSubtleBorder, width: 1),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightSecondarySurface,
        selectedColor: AppColors.lightPrimaryAccent,
        labelStyle: AppTypography.chip(AppColors.lightPrimaryText),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(chipRadius),
        ),
        side: const BorderSide(color: AppColors.lightSubtleBorder, width: 1),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightPrimaryAccent,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
          textStyle: AppTypography.button(Colors.white),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.lightPrimaryAccent,
          side: const BorderSide(color: AppColors.lightSubtleBorder),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
          textStyle: AppTypography.button(AppColors.lightPrimaryAccent),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightElevatedSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: const BorderSide(color: AppColors.lightSubtleBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: const BorderSide(color: AppColors.lightSubtleBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: const BorderSide(color: AppColors.lightPrimaryAccent, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: AppTypography.body(AppColors.lightDisabled),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightPrimarySurface,
        selectedItemColor: AppColors.lightPrimaryAccent,
        unselectedItemColor: AppColors.lightSecondaryText,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(
          fontFamily: AppTypography.sansFontFamily,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: AppTypography.sansFontFamily,
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.lightSubtleBorder,
        thickness: 1,
        space: 0,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.lightSecondaryText,
        size: 22,
      ),
      splashColor: AppColors.lightPrimaryAccent.withValues(alpha: 0.08),
      highlightColor: AppColors.lightPrimaryAccent.withValues(alpha: 0.05),
    );
  }

  // ── Dark theme ───────────────────────────────────────────────────────
  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimaryAccent,
        onPrimary: AppColors.darkBackground,
        secondary: AppColors.darkMutedTerracotta,
        onSecondary: AppColors.darkBackground,
        surface: AppColors.darkPrimarySurface,
        onSurface: AppColors.darkPrimaryText,
        surfaceContainerHighest: AppColors.darkSecondarySurface,
        outline: AppColors.darkSubtleBorder,
        error: Color(0xFFF2B8B5),
        onError: Color(0xFF601410),
      ),
      fontFamily: AppTypography.sansFontFamily,
      textTheme: _buildTextTheme(Brightness.dark),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.darkPrimaryText,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkPrimarySurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
          side: const BorderSide(color: AppColors.darkSubtleBorder, width: 1),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkSecondarySurface,
        selectedColor: AppColors.darkPrimaryAccent,
        labelStyle: AppTypography.chip(AppColors.darkPrimaryText),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(chipRadius),
        ),
        side: const BorderSide(color: AppColors.darkSubtleBorder, width: 1),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimaryAccent,
          foregroundColor: AppColors.darkBackground,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
          textStyle: AppTypography.button(AppColors.darkBackground),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkPrimaryAccent,
          side: const BorderSide(color: AppColors.darkSubtleBorder),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
          textStyle: AppTypography.button(AppColors.darkPrimaryAccent),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkElevatedSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: const BorderSide(color: AppColors.darkSubtleBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: const BorderSide(color: AppColors.darkSubtleBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: const BorderSide(color: AppColors.darkPrimaryAccent, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: AppTypography.body(AppColors.darkDisabled),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkPrimarySurface,
        selectedItemColor: AppColors.darkPrimaryAccent,
        unselectedItemColor: AppColors.darkSecondaryText,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(
          fontFamily: AppTypography.sansFontFamily,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: AppTypography.sansFontFamily,
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkSubtleBorder,
        thickness: 1,
        space: 0,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.darkSecondaryText,
        size: 22,
      ),
      splashColor: AppColors.darkPrimaryAccent.withValues(alpha: 0.10),
      highlightColor: AppColors.darkPrimaryAccent.withValues(alpha: 0.06),
    );
  }

  static TextTheme _buildTextTheme(Brightness brightness) {
    final primary = brightness == Brightness.light
        ? AppColors.lightPrimaryText
        : AppColors.darkPrimaryText;
    final secondary = brightness == Brightness.light
        ? AppColors.lightSecondaryText
        : AppColors.darkSecondaryText;

    return TextTheme(
      headlineLarge: AppTypography.screenTitle(primary),
      headlineMedium: AppTypography.sectionHeading(primary),
      headlineSmall: AppTypography.subtitle(primary),
      titleLarge: AppTypography.sectionHeading(primary),
      titleMedium: AppTypography.body(primary),
      titleSmall: AppTypography.bodySmall(primary),
      bodyLarge: AppTypography.translationBody(primary),
      bodyMedium: AppTypography.body(primary),
      bodySmall: AppTypography.bodySmall(secondary),
      labelLarge: AppTypography.button(primary),
      labelMedium: AppTypography.label(secondary),
      labelSmall: AppTypography.verseId(secondary),
    );
  }
}
