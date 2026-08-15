import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

enum AppThemeMode { system, light, dark }

const _storageKey = 'mizan_theme_mode';

/// Persists and applies the user's theme preference (master prompt §13:
/// System Default / Light / Dark, persisted across restarts).
class ThemeController extends GetxController {
  final _box = GetStorage();
  final Rx<AppThemeMode> mode = AppThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    final stored = _box.read<String>(_storageKey);
    mode.value = AppThemeMode.values.firstWhere(
      (m) => m.name == stored,
      orElse: () => AppThemeMode.system,
    );
    _applyToGetX();
  }

  void setMode(AppThemeMode newMode) {
    mode.value = newMode;
    _box.write(_storageKey, newMode.name);
    _applyToGetX();
  }

  void _applyToGetX() {
    switch (mode.value) {
      case AppThemeMode.system:
        Get.changeThemeMode(ThemeMode.system);
        break;
      case AppThemeMode.light:
        Get.changeThemeMode(ThemeMode.light);
        break;
      case AppThemeMode.dark:
        Get.changeThemeMode(ThemeMode.dark);
        break;
    }
  }
}
