import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  final String id;
  final String businessId;
  final String category;
  final String title;
  final String description;
  final double amount;
  final DateTime date;
  final String paymentMethod;
  final String reference;

  const Expense({
    required this.id,
    required this.businessId,
    required this.category,
    required this.title,
    this.description = '',
    required this.amount,
    required this.date,
    this.paymentMethod = 'Cash',
    this.reference = '',
  });

  @override
  List<Object?> get props => [
        id,
        businessId,
        category,
        title,
        description,
        amount,
        date,
        paymentMethod,
        reference,
      ];
}
