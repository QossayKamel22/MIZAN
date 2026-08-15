import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import 'add_transaction_form_screen.dart';

/// Central Add entry point (docs/NAVIGATION_STRUCTURE.md §1, FR-TXN-7):
/// a single modal, fast type selection, minimal required fields.
class AddTypeSelectorSheet extends StatelessWidget {
  const AddTypeSelectorSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const AddTypeSelectorSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final types = [
      (TransactionType.income, 'add_income', Icons.trending_up),
      (TransactionType.expense, 'add_expense', Icons.trending_down),
      (TransactionType.transfer, 'add_transfer', Icons.swap_horiz),
      (TransactionType.savingsContribution, 'add_savings', Icons.savings_outlined),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('add_title'.tr, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.lg),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              childAspectRatio: 2.6,
              physics: const NeverScrollableScrollPhysics(),
              children: types
                  .map((t) => _TypeTile(
                        icon: t.$3,
                        label: t.$2.tr,
                        color: colors.primary,
                        onTap: () {
                          Get.back();
                          Get.to(() => AddTransactionFormScreen(type: t.$1));
                        },
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeTile extends StatelessWidget {
  const _TypeTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surfaceAlt,
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: AppSpacing.sm),
            Text(label, style: Theme.of(context).textTheme.labelLarge),
          ],
        ),
      ),
    );
  }
}
