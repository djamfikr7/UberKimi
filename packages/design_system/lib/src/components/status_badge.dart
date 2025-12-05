import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Status badge types
enum BadgeType {
  gold,
  silver,
  platinum,
  bronze,
  online,
  offline,
  surge,
  enStock,
  scheduled,
  custom,
}

/// Colored status badge component
class StatusBadge extends StatelessWidget {
  final String text;
  final BadgeType type;
  final Color? customColor;
  final Color? customTextColor;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;

  const StatusBadge({
    super.key,
    required this.text,
    this.type = BadgeType.custom,
    this.customColor,
    this.customTextColor,
    this.fontSize,
    this.padding,
  });

  /// Factory constructors for common badge types
  factory StatusBadge.gold({String text = 'GOLD'}) =>
      StatusBadge(text: text, type: BadgeType.gold);

  factory StatusBadge.silver({String text = 'SILVER'}) =>
      StatusBadge(text: text, type: BadgeType.silver);

  factory StatusBadge.platinum({String text = 'PLATINUM'}) =>
      StatusBadge(text: text, type: BadgeType.platinum);

  factory StatusBadge.bronze({String text = 'BRONZE'}) =>
      StatusBadge(text: text, type: BadgeType.bronze);

  factory StatusBadge.online({String text = 'ONLINE'}) =>
      StatusBadge(text: text, type: BadgeType.online);

  factory StatusBadge.offline({String text = 'OFFLINE'}) =>
      StatusBadge(text: text, type: BadgeType.offline);

  factory StatusBadge.surge({required String multiplier}) =>
      StatusBadge(text: '${multiplier}x SURGE', type: BadgeType.surge);

  Color get _backgroundColor {
    switch (type) {
      case BadgeType.gold:
        return AppColors.badgeGold;
      case BadgeType.silver:
        return AppColors.badgeSilver;
      case BadgeType.platinum:
        return AppColors.badgePlatinum;
      case BadgeType.bronze:
        return AppColors.badgeBronze;
      case BadgeType.online:
        return AppColors.badgeOnline;
      case BadgeType.offline:
        return AppColors.badgeOffline;
      case BadgeType.surge:
        return AppColors.badgeSurge;
      case BadgeType.enStock:
        return AppColors.success;
      case BadgeType.scheduled:
        return AppColors.accent;
      case BadgeType.custom:
        return customColor ?? AppColors.primary;
    }
  }

  Color get _textColor {
    switch (type) {
      case BadgeType.gold:
        return AppColors.badgeGoldText;
      case BadgeType.silver:
        return AppColors.badgeSilverText;
      case BadgeType.platinum:
      case BadgeType.bronze:
      case BadgeType.online:
      case BadgeType.offline:
      case BadgeType.surge:
      case BadgeType.enStock:
      case BadgeType.scheduled:
        return Colors.white;
      case BadgeType.custom:
        return customTextColor ?? Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: AppTypography.caption().copyWith(
          color: _textColor,
          fontSize: fontSize ?? 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Animated online/offline indicator dot
class StatusDot extends StatelessWidget {
  final bool isOnline;
  final double size;

  const StatusDot({
    super.key,
    required this.isOnline,
    this.size = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isOnline ? AppColors.success : AppColors.badgeOffline,
        shape: BoxShape.circle,
        boxShadow: isOnline
            ? [
                BoxShadow(
                  color: AppColors.success.withOpacity(0.5),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
    );
  }
}
