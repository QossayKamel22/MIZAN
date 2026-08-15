import 'package:equatable/equatable.dart';

enum BillStatus { upcoming, due, overdue, paid }

class BillEntity extends Equatable {
  const BillEntity({
    required this.id,
    required this.payeeName,
    required this.amount,
    required this.dueDate,
    this.status = BillStatus.upcoming,
  });

  final String id;
  final String payeeName;
  final double amount;
  final DateTime dueDate;
  final BillStatus status;

  @override
  List<Object?> get props => [id, payeeName, amount, dueDate, status];
}
