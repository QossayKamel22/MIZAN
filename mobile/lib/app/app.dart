import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import '../core/theme/app_theme.dart';
import '../core/localization/app_translations.dart';
import '../core/localization/locale_controller.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'bindings/global_binding.dart';

/// MIZAN root widget. Wires theme (Light/Dark/System — master prompt §13),
/// localization (Arabic/English, RTL/LTR — master prompt §16), and routing
/// (docs/NAVIGATION_STRUCTURE.md) together via GetMaterialApp.
class MizanApp extends StatelessWidget {
  const MizanApp({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalBinding().dependencies();
    final localeController = Get.find<LocaleController>();

    return Obx(() => GetMaterialApp(
          title: 'MIZAN',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: ThemeMode.system,
          translations: AppTranslations(),
          locale: localeController.locale.value,
          fallbackLocale: AppLocales.arabic,
          supportedLocales: AppLocales.supported,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          initialRoute: AppRoutes.auth,
          getPages: AppPages.pages,
        ));
  }
}
