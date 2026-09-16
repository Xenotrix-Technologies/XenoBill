
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

  factory SubscriptionTransaction.fromPurchaseHistoryJson(Map<String, dynamic> json) {
    final statusRaw = json['payment_status']?.toString().toLowerCase() ?? 'paid';
    String displayStatus = 'Paid';
    if (statusRaw == 'pending') {
      displayStatus = 'Pending';
    } else if (statusRaw == 'failed') {
      displayStatus = 'Failed';
    } else if (statusRaw == 'refunded') {
      displayStatus = 'Refunded';
    } else if (statusRaw == 'cancelled') {
      displayStatus = 'Cancelled';
    }

    return SubscriptionTransaction(
      id: json['id']?.toString() ?? '',
      businessId: json['business_id']?.toString() ?? '',
      date: DateTime.tryParse(json['purchase_date']?.toString() ?? json['created_at']?.toString() ?? '') ?? DateTime.now(),
      planName: json['plan_name']?.toString() ?? 'Xenobill Pro',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      status: displayStatus,
      paymentMethod: json['payment_method']?.toString() ?? 'Razorpay Online',
      invoiceId: json['transaction_id']?.toString() ?? json['payment_reference']?.toString(),
    );
  }

  Map<String, dynamic> toPurchaseHistoryJson({
    required String businessAccountId,
    String? planId,
    String? companyName,
    String? billingCycle,
    double? originalPrice,
    double? discountAmount,
    String? purchaseType,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final isPlanUuid = planId != null &&
        RegExp(r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$')
            .hasMatch(planId);

    final isTxUuid = RegExp(r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$')
        .hasMatch(id);

    // Validate payment_status constraint: pending, paid, failed, refunded, cancelled
    final stLower = status.toLowerCase();
    String validPaymentStatus = 'paid';
    if (stLower.contains('pending')) {
      validPaymentStatus = 'pending';
    } else if (stLower.contains('fail')) {
      validPaymentStatus = 'failed';
    } else if (stLower.contains('refund')) {
      validPaymentStatus = 'refunded';
    } else if (stLower.contains('cancel')) {
      validPaymentStatus = 'cancelled';
    }

    // Validate billing_cycle constraint: monthly, 3_months, 6_months, yearly, 3_years, one_time, custom
    String? validBillingCycle;
    if (billingCycle != null) {
      final bcLower = billingCycle.toLowerCase();
      if (['monthly', '3_months', '6_months', 'yearly', '3_years', 'one_time', 'custom'].contains(bcLower)) {
        validBillingCycle = bcLower;
      }
    }

    // Validate purchase_type constraint: new, renewal, reactivation, upgrade, downgrade, offer, manual, refund
    String validPurchaseType = 'new';
    if (purchaseType != null) {
      final ptLower = purchaseType.toLowerCase();
      if (['new', 'renewal', 'reactivation', 'upgrade', 'downgrade', 'offer', 'manual', 'refund'].contains(ptLower)) {
        validPurchaseType = ptLower;
      }
    }

    return {
      if (isTxUuid) 'id': id,
      'business_id': businessAccountId,
      'plan_id': isPlanUuid ? planId : null,
      'plan_name': planName,
      'company_name': companyName,
      'amount': amount,
      'currency': 'INR',
      'billing_cycle': validBillingCycle,
      'original_price': originalPrice,
      'discount_amount': discountAmount ?? 0.0,
      'payment_status': validPaymentStatus,
      'payment_method': paymentMethod,
      'transaction_id': invoiceId ?? id,
      'purchase_date': date.toIso8601String(),
      'start_date': startDate?.toIso8601String() ?? date.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'purchase_type': validPurchaseType,
      'metadata': {},
    };
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
