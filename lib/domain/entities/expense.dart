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
  final String? customerId;
  final String? customerName;

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
    this.customerId,
    this.customerName,
  });

  Expense copyWith({
    String? id,
    String? businessId,
    String? category,
    String? title,
    String? description,
    double? amount,
    DateTime? date,
    String? paymentMethod,
    String? reference,
    String? customerId,
    String? customerName,
  }) {
    return Expense(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      category: category ?? this.category,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      reference: reference ?? this.reference,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
    );
  }

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
        customerId,
        customerName,
      ];
}
