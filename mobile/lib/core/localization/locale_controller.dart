import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

const _storageKey = 'mizan_locale';

/// Supported MIZAN locales. Arabic is first-class, not an afterthought
/// (master prompt §4, §16) — it is the default locale.
class AppLocales {
  AppLocales._();

  static const arabic = Locale('ar');
  static const english = Locale('en');

  static const supported = [arabic, english];
}

/// Persists language preference and drives RTL/LTR relayout via GetX.
class LocaleController extends GetxController {
  final _box = GetStorage();
  final Rx<Locale> locale = AppLocales.arabic.obs;

  @override
  void onInit() {
    super.onInit();
    final stored = _box.read<String>(_storageKey);
    locale.value = AppLocales.supported.firstWhere(
      (l) => l.languageCode == stored,
      orElse: () => AppLocales.arabic,
    );
    Get.updateLocale(locale.value);
  }

  bool get isRtl => locale.value.languageCode == 'ar';

  void setLocale(Locale newLocale) {
    locale.value = newLocale;
    _box.write(_storageKey, newLocale.languageCode);
    Get.updateLocale(newLocale);
  }
}
