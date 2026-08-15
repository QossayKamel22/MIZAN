import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/budget_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/mizan_card.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../core/widgets/progress_bar.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/localization/locale_controller.dart';
import '../../../../app/routes/app_routes.dart';

class BudgetScreen extends GetView<BudgetController> {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Get.find<LocaleController>();
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: Text('budget_title'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Get.toNamed(AppRoutes.budgetCreate),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.store.budgets.isEmpty) {
          return EmptyView(
            message: 'budget_empty'.tr,
            icon: Icons.pie_chart_outline,
            action: ElevatedButton(
              onPressed: () => Get.toNamed(AppRoutes.budgetCreate),
              child: Text('budget_create'.tr),
            ),
          );
        }
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            ...controller.store.budgets.map((b) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: MizanCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(b.categoryName ?? 'Overall',
                                style: Theme.of(context).textTheme.titleMedium),
                            Text(AppFormatters.percent(b.percentUsed),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                        color: b.isOverLimit
                                            ? colors.danger
                                            : colors.primary)),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        MizanProgressBar(
                          percent: b.percentUsed,
                          isOverLimit: b.isOverLimit,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${'budget_spent'.tr}: ${AppFormatters.currency(b.spentAmount, localeCode: locale.locale.value.languageCode)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              '${'budget_remaining'.tr}: ${AppFormatters.currency(b.remainingAmount, localeCode: locale.locale.value.languageCode)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: AppSpacing.lg),
            Text('transfers_history'.tr,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            if (controller.store.transactions
                .where((t) => t.type.name == 'transfer')
                .isEmpty)
              Text('No transfers yet.',
                  style: Theme.of(context).textTheme.bodyMedium),
          ],
        );
      }),
    );
  }
}
