import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_shadows.dart';
import 'status_badge.dart';

/// Vehicle type card for ride selection
class VehicleCard extends StatelessWidget {
  final String name;
  final String description;
  final String price;
  final String eta;
  final IconData icon;
  final Color? iconColor;
  final bool isSelected;
  final bool hasSurge;
  final String? surgeMultiplier;
  final VoidCallback? onTap;
  final bool isDark;

  const VehicleCard({
    super.key,
    required this.name,
    required this.description,
    required this.price,
    required this.eta,
    this.icon = Icons.directions_car,
    this.iconColor,
    this.isSelected = false,
    this.hasSurge = false,
    this.surgeMultiplier,
    this.onTap,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface(isDark),
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 2)
              : null,
          boxShadow: isSelected
              ? AppShadows.primaryGlow
              : AppShadows.cardShadow(isDark: isDark),
        ),
        child: Row(
          children: [
            // Vehicle icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.vehicleX).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 32,
                color: iconColor ?? AppColors.vehicleX,
              ),
            ),
            const SizedBox(width: 16),
            // Vehicle info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: AppTypography.h4(isDark: isDark),
                      ),
                      if (hasSurge && surgeMultiplier != null) ...[
                        const SizedBox(width: 8),
                        StatusBadge.surge(multiplier: surgeMultiplier!),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTypography.bodySmall(isDark: isDark),
                  ),
                ],
              ),
            ),
            // Price and ETA
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: AppTypography.price(isDark: isDark),
                ),
                const SizedBox(height: 4),
                Text(
                  eta,
                  style: AppTypography.eta(isDark: isDark),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact vehicle card for horizontal carousel
class VehicleCardCompact extends StatelessWidget {
  final String name;
  final String price;
  final String eta;
  final IconData icon;
  final Color? iconColor;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool isDark;

  const VehicleCardCompact({
    super.key,
    required this.name,
    required this.price,
    required this.eta,
    this.icon = Icons.directions_car,
    this.iconColor,
    this.isSelected = false,
    this.onTap,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface(isDark),
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 2)
              : null,
          boxShadow: isSelected
              ? AppShadows.primaryGlow
              : AppShadows.cardShadow(isDark: isDark),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 36,
              color: isSelected
                  ? AppColors.primary
                  : (iconColor ?? AppColors.textSecondary(isDark)),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: AppTypography.labelMedium(isDark: isDark).copyWith(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textPrimary(isDark),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              price,
              style: AppTypography.labelLarge(isDark: isDark).copyWith(
                color: AppColors.primary,
              ),
            ),
            Text(
              eta,
              style: AppTypography.caption(isDark: isDark),
            ),
          ],
        ),
      ),
    );
  }
}
