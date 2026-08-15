import 'package:get/get.dart';
import '../../../../core/local_store/finance_store.dart';
import '../../../transactions/domain/entities/transaction_entity.dart';

/// Dashboard aggregates read-only views over [FinanceStore]
/// (docs/FUNCTIONAL_REQUIREMENTS.md FR-DASH-*). Reactive: any transaction
/// or budget change elsewhere in the app is reflected here automatically
/// via GetX's `.obs` streams, satisfying FR-TXN write → dashboard update.
class DashboardController extends GetxController {
  final FinanceStore _store = Get.find<FinanceStore>();

  FinanceStore get store => _store;

  double get totalBalance => _store.totalBalance;

  double get monthIncome {
    final start = DateTime(DateTime.now().year, DateTime.now().month, 1);
    return _store.totalForType(TransactionType.income, since: start);
  }

  double get monthExpenses {
    final start = DateTime(DateTime.now().year, DateTime.now().month, 1);
    return _store.totalForType(TransactionType.expense, since: start);
  }

  List get upcomingBills {
    final horizon = DateTime.now().add(const Duration(days: 7));
    return _store.bills
        .where((b) => b.dueDate.isBefore(horizon))
        .toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  String get topInsight {
    if (upcomingBills.isNotEmpty) {
      final b = upcomingBills.first;
      final days = b.dueDate.difference(DateTime.now()).inDays;
      return 'You have "${b.payeeName}" due in $days day(s) — AED ${b.amount.toStringAsFixed(0)}.';
    }
    if (_store.budgets.isNotEmpty && _store.budgets.first.percentUsed >= 0.8) {
      return '${_store.budgets.first.categoryName ?? 'Your'} budget is at '
          '${(_store.budgets.first.percentUsed * 100).toStringAsFixed(0)}% — consider slowing down spending.';
    }
    return "You're on track this month. Ask MIZAN for a deeper look anytime.";
  }
}
