import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Animated counter for prices and earnings
class AnimatedCounter extends StatefulWidget {
  final double value;
  final String prefix;
  final String suffix;
  final int decimalPlaces;
  final Duration duration;
  final TextStyle? style;
  final bool isDark;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.prefix = '\$',
    this.suffix = '',
    this.decimalPlaces = 2,
    this.duration = const Duration(milliseconds: 500),
    this.style,
    this.isDark = false,
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _previousValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: widget.value,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = oldWidget.value;
      _animation = Tween<double>(
        begin: _previousValue,
        end: widget.value,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ));
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          '${widget.prefix}${_animation.value.toStringAsFixed(widget.decimalPlaces)}${widget.suffix}',
          style: widget.style ?? AppTypography.price(isDark: widget.isDark),
        );
      },
    );
  }
}

/// Circular progress indicator with percentage
class CircularProgress extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final double size;
  final double strokeWidth;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Widget? child;
  final bool isDark;

  const CircularProgress({
    super.key,
    required this.value,
    this.size = 120,
    this.strokeWidth = 10,
    this.backgroundColor,
    this.foregroundColor,
    this.child,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: strokeWidth,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation(
                backgroundColor ??
                    AppColors.textSecondary(isDark).withOpacity(0.2),
              ),
            ),
          ),
          // Progress circle
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: value.clamp(0.0, 1.0),
              strokeWidth: strokeWidth,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation(
                foregroundColor ?? AppColors.success,
              ),
              strokeCap: StrokeCap.round,
            ),
          ),
          // Center content
          if (child != null) child!,
        ],
      ),
    );
  }
}

/// Earnings display with animated value
class EarningsDisplay extends StatelessWidget {
  final double amount;
  final String label;
  final bool isDark;
  final Color? color;

  const EarningsDisplay({
    super.key,
    required this.amount,
    required this.label,
    this.isDark = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.caption(isDark: isDark),
        ),
        const SizedBox(height: 4),
        AnimatedCounter(
          value: amount,
          style: AppTypography.h2(isDark: isDark).copyWith(
            color: color ?? AppColors.success,
          ),
          isDark: isDark,
        ),
      ],
    );
  }
}
