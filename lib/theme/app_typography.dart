import 'package:flutter/material.dart';

/// Typography system for Scroll the Geeta.
///
/// Uses Google Fonts via package or system fonts.
/// Sanskrit verses use Noto Sans Devanagari for correct rendering.
/// English editorial text uses a refined serif/sans combination.
class AppTypography {
  AppTypography._();

  // Font families — we use Google Fonts loaded at runtime
  static const String sansFontFamily = 'Outfit';
  static const String serifFontFamily = 'Libre Baskerville';
  static const String devanagariFontFamily = 'Noto Sans Devanagari';

  /// Sanskrit verse — the visual centrepiece
  static TextStyle sanskritVerse(Color color) => TextStyle(
        fontFamily: devanagariFontFamily,
        fontSize: 26,
        fontWeight: FontWeight.w500,
        height: 1.7,
        letterSpacing: 0.3,
        color: color,
      );

  /// Sanskrit verse — compact for cards
  static TextStyle sanskritVerseCompact(Color color) => TextStyle(
        fontFamily: devanagariFontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w500,
        height: 1.6,
        color: color,
      );

  /// Transliteration text
  static TextStyle transliteration(Color color) => TextStyle(
        fontFamily: serifFontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.italic,
        height: 1.6,
        color: color,
      );

  /// Translation body text
  static TextStyle translationBody(Color color) => TextStyle(
        fontFamily: serifFontFamily,
        fontSize: 17,
        fontWeight: FontWeight.w400,
        height: 1.7,
        color: color,
      );

  /// Page/screen title
  static TextStyle screenTitle(Color color) => TextStyle(
        fontFamily: sansFontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: -0.3,
        color: color,
      );

  /// Section heading
  static TextStyle sectionHeading(Color color) => TextStyle(
        fontFamily: sansFontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: -0.2,
        color: color,
      );

  /// Subtitle / description
  static TextStyle subtitle(Color color) => TextStyle(
        fontFamily: sansFontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: color,
      );

  /// Body text
  static TextStyle body(Color color) => TextStyle(
        fontFamily: sansFontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: color,
      );

  /// Small body
  static TextStyle bodySmall(Color color) => TextStyle(
        fontFamily: sansFontFamily,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: color,
      );

  /// Label — chapter / metadata
  static TextStyle label(Color color) => TextStyle(
        fontFamily: sansFontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.4,
        letterSpacing: 1.2,
        color: color,
      );

  /// Button label
  static TextStyle button(Color color) => TextStyle(
        fontFamily: sansFontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.4,
        letterSpacing: 0.3,
        color: color,
      );

  /// Chat message text
  static TextStyle chatMessage(Color color) => TextStyle(
        fontFamily: sansFontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: color,
      );

  /// Chip / tag
  static TextStyle chip(Color color) => TextStyle(
        fontFamily: sansFontFamily,
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: color,
      );

  /// Price display
  static TextStyle price(Color color) => TextStyle(
        fontFamily: sansFontFamily,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.5,
        color: color,
      );

  /// Verse identifier (e.g. "2.47")
  static TextStyle verseId(Color color) => TextStyle(
        fontFamily: sansFontFamily,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        height: 1.4,
        letterSpacing: 0.8,
        color: color,
      );
}
