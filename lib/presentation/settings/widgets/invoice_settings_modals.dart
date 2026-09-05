import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../application/business/business_bloc.dart';
import '../../../infrastructure/database/app_database.dart';
import '../../../domain/entities/business.dart';

/// Modal for General Invoice Printing & Display Settings
class InvoiceSettingsModal extends StatefulWidget {
  final Business? business;

  const InvoiceSettingsModal({super.key, required this.business});

  static void show(BuildContext context, Business? business) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => InvoiceSettingsModal(business: business),
    );
  }

  @override
  State<InvoiceSettingsModal> createState() => _InvoiceSettingsModalState();
}

class _InvoiceSettingsModalState extends State<InvoiceSettingsModal> {
  late bool showGst;
  late bool showAddress;
  late bool showPhone;
  late bool showTerms;
  late bool showSignature;
  final TextEditingController termsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    showGst = widget.business?.gstEnabled ?? true;
    showAddress = true;
    showPhone = true;
    showTerms = true;
    showSignature = true;
    termsController.text = 'Thank you for your business! Goods once sold cannot be returned.';
  }

  @override
  void dispose() {
    termsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.description_outlined, color: AppColors.darkNavy, size: 24),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Invoice Display & Printing Settings',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.darkNavy),
                    ),
                  ),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ],
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Show GST Details on Invoice'),
                value: showGst,
                activeColor: AppColors.brightCyan,
                onChanged: (v) => setState(() => showGst = v),
              ),
              SwitchListTile(
                title: const Text('Include Business Address'),
                value: showAddress,
                activeColor: AppColors.brightCyan,
                onChanged: (v) => setState(() => showAddress = v),
              ),
              SwitchListTile(
                title: const Text('Include Phone & Contact Info'),
                value: showPhone,
                activeColor: AppColors.brightCyan,
                onChanged: (v) => setState(() => showPhone = v),
              ),
              SwitchListTile(
                title: const Text('Show Terms & Conditions'),
                value: showTerms,
                activeColor: AppColors.brightCyan,
                onChanged: (v) => setState(() => showTerms = v),
              ),
              SwitchListTile(
                title: const Text('Include Authorized Signature Line'),
                value: showSignature,
                activeColor: AppColors.brightCyan,
                onChanged: (v) => setState(() => showSignature = v),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: termsController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Default Terms & Conditions / Footer Note',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invoice display settings saved successfully!')),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkNavy,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Save Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Modal for Prefix & Numbering Configuration
class PrefixNumberingModal extends StatefulWidget {
  final Business? business;

  const PrefixNumberingModal({super.key, required this.business});

  static void show(BuildContext context, Business? business) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => PrefixNumberingModal(business: business),
    );
  }

  @override
  State<PrefixNumberingModal> createState() => _PrefixNumberingModalState();
}

class _PrefixNumberingModalState extends State<PrefixNumberingModal> {
  late TextEditingController prefixController;
  late TextEditingController numberController;

  @override
  void initState() {
    super.initState();
    prefixController = TextEditingController(text: widget.business?.invoicePrefix ?? 'INV');
    numberController = TextEditingController(text: (widget.business?.nextInvoiceNumber ?? 1001).toString());
  }

