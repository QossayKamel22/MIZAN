import 'package:get/get.dart';
import '../../domain/entities/app_user.dart';
import '../../../../app/routes/app_routes.dart';

/// Auth session state. Wraps Firebase Authentication
/// (docs/SECURITY_REQUIREMENTS.md §1) — real Firebase calls require a
/// provisioned Firebase project (pending, see docs/FINAL_TECHNICAL_REPORT.md).
/// The interface here is what the rest of the app depends on, so wiring in
/// real `firebase_auth` calls is isolated to this controller/its repository.
class AuthController extends GetxController {
  final Rxn<AppUser> currentUser = Rxn<AppUser>();
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  bool get isAuthenticated => currentUser.value != null;

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      // TODO(backend-integration): replace with FirebaseAuth.instance
      // .signInWithEmailAndPassword once a Firebase project is provisioned.
      await Future.delayed(const Duration(milliseconds: 400));
      currentUser.value = AppUser(id: 'demo-user', email: email);
      Get.offAllNamed(AppRoutes.dashboard);
    } catch (e) {
      errorMessage.value = 'auth_login_failed'.tr;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      // TODO(backend-integration): FirebaseAuth.instance
      // .createUserWithEmailAndPassword + POST /auth/sync-profile.
      await Future.delayed(const Duration(milliseconds: 400));
      currentUser.value = AppUser(id: 'demo-user', email: email);
      Get.offAllNamed(AppRoutes.dashboard);
    } catch (e) {
      errorMessage.value = 'auth_register_failed'.tr;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    currentUser.value = null;
    Get.offAllNamed(AppRoutes.auth);
  }
}
