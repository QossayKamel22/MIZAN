import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Budget/goal progress indicator. Uses shape + color together (never
/// color alone) so it stays legible for color-blind users and readable in
/// both Light and Dark themes (docs/UI_UX_REQUIREMENTS.md §7).
class MizanProgressBar extends StatelessWidget {
  const MizanProgressBar({
    super.key,
    required this.percent,
    this.height = 8,
    this.isOverLimit = false,
  });

  final double percent; // 0.0 - 1.0+
  final double height;
  final bool isOverLimit;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final clamped = percent.clamp(0.0, 1.0);
    final barColor = isOverLimit || percent >= 1.0
        ? colors.danger
        : percent >= 0.8
            ? colors.warning
            : colors.primary;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: Stack(
        children: [
          Container(height: height, color: colors.surfaceAlt),
          FractionallySizedBox(
            widthFactor: clamped,
            child: Container(height: height, color: barColor),
          ),
        ],
      ),
    );
  }
}
