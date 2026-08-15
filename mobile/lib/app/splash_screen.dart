import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_routes.dart';
import '../features/auth/presentation/controllers/auth_controller.dart';

/// Gates the app's initial route on Firebase's restored auth state
/// (docs/NAVIGATION_STRUCTURE.md §3) — `FirebaseAuth` restores a persisted
/// session asynchronously, so we wait for the first `idTokenChanges` event
/// before deciding between the dashboard and the login screen.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Obx(() {
      if (!auth.isInitializing.value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offAllNamed(
            auth.isAuthenticated ? AppRoutes.dashboard : AppRoutes.auth,
          );
        });
      }
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    });
  }
}
