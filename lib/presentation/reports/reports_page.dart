import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/widgets/app_card.dart';
import '../../application/reports/reports_bloc.dart';
import '../../application/business/business_bloc.dart';
import '../../domain/entities/business.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  int _selectedReportType = 0; // 0 = Sales Report, 1 = Dedicated GST Report
  String _selectedDateRange = '7 Days';

  @override
  void initState() {
    super.initState();
    context.read<ReportsBloc>().add(LoadReportsEvent(dateRange: _selectedDateRange));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusinessBloc, BusinessState>(
      builder: (context, bizState) {
        Business? business;
        if (bizState is BusinessLoaded) {
          business = bizState.business;
        }

        final gstEnabled = business?.gstEnabled ?? false;
        final terminology = business?.terminology;

        return Scaffold(
          backgroundColor: AppColors.lightGray,
          appBar: AppBar(
            title: const Text('Reports & Analytics'),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Segmented Report Selector (Sales vs GST)
                  if (gstEnabled) ...[
                    _buildReportSegmentSelector(),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  // Date Range Filters
                  _buildDateRangeChips(),
                  const SizedBox(height: AppSpacing.md),

                  BlocBuilder<ReportsBloc, ReportsState>(
                    builder: (context, state) {
                      if (state is ReportsLoaded) {
                        if (state.totalInvoices == 0) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.analytics_outlined,
                                      size: 48,
                                      color: AppColors.brightCyan,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No data available yet',
                                    style: AppTextStyles.h2,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Reports will appear as your business activity grows.',
                                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        if (_selectedReportType == 0 || !gstEnabled) {
                          return _buildSalesReportView(state, terminology?.invoices ?? 'Invoices');
                        } else {
                          return _buildGstReportView(state);
                        }
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReportSegmentSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.darkNavy,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedReportType = 0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: _selectedReportType == 0 ? AppColors.brightCyan : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'SALES REPORT',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: _selectedReportType == 0 ? AppColors.deepNavy : Colors.white70,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedReportType = 1),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: _selectedReportType == 1 ? AppColors.brightCyan : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'GST REPORT',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: _selectedReportType == 1 ? AppColors.deepNavy : Colors.white70,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangeChips() {
    final ranges = ['Today', '7 Days', '30 Days', 'This Month'];
    return SizedBox(
      height: 32,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: ranges.length,
        itemBuilder: (context, index) {
          final range = ranges[index];
          final isSelected = _selectedDateRange == range;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedDateRange = range);
              context.read<ReportsBloc>().add(LoadReportsEvent(dateRange: range));
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.deepNavy : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isSelected ? AppColors.brightCyan : AppColors.border),
              ),
              child: Text(
                range,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppColors.brightCyan : AppColors.nearBlack,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSalesReportView(ReportsLoaded state, String invoiceLabel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Net Sales Hero Card
        AppCard(
          color: AppColors.deepNavy,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('NET SALES', style: TextStyle(color: AppColors.brightCyan.withValues(alpha: 0.8), fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                CurrencyFormatter.format(state.netSales),
                style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('${state.totalInvoices} Total $invoiceLabel Generated', style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Financial Breakdown Table
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sales Breakdown', style: AppTextStyles.h3),
              const SizedBox(height: 12),
              _buildReportRow('Gross Sales', CurrencyFormatter.format(state.grossSales)),
              _buildReportRow('Total Discounts', '-${CurrencyFormatter.format(state.totalDiscount)}'),
              _buildReportRow('Total Tax Collected', CurrencyFormatter.format(state.totalTax)),
              const Divider(),
              _buildReportRow('Net Sales Total', CurrencyFormatter.format(state.netSales), isBold: true),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Payment Method Split
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Payment Methods', style: AppTextStyles.h3),
              const SizedBox(height: 12),
              _buildReportRow('Cash Payments', CurrencyFormatter.format(state.cashTotal)),
              _buildReportRow('Credit (Pending)', CurrencyFormatter.format(state.creditTotal)),
              _buildReportRow('UPI Payments', CurrencyFormatter.format(state.upiTotal)),
              _buildReportRow('Card Payments', CurrencyFormatter.format(state.cardTotal)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGstReportView(ReportsLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tax Summary Hero
        AppCard(
          color: AppColors.darkNavy,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('TOTAL TAX LIABILITY (CGST + SGST)', style: TextStyle(color: AppColors.brightCyan.withValues(alpha: 0.8), fontSize: 11, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                CurrencyFormatter.format(state.totalTax),
                style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text('Taxable Turnover: ${CurrencyFormatter.format(state.taxableSales)}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // CGST / SGST / IGST Breakdown
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('GST Component Breakdown', style: AppTextStyles.h3),
              const SizedBox(height: 12),
              _buildReportRow('Taxable Sales Value', CurrencyFormatter.format(state.taxableSales)),
              _buildReportRow('CGST (Central Tax)', CurrencyFormatter.format(state.cgstTotal)),
              _buildReportRow('SGST (State Tax)', CurrencyFormatter.format(state.sgstTotal)),
              _buildReportRow('IGST (Integrated Tax)', CurrencyFormatter.format(state.igstTotal)),
              const Divider(),
              _buildReportRow('Total GST Collected', CurrencyFormatter.format(state.totalTax), isBold: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReportRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: isBold ? AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold) : AppTextStyles.bodyMedium),
          Text(value, style: isBold ? AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold) : AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}
