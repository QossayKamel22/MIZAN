import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';

/// Standard MIZAN card surface — consistent radius/padding across the app
/// so screens never redefine their own card chrome.
class MizanCard extends StatelessWidget {
  const MizanCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.onTap,
  });

  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Card(
      margin: EdgeInsets.zero,
      child: Padding(padding: padding, child: child),
    );
    if (onTap == null) return card;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.large),
      child: card,
    );
  }
}
