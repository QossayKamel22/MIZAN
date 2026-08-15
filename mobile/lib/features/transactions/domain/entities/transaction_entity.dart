import 'package:equatable/equatable.dart';

enum TransactionType { income, expense, transfer, savingsContribution }

/// Domain entity — framework-agnostic, matches docs/DATABASE_DESIGN.md §3.4.
class TransactionEntity extends Equatable {
  const TransactionEntity({
    required this.id,
    required this.type,
    required this.amount,
    required this.occurredAt,
    this.categoryId,
    this.categoryName,
    this.notes,
    this.goalId,
    this.billId,
    this.isRecurring = false,
  });

  final String id;
  final TransactionType type;
  final double amount;
  final DateTime occurredAt;
  final String? categoryId;
  final String? categoryName;
  final String? notes;
  final String? goalId;
  final String? billId;
  final bool isRecurring;

  @override
  List<Object?> get props =>
      [id, type, amount, occurredAt, categoryId, notes, goalId, billId];
}
