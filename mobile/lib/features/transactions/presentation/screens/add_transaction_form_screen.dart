import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/add_transaction_controller.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';

/// Single generic form reused across income/expense/transfer/savings —
/// only the label set and category requirement change per type
/// (FR-TXN-1..3, FR-TXN-5, FR-TXN-7: minimal required fields).
class AddTransactionFormScreen extends GetView<AddTransactionController> {
  const AddTransactionFormScreen({super.key, required this.type});

  final TransactionType type;

  String get _titleKey {
    switch (type) {
      case TransactionType.income:
        return 'add_income';
      case TransactionType.expense:
        return 'add_expense';
      case TransactionType.transfer:
        return 'add_transfer';
      case TransactionType.savingsContribution:
        return 'add_savings';
    }
  }

  bool get _needsCategory =>
      type == TransactionType.income || type == TransactionType.expense;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final amountCtrl = TextEditingController();
    final categoryCtrl = TextEditingController();
    final notesCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text(_titleKey.tr)),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: amountCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'add_amount'.tr),
                validator: Validators.amount,
                autofocus: true,
              ),
              if (_needsCategory) ...[
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: categoryCtrl,
                  decoration: InputDecoration(labelText: 'add_category'.tr),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: notesCtrl,
                decoration: InputDecoration(labelText: 'add_notes'.tr),
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    controller.addTransaction(
                      type: type,
                      amount: double.parse(amountCtrl.text),
                      categoryName:
                          categoryCtrl.text.isEmpty ? null : categoryCtrl.text,
                      categoryId: categoryCtrl.text.isEmpty
                          ? null
                          : categoryCtrl.text.toLowerCase(),
                      notes: notesCtrl.text.isEmpty ? null : notesCtrl.text,
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
