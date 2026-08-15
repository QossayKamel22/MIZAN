import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/mizan_card.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final auth = Get.find<AuthController>();

    final items = [
      (Icons.person_outline, 'settings_profile', null),
      (Icons.palette_outlined, 'settings_appearance', AppRoutes.settingsAppearance),
      (Icons.language_outlined, 'settings_language', AppRoutes.settingsLanguage),
      (Icons.lock_outline, 'settings_security', null),
      (Icons.notifications_outlined, 'settings_notifications', null),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('settings_title'.tr)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: MizanCard(
                  onTap: item.$3 == null ? null : () => Get.toNamed(item.$3!),
                  child: Row(
                    children: [
                      Icon(item.$1, color: colors.textSecondary),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                          child: Text(item.$2.tr,
                              style: Theme.of(context).textTheme.bodyLarge)),
                      Icon(Icons.chevron_right, color: colors.textTertiary),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: AppSpacing.lg),
          OutlinedButton(
            onPressed: auth.logout,
            child: Text('settings_logout'.tr),
          ),
        ],
      ),
    );
  }
}
