import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Neumorphic shadow styles for UberKimi
class AppShadows {
  AppShadows._();

  /// Neumorphic raised effect (light source from top-left)
  static List<BoxShadow> neumorphicRaised({bool isDark = false}) => [
        BoxShadow(
          color: AppColors.shadowLight(isDark),
          offset: const Offset(-5, -5),
          blurRadius: 15,
          spreadRadius: 1,
        ),
        BoxShadow(
          color: AppColors.shadowDark(isDark),
          offset: const Offset(5, 5),
          blurRadius: 15,
          spreadRadius: 1,
        ),
      ];

  /// Neumorphic pressed/inset effect
  static List<BoxShadow> neumorphicPressed({bool isDark = false}) => [
        BoxShadow(
          color: AppColors.shadowDark(isDark),
          offset: const Offset(-2, -2),
          blurRadius: 5,
          spreadRadius: -2,
        ),
        BoxShadow(
          color: AppColors.shadowLight(isDark),
          offset: const Offset(2, 2),
          blurRadius: 5,
          spreadRadius: -2,
        ),
      ];

  /// Subtle floating shadow for cards
  static List<BoxShadow> cardShadow({bool isDark = false}) => [
        BoxShadow(
          color: isDark
              ? Colors.black.withOpacity(0.3)
              : Colors.black.withOpacity(0.08),
          offset: const Offset(0, 4),
          blurRadius: 20,
          spreadRadius: 0,
        ),
      ];

  /// Strong shadow for modals and bottom sheets
  static List<BoxShadow> modalShadow({bool isDark = false}) => [
        BoxShadow(
          color: isDark
              ? Colors.black.withOpacity(0.5)
              : Colors.black.withOpacity(0.15),
          offset: const Offset(0, -8),
          blurRadius: 30,
          spreadRadius: 0,
        ),
      ];

  /// Glow effect for primary actions
  static List<BoxShadow> primaryGlow = [
    BoxShadow(
      color: AppColors.primary.withOpacity(0.4),
      offset: const Offset(0, 4),
      blurRadius: 20,
      spreadRadius: 0,
    ),
  ];

  /// Success glow for online status
  static List<BoxShadow> successGlow = [
    BoxShadow(
      color: AppColors.success.withOpacity(0.4),
      offset: const Offset(0, 4),
      blurRadius: 15,
      spreadRadius: 0,
    ),
  ];
}
