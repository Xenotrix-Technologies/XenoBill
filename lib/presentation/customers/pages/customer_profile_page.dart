import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/customer.dart';
import '../../../domain/entities/customer_payment.dart';
import '../../../domain/entities/invoice.dart';
import '../../../application/customers/customers_bloc.dart';
import '../../../infrastructure/database/app_database.dart';

class CustomerProfilePage extends StatefulWidget {
  final Customer customer;

  const CustomerProfilePage({
    super.key,
    required this.customer,
  });

  @override
  State<CustomerProfilePage> createState() => _CustomerProfilePageState();
}

class _CustomerProfilePageState extends State<CustomerProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Customer _currentCustomer;

  String _transactionFilter = 'All'; // 'All', 'Invoices', 'Payments'
  final List<String> _notes = [
    'Usually pays every Friday.',
    'Prefers invoices via email or WhatsApp.'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _currentCustomer = widget.customer;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _refreshCustomerData() {
    final db = AppDatabase.instance;
    try {
      final updated = db.customers.firstWhere((c) => c.id == _currentCustomer.id);
      setState(() {
        _currentCustomer = updated;
      });
    } catch (_) {}
  }

  String _getInitials(String name) {
    if (name.trim().isEmpty) return 'C';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
  }

  void _makePhoneCall(String phone) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calling $phone...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openWhatsApp(String phone) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening WhatsApp for $phone...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final db = AppDatabase.instance;
    final customerInvoices =
        db.invoices.where((i) => i.customerId == _currentCustomer.id).toList();
    final customerPayments = db.customerPayments
        .where((p) => p.customerId == _currentCustomer.id)
        .toList();

    final totalInvoiced =
        customerInvoices.fold(0.0, (sum, i) => sum + i.grandTotal);
    final totalPaid =
        customerPayments.fold(0.0, (sum, p) => sum + p.amount);
    final outstanding = _currentCustomer.outstandingBalance;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: AppColors.darkNavy,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Customer Profile',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined, color: Colors.white),
            tooltip: 'Customer Statement',
            onPressed: () => _showStatementDialog(
              context,
              _currentCustomer,
              totalInvoiced,
              totalPaid,
              outstanding,
              customerInvoices,
              customerPayments,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.white),
            tooltip: 'Edit Customer',
            onPressed: () async {
              await context.push(RouteConstants.addEditCustomer, extra: _currentCustomer);
              _refreshCustomerData();
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // 1. CUSTOMER HEADER SECTION
                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                      child: Column(
                        children: [
                          // Squircle Avatar
                          Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              color: AppColors.darkNavy,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.darkNavy.withValues(alpha: 0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              _getInitials(_currentCustomer.name),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Customer Name
                          Text(
                            _currentCustomer.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Customer Phone
                          Text(
                            _currentCustomer.phone.isEmpty
                                ? 'No phone provided'
                                : _currentCustomer.phone,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // 2. CUSTOMER ACTION BUTTONS (Call | WhatsApp | Edit)
                          Row(
                            children: [
                              Expanded(
                                child: _buildActionButton(
                                  label: 'Call',
                                  icon: Icons.call_outlined,
                                  onTap: () => _makePhoneCall(_currentCustomer.phone),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildActionButton(
                                  label: 'WhatsApp',
                                  icon: Icons.chat_outlined,
                                  onTap: () => _openWhatsApp(_currentCustomer.phone),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildActionButton(
                                  label: 'Edit',
                                  icon: Icons.edit_outlined,
                                  isPrimary: true,
                                  onTap: () async {
                                    await context.push(
                                      RouteConstants.addEditCustomer,
                                      extra: _currentCustomer,
                                    );
                                    _refreshCustomerData();
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // 3. PROMINENT RECORD PAYMENT BUTTON
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton.icon(
                              onPressed: () => _showRecordPaymentBottomSheet(
                                context,
                                _currentCustomer,
                                customerInvoices,
                              ),
                              icon: const Icon(Icons.add, size: 20),
                              label: const Text(
                                'Record Payment',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.brightCyan,
                                foregroundColor: AppColors.deepNavy,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 4. CUSTOMER BALANCE SUMMARY CARD
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildSummaryMetric(
                                    label: 'Total Invoiced',
                                    value: CurrencyFormatter.format(totalInvoiced),
                                  ),
                                ),
                                Container(height: 36, width: 1, color: const Color(0xFFE2E8F0)),
                                Expanded(
                                  child: _buildSummaryMetric(
                                    label: 'Total Paid',
                                    value: CurrencyFormatter.format(totalPaid),
                                    valueColor: const Color(0xFF059669),
                                  ),
                                ),
                                Container(height: 36, width: 1, color: const Color(0xFFE2E8F0)),
                                Expanded(
                                  child: _buildSummaryMetric(
                                    label: 'Outstanding',
                                    value: CurrencyFormatter.format(outstanding),
                                    valueColor: outstanding > 0
                                        ? const Color(0xFFD97706)
                                        : const Color(0xFF059669),
                                    isHighlight: outstanding > 0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Divider(height: 1, color: Color(0xFFF1F5F9)),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Invoices (${customerInvoices.length})',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: outstanding > 0
                                        ? const Color(0xFFFEF3C7)
                                        : const Color(0xFFD1FAE5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    outstanding > 0 ? 'Credit Due' : 'Paid in Full',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: outstanding > 0
                                          ? const Color(0xFFB45309)
                                          : const Color(0xFF047857),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 5. TABS BAR (Overview | Transactions | Notes | Timeline)
                    Container(
                      color: Colors.white,
                      child: TabBar(
                        controller: _tabController,
                        labelColor: AppColors.brightCyan,
                        unselectedLabelColor: const Color(0xFF64748B),
                        indicatorColor: AppColors.brightCyan,
                        indicatorWeight: 3,
                        labelStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        tabs: const [
                          Tab(text: 'Overview'),
                          Tab(text: 'Transactions'),
                          Tab(text: 'Notes'),
                          Tab(text: 'Timeline'),
                        ],
                      ),
                    ),

                    // 6. TAB VIEW CONTENTS
                    SizedBox(
                      height: 520,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // OVERVIEW TAB
                          _buildOverviewTab(
                            context,
                            _currentCustomer,
                            totalInvoiced,
                            totalPaid,
                            outstanding,
                            customerInvoices,
                          ),

                          // TRANSACTIONS TAB
                          _buildTransactionsTab(
                            context,
                            customerInvoices,
                            customerPayments,
                          ),

                          // NOTES TAB
                          _buildNotesTab(context),

                          // TIMELINE TAB
                          _buildTimelineTab(
                            context,
                            customerInvoices,
                            customerPayments,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: isPrimary ? AppColors.darkNavy : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isPrimary ? AppColors.darkNavy : const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isPrimary ? Colors.white : const Color(0xFF334155),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isPrimary ? Colors.white : const Color(0xFF334155),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryMetric({
    required String label,
    required String value,
    Color? valueColor,
    bool isHighlight = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      decoration: BoxDecoration(
        color: isHighlight ? const Color(0xFFFFFBEB) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: valueColor ?? const Color(0xFF0F172A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 1. OVERVIEW TAB
  // ===========================================================================
  Widget _buildOverviewTab(
    BuildContext context,
    Customer customer,
    double totalInvoiced,
    double totalPaid,
    double outstanding,
    List<Invoice> customerInvoices,
  ) {
    String firstInvoiceDate = 'No invoices yet';
    String lastInvoiceDate = 'No invoices yet';

    if (customerInvoices.isNotEmpty) {
      final sorted = List<Invoice>.from(customerInvoices)
        ..sort((a, b) => a.invoiceDate.compareTo(b.invoiceDate));
      firstInvoiceDate = DateFormat('dd MMM yyyy').format(sorted.first.invoiceDate);
      lastInvoiceDate = DateFormat('dd MMM yyyy').format(sorted.last.invoiceDate);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Customer Information Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Customer Information',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                const SizedBox(height: 12),
                _buildInfoRow('Phone', customer.phone.isNotEmpty ? customer.phone : 'Not provided'),
                _buildInfoRow('Alternate Phone', 'Not provided'),
                _buildInfoRow('Email', customer.email.isNotEmpty ? customer.email : 'Not provided'),
                _buildInfoRow('Address', customer.address.isNotEmpty ? customer.address : 'Not provided'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Account Summary Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Account Summary',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                const SizedBox(height: 12),
                _buildInfoRow('First Invoice', firstInvoiceDate),
                _buildInfoRow('Last Invoice', lastInvoiceDate),
                _buildInfoRow('Total Invoices', '${customerInvoices.length}'),
                _buildInfoRow('Total Invoiced', CurrencyFormatter.format(totalInvoiced)),
                _buildInfoRow('Total Paid', CurrencyFormatter.format(totalPaid)),
                _buildInfoRow(
                  'Outstanding',
                  CurrencyFormatter.format(outstanding),
                  isBold: true,
                  valueColor: outstanding > 0 ? const Color(0xFFD97706) : const Color(0xFF059669),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: valueColor ?? const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 2. TRANSACTIONS TAB (Unified Invoices + Payments Stream)
  // ===========================================================================
  Widget _buildTransactionsTab(
    BuildContext context,
    List<Invoice> invoices,
    List<CustomerPayment> payments,
  ) {
    // Combine into unified transaction items
    final List<_TransactionItem> items = [];

    for (final inv in invoices) {
      items.add(_TransactionItem(
        id: inv.id,
        date: inv.invoiceDate,
        isInvoice: true,
        invoice: inv,
      ));
    }

    for (final pay in payments) {
      items.add(_TransactionItem(
        id: pay.id,
        date: pay.paymentDate,
        isInvoice: false,
        payment: pay,
      ));
    }

    // Sort descending (latest first)
    items.sort((a, b) => b.date.compareTo(a.date));

    // Apply Filter
    final filtered = items.where((item) {
      if (_transactionFilter == 'Invoices') return item.isInvoice;
      if (_transactionFilter == 'Payments') return !item.isInvoice;
      return true;
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Filter Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _transactionFilter,
                    items: const [
                      DropdownMenuItem(value: 'All', child: Text('All Transactions')),
                      DropdownMenuItem(value: 'Invoices', child: Text('Invoices Only')),
                      DropdownMenuItem(value: 'Payments', child: Text('Payments Only')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _transactionFilter = val;
                        });
                      }
                    },
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                    icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF64748B)),
                  ),
                ),
              ),
              Text(
                '${filtered.length} entries',
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // List Stream
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No transactions found',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Invoices and payments recorded will appear here.',
                          style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      if (item.isInvoice) {
                        return _buildInvoiceTile(context, item.invoice!);
                      } else {
                        return _buildPaymentTile(context, item.payment!);
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceTile(BuildContext context, Invoice inv) {
    final dateStr = DateFormat('dd MMM · h:mm a').format(inv.invoiceDate);
    final isPaid = inv.status == InvoiceStatus.paid;
    final isPartial = inv.status == InvoiceStatus.partial;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: () {
            context.push('/invoice/${inv.id}');
          },
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                // Icon Box
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.description_outlined,
                    color: AppColors.darkNavy,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Invoice #${inv.invoiceNumber}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$dateStr · ${inv.items.length} Items',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),

                // Amount & Status
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '+${CurrencyFormatter.format(inv.grandTotal)}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isPaid
                          ? 'Paid'
                          : (isPartial
                              ? 'Paid ${CurrencyFormatter.format(inv.paidAmount)} · ${CurrencyFormatter.format(inv.dueAmount)} Due'
                              : '${CurrencyFormatter.format(inv.dueAmount)} Due'),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isPaid
                            ? const Color(0xFF059669)
                            : (isPartial ? const Color(0xFFD97706) : const Color(0xFFDC2626)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentTile(BuildContext context, CustomerPayment pay) {
    final dateStr = DateFormat('dd MMM · h:mm a').format(pay.paymentDate);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: () => _showPaymentDetailDialog(context, pay),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                // Icon Box
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_outlined,
                    color: Color(0xFF059669),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Payment Received',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$dateStr · ${pay.paymentMethod}',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),

                // Amount
                Text(
                  '-${CurrencyFormatter.format(pay.amount)}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF059669),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // 3. NOTES TAB
  // ===========================================================================
  Widget _buildNotesTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Customer Notes',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              TextButton.icon(
                onPressed: () => _showAddNoteDialog(context),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Note'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _notes.isEmpty
                ? const Center(
                    child: Text('No notes added yet', style: TextStyle(color: Color(0xFF64748B))),
                  )
                : ListView.builder(
                    itemCount: _notes.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        elevation: 0,
                        child: ListTile(
                          leading: const Icon(Icons.sticky_note_2_outlined, color: AppColors.brightCyan),
                          title: Text(
                            _notes[index],
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    final noteController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add Customer Note'),
        content: TextField(
          controller: noteController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Enter note details...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (noteController.text.trim().isNotEmpty) {
                setState(() {
                  _notes.insert(0, noteController.text.trim());
                });
                Navigator.pop(dialogCtx);
              }
            },
            child: const Text('Save Note'),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 4. TIMELINE TAB
  // ===========================================================================
  Widget _buildTimelineTab(
    BuildContext context,
    List<Invoice> invoices,
    List<CustomerPayment> payments,
  ) {
    final List<_TimelineEvent> events = [];

    for (final inv in invoices) {
      events.add(_TimelineEvent(
        title: 'Invoice #${inv.invoiceNumber} created',
        subtitle: '${CurrencyFormatter.format(inv.grandTotal)} • ${inv.items.length} items',
        date: inv.invoiceDate,
        icon: Icons.receipt,
        iconColor: AppColors.darkNavy,
      ));
    }

    for (final pay in payments) {
      events.add(_TimelineEvent(
        title: 'Payment of ${CurrencyFormatter.format(pay.amount)} recorded',
        subtitle: 'Method: ${pay.paymentMethod}',
        date: pay.paymentDate,
        icon: Icons.check_circle,
        iconColor: const Color(0xFF059669),
      ));
    }

    events.sort((a, b) => b.date.compareTo(a.date));

    return Padding(
      padding: const EdgeInsets.all(16),
      child: events.isEmpty
          ? const Center(
              child: Text('No timeline history yet', style: TextStyle(color: Color(0xFF64748B))),
            )
          : ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final e = events[index];
                final dateStr = DateFormat('dd MMM yyyy · h:mm a').format(e.date);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: e.iconColor.withValues(alpha: 0.1),
                        child: Icon(e.icon, size: 16, color: e.iconColor),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${e.subtitle} • $dateStr',
                              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  // ===========================================================================
  // RECORD PAYMENT BOTTOM SHEET
  // ===========================================================================
  void _showRecordPaymentBottomSheet(
    BuildContext context,
    Customer customer,
    List<Invoice> invoices,
  ) {
    final amountController = TextEditingController(
      text: customer.outstandingBalance > 0
          ? customer.outstandingBalance.toStringAsFixed(0)
          : '',
    );
    final refController = TextEditingController();
    String selectedMethod = 'Cash';
    String? selectedInvoiceId;

    final unpaidInvoices = invoices.where((i) => i.dueAmount > 0).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (sheetCtx, setSheetState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(sheetCtx).viewInsets.bottom + 20,
                left: 20,
                right: 20,
                top: 20,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Record Payment',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Color(0xFF64748B)),
                          onPressed: () => Navigator.pop(sheetCtx),
                        ),
                      ],
                    ),
                    const Divider(height: 1, color: Color(0xFFE2E8F0)),
                    const SizedBox(height: 16),

                    // Amount
                    const Text(
                      'Amount Collected *',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF334155),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      autofocus: true,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                      decoration: InputDecoration(
                        hintText: '₹ Enter amount',
                        prefixText: '₹ ',
                        prefixStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Payment Method Dropdown
                    const Text(
                      'Payment Method',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF334155),
                      ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: selectedMethod,
                      items: const [
                        DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                        DropdownMenuItem(value: 'UPI', child: Text('UPI')),
                        DropdownMenuItem(value: 'Card', child: Text('Card')),
                        DropdownMenuItem(value: 'Bank Transfer', child: Text('Bank Transfer')),
                        DropdownMenuItem(value: 'Other', child: Text('Other')),
                      ],
                      onChanged: (val) {
                        if (val != null) setSheetState(() => selectedMethod = val);
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Allocate To Invoice (Optional)
                    if (unpaidInvoices.isNotEmpty) ...[
                      const Text(
                        'Allocate To (Optional)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF334155),
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String?>(
                        initialValue: selectedInvoiceId,
                        isExpanded: true,
                        items: [
                          const DropdownMenuItem<String?>(
                            value: null,
                            child: Text('General Outstanding Balance', overflow: TextOverflow.ellipsis),
                          ),
                          ...unpaidInvoices.map((inv) => DropdownMenuItem<String?>(
                                value: inv.id,
                                child: Text(
                                  'Invoice #${inv.invoiceNumber} (Due: ${CurrencyFormatter.format(inv.dueAmount)})',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )),
                        ],
                        onChanged: (val) {
                          setSheetState(() => selectedInvoiceId = val);
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],

                    // Reference Note
                    const Text(
                      'Reference / Note',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF334155),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: refController,
                      decoration: InputDecoration(
                        hintText: 'e.g. UPI Ref, Check No, Cash Note',
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          final amt = double.tryParse(amountController.text.trim()) ?? 0.0;
                          if (amt <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please enter a valid amount')),
                            );
                            return;
                          }

                          final payment = CustomerPayment(
                            id: const Uuid().v4(),
                            customerId: customer.id,
                            customerName: customer.name,
                            amount: amt,
                            paymentMethod: selectedMethod,
                            paymentDate: DateTime.now(),
                            referenceNote: refController.text.trim(),
                            allocatedInvoiceId: selectedInvoiceId,
                          );

                          context.read<CustomersBloc>().add(RecordDetailedCustomerPaymentEvent(payment));
                          Navigator.pop(sheetCtx);

                          _refreshCustomerData();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Recorded ${CurrencyFormatter.format(amt)} payment for ${customer.name}',
                              ),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brightCyan,
                          foregroundColor: AppColors.deepNavy,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Record Payment',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showPaymentDetailDialog(BuildContext context, CustomerPayment pay) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Color(0xFF059669), size: 24),
            SizedBox(width: 8),
            Text('Payment Details', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Amount Received', CurrencyFormatter.format(pay.amount), isBold: true, valueColor: const Color(0xFF059669)),
            _buildInfoRow('Customer', pay.customerName),
            _buildInfoRow('Date', DateFormat('dd MMM yyyy, h:mm a').format(pay.paymentDate)),
            _buildInfoRow('Payment Method', pay.paymentMethod),
            if (pay.referenceNote.isNotEmpty)
              _buildInfoRow('Reference', pay.referenceNote),
            if (pay.allocatedInvoiceId != null)
              _buildInfoRow('Allocated Invoice', pay.allocatedInvoiceId!),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showStatementDialog(
    BuildContext context,
    Customer customer,
    double totalInvoiced,
    double totalPaid,
    double outstanding,
    List<Invoice> invoices,
    List<CustomerPayment> payments,
  ) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text('${customer.name} - Statement', style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Statement generated on ${DateFormat('dd MMM yyyy').format(DateTime.now())}',
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
            const Divider(height: 20),
            _buildInfoRow('Total Invoiced', CurrencyFormatter.format(totalInvoiced)),
            _buildInfoRow('Total Paid', CurrencyFormatter.format(totalPaid)),
            _buildInfoRow('Outstanding Balance', CurrencyFormatter.format(outstanding), isBold: true, valueColor: const Color(0xFFD97706)),
            const SizedBox(height: 12),
            Text('Includes ${invoices.length} Invoices and ${payments.length} Payments.',
                style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Color(0xFF64748B))),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(dialogCtx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Customer statement downloaded / shared successfully')),
              );
            },
            icon: const Icon(Icons.share, size: 16),
            label: const Text('Share Statement'),
          ),
        ],
      ),
    );
  }
}

class _TransactionItem {
  final String id;
  final DateTime date;
  final bool isInvoice;
  final Invoice? invoice;
  final CustomerPayment? payment;

  _TransactionItem({
    required this.id,
    required this.date,
    required this.isInvoice,
    this.invoice,
    this.payment,
  });
}

class _TimelineEvent {
  final String title;
  final String subtitle;
  final DateTime date;
  final IconData icon;
  final Color iconColor;

  _TimelineEvent({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.icon,
    required this.iconColor,
  });
}
