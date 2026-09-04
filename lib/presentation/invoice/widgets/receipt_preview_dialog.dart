import 'package:flutter/material.dart';
import '../../../domain/entities/invoice.dart';
import '../../../domain/entities/business.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/app_button.dart';
import '../../../infrastructure/services/printer_service.dart';

class ReceiptPreviewDialog extends StatelessWidget {
  final Invoice invoice;
  final Business business;

  const ReceiptPreviewDialog({
    super.key,
    required this.invoice,
    required this.business,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: AppColors.brightCyan,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: AppColors.deepNavy, size: 36),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text('Invoice Saved!', style: AppTextStyles.h2),
              Text(invoice.invoiceNumber, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.brightCyan, fontWeight: FontWeight.bold)),
              const SizedBox(height: AppSpacing.md),

              // Thermal Receipt Simulator Container
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(business.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(business.address, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary), textAlign: TextAlign.center),
                    if (business.gstin.isNotEmpty)
                      Text('GSTIN: ${business.gstin}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Customer: ${invoice.customerName}', style: const TextStyle(fontSize: 12)),
                        Text(DateFormatter.formatShortDate(invoice.invoiceDate), style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                    const Divider(),
                    ...invoice.items.map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${item.productName} x${item.quantity}', style: const TextStyle(fontSize: 12)),
                              Text(CurrencyFormatter.formatNoDecimal(item.totalAmount), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Grand Total:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text(CurrencyFormatter.format(invoice.grandTotal), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.nearBlack)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('Paid via ${invoice.paymentType.name.toUpperCase()}', style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic)),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: 'Print Receipt',
                      icon: Icons.print,
                      onPressed: () {
                        PrinterService.printThermalReceipt(
                          invoice: invoice,
                          business: business,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppButton(
                      text: 'Share',
                      icon: Icons.share,
                      isSecondary: true,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('WhatsApp receipt text ready to share!')),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close & Start Next Invoice', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkNavy)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
