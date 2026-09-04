import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../domain/entities/customer.dart';
import '../../../../application/customers/customers_bloc.dart';
import '../../../../application/invoice/invoice_bloc.dart';

class CustomerSelector extends StatelessWidget {
  final Customer selectedCustomer;
  final String label;

  const CustomerSelector({
    super.key,
    required this.selectedCustomer,
    this.label = 'Customer / Party',
  });

  @override
  Widget build(BuildContext context) {
    final bool isWalkIn = selectedCustomer.id == 'cust_walk_in';
    final hasOutstanding = selectedCustomer.outstandingBalance > 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
              if (hasOutstanding)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(
                    'Outstanding: ${CurrencyFormatter.format(selectedCustomer.outstandingBalance)}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          InkWell(
            onTap: () => showCustomerPicker(context, label: label),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.lightGray,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.darkNavy.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person_outline, color: AppColors.darkNavy, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedCustomer.name,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.nearBlack,
                          ),
                        ),
                        if (selectedCustomer.phone.isNotEmpty)
                          Text(
                            selectedCustomer.phone,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          )
                        else if (isWalkIn)
                          Text(
                            'Tap to change or select party',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Icon(Icons.unfold_more, color: AppColors.darkNavy, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void showCustomerPicker(BuildContext context, {String label = 'Customer / Party'}) {
    final invoiceBloc = context.read<InvoiceBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BlocProvider.value(
        value: context.read<CustomersBloc>(),
        child: Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Select $label', style: AppTextStyles.h2.copyWith(fontSize: 18)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // Walk-in Customer Tile
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppColors.border),
                ),
                leading: const CircleAvatar(
                  backgroundColor: AppColors.brightCyan,
                  child: Icon(Icons.store, color: AppColors.deepNavy),
                ),
                title: const Text('Walk-in Customer', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Standard cash/pos sale without account history'),
                onTap: () {
                  invoiceBloc.add(
                    const SetCustomerEvent(
                      Customer(
                        id: 'cust_walk_in',
                        businessId: 'biz_1',
                        name: 'Walk-in Customer',
                        phone: '',
                        email: '',
                        address: '',
                        gstin: '',
                        outstandingBalance: 0.0,
                        totalInvoices: 0,
                      ),
                    ),
                  );
                  Navigator.pop(ctx);
                },
              ),
              const SizedBox(height: 14),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'REGISTERED PARTIES',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      Navigator.pop(ctx);
                      final result = await context.push(RouteConstants.addEditCustomer);
                      if (result is Customer) {
                        invoiceBloc.add(SetCustomerEvent(result));
                      }
                    },
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Create New'),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              Expanded(
                child: BlocBuilder<CustomersBloc, CustomersState>(
                  builder: (context, state) {
                    if (state is CustomersLoaded) {
                      final customers = state.customers.where((c) => c.id != 'cust_walk_in').toList();
                      if (customers.isEmpty) {
                        return Center(
                          child: Text(
                            'No registered parties found.',
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                          ),
                        );
                      }

                      return ListView.separated(
                        itemCount: customers.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final cust = customers[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.darkNavy.withValues(alpha: 0.1),
                              child: Text(
                                cust.name.isNotEmpty ? cust.name[0].toUpperCase() : 'C',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkNavy),
                              ),
                            ),
                            title: Text(cust.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(cust.phone),
                            trailing: cust.outstandingBalance > 0
                                ? Text(
                                    'Due: ${CurrencyFormatter.format(cust.outstandingBalance)}',
                                    style: const TextStyle(
                                      color: AppColors.error,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  )
                                : null,
                            onTap: () {
                              invoiceBloc.add(SetCustomerEvent(cust));
                              Navigator.pop(ctx);
                            },
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
      ),
    );
  }
}
