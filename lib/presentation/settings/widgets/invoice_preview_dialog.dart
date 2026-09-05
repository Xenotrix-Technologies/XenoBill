import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/invoice_display_settings.dart';
import '../../../infrastructure/database/app_database.dart';

class InvoicePreviewDialog extends StatelessWidget {
  final InvoiceDisplaySettings settings;

  const InvoicePreviewDialog({super.key, required this.settings});

  static void show(BuildContext context, InvoiceDisplaySettings settings) {
    showDialog(
      context: context,
      builder: (ctx) => InvoicePreviewDialog(settings: settings),
    );
  }

  @override
  Widget build(BuildContext context) {
    final biz = AppDatabase.instance.currentBusiness;
    final bizName = biz?.name.isNotEmpty == true ? biz!.name : 'Demo Store & Services';
    final phone = biz?.phone.isNotEmpty == true ? biz!.phone : '9876543210';
    final address = biz?.address.isNotEmpty == true ? biz!.address : 'Demo Market, Station Road, Mumbai';
    final gstin = biz?.gstin.isNotEmpty == true ? biz!.gstin : '27AABCU9603R1ZM';
    final isGst = biz?.gstEnabled ?? true;

    final paperUpper = settings.paperSize.toUpperCase();
    final bool isA4OrA5 = paperUpper.contains('A4') || paperUpper.contains('A5');
    final bool isThermal58 = settings.paperSize.contains('58mm');

    final double dialogWidth = isA4OrA5 ? 520.0 : (isThermal58 ? 300.0 : 350.0);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: BoxConstraints(maxWidth: dialogWidth, maxHeight: 660),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Preview Dialog Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        isA4OrA5 ? Icons.description_outlined : Icons.receipt_long_outlined,
                        color: AppColors.darkNavy,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Preview (${settings.paperSize})',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.darkNavy),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isA4OrA5 ? const Color(0xFFEFF6FF) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: isA4OrA5 ? const Color(0xFFBFDBFE) : const Color(0xFFCBD5E1)),
                  ),
                  child: Text(
                    isA4OrA5 ? 'A4/A5 FORMAT' : 'THERMAL RECEIPT',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isA4OrA5 ? const Color(0xFF1D4ED8) : AppColors.darkNavy,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Scrollable Preview Container
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: isA4OrA5
                      ? _buildA4Preview(bizName, phone, address, gstin, isGst)
                      : _buildThermalPreview(bizName, phone, address, gstin, isGst),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // A4 / A5 FULL FORMAT PREVIEW
  // ==========================================
  Widget _buildA4Preview(String bizName, String phone, String address, String gstin, bool isGst) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // A4 Header Row: Left Business Info, Right TAX INVOICE & Meta
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (settings.showBusinessLogo)
                    Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(color: AppColors.darkNavy, shape: BoxShape.circle),
                      child: const Icon(Icons.storefront, color: AppColors.brightCyan, size: 18),
                    ),
                  if (settings.showBusinessName)
                    Text(
                      bizName,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkNavy),
                    ),
                  if (settings.showBusinessAddress && address.isNotEmpty)
                    Text(address, style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B))),
                  if (settings.showPhone && phone.isNotEmpty)
                    Text('Ph: $phone', style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B))),
                  if (settings.showEmail)
                    const Text('Email: info@xenobiz.com', style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B))),
                  if (settings.showGstin && isGst && gstin.isNotEmpty)
                    Text('GSTIN: $gstin', style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: AppColors.darkNavy)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.darkNavy,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('TAX INVOICE', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8)),
                ),
                const SizedBox(height: 6),
                if (settings.showInvoiceNumber)
                  const Text('Invoice #: INV-1027', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.darkNavy)),
                if (settings.showInvoiceDate)
                  Text(
                    settings.showInvoiceTime ? 'Date: 05 Sep 2026, 12:30 PM' : 'Date: 05 Sep 2026',
                    style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                  ),
                if (settings.showInvoiceDate)
                  const Text('Due Date: 12 Sep 2026', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(4)),
                  child: const Text('PAID', style: TextStyle(color: Color(0xFF166534), fontSize: 9.5, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 12),
        const Divider(height: 1, color: Color(0xFFCBD5E1)),
        const SizedBox(height: 8),

        // Customer Info Section (Billed To)
        if (settings.showCustomerDetails) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('BILLED TO', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                    SizedBox(height: 2),
                    Text('Hari Prasad (+91 9876543210)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.darkNavy)),
                    Text('Main Market Road, Hubli', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                  ],
                ),
                if (settings.showPreviousCustomerBalance)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Text('PREV BALANCE', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                      SizedBox(height: 2),
                      Text('₹2,500.00', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.error)),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],

        // Items Table
        Table(
          border: TableBorder.all(color: const Color(0xFFE2E8F0), width: 1),
          columnWidths: const {
            0: FlexColumnWidth(3),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1.5),
          },
          children: [
            TableRow(
              decoration: const BoxDecoration(color: Color(0xFFF1F5F9)),
              children: [
                const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Text('Item / Description', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: AppColors.darkNavy)),
                ),
                if (settings.showQuantity)
                  const Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Text('Qty', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: AppColors.darkNavy), textAlign: TextAlign.center),
                  ),
                if (settings.showUnitPrice)
                  const Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Text('Rate', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: AppColors.darkNavy), textAlign: TextAlign.right),
                  ),
                const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Text('Amount', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: AppColors.darkNavy), textAlign: TextAlign.right),
                ),
              ],
            ),
            _buildA4ItemRow('Basmati Rice 5kg Pack', '2', '₹320.00', '₹640.00'),
            _buildA4ItemRow('Fortune Sunflower Oil 1L', '1', '₹165.00', '₹165.00'),
          ],
        ),

        const SizedBox(height: 12),

        // Summary Section: Bottom Left Terms, Bottom Right Totals
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Side: Terms, Custom Note, Footer Message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (settings.showPaymentMethod)
                    Container(
                      padding: const EdgeInsets.all(6),
                      margin: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(4)),
                      child: Row(
                        children: const [
                          Icon(Icons.payment, size: 12, color: AppColors.darkNavy),
                          SizedBox(width: 4),
                          Text('Payment Mode: Cash / UPI', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.darkNavy)),
                        ],
                      ),
                    ),
                  if (settings.showFooterMessage && settings.footerMessage.isNotEmpty) ...[
                    Text(settings.footerMessage, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.darkNavy)),
                    const SizedBox(height: 4),
                  ],
                  if (settings.showTermsAndConditions && settings.termsAndConditions.isNotEmpty) ...[
                    const Text('Terms & Conditions:', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                    Text(settings.termsAndConditions, style: const TextStyle(fontSize: 9, color: Color(0xFF64748B))),
                    const SizedBox(height: 4),
                  ],
                  if (settings.showCustomFooterNote && settings.customFooterNote.isNotEmpty) ...[
                    Text(settings.customFooterNote, style: const TextStyle(fontSize: 9, fontStyle: FontStyle.italic, color: Color(0xFF64748B))),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Right Side: Totals Card
            SizedBox(
              width: 180,
              child: Column(
                children: [
                  if (settings.showSubtotal)
                    _buildTotalRow('Subtotal', '₹805.00'),
                  if (settings.showDiscount && settings.showDiscountTotal)
                    _buildTotalRow('Discount', '-₹25.00'),
                  if (settings.showTaxRowAndRate && settings.showTaxTotal && isGst)
                    _buildTotalRow('GST (5%)', '₹39.00'),
                  if (settings.showAdditionalExpenses && settings.showExpenseTotal) ...[
                    if (settings.showExpenseDetails) ...[
                      _buildTotalRow('Delivery Charge', '₹50.00'),
                    ],
                  ],
                  const Divider(height: 8),
                  if (settings.showGrandTotal)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.darkNavy,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Grand Total', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                          Text('₹869.00', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.brightCyan)),
                        ],
                      ),
                    ),
                  if (settings.showAmountPaid)
                    _buildTotalRow('Amount Paid', '₹869.00'),
                  if (settings.showBalanceDue)
                    _buildTotalRow('Balance Due', '₹0.00'),
                ],
              ),
            ),
          ],
        ),

        if (settings.showAuthorizedSignature) ...[
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Column(
                children: [
                  Text('_______________________', style: TextStyle(fontSize: 10, color: Colors.grey)),
                  Text('Authorized Signature', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: AppColors.darkNavy)),
                ],
              ),
            ],
          ),
        ],
      ],
    );
  }

  // ==========================================
  // THERMAL RECEIPT FORMAT PREVIEW (DEFAULT)
  // ==========================================
  Widget _buildThermalPreview(String bizName, String phone, String address, String gstin, bool isGst) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section 1: Business Information (Centered)
        if (settings.showBusinessLogo)
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(color: AppColors.darkNavy, shape: BoxShape.circle),
              child: const Icon(Icons.storefront, color: AppColors.brightCyan, size: 18),
            ),
          ),
        if (settings.showBusinessName)
          Center(
            child: Text(
              bizName,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.darkNavy),
              textAlign: TextAlign.center,
            ),
          ),
        if (settings.showBusinessAddress && address.isNotEmpty)
          Center(
            child: Text(
              address,
              style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
              textAlign: TextAlign.center,
            ),
          ),
        if (settings.showPhone && phone.isNotEmpty)
          Center(
            child: Text(
              'Ph: $phone',
              style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
            ),
          ),
        if (settings.showEmail)
          const Center(
            child: Text('Email: demo@xenobiz.com', style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B))),
          ),
        if (settings.showGstin && isGst && gstin.isNotEmpty)
          Center(
            child: Text(
              'GSTIN: $gstin',
              style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: AppColors.darkNavy),
            ),
          ),
        const SizedBox(height: 8),
        const Divider(height: 1),
        const SizedBox(height: 8),

        // Section 2: Invoice Details
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (settings.showInvoiceNumber)
              const Text('Invoice #: INV-1027', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.darkNavy)),
            if (settings.showInvoiceDate)
              Text(
                settings.showInvoiceTime ? '05 Sep 2026, 12:30 PM' : '05 Sep 2026',
                style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
              ),
          ],
        ),
        if (settings.showCustomerDetails) ...[
          const SizedBox(height: 4),
          const Text('Customer: Hari (+91 9876543210)', style: TextStyle(fontSize: 10.5, color: Color(0xFF475569))),
        ],
        if (settings.showPreviousCustomerBalance) ...[
          const SizedBox(height: 2),
          const Text('Prev Balance: ₹2,500.00', style: TextStyle(fontSize: 10.5, color: AppColors.error)),
        ],
        const SizedBox(height: 8),
        const Divider(height: 1),
        const SizedBox(height: 8),

        // Section 3: Items Table
        Table(
          columnWidths: const {
            0: FlexColumnWidth(3),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(2),
          },
          children: [
            TableRow(
              decoration: const BoxDecoration(color: Color(0xFFF1F5F9)),
              children: [
                const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text('Item', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: AppColors.darkNavy)),
                ),
                if (settings.showQuantity)
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text('Qty', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: AppColors.darkNavy), textAlign: TextAlign.center),
                  ),
                const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text('Amount', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: AppColors.darkNavy), textAlign: TextAlign.right),
                ),
              ],
            ),
            _buildThermalItemRow('Basmati Rice 5kg', '2', '₹640.00', settings),
            _buildThermalItemRow('Fortune Oil 1L', '1', '₹165.00', settings),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(height: 1),
        const SizedBox(height: 8),

        // Section 4: Totals
        if (settings.showSubtotal)
          _buildTotalRow('Subtotal', '₹805.00'),
        if (settings.showDiscount && settings.showDiscountTotal)
          _buildTotalRow('Discount', '-₹25.00'),
        if (settings.showTaxRowAndRate && settings.showTaxTotal && isGst)
          _buildTotalRow('GST (5%)', '₹39.00'),
        if (settings.showAdditionalExpenses && settings.showExpenseTotal) ...[
          if (settings.showExpenseDetails) ...[
            _buildTotalRow('Delivery Charge', '₹50.00'),
          ],
        ],
        const Divider(),
        if (settings.showGrandTotal)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Grand Total', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.darkNavy)),
              Text('₹869.00', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.darkNavy)),
            ],
          ),
        if (settings.showPaymentMethod) ...[
          const SizedBox(height: 4),
          const Text('Payment Mode: Cash', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
        ],
        if (settings.showAmountPaid)
          _buildTotalRow('Amount Paid', '₹869.00'),
        if (settings.showBalanceDue)
          _buildTotalRow('Balance Due', '₹0.00'),

        // Footer
        const SizedBox(height: 12),
        if (settings.showFooterMessage && settings.footerMessage.isNotEmpty) ...[
          Center(
            child: Text(
              settings.footerMessage,
              style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: AppColors.darkNavy),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 4),
        ],
        if (settings.showTermsAndConditions && settings.termsAndConditions.isNotEmpty) ...[
          Center(
            child: Text(
              settings.termsAndConditions,
              style: const TextStyle(fontSize: 9.5, color: Color(0xFF64748B)),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 6),
        ],
        if (settings.showAuthorizedSignature) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Column(
                children: [
                  Text('_______________________', style: TextStyle(fontSize: 10, color: Colors.grey)),
                  Text('Authorized Signature', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: AppColors.darkNavy)),
                ],
              ),
            ],
          ),
        ],
      ],
    );
  }

  TableRow _buildA4ItemRow(String name, String qty, String rate, String amount) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: AppColors.darkNavy)),
              if (settings.showSku)
                const Text('SKU: RICE-001', style: TextStyle(fontSize: 8.5, color: Colors.grey)),
              if (settings.showHsnSac)
                const Text('HSN: 1006', style: TextStyle(fontSize: 8.5, color: Colors.grey)),
            ],
          ),
        ),
        if (settings.showQuantity)
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(qty, style: const TextStyle(fontSize: 10.5, color: AppColors.darkNavy), textAlign: TextAlign.center),
          ),
        if (settings.showUnitPrice)
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(rate, style: const TextStyle(fontSize: 10.5, color: AppColors.darkNavy), textAlign: TextAlign.right),
          ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(amount, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: AppColors.darkNavy), textAlign: TextAlign.right),
        ),
      ],
    );
  }

  TableRow _buildThermalItemRow(String name, String qty, String amount, InvoiceDisplaySettings settings) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontSize: 10.5, color: AppColors.darkNavy)),
              if (settings.showSku)
                const Text('SKU: RICE001', style: TextStyle(fontSize: 8.5, color: Colors.grey)),
              if (settings.showHsnSac)
                const Text('HSN: 1006', style: TextStyle(fontSize: 8.5, color: Colors.grey)),
            ],
          ),
        ),
        if (settings.showQuantity)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(qty, style: const TextStyle(fontSize: 10.5, color: AppColors.darkNavy), textAlign: TextAlign.center),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(amount, style: const TextStyle(fontSize: 10.5, color: AppColors.darkNavy), textAlign: TextAlign.right),
        ),
      ],
    );
  }

  Widget _buildTotalRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B))),
          Text(value, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: AppColors.darkNavy)),
        ],
      ),
    );
  }
}
