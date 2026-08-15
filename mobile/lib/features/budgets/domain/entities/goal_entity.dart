import 'package:equatable/equatable.dart';

class GoalEntity extends Equatable {
  const GoalEntity({
    required this.id,
    required this.name,
    required this.targetAmount,
    this.currentAmount = 0,
    this.targetDate,
  });

  final String id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime? targetDate;

  double get percentComplete =>
      targetAmount <= 0 ? 0 : (currentAmount / targetAmount).clamp(0, 1);

  @override
  List<Object?> get props => [id, name, targetAmount, currentAmount, targetDate];
}
