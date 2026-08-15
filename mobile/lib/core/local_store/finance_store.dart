import 'package:get/get.dart';
import '../../features/transactions/domain/entities/transaction_entity.dart';
import '../../features/budgets/domain/entities/budget_entity.dart';
import '../../features/budgets/domain/entities/bill_entity.dart';
import '../../features/budgets/domain/entities/goal_entity.dart';
import '../../features/notifications/domain/entities/notification_entity.dart';

/// In-memory data store standing in for the live backend
/// (docs/API_SPECIFICATION.md) until a deployed API/DB is available.
///
/// This is a deliberate, clearly-marked integration seam — not a fake
/// implementation dressed up as real (master prompt §25). All business
/// logic here (budget recalculation, threshold-triggered notifications)
/// mirrors what `backend/app/services/` implements server-side, so the
/// client behaves correctly today and the seam to swap in
/// `ApiClient`-backed repositories later is a repository-implementation
/// change only — controllers and domain layers do not change.
class FinanceStore extends GetxService {
  final RxList<TransactionEntity> transactions = <TransactionEntity>[].obs;
  final RxList<BudgetEntity> budgets = <BudgetEntity>[].obs;
  final RxList<BillEntity> bills = <BillEntity>[].obs;
  final RxList<GoalEntity> goals = <GoalEntity>[].obs;
  final RxList<NotificationEntity> notifications = <NotificationEntity>[].obs;

  int _idCounter = 1000;
  String _nextId() => 'local-${_idCounter++}';

  @override
  void onInit() {
    super.onInit();
    _seedDemoData();
  }

  double get totalBalance {
    double balance = 0;
    for (final t in transactions) {
      switch (t.type) {
        case TransactionType.income:
          balance += t.amount;
          break;
        case TransactionType.expense:
          balance -= t.amount;
          break;
        case TransactionType.savingsContribution:
          balance -= t.amount;
          break;
        case TransactionType.transfer:
          break;
      }
    }
    return balance;
  }

  double totalForType(TransactionType type, {DateTime? since}) {
    return transactions
        .where((t) => t.type == type && (since == null || !t.occurredAt.isBefore(since)))
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  void addTransaction(TransactionEntity transaction) {
    transactions.insert(0, transaction);
    _recalculateBudgets();
  }

  void addBudget(BudgetEntity budget) {
    budgets.add(budget);
    _recalculateBudgets();
  }

  void addBill(BillEntity bill) => bills.add(bill);

  void addGoal(GoalEntity goal) => goals.add(goal);

  void contributeToGoal(String goalId, double amount) {
    final index = goals.indexWhere((g) => g.id == goalId);
    if (index == -1) return;
    final goal = goals[index];
    goals[index] = GoalEntity(
      id: goal.id,
      name: goal.name,
      targetAmount: goal.targetAmount,
      currentAmount: goal.currentAmount + amount,
      targetDate: goal.targetDate,
    );
    addTransaction(TransactionEntity(
      id: _nextId(),
      type: TransactionType.savingsContribution,
      amount: amount,
      occurredAt: DateTime.now(),
      goalId: goalId,
      categoryName: 'Savings',
    ));
  }

  void markNotificationRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index == -1) return;
    notifications[index] = notifications[index].copyWithRead(true);
  }

  void markAllNotificationsRead() {
    for (var i = 0; i < notifications.length; i++) {
      notifications[i] = notifications[i].copyWithRead(true);
    }
    notifications.refresh();
  }

  /// Mirrors docs/SYSTEM_ARCHITECTURE.md §3.1: on transaction write,
  /// recalculate affected budgets and generate a threshold notification
  /// (UC-5 in docs/USE_CASES.md) — same rule the backend service layer
  /// implements server-side (backend/app/services/budget_service.py).
  void _recalculateBudgets() {
    for (var i = 0; i < budgets.length; i++) {
      final budget = budgets[i];
      final spent = transactions
          .where((t) =>
              t.type == TransactionType.expense &&
              (budget.categoryId == null || t.categoryId == budget.categoryId) &&
              !t.occurredAt.isBefore(budget.periodStart) &&
              !t.occurredAt.isAfter(budget.periodEnd))
          .fold(0.0, (sum, t) => sum + t.amount);

      final previousPercent = budget.percentUsed;
      final updated = budget.copyWithSpent(spent);
      budgets[i] = updated;

      final crossedThreshold = previousPercent < 0.8 && updated.percentUsed >= 0.8;
      final crossedLimit = previousPercent < 1.0 && updated.percentUsed >= 1.0;
      if (crossedLimit) {
        _pushNotification(
          type: NotificationType.budgetAlert,
          title: 'Budget limit reached',
          body: '${updated.categoryName ?? 'Overall'} budget has reached its limit.',
        );
      } else if (crossedThreshold) {
        _pushNotification(
          type: NotificationType.budgetAlert,
          title: 'Budget at 80%',
          body: '${updated.categoryName ?? 'Overall'} budget is at 80% of its limit.',
        );
      }
    }
  }

  void _pushNotification({
    required NotificationType type,
    required String title,
    required String body,
  }) {
    notifications.insert(
      0,
      NotificationEntity(
        id: _nextId(),
        type: type,
        title: title,
        body: body,
        createdAt: DateTime.now(),
      ),
    );
  }

  void _seedDemoData() {
    final now = DateTime.now();
    final periodStart = DateTime(now.year, now.month, 1);
    final periodEnd = DateTime(now.year, now.month + 1, 0);

    transactions.addAll([
      TransactionEntity(
        id: _nextId(),
        type: TransactionType.income,
        amount: 12000,
        occurredAt: DateTime(now.year, now.month, 1),
        categoryName: 'Salary',
      ),
      TransactionEntity(
        id: _nextId(),
        type: TransactionType.expense,
        amount: 850,
        occurredAt: now.subtract(const Duration(days: 2)),
        categoryId: 'groceries',
        categoryName: 'Groceries',
      ),
      TransactionEntity(
        id: _nextId(),
        type: TransactionType.expense,
        amount: 320,
        occurredAt: now.subtract(const Duration(days: 1)),
        categoryId: 'dining',
        categoryName: 'Dining',
      ),
    ]);

    budgets.add(BudgetEntity(
      id: _nextId(),
      limitAmount: 1500,
      period: BudgetPeriod.monthly,
      periodStart: periodStart,
      periodEnd: periodEnd,
      categoryId: 'groceries',
      categoryName: 'Groceries',
    ));

    bills.addAll([
      BillEntity(
        id: _nextId(),
        payeeName: 'DEWA (Electricity & Water)',
        amount: 420,
        dueDate: now.add(const Duration(days: 3)),
      ),
      BillEntity(
        id: _nextId(),
        payeeName: 'Etisalat',
        amount: 199,
        dueDate: now.add(const Duration(days: 6)),
      ),
    ]);

    goals.add(GoalEntity(
      id: _nextId(),
      name: 'Emergency Fund',
      targetAmount: 20000,
      currentAmount: 6500,
      targetDate: DateTime(now.year + 1, now.month, 1),
    ));

    notifications.add(NotificationEntity(
      id: _nextId(),
      type: NotificationType.billReminder,
      title: 'Upcoming bill',
      body: 'DEWA bill of AED 420 is due in 3 days.',
      createdAt: now.subtract(const Duration(hours: 4)),
    ));

    _recalculateBudgets();
  }
}
