import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';

class RegisterScreen extends GetView<AuthController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();
    final confirmPasswordCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('auth_register'.tr)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: nameCtrl,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(labelText: 'auth_name'.tr),
                    validator: (v) => Validators.required(v, field: 'auth_name'.tr),
                  ),
                  const SizedBox(height: AppSpacing.md),
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
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: confirmPasswordCtrl,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'auth_confirm_password'.tr),
                    validator: (v) {
                      if (v != passwordCtrl.text) {
                        return 'auth_passwords_dont_match'.tr;
                      }
                      return null;
                    },
                  ),
                  Obx(() => controller.errorMessage.value != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.sm),
                          child: Text(controller.errorMessage.value!,
                              style: TextStyle(color: context.colors.danger)),
                        )
                      : const SizedBox.shrink()),
                  const SizedBox(height: AppSpacing.xl),
                  Obx(() => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () {
                                if (formKey.currentState!.validate()) {
                                  controller.register(
                                    nameCtrl.text,
                                    emailCtrl.text,
                                    passwordCtrl.text,
                                  );
                                }
                              },
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white))
                            : Text('auth_register'.tr),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
