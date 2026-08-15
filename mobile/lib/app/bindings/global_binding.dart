import 'package:get/get.dart';
import '../../core/theme/theme_controller.dart';
import '../../core/localization/locale_controller.dart';
import '../../core/local_store/finance_store.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';

/// App-wide singletons available from first frame — theme, locale, the
/// local data store, and the auth session (needed by AuthMiddleware on
/// every route).
class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ThemeController(), permanent: true);
    Get.put(LocaleController(), permanent: true);
    Get.put(FinanceStore(), permanent: true);
    Get.put(AuthController(), permanent: true);
  }
}
