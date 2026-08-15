import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/mizan_card.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/localization/locale_controller.dart';
import '../../../../app/routes/app_routes.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Get.find<LocaleController>();
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(title: Text('dashboard_title'.tr)),
      body: Obx(() => RefreshIndicator(
            onRefresh: () async => controller.update(),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                MizanCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('dashboard_balance'.tr,
                          style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        AppFormatters.currency(controller.totalBalance,
                            localeCode: locale.locale.value.languageCode),
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.copyWith(color: colors.primary),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: _MiniStat(
                              label: 'dashboard_income'.tr,
                              value: AppFormatters.currency(
                                  controller.monthIncome,
                                  localeCode:
                                      locale.locale.value.languageCode),
                              color: colors.success,
                            ),
                          ),
                          Expanded(
                            child: _MiniStat(
                              label: 'dashboard_expenses'.tr,
                              value: AppFormatters.currency(
                                  controller.monthExpenses,
                                  localeCode:
                                      locale.locale.value.languageCode),
                              color: colors.danger,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                MizanCard(
                  onTap: () => Get.toNamed(AppRoutes.aiAssistant),
                  child: Row(
                    children: [
                      Icon(Icons.auto_awesome, color: colors.primary),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(controller.topInsight,
                            style: Theme.of(context).textTheme.bodyMedium),
                      ),
                      Icon(Icons.chevron_right, color: colors.textTertiary),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('dashboard_upcoming_bills'.tr,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                if (controller.upcomingBills.isEmpty)
                  Text('No upcoming bills in the next 7 days.',
                      style: Theme.of(context).textTheme.bodyMedium)
                else
                  ...controller.upcomingBills.map((b) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: MizanCard(
                          child: Row(
                            children: [
                              Icon(Icons.receipt_long,
                                  color: colors.textSecondary),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                  child: Text(b.payeeName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge)),
                              Text(
                                AppFormatters.currency(b.amount,
                                    localeCode:
                                        locale.locale.value.languageCode),
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                      )),
                const SizedBox(height: AppSpacing.lg),
                Text('dashboard_goals'.tr,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                ...controller.store.goals.map((g) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: MizanCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(g.name,
                                style: Theme.of(context).textTheme.bodyLarge),
                            const SizedBox(height: AppSpacing.xs),
                            LinearProgressIndicator(
                              value: g.percentComplete,
                              backgroundColor: colors.surfaceAlt,
                              color: colors.primary,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              '${AppFormatters.currency(g.currentAmount, localeCode: locale.locale.value.languageCode)} ${'budget_of'.tr} ${AppFormatters.currency(g.targetAmount, localeCode: locale.locale.value.languageCode)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          )),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        Text(value,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: color)),
      ],
    );
  }
}
