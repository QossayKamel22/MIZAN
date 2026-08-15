import 'package:get/get.dart';
import '../../../../core/local_store/finance_store.dart';
import '../../domain/entities/budget_entity.dart';

class BudgetController extends GetxController {
  final FinanceStore _store = Get.find<FinanceStore>();

  FinanceStore get store => _store;

  void createBudget({
    required double limitAmount,
    String? categoryId,
    String? categoryName,
  }) {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 0);
    _store.addBudget(BudgetEntity(
      id: 'budget-${DateTime.now().microsecondsSinceEpoch}',
      limitAmount: limitAmount,
      period: BudgetPeriod.monthly,
      periodStart: start,
      periodEnd: end,
      categoryId: categoryId,
      categoryName: categoryName,
    ));
  }
}
