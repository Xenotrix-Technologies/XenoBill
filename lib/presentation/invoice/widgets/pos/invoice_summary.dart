import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../domain/entities/invoice.dart';

class InvoiceSummary extends StatelessWidget {
  final double subtotal;
  final double cgst;
  final double sgst;
  final double igst;
  final double totalTax;
  final double extraExpensesTotal;
  final double grandTotal;
  final double dueAmount;
  final PaymentType paymentType;

  const InvoiceSummary({
    super.key,
    required this.subtotal,
    this.cgst = 0.0,
    this.sgst = 0.0,
    this.igst = 0.0,
    required this.totalTax,
    required this.extraExpensesTotal,
    required this.grandTotal,
    required this.dueAmount,
    required this.paymentType,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCredit = paymentType == PaymentType.credit;
    final bool isIgst = igst > 0;
    final double computedCgst = cgst > 0 ? cgst : (isIgst ? 0.0 : totalTax / 2.0);
    final double computedSgst = sgst > 0 ? sgst : (isIgst ? 0.0 : totalTax / 2.0);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
              Text(CurrencyFormatter.format(subtotal), style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          if (isIgst) ...[
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('IGST', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                Text(CurrencyFormatter.format(igst), style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          ] else ...[
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('CGST', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                Text(CurrencyFormatter.format(computedCgst), style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('SGST', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                Text(CurrencyFormatter.format(computedSgst), style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          ],
          if (extraExpensesTotal > 0) ...[
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Extra Expenses', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                Text(CurrencyFormatter.format(extraExpensesTotal), style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: AppTextStyles.h2.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.nearBlack,
                ),
              ),
              Text(
                CurrencyFormatter.format(grandTotal),
                style: AppTextStyles.h1.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkNavy,
                ),
              ),
            ],
          ),
          if (isCredit) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Balance Due (Credit Sale)',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.amber.shade900),
                  ),
                  Text(
                    CurrencyFormatter.format(dueAmount > 0 ? dueAmount : grandTotal),
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.amber.shade900),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
