import 'package:flutter_test/flutter_test.dart';
import 'package:mizan/features/budgets/domain/entities/budget_entity.dart';

void main() {
  group('BudgetEntity', () {
    test('percentUsed computes spent/limit correctly', () {
      final budget = BudgetEntity(
        id: '1',
        limitAmount: 1000,
        period: BudgetPeriod.monthly,
        periodStart: DateTime(2026, 1, 1),
        periodEnd: DateTime(2026, 1, 31),
        spentAmount: 800,
      );
      expect(budget.percentUsed, 0.8);
      expect(budget.isOverLimit, isFalse);
      expect(budget.remainingAmount, 200);
    });

    test('isOverLimit true when spent exceeds limit', () {
      final budget = BudgetEntity(
        id: '2',
        limitAmount: 500,
        period: BudgetPeriod.monthly,
        periodStart: DateTime(2026, 1, 1),
        periodEnd: DateTime(2026, 1, 31),
        spentAmount: 600,
      );
      expect(budget.isOverLimit, isTrue);
    });

    test('percentUsed is 0 when limit is 0 (avoids divide-by-zero)', () {
      final budget = BudgetEntity(
        id: '3',
        limitAmount: 0,
        period: BudgetPeriod.monthly,
        periodStart: DateTime(2026, 1, 1),
        periodEnd: DateTime(2026, 1, 31),
        spentAmount: 50,
      );
      expect(budget.percentUsed, 0);
    });
  });
}
