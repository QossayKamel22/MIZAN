import 'package:get/get.dart';
import '../../../../core/local_store/finance_store.dart';
import '../../domain/entities/transaction_entity.dart';

class AddTransactionController extends GetxController {
  final FinanceStore _store = Get.find<FinanceStore>();

  void addTransaction({
    required TransactionType type,
    required double amount,
    String? categoryName,
    String? categoryId,
    String? notes,
    DateTime? date,
  }) {
    _store.addTransaction(TransactionEntity(
      id: 'txn-${DateTime.now().microsecondsSinceEpoch}',
      type: type,
      amount: amount,
      occurredAt: date ?? DateTime.now(),
      categoryId: categoryId,
      categoryName: categoryName,
      notes: notes,
    ));
  }
}
