import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_shadows.dart';

/// Neumorphic input field
class NeoInput extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool isDark;
  final int maxLines;
  final String? errorText;

  const NeoInput({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.isDark = false,
    this.maxLines = 1,
    this.errorText,
  });

  @override
  State<NeoInput> createState() => _NeoInputState();
}

class _NeoInputState extends State<NeoInput> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: AppTypography.labelMedium(isDark: widget.isDark),
          ),
          const SizedBox(height: 8),
        ],
        Focus(
          onFocusChange: (focused) => setState(() => _isFocused = focused),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: AppColors.surface(widget.isDark),
              borderRadius: BorderRadius.circular(16),
              boxShadow: _isFocused
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                  : AppShadows.neumorphicPressed(isDark: widget.isDark),
              border: hasError
                  ? Border.all(color: AppColors.error, width: 1.5)
                  : _isFocused
                      ? Border.all(color: AppColors.primary, width: 1.5)
                      : null,
            ),
            child: TextField(
              controller: widget.controller,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              onChanged: widget.onChanged,
              onTap: widget.onTap,
              readOnly: widget.readOnly,
              maxLines: widget.maxLines,
              style: AppTypography.bodyLarge(isDark: widget.isDark),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: AppTypography.bodyMedium(isDark: widget.isDark)
                    .copyWith(color: AppColors.textSecondary(widget.isDark)),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                prefixIcon: widget.prefixIcon != null
                    ? Icon(
                        widget.prefixIcon,
                        color: AppColors.textSecondary(widget.isDark),
                      )
                    : null,
                suffixIcon: widget.suffixIcon != null
                    ? IconButton(
                        icon: Icon(
                          widget.suffixIcon,
                          color: AppColors.textSecondary(widget.isDark),
                        ),
                        onPressed: widget.onSuffixTap,
                      )
                    : null,
              ),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          Text(
            widget.errorText!,
            style: AppTypography.caption().copyWith(color: AppColors.error),
          ),
        ],
      ],
    );
  }
}

/// Search input with location-style design
class SearchInput extends StatelessWidget {
  final String hintText;
  final VoidCallback? onTap;
  final bool isDark;
  final IconData? prefixIcon;

  const SearchInput({
    super.key,
    this.hintText = 'Where to?',
    this.onTap,
    this.isDark = false,
    this.prefixIcon = Icons.search,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surface(isDark),
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppShadows.cardShadow(isDark: isDark),
        ),
        child: Row(
          children: [
            Icon(
              prefixIcon,
              color: AppColors.primary,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              hintText,
              style: AppTypography.bodyLarge(isDark: isDark).copyWith(
                color: AppColors.textSecondary(isDark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
