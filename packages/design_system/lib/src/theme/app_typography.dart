import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// App typography using Google Fonts (Inter)
class AppTypography {
  AppTypography._();

  static String get _fontFamily => GoogleFonts.inter().fontFamily!;

  // === DISPLAY ===
  static TextStyle displayLarge({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary(isDark),
        letterSpacing: -1.5,
      );

  static TextStyle displayMedium({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary(isDark),
        letterSpacing: -0.5,
      );

  // === HEADINGS ===
  static TextStyle h1({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary(isDark),
      );

  static TextStyle h2({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary(isDark),
      );

  static TextStyle h3({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary(isDark),
      );

  static TextStyle h4({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary(isDark),
      );

  // === BODY ===
  static TextStyle bodyLarge({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary(isDark),
        height: 1.5,
      );

  static TextStyle bodyMedium({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary(isDark),
        height: 1.5,
      );

  static TextStyle bodySmall({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary(isDark),
        height: 1.4,
      );

  // === LABELS ===
  static TextStyle labelLarge({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary(isDark),
        letterSpacing: 0.5,
      );

  static TextStyle labelMedium({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary(isDark),
      );

  // === SPECIAL ===
  static TextStyle price({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      );

  static TextStyle eta({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.success,
      );

  static TextStyle button = TextStyle(
    fontFamily: GoogleFonts.inter().fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  static TextStyle caption({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary(isDark),
        letterSpacing: 0.3,
      );
}
