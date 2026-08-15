import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../app/routes/app_routes.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('app_name'.tr,
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge
                        ?.copyWith(color: context.colors.primary)),
                const SizedBox(height: AppSpacing.sm),
                Text('auth_login'.tr,
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: AppSpacing.xxl),
                TextFormField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'auth_email'.tr),
                  validator: Validators.email,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: passwordCtrl,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'auth_password'.tr),
                  validator: Validators.password,
                ),
                Obx(() => controller.errorMessage.value != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.sm),
                        child: Text(controller.errorMessage.value!,
                            style: TextStyle(color: context.colors.danger)),
                      )
                    : const SizedBox.shrink()),
                const SizedBox(height: AppSpacing.xl),
                Obx(() => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () {
                                if (formKey.currentState!.validate()) {
                                  controller.login(
                                      emailCtrl.text, passwordCtrl.text);
                                }
                              },
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white))
                            : Text('auth_login'.tr),
                      ),
                    )),
                const SizedBox(height: AppSpacing.lg),
                Center(
                  child: TextButton(
                    onPressed: () => Get.toNamed(AppRoutes.register),
                    child: Text('${'auth_no_account'.tr} ${'auth_register'.tr}'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
