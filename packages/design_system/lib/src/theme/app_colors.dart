import 'package:flutter/material.dart';

/// App color palette for UberKimi
/// Supports both light and dark modes with neumorphic design
class AppColors {
  AppColors._();

  // === LIGHT MODE ===
  static const Color lightBackground = Color(0xFFE8EDF2);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightShadowDark = Color(0xFFD1D9E6);
  static const Color lightShadowLight = Color(0xFFFFFFFF);

  // === DARK MODE ===
  static const Color darkBackground = Color(0xFF1A1D21);
  static const Color darkSurface = Color(0xFF252A31);
  static const Color darkShadowDark = Color(0xFF151719);
  static const Color darkShadowLight = Color(0xFF2A2F37);

  // === BRAND COLORS ===
  static const Color primary = Color(0xFFE91E8C);
  static const Color primaryLight = Color(0xFFFF6B9D);
  static const Color primaryDark = Color(0xFFB5156D);

  // Gradient for buttons
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFE91E8C), Color(0xFFFF6B9D)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // === ACCENT COLORS ===
  static const Color accent = Color(0xFF3B82F6);
  static const Color accentLight = Color(0xFF60A5FA);

  // === SEMANTIC COLORS ===
  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFF4ADE80);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFF87171);
  static const Color info = Color(0xFF06B6D4);

  // === TEXT COLORS ===
  static const Color textPrimaryLight = Color(0xFF1F2937);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color textTertiaryLight = Color(0xFF9CA3AF);

  static const Color textPrimaryDark = Color(0xFFF9FAFB);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);
  static const Color textTertiaryDark = Color(0xFF6B7280);

  // === STATUS BADGE COLORS ===
  static const Color badgeGold = Color(0xFFFFD700);
  static const Color badgeGoldText = Color(0xFF78350F);
  static const Color badgeSilver = Color(0xFF94A3B8);
  static const Color badgeSilverText = Color(0xFF1E293B);
  static const Color badgePlatinum = Color(0xFF7C3AED);
  static const Color badgeBronze = Color(0xFFF59E0B);
  static const Color badgeSurge = Color(0xFFEF4444);
  static const Color badgeOnline = Color(0xFF22C55E);
  static const Color badgeOffline = Color(0xFF6B7280);

  // === VEHICLE TYPE COLORS ===
  static const Color vehicleX = Color(0xFF3B82F6);
  static const Color vehicleXL = Color(0xFF8B5CF6);
  static const Color vehicleComfort = Color(0xFF10B981);
  static const Color vehicleBlack = Color(0xFF1F2937);

  // === HELPER METHODS ===
  static Color background(bool isDark) =>
      isDark ? darkBackground : lightBackground;

  static Color surface(bool isDark) => isDark ? darkSurface : lightSurface;

  static Color shadowDark(bool isDark) =>
      isDark ? darkShadowDark : lightShadowDark;

  static Color shadowLight(bool isDark) =>
      isDark ? darkShadowLight : lightShadowLight;

  static Color textPrimary(bool isDark) =>
      isDark ? textPrimaryDark : textPrimaryLight;

  static Color textSecondary(bool isDark) =>
      isDark ? textSecondaryDark : textSecondaryLight;
}
