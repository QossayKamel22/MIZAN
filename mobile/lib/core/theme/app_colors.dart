import 'package:flutter/material.dart';

/// MIZAN semantic color tokens.
///
/// Screens and widgets must NEVER reference raw [Color] literals directly —
/// always go through [AppColors.light] / [AppColors.dark] via the current
/// [ThemeData.extension]. This keeps Light/Dark Mode intentional rather than
/// a naive inversion (see docs/UI_UX_REQUIREMENTS.md §2.1, §3).
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.primary,
    required this.primaryMuted,
    required this.onPrimary,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.border,
    required this.success,
    required this.warning,
    required this.danger,
    required this.overlay,
  });

  final Color background;
  final Color surface;
  final Color surfaceAlt;
  final Color primary;
  final Color primaryMuted;
  final Color onPrimary;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color border;
  final Color success;
  final Color warning;
  final Color danger;
  final Color overlay;

  /// Light Mode — white/off-white surfaces, near-black text, green accent.
  static const light = AppColors(
    background: Color(0xFFFAFAF8),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFF2F3F1),
    primary: Color(0xFF1E8A5F),
    primaryMuted: Color(0xFFDCEFE4),
    onPrimary: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF12140F),
    textSecondary: Color(0xFF565A52),
    textTertiary: Color(0xFF8B8F86),
    border: Color(0xFFE6E7E2),
    success: Color(0xFF1E8A5F),
    warning: Color(0xFFB6791C),
    danger: Color(0xFFC24040),
    overlay: Color(0x66000000),
  );

  /// Dark Mode — intentionally designed, not an inversion of Light Mode.
  /// Near-black background, elevated dark-gray surfaces (not pure black
  /// cards), light-gray text (not pure white — reduces glare), same brand
  /// green tuned slightly brighter for contrast on dark surfaces.
  static const dark = AppColors(
    background: Color(0xFF0E0F0D),
    surface: Color(0xFF171915),
    surfaceAlt: Color(0xFF1F221C),
    primary: Color(0xFF34C185),
    primaryMuted: Color(0xFF1B3226),
    onPrimary: Color(0xFF08130D),
    textPrimary: Color(0xFFEDEFEA),
    textSecondary: Color(0xFFA9AEA3),
    textTertiary: Color(0xFF71766C),
    border: Color(0xFF2A2D26),
    success: Color(0xFF34C185),
    warning: Color(0xFFE0A73C),
    danger: Color(0xFFE0605E),
    overlay: Color(0x99000000),
  );

  @override
  AppColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceAlt,
    Color? primary,
    Color? primaryMuted,
    Color? onPrimary,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? border,
    Color? success,
    Color? warning,
    Color? danger,
    Color? overlay,
  }) {
    return AppColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      primary: primary ?? this.primary,
      primaryMuted: primaryMuted ?? this.primaryMuted,
      onPrimary: onPrimary ?? this.onPrimary,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      border: border ?? this.border,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      overlay: overlay ?? this.overlay,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryMuted: Color.lerp(primaryMuted, other.primaryMuted, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      border: Color.lerp(border, other.border, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
    );
  }
}

/// Convenience accessor: `context.colors.primary` instead of threading
/// Theme.of(context) everywhere.
extension AppColorsContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
