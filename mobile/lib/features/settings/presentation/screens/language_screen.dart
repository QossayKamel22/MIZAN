import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/localization/locale_controller.dart';
import '../../../../core/theme/app_spacing.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localeController = Get.find<LocaleController>();

    return Scaffold(
      appBar: AppBar(title: Text('settings_language'.tr)),
      body: Obx(() => Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: RadioGroup<Locale>(
              groupValue: localeController.locale.value,
              onChanged: (v) => localeController.setLocale(v!),
              child: const Column(
                children: [
                  RadioListTile<Locale>(
                    title: Text('العربية'),
                    value: AppLocales.arabic,
                  ),
                  RadioListTile<Locale>(
                    title: Text('English'),
                    value: AppLocales.english,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
