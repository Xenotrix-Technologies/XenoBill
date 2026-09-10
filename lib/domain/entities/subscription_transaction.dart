import 'package:equatable/equatable.dart';

class SubscriptionTransaction extends Equatable {
  final String id;
  final String userId;
  final DateTime date;
  final String planName;
  final double amount;
  final String status; // 'Paid', 'Pending', 'Refunded'
  final String paymentMethod; // 'UPI', 'Card •••• 4242', 'Netbanking'
  final String? invoiceId;

  const SubscriptionTransaction({
    required this.id,
    required this.userId,
    required this.date,
    required this.planName,
    required this.amount,
    required this.status,
    required this.paymentMethod,
    this.invoiceId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'date': date.toIso8601String(),
      'plan_name': planName,
      'amount': amount,
      'status': status,
      'payment_method': paymentMethod,
      'invoice_id': invoiceId,
    };
  }

  factory SubscriptionTransaction.fromJson(Map<String, dynamic> json) {
    return SubscriptionTransaction(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      planName: json['plan_name']?.toString() ?? 'Xenobill Pro',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      status: json['status']?.toString() ?? 'Paid',
      paymentMethod: json['payment_method']?.toString() ?? 'UPI',
      invoiceId: json['invoice_id']?.toString(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        date,
        planName,
        amount,
        status,
        paymentMethod,
        invoiceId,
      ];
}
