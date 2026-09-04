import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../application/sales/sales_bloc.dart';
import '../../../application/customers/customers_bloc.dart';
import '../../../domain/entities/invoice.dart';
import '../../../infrastructure/database/app_database.dart';
import '../../../infrastructure/services/printer_service.dart';

class InvoiceDetailPage extends StatelessWidget {
  final String invoiceId;

  const InvoiceDetailPage({super.key, required this.invoiceId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalesBloc, SalesState>(
      builder: (context, state) {
        Invoice? invoice;
        if (state is SalesLoaded) {
          try {
            invoice = state.allInvoices.firstWhere((i) => i.id == invoiceId);
          } catch (_) {
            try {
              invoice = AppDatabase.instance.invoices.firstWhere((i) => i.id == invoiceId);
            } catch (_) {}
          }
        }

        if (invoice == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Invoice Details')),
            body: const Center(child: Text('Invoice not found')),
          );
        }

        final biz = AppDatabase.instance.currentBusiness!;

        return Scaffold(
          backgroundColor: AppColors.lightGray,
          appBar: AppBar(
            title: Text(invoice.invoiceNumber),
            actions: [
              IconButton(
                icon: const Icon(Icons.print),
                onPressed: () {
                  PrinterService.printThermalReceipt(invoice: invoice!, business: biz);
                },
                tooltip: 'Print',
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Receipt link copied to clipboard')),
                  );
                },
                tooltip: 'Share',
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  // Receipt Card
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Shop Header
                        Center(
                          child: Column(
                            children: [
                              Text(biz.name, style: AppTextStyles.h2),
                              Text(biz.address, style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
                              Text('Ph: ${biz.phone}', style: AppTextStyles.bodySmall),
                              if (biz.gstin.isNotEmpty)
                                Text('GSTIN: ${biz.gstin}', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const Divider(height: 24),

                        // Meta details
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Invoice No: ${invoice.invoiceNumber}', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                                Text('Date: ${DateFormatter.formatDateTime(invoice.invoiceDate)}', style: AppTextStyles.bodySmall),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: invoice.status == InvoiceStatus.paid ? Colors.green.shade100 : Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                invoice.paymentType.name.toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: invoice.status == InvoiceStatus.paid ? Colors.green.shade900 : Colors.orange.shade900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text('Billed To: ${invoice.customerName}', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                        const Divider(height: 24),

                        // Itemized Table
                        Table(
                          columnWidths: const {
                            0: FlexColumnWidth(3),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(2),
                          },
                          children: [
                            TableRow(
                              children: [
                                Text('Product', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
                                Text('Qty', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                                Text('Amount', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.right),
                              ],
                            ),
                            ...invoice.items.map((item) => TableRow(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      child: Text(item.productName, style: AppTextStyles.bodyMedium),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      child: Text('${item.quantity}', style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      child: Text(CurrencyFormatter.format(item.totalAmount), style: AppTextStyles.bodyMedium, textAlign: TextAlign.right),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                        const Divider(height: 24),

                        // Financial Summary
                        _buildSummaryRow('Subtotal', CurrencyFormatter.format(invoice.subtotal)),
                        if (invoice.discount > 0) _buildSummaryRow('Discount', '-${CurrencyFormatter.format(invoice.discount)}'),
                        if (biz.gstEnabled) ...[
                          _buildSummaryRow('CGST', CurrencyFormatter.format(invoice.cgst)),
                          _buildSummaryRow('SGST', CurrencyFormatter.format(invoice.sgst)),
                        ],
                        const Divider(),
                        _buildSummaryRow('Grand Total', CurrencyFormatter.format(invoice.grandTotal), isBold: true),
                        if (invoice.paymentType == PaymentType.credit) ...[
                          _buildSummaryRow('Paid Amount', CurrencyFormatter.format(invoice.paidAmount)),
                          _buildSummaryRow('Due Amount', CurrencyFormatter.format(invoice.dueAmount), isBold: true, textColor: AppColors.error),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Actions
                  if (invoice.paymentType == PaymentType.credit && invoice.dueAmount > 0) ...[
                    AppButton(
                      text: 'Record Payment for Due (₹${invoice.dueAmount.toStringAsFixed(0)})',
                      icon: Icons.payments,
                      width: double.infinity,
                      onPressed: () {
                        context.read<CustomersBloc>().add(
                          RecordCustomerPaymentEvent(customerId: invoice!.customerId, amount: invoice.dueAmount),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Payment recorded successfully!')),
                        );
                        context.pop();
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          text: 'Print Receipt',
                          icon: Icons.print,
                          onPressed: () {
                            PrinterService.printThermalReceipt(invoice: invoice!, business: biz);
                          },
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: AppButton(
                          text: 'Cancel Sale',
                          isOutlined: true,
                          customTextColor: AppColors.error,
                          onPressed: () {
                            context.read<SalesBloc>().add(CancelInvoiceEvent(invoice!.id));
                            context.pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: isBold ? AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold) : AppTextStyles.bodyMedium),
          Text(
            value,
            style: isBold
                ? AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold, color: textColor ?? AppColors.nearBlack)
                : AppTextStyles.bodyMedium.copyWith(color: textColor ?? AppColors.nearBlack),
          ),
        ],
      ),
    );
  }
}
