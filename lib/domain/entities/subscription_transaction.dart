import 'package:equatable/equatable.dart';

class SubscriptionTransaction extends Equatable {
  final String id;
  final String businessId;
  final DateTime date;
  final String planName;
  final double amount;
  final String status; // 'Paid', 'Pending', 'Refunded'
  final String paymentMethod; // 'UPI', 'Card •••• 4242', 'Netbanking'
  final String? invoiceId;

  const SubscriptionTransaction({
    required this.id,
    required this.businessId,
    required this.date,
    required this.planName,
    required this.amount,
    required this.status,
    required this.paymentMethod,
    this.invoiceId,
  });

  /// Backward compatible getter
  String get userId => businessId;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_id': businessId,
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
      businessId: json['business_id']?.toString() ?? json['user_id']?.toString() ?? '',
      date: DateTime.tryParse(json['date']?.toString() ?? json['created_at']?.toString() ?? '') ?? DateTime.now(),
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
        businessId,
        date,
        planName,
        amount,
        status,
        paymentMethod,
        invoiceId,
      ];
}
