import 'package:equatable/equatable.dart';

enum BudgetPeriod { weekly, monthly, custom }

class BudgetEntity extends Equatable {
  const BudgetEntity({
    required this.id,
    required this.limitAmount,
    required this.period,
    required this.periodStart,
    required this.periodEnd,
    this.categoryId,
    this.categoryName,
    this.spentAmount = 0,
  });

  final String id;
  final double limitAmount;
  final BudgetPeriod period;
  final DateTime periodStart;
  final DateTime periodEnd;
  final String? categoryId;
  final String? categoryName;
  final double spentAmount;

  double get remainingAmount => (limitAmount - spentAmount).clamp(
      -double.infinity, double.infinity);

  double get percentUsed =>
      limitAmount <= 0 ? 0 : (spentAmount / limitAmount).clamp(0, 999);

  bool get isOverLimit => spentAmount > limitAmount;

  BudgetEntity copyWithSpent(double spent) => BudgetEntity(
        id: id,
        limitAmount: limitAmount,
        period: period,
        periodStart: periodStart,
        periodEnd: periodEnd,
        categoryId: categoryId,
        categoryName: categoryName,
        spentAmount: spent,
      );

  @override
  List<Object?> get props => [id, limitAmount, period, categoryId, spentAmount];
}
