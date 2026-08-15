import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/budget_controller.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';

class BudgetCreateScreen extends GetView<BudgetController> {
  const BudgetCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final amountCtrl = TextEditingController();
    final categoryCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('budget_create'.tr)),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: categoryCtrl,
                decoration: InputDecoration(labelText: 'add_category'.tr),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: amountCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'add_amount'.tr),
                validator: Validators.amount,
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    controller.createBudget(
                      limitAmount: double.parse(amountCtrl.text),
                      categoryName: categoryCtrl.text.isEmpty
                          ? null
                          : categoryCtrl.text,
                      categoryId: categoryCtrl.text.isEmpty
                          ? null
                          : categoryCtrl.text.toLowerCase(),
                    );
                    Get.back();
                  }
                },
                child: Text('action_save'.tr),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
