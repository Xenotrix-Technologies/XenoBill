import '../entities/invoice.dart';

class CalculateInvoiceTotals {
  Map<String, double> execute({
    required List<InvoiceItem> items,
    required double overallDiscount,
    required bool gstEnabled,
    required bool isInterState,
  }) {
    double subtotal = 0.0;
    double totalTax = 0.0;
    double cgst = 0.0;
    double sgst = 0.0;
    double igst = 0.0;

    for (final item in items) {
      final lineSubtotal = item.unitPrice * item.quantity - item.discountAmount;
      subtotal += lineSubtotal;

      if (gstEnabled && item.gstRate > 0) {
        final lineTax = (lineSubtotal * item.gstRate) / 100.0;
        totalTax += lineTax;
        if (isInterState) {
          igst += lineTax;
        } else {
          cgst += lineTax / 2.0;
          sgst += lineTax / 2.0;
        }
      }
    }

    final netSubtotal = (subtotal - overallDiscount).clamp(0.0, double.infinity);
    final grandTotal = netSubtotal + totalTax;

    return {
      'subtotal': subtotal,
      'discount': overallDiscount,
      'cgst': cgst,
      'sgst': sgst,
      'igst': igst,
      'totalTax': totalTax,
      'grandTotal': grandTotal,
    };
  }
}