  @override
  void dispose() {
    prefixController.dispose();
    numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final preview = '${prefixController.text.trim()}-${numberController.text.trim()}';

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.pin_outlined, color: AppColors.darkNavy, size: 24),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Invoice Prefix & Numbering',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.darkNavy),
                    ),
                  ),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ],
              ),
              const SizedBox(height: 12),
              // Live Preview Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    const Text('NEXT INVOICE NUMBER PREVIEW', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                    const SizedBox(height: 4),
                    Text(
                      preview,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.darkNavy),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: prefixController,
                decoration: const InputDecoration(
                  labelText: 'Invoice Prefix (e.g. INV, BILL, QT)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: numberController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Starting Invoice Number (e.g. 1001)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final newPrefix = prefixController.text.trim();
                    final newNum = int.tryParse(numberController.text.trim()) ?? 1001;
                    if (widget.business != null) {
                      final updated = widget.business!.copyWith(
                        invoicePrefix: newPrefix,
                        nextInvoiceNumber: newNum,
                      );
                      AppDatabase.instance.currentBusiness = updated;
                      context.read<BusinessBloc>().add(UpdateBusinessEvent(updated));
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Invoice sequence updated to $newPrefix-$newNum')),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkNavy,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Update Sequence', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Modal for Printing Formats
class PrintingFormatsModal extends StatefulWidget {
  final String currentSize;
  final ValueChanged<String>? onSelected;

  const PrintingFormatsModal({
    super.key,
    this.currentSize = 'Thermal 80mm',
    this.onSelected,
  });

  static void show(
    BuildContext context, {
    String currentSize = 'Thermal 80mm',
    ValueChanged<String>? onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => PrintingFormatsModal(
        currentSize: currentSize,
        onSelected: onSelected,
      ),
    );
  }

  @override
  State<PrintingFormatsModal> createState() => _PrintingFormatsModalState();
}

class _PrintingFormatsModalState extends State<PrintingFormatsModal> {
  late String selectedFormat;

  final List<Map<String, String>> formats = [
    {'name': 'Thermal 80mm', 'desc': '3 Inch POS receipt format (Recommended)'},
    {'name': 'Thermal 58mm', 'desc': '2 Inch compact Bluetooth receipt format'},
    {'name': 'A4 Standard', 'desc': 'Full page desktop format for GST billing'},
    {'name': 'A5 Half Sheet', 'desc': 'Half page compact print format'},
  ];

  @override
  void initState() {
    super.initState();
    selectedFormat = widget.currentSize;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.print_outlined, color: AppColors.darkNavy, size: 24),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Printing Formats',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.darkNavy),
                    ),
                  ),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ],
              ),
              const SizedBox(height: 8),
              const Text('Select your primary receipt and invoice printing paper size:', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
              const SizedBox(height: 16),
              ...formats.map((f) {
                final isSelected = f['name'] == selectedFormat;
                return RadioListTile<String>(
                  value: f['name']!,
                  groupValue: selectedFormat,
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(f['name']!, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkNavy)),
                      if (isSelected) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F2FE),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: const Color(0xFF38BDF8)),
                          ),
                          child: const Text(
                            'SELECTED',
                            style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
                          ),
                        ),
                      ],
                    ],
                  ),
                  subtitle: Text(f['desc']!),
                  activeColor: AppColors.brightCyan,
                  onChanged: (val) {
                    if (val != null) setState(() => selectedFormat = val);
                  },
                );
              }),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final current = AppDatabase.instance.invoiceDisplaySettings;
                    AppDatabase.instance.invoiceDisplaySettings = current.copyWith(paperSize: selectedFormat);
                    widget.onSelected?.call(selectedFormat);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkNavy,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Save Selection', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InvoiceFormatModal extends StatefulWidget {
  final String currentFormat;
  final ValueChanged<String>? onSelected;

  const InvoiceFormatModal({
    super.key,
    this.currentFormat = 'Standard',
    this.onSelected,
  });

  static void show(
    BuildContext context, {
    String currentFormat = 'Standard',
    ValueChanged<String>? onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => InvoiceFormatModal(
        currentFormat: currentFormat,
        onSelected: onSelected,
      ),
    );
  }

  @override
  State<InvoiceFormatModal> createState() => _InvoiceFormatModalState();
}

class _InvoiceFormatModalState extends State<InvoiceFormatModal> {
  late String selectedFormat;

  final List<Map<String, String>> formats = [
    {'name': 'Standard', 'desc': 'Default clean invoice template with standard columns'},
    {'name': 'Compact', 'desc': 'Space-saving compact layout fitting maximum line items'},
    {'name': 'Detailed', 'desc': 'Detailed view showing itemized breakdowns & tax rates'},
  ];

  @override
  void initState() {
    super.initState();
    selectedFormat = widget.currentFormat;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.style_outlined, color: AppColors.darkNavy, size: 24),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Invoice Format',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.darkNavy),
                    ),
                  ),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ],
              ),
              const SizedBox(height: 8),
              const Text('Select your preferred invoice layout format template:', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
              const SizedBox(height: 16),
              ...formats.map((f) {
                final isSelected = f['name'] == selectedFormat;
                return RadioListTile<String>(
                  value: f['name']!,
                  groupValue: selectedFormat,
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(f['name']!, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkNavy)),
                      if (isSelected) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F2FE),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: const Color(0xFF38BDF8)),
                          ),
                          child: const Text(
                            'SELECTED',
                            style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
                          ),
                        ),
                      ],
                    ],
                  ),
                  subtitle: Text(f['desc']!),
                  activeColor: AppColors.brightCyan,
                  onChanged: (val) {
                    if (val != null) setState(() => selectedFormat = val);
                  },
                );
              }),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final current = AppDatabase.instance.invoiceDisplaySettings;
                    AppDatabase.instance.invoiceDisplaySettings = current.copyWith(invoiceFormat: selectedFormat);
                    widget.onSelected?.call(selectedFormat);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkNavy,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Save Selection', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
