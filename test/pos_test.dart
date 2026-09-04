import 'package:flutter_test/flutter_test.dart';
import 'package:xenobill_flutter/domain/entities/invoice.dart';
import 'package:xenobill_flutter/domain/usecases/calculate_invoice_totals.dart';

void main() {
  group('Universal POS Invoice Calculation', () {
    final useCase = CalculateInvoiceTotals();

    test('should calculate subtotal & taxes correctly for mixed Product + Service invoice', () {
      final items = [
        const InvoiceItem(
          id: 'item_1',
          productId: 'p1',
          productName: 'Basmati Rice 5kg',
          quantity: 2,
          unitPrice: 350.0,
          discountAmount: 0.0,
          gstRate: 5.0,
          taxAmount: 35.0,
          totalAmount: 700.0,
        ),
        const InvoiceItem(
          id: 'item_2',
          productId: 's1',
          productName: 'Haircut & Styling',
          quantity: 1,
          unitPrice: 300.0,
          discountAmount: 0.0,
          gstRate: 18.0,
          taxAmount: 54.0,
          totalAmount: 300.0,
        ),
      ];

      final result = useCase.execute(
        items: items,
        overallDiscount: 0.0,
        gstEnabled: true,
        isInterState: false,
      );

      expect(result['subtotal'], equals(1000.0));
      expect(result['totalTax'], equals(89.0)); // 35 (5% on 700) + 54 (18% on 300)
      expect(result['cgst'], equals(44.5));
      expect(result['sgst'], equals(44.5));
      expect(result['grandTotal'], equals(1089.0));
    });
  });
}
