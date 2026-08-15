import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notifications_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/mizan_card.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/localization/locale_controller.dart';

class NotificationsScreen extends GetView<NotificationsController> {
  const NotificationsScreen({super.key});

  IconData _iconFor(String typeName) {
    switch (typeName) {
      case 'billReminder':
        return Icons.receipt_long;
      case 'budgetAlert':
        return Icons.warning_amber_rounded;
      case 'aiInsight':
        return Icons.auto_awesome;
      case 'goalMilestone':
        return Icons.flag_outlined;
      default:
        return Icons.notifications_none;
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = Get.find<LocaleController>();
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: Text('notifications_title'.tr),
        actions: [
          TextButton(
            onPressed: controller.markAllRead,
            child: Text('notifications_mark_all_read'.tr),
          ),
        ],
      ),
      body: Obx(() {
        final items = controller.store.notifications;
        if (items.isEmpty) {
          return EmptyView(
            message: 'notifications_empty'.tr,
            icon: Icons.notifications_none,
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.lg),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (_, i) {
            final n = items[i];
            return MizanCard(
              onTap: () => controller.markRead(n.id),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(_iconFor(n.type.name),
                      color: n.isRead ? colors.textTertiary : colors.primary),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(n.title,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight:
                                    n.isRead ? FontWeight.w400 : FontWeight.w700)),
                        const SizedBox(height: AppSpacing.xs),
                        Text(n.body, style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          AppFormatters.shortDate(n.createdAt,
                              localeCode: locale.locale.value.languageCode),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                  if (!n.isRead)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                          color: colors.primary, shape: BoxShape.circle),
                    ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
