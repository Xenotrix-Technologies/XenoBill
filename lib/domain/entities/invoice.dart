import 'package:equatable/equatable.dart';

enum PaymentType { cash, credit, upi, card }
enum InvoiceStatus { paid, credit, partial, cancelled }

class InvoiceItem extends Equatable {
  final String id;
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double discountAmount;
  final double gstRate;
  final double taxAmount;
  final double totalAmount;

  const InvoiceItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.discountAmount,
    required this.gstRate,
    required this.taxAmount,
    required this.totalAmount,
  });

  InvoiceItem copyWith({
    String? id,
    String? productId,
    String? productName,
    int? quantity,
    double? unitPrice,
    double? discountAmount,
    double? gstRate,
    double? taxAmount,
    double? totalAmount,
  }) {
    return InvoiceItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      discountAmount: discountAmount ?? this.discountAmount,
      gstRate: gstRate ?? this.gstRate,
      taxAmount: taxAmount ?? this.taxAmount,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }

  @override
  List<Object?> get props => [
        id,
        productId,
        productName,
        quantity,
        unitPrice,
        discountAmount,
        gstRate,
        taxAmount,
        totalAmount,
      ];
}

class Invoice extends Equatable {
  final String id;
  final String businessId;
  final String invoiceNumber;
  final DateTime invoiceDate;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final List<InvoiceItem> items;
  final double subtotal;
  final double discount;
  final double cgst;
  final double sgst;
  final double igst;
  final double grandTotal;
  final PaymentType paymentType;
  final double paidAmount;
  final double dueAmount;
  final InvoiceStatus status;

  const Invoice({
    required this.id,
    required this.businessId,
    required this.invoiceNumber,
    required this.invoiceDate,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.cgst,
    required this.sgst,
    required this.igst,
    required this.grandTotal,
    required this.paymentType,
    required this.paidAmount,
    required this.dueAmount,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        businessId,
        invoiceNumber,
        invoiceDate,
        customerId,
        customerName,
        customerPhone,
        items,
        subtotal,
        discount,
        cgst,
        sgst,
        igst,
        grandTotal,
        paymentType,
        paidAmount,
        dueAmount,
        status,
      ];
}
