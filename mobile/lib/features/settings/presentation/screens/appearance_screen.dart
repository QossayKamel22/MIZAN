import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../core/theme/app_spacing.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(title: Text('settings_appearance'.tr)),
      body: Obx(() => Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                RadioListTile<AppThemeMode>(
                  title: Text('settings_theme_system'.tr),
                  value: AppThemeMode.system,
                  groupValue: themeController.mode.value,
                  onChanged: (v) => themeController.setMode(v!),
                ),
                RadioListTile<AppThemeMode>(
                  title: Text('settings_theme_light'.tr),
                  value: AppThemeMode.light,
                  groupValue: themeController.mode.value,
                  onChanged: (v) => themeController.setMode(v!),
                ),
                RadioListTile<AppThemeMode>(
                  title: Text('settings_theme_dark'.tr),
                  value: AppThemeMode.dark,
                  groupValue: themeController.mode.value,
                  onChanged: (v) => themeController.setMode(v!),
                ),
              ],
            ),
          )),
    );
  }
}
