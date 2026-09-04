import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';

class InvoiceActionButtons extends StatelessWidget {
  final double subtotal;
  final double cgst;
  final double sgst;
  final double igst;
  final double totalTax;
  final double grandTotal;
  final bool isSaving;
  final VoidCallback onSave;
  final VoidCallback onSaveAndPrint;

  const InvoiceActionButtons({
    super.key,
    required this.subtotal,
    this.cgst = 0.0,
    this.sgst = 0.0,
    this.igst = 0.0,
    required this.totalTax,
    required this.grandTotal,
    required this.isSaving,
    required this.onSave,
    required this.onSaveAndPrint,
  });

  @override
  Widget build(BuildContext context) {
    final bool isIgst = igst > 0;
    final double computedCgst = cgst > 0 ? cgst : (isIgst ? 0.0 : totalTax / 2.0);
    final double computedSgst = sgst > 0 ? sgst : (isIgst ? 0.0 : totalTax / 2.0);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Subtotal Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Subtotal',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  CurrencyFormatter.format(subtotal),
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF0F172A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // GST Breakdown (IGST or CGST + SGST)
            if (isIgst) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'IGST',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    CurrencyFormatter.format(igst),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF0F172A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'CGST',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    CurrencyFormatter.format(computedCgst),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF0F172A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'SGST',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    CurrencyFormatter.format(computedSgst),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF0F172A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
            ],

            const Divider(height: 1, color: Color(0xFFE2E8F0)),
            const SizedBox(height: 6),

            // Total Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Text(
                  CurrencyFormatter.format(grandTotal),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkNavy,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Buttons Row
            Row(
              children: [
                // Save button
                Expanded(
                  flex: 2,
                  child: OutlinedButton(
                    onPressed: isSaving ? null : onSave,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.darkNavy,
                      side: const BorderSide(color: AppColors.darkNavy, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      minimumSize: const Size(0, 48),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Save & Print primary button
                Expanded(
                  flex: 3,
                  child: ElevatedButton.icon(
                    onPressed: isSaving ? null : onSaveAndPrint,
                    icon: isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.deepNavy,
                            ),
                          )
                        : const Icon(Icons.print_outlined,
                            color: AppColors.deepNavy, size: 20),
                    label: Text(
                      isSaving ? 'Saving...' : 'Save & Print',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepNavy,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brightCyan,
                      foregroundColor: AppColors.deepNavy,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      minimumSize: const Size(0, 48),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
