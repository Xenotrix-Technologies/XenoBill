import 'package:equatable/equatable.dart';

class SmartInsight extends Equatable {
  final String id;
  final String title;
  final String message;
  final String category; // 'Sales', 'Inventory', 'Credit', 'Expenses', 'Profit'
  final String? actionLabel;
  final String? actionRoute;
  final bool isPositive;

  const SmartInsight({
    required this.id,
    required this.title,
    required this.message,
    required this.category,
    this.actionLabel,
    this.actionRoute,
    this.isPositive = true,
  });

  @override
  List<Object?> get props => [id, title, message, category, actionLabel, actionRoute, isPositive];
}
