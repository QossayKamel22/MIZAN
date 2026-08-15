import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';

class ResetPasswordScreen extends GetView<AuthController> {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailCtrl = TextEditingController();
    final sent = false.obs;

    return Scaffold(
      appBar: AppBar(title: Text('auth_reset_password'.tr)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('auth_reset_password_instructions'.tr,
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: AppSpacing.xl),
                TextFormField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'auth_email'.tr),
                  validator: Validators.email,
                ),
                Obx(() => controller.errorMessage.value != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.sm),
                        child: Text(controller.errorMessage.value!,
                            style: TextStyle(color: context.colors.danger)),
                      )
                    : const SizedBox.shrink()),
                Obx(() => sent.value
                    ? Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.sm),
                        child: Text('auth_reset_password_sent'.tr,
                            style: TextStyle(color: context.colors.success)),
                      )
                    : const SizedBox.shrink()),
                const SizedBox(height: AppSpacing.xl),
                Obx(() => ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () async {
                              if (formKey.currentState!.validate()) {
                                try {
                                  await controller
                                      .sendPasswordResetEmail(emailCtrl.text);
                                  sent.value = true;
                                } catch (_) {
                                  // errorMessage is already set by the controller.
                                }
                              }
                            },
                      child: controller.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : Text('auth_reset_password_send'.tr),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
