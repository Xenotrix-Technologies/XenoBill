import 'package:equatable/equatable.dart';

class CustomerPayment extends Equatable {
  final String id;
  final String customerId;
  final String customerName;
  final double amount;
  final String paymentMethod;
  final DateTime paymentDate;
  final String referenceNote;
  final String? allocatedInvoiceId;

  const CustomerPayment({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.amount,
    required this.paymentMethod,
    required this.paymentDate,
    this.referenceNote = '',
    this.allocatedInvoiceId,
  });

  CustomerPayment copyWith({
    String? id,
    String? customerId,
    String? customerName,
    double? amount,
    String? paymentMethod,
    DateTime? paymentDate,
    String? referenceNote,
    String? allocatedInvoiceId,
  }) {
    return CustomerPayment(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      amount: amount ?? this.amount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentDate: paymentDate ?? this.paymentDate,
      referenceNote: referenceNote ?? this.referenceNote,
      allocatedInvoiceId: allocatedInvoiceId ?? this.allocatedInvoiceId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        customerId,
        customerName,
        amount,
        paymentMethod,
        paymentDate,
        referenceNote,
        allocatedInvoiceId,
      ];
}
