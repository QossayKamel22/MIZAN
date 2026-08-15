import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';

class RegisterScreen extends GetView<AuthController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('auth_register'.tr)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                const SizedBox(height: AppSpacing.xl),
                Obx(() => ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () {
                              if (formKey.currentState!.validate()) {
                                controller.register(
                                    emailCtrl.text, passwordCtrl.text);
                              }
                            },
                      child: Text('auth_register'.tr),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
