import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/app_user.dart';

const _tokenStorageKey = 'firebase_id_token';

/// Auth session state, backed by real Firebase Authentication
/// (docs/SECURITY_REQUIREMENTS.md §1). `FirebaseAuth.instance` is the
/// single source of truth for identity; this controller mirrors it into
/// reactive state, keeps the ID token in secure storage in sync (consumed
/// by `ApiClient`'s request interceptor), and syncs the MIZAN profile row
/// on the backend after sign-in.
class AuthController extends GetxController {
  AuthController({FirebaseAuth? firebaseAuth, FlutterSecureStorage? secureStorage, ApiClient? apiClient})
      : _auth = firebaseAuth ?? FirebaseAuth.instance,
        _secureStorage = secureStorage ?? const FlutterSecureStorage(),
        _apiClient = apiClient ?? ApiClient(baseUrl: AppConfig.apiBaseUrl);

  final FirebaseAuth _auth;
  final FlutterSecureStorage _secureStorage;
  final ApiClient _apiClient;
  StreamSubscription<User?>? _idTokenSub;

  final Rxn<AppUser> currentUser = Rxn<AppUser>();
  final RxBool isLoading = false.obs;
  final RxBool isInitializing = true.obs;
  final RxnString errorMessage = RxnString();

  bool get isAuthenticated => currentUser.value != null;

  @override
  void onInit() {
    super.onInit();
    // Firebase auto-refreshes the ID token; mirroring it here on every
    // change keeps ApiClient's stored token from ever going stale.
    _idTokenSub = _auth.idTokenChanges().listen(_onIdTokenChanged);
  }

  @override
  void onClose() {
    _idTokenSub?.cancel();
    super.onClose();
  }

  Future<void> _onIdTokenChanged(User? user) async {
    if (user == null) {
      currentUser.value = null;
      await _secureStorage.delete(key: _tokenStorageKey);
    } else {
      final token = await user.getIdToken();
      if (token != null) {
        await _secureStorage.write(key: _tokenStorageKey, value: token);
      }
      currentUser.value = AppUser(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
        emailVerified: user.emailVerified,
      );
    }
    isInitializing.value = false;
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
      await _syncProfile();
      Get.offAllNamed(AppRoutes.dashboard);
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _messageFor(e);
    } catch (_) {
      errorMessage.value = 'auth_login_failed'.tr;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(String name, String email, String password) async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      if (name.trim().isNotEmpty) {
        await credential.user?.updateDisplayName(name.trim());
        await credential.user?.reload();
      }
      await _syncProfile(displayName: name.trim().isEmpty ? null : name.trim());
      Get.offAllNamed(AppRoutes.dashboard);
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _messageFor(e);
    } catch (_) {
      errorMessage.value = 'auth_register_failed'.tr;
    } finally {
      isLoading.value = false;
    }
  }

  /// Creates (or confirms) this account's MIZAN profile row on the backend
  /// (docs/API_SPECIFICATION.md §2) — idempotent, safe to call on every
  /// sign-in. Failure here doesn't block the client-side session: the
  /// profile sync retries on the next authenticated request.
  Future<void> _syncProfile({String? displayName}) async {
    try {
      await _apiClient.client.post(
        '/api/v1/auth/sync-profile',
        queryParameters: {
          if (displayName != null) 'display_name': displayName,
        },
      );
    } catch (_) {
      // Non-fatal: profile sync is retried implicitly on the next
      // authenticated call (backend re-checks on every request).
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _messageFor(e);
      rethrow;
    } catch (e) {
      errorMessage.value = 'auth_error_network'.tr;
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    Get.offAllNamed(AppRoutes.auth);
  }

  String _messageFor(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'auth_error_invalid_email'.tr;
      case 'weak-password':
        return 'auth_error_weak_password'.tr;
      case 'email-already-in-use':
        return 'auth_error_email_in_use'.tr;
      case 'user-not-found':
        return 'auth_error_user_not_found'.tr;
      case 'wrong-password':
      case 'invalid-credential':
        return 'auth_error_wrong_password'.tr;
      case 'user-disabled':
        return 'auth_error_user_disabled'.tr;
      case 'too-many-requests':
        return 'auth_error_too_many_requests'.tr;
      case 'network-request-failed':
        return 'auth_error_network'.tr;
      default:
        return 'auth_login_failed'.tr;
    }
  }
}
