import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/route_constants.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_search_field.dart';
import '../../application/sales/sales_bloc.dart';
import '../../application/business/business_bloc.dart';
import '../../domain/entities/business.dart';
import '../../domain/entities/invoice.dart';

class SalesHistoryPage extends StatefulWidget {
  const SalesHistoryPage({super.key});

  @override
  State<SalesHistoryPage> createState() => _SalesHistoryPageState();
}

class _SalesHistoryPageState extends State<SalesHistoryPage> {
  String _selectedDateFilter = 'Today';
  String _selectedPaymentFilter = 'All';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<SalesBloc>().add(LoadSalesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusinessBloc, BusinessState>(
      builder: (context, bizState) {
        Business? business;
        if (bizState is BusinessLoaded) {
          business = bizState.business;
        }

        final terminology = business?.terminology;
        final invoiceLabel = terminology?.invoices ?? 'Invoices';

        return Scaffold(
          backgroundColor: AppColors.lightGray,
          appBar: AppBar(
            title: Text('$invoiceLabel & Sales History'),
          ),
          body: SafeArea(
            child: Column(
              children: [
                // KPI Summary Header Banner
                _buildSummaryHeader(),

                // Filters & Search
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    children: [
                      AppSearchField(
                        controller: _searchController,
                        hint: 'Search by number or customer...',
                        onChanged: (q) => _applyFilters(searchQuery: q),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _buildDateFilterChips(),
                      const SizedBox(height: AppSpacing.xs),
                      _buildPaymentFilterChips(),
                    ],
                  ),
                ),

                // Invoices List
                Expanded(
                  child: BlocBuilder<SalesBloc, SalesState>(
                    builder: (context, state) {
                      if (state is SalesLoaded) {
                        final invoices = state.filteredInvoices;
                        if (invoices.isEmpty) {
                          return Center(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(24),
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
                                      Icons.receipt_long_outlined,
                                      size: 48,
                                      color: AppColors.brightCyan,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No $invoiceLabel found',
                                    style: AppTextStyles.h2,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Create your first $invoiceLabel to see transactions here.',
                                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 24),
                                  AppButton(
                                    text: '+ Create ${terminology?.invoice ?? 'Invoice'}',
                                    onPressed: () => context.push(RouteConstants.addInvoice),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 100),
                          itemCount: invoices.length,
                          itemBuilder: (context, index) {
                            final inv = invoices[index];
                            final isCancelled = inv.status == InvoiceStatus.cancelled;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                              child: AppCard(
                                onTap: () => context.push('/invoice/${inv.id}'),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: isCancelled
                                            ? Colors.grey.shade200
                                            : (inv.paymentType == PaymentType.cash
                                                ? AppColors.brightCyan.withValues(alpha: 0.15)
                                                : Colors.orange.shade50),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        isCancelled ? Icons.cancel_outlined : (inv.paymentType == PaymentType.cash ? Icons.payments : Icons.account_balance_wallet),
                                        color: isCancelled ? Colors.grey : (inv.paymentType == PaymentType.cash ? AppColors.darkNavy : Colors.orange.shade800),
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.md),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                inv.invoiceNumber,
                                                style: AppTextStyles.bodyLarge.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  decoration: isCancelled ? TextDecoration.lineThrough : null,
                                                ),
                                              ),
                                              if (isCancelled) ...[
                                                const SizedBox(width: 6),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                                  decoration: BoxDecoration(color: Colors.red.shade100, borderRadius: BorderRadius.circular(4)),
                                                  child: Text('CANCELLED', style: TextStyle(fontSize: 9, color: Colors.red.shade900, fontWeight: FontWeight.bold)),
                                                ),
                                              ],
                                            ],
                                          ),
                                          Text('${inv.customerName} • ${DateFormatter.formatDisplay(inv.invoiceDate)}', style: AppTextStyles.bodySmall),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          CurrencyFormatter.format(inv.grandTotal),
                                          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: inv.status == InvoiceStatus.paid ? Colors.green.shade100 : Colors.orange.shade100,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            inv.paymentType.name.toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: inv.status == InvoiceStatus.paid ? Colors.green.shade900 : Colors.orange.shade900,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryHeader() {
    return BlocBuilder<SalesBloc, SalesState>(
      builder: (context, state) {
        double todaySales = 0.0;
        int todayBills = 0;

        if (state is SalesLoaded) {
          todaySales = state.todaySales;
          todayBills = state.todayBillsCount;
        }

        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          color: AppColors.darkNavy,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Text('Total Revenue', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(
                    CurrencyFormatter.format(todaySales),
                    style: const TextStyle(color: AppColors.brightCyan, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(height: 30, width: 1, color: Colors.white24),
              Column(
                children: [
                  const Text('Total Bills', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(
                    '$todayBills',
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDateFilterChips() {
    final ranges = ['Today', '7 Days', '30 Days', 'All'];
    return SizedBox(
      height: 32,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: ranges.length,
        itemBuilder: (context, index) {
          final range = ranges[index];
          final isSelected = _selectedDateFilter == range;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedDateFilter = range);
              _applyFilters(dateRange: range);
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

  Widget _buildPaymentFilterChips() {
    final filters = ['All', 'Cash', 'Credit', 'UPI', 'Card'];
    return SizedBox(
      height: 32,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final f = filters[index];
          final isSelected = _selectedPaymentFilter == f;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedPaymentFilter = f);
              _applyFilters(paymentFilter: f);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.brightCyan : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                f,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppColors.deepNavy : AppColors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _applyFilters({String? dateRange, String? paymentFilter, String? searchQuery}) {
    context.read<SalesBloc>().add(
          FilterSalesEvent(
            dateRange: dateRange ?? _selectedDateFilter,
            paymentFilter: paymentFilter ?? _selectedPaymentFilter,
            searchQuery: searchQuery ?? _searchController.text,
          ),
        );
  }
}
