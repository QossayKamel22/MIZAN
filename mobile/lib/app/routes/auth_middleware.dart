import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'app_routes.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';

/// Guards authenticated-only routes (docs/NAVIGATION_STRUCTURE.md §3).
class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final auth = Get.isRegistered<AuthController>()
        ? Get.find<AuthController>()
        : null;
    if (auth == null || !auth.isAuthenticated) {
      return const RouteSettings(name: AppRoutes.auth);
    }
    return null;
  }
}
