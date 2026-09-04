import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_search_field.dart';
import '../../../application/customers/customers_bloc.dart';
import '../../../application/business/business_bloc.dart';
import '../../../domain/entities/business.dart';
import '../../../domain/entities/customer.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CustomersBloc>().add(LoadCustomersEvent());
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
        final customerLabel = terminology?.customer ?? 'Customer';
        final customersLabel = terminology?.customers ?? 'Customers';

        return Scaffold(
          backgroundColor: AppColors.lightGray,
          appBar: AppBar(
            title: Text('$customersLabel Directory'),
            actions: [
              IconButton(
                icon: const Icon(Icons.inventory_2_outlined),
                onPressed: () => context.go(RouteConstants.shop),
                tooltip: 'View Catalog',
              ),
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 70),
            child: FloatingActionButton.extended(
              backgroundColor: AppColors.brightCyan,
              foregroundColor: AppColors.deepNavy,
              onPressed: () => context.push(RouteConstants.addEditCustomer),
              icon: const Icon(Icons.person_add, color: AppColors.deepNavy),
              label: Text('Add $customerLabel', style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                // Segmented Switch Container
                _buildShopSegmentedSwitch(context, customersLabel),

                // Customer Summary Banner
                _buildCustomerStats(context, customersLabel),

                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: AppSearchField(
                    controller: _searchController,
                    hint: 'Search ${customerLabel.toLowerCase()} name or phone...',
                    onChanged: (q) {
                      context.read<CustomersBloc>().add(SearchCustomersEvent(q));
                    },
                  ),
                ),

                // Customer List
                Expanded(
                  child: BlocBuilder<CustomersBloc, CustomersState>(
                    builder: (context, state) {
                      if (state is CustomersLoaded) {
                        final customers = state.filteredCustomers;
                        if (customers.isEmpty) {
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
                                      Icons.people_outline,
                                      size: 48,
                                      color: AppColors.brightCyan,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No ${customersLabel.toLowerCase()} yet',
                                    style: AppTextStyles.h2,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '$customersLabel you add will appear here.',
                                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 24),
                                  AppButton(
                                    text: '+ Add $customerLabel',
                                    onPressed: () => context.push(RouteConstants.addEditCustomer),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 120),
                          itemCount: customers.length,
                          itemBuilder: (context, index) {
                            final customer = customers[index];
                            return _buildCustomerTile(context, customer);
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

  Widget _buildShopSegmentedSwitch(BuildContext context, String customersLabel) {
    return Container(
      color: AppColors.deepNavy,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => context.go(RouteConstants.shop),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.darkNavy,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text(
                    'CATALOG',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.brightCyan,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  customersLabel.toUpperCase(),
                  style: const TextStyle(color: AppColors.deepNavy, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerStats(BuildContext context, String customersLabel) {
    return BlocBuilder<CustomersBloc, CustomersState>(
      builder: (context, state) {
        int total = 0;
        double outstanding = 0.0;

        if (state is CustomersLoaded) {
          total = state.customers.length;
          outstanding = state.totalOutstanding;
        }

        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          color: AppColors.darkNavy,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text('Total $customersLabel', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                  const SizedBox(height: 2),
                  Text('$total', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(height: 24, width: 1, color: Colors.white24),
              Column(
                children: [
                  const Text('Total Credit Outstanding', style: TextStyle(color: Colors.white70, fontSize: 11)),
                  const SizedBox(height: 2),
                  Text(
                    CurrencyFormatter.format(outstanding),
                    style: TextStyle(
                      color: outstanding > 0 ? AppColors.error : AppColors.brightCyan,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCustomerTile(BuildContext context, Customer customer) {
    final hasDue = customer.outstandingBalance > 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        onTap: () => _showCustomerDetailModal(context, customer),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: hasDue ? Colors.amber.shade100 : AppColors.darkNavy,
              child: Icon(
                Icons.person,
                color: hasDue ? Colors.amber.shade900 : Colors.white,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(customer.name, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                  Text('${customer.phone.isEmpty ? "Walk-in" : customer.phone} • ${customer.totalInvoices} Invoices', style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (hasDue) ...[
                  Text(
                    CurrencyFormatter.format(customer.outstandingBalance),
                    style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold, color: AppColors.error),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.red.shade100, borderRadius: BorderRadius.circular(4)),
                    child: Text('CREDIT DUE', style: TextStyle(fontSize: 9, color: Colors.red.shade900, fontWeight: FontWeight.bold)),
                  ),
                ] else ...[
                  const Text('₹0 Due', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomerDetailModal(BuildContext context, Customer customer) {
    final paymentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom + 16, left: 16, right: 16, top: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(customer.name, style: AppTextStyles.h2),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                ],
              ),
              Text('Phone: ${customer.phone.isEmpty ? "N/A" : customer.phone}', style: AppTextStyles.bodyMedium),
              if (customer.address.isNotEmpty) Text('Address: ${customer.address}', style: AppTextStyles.bodySmall),
              if (customer.gstin.isNotEmpty) Text('GSTIN: ${customer.gstin}', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
              const Divider(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Outstanding Credit Balance:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    CurrencyFormatter.format(customer.outstandingBalance),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.error),
                  ),
                ],
              ),

              if (customer.outstandingBalance > 0) ...[
                const SizedBox(height: 16),
                Text('Record Payment Collected', style: AppTextStyles.h3),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: paymentController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Amount Paid (₹)'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        final amt = double.tryParse(paymentController.text) ?? 0.0;
                        if (amt > 0) {
                          context.read<CustomersBloc>().add(RecordCustomerPaymentEvent(customerId: customer.id, amount: amt));
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Recorded ₹$amt payment for ${customer.name}')),
                          );
                        }
                      },
                      child: const Text('Record Payment'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
