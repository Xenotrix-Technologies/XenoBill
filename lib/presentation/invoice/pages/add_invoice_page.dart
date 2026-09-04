import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/app_search_field.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_button.dart';
import '../../../application/invoice/invoice_bloc.dart';
import '../../../application/inventory/inventory_bloc.dart';
import '../../../application/customers/customers_bloc.dart';
import '../../../application/sales/sales_bloc.dart';
import '../../../application/business/business_bloc.dart';
import '../../../domain/entities/business.dart';
import '../../../domain/entities/invoice.dart';
import '../../../infrastructure/database/app_database.dart';
import '../widgets/receipt_preview_dialog.dart';

class AddInvoicePage extends StatefulWidget {
  const AddInvoicePage({super.key});

  @override
  State<AddInvoicePage> createState() => _AddInvoicePageState();
}

class _AddInvoicePageState extends State<AddInvoicePage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    context.read<InvoiceBloc>().add(ResetCartEvent());
    context.read<InventoryBloc>().add(LoadInventoryEvent());
    context.read<CustomersBloc>().add(LoadCustomersEvent());

    // Auto focus product search immediately for fast 1-tap workflow
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
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
        final features = business?.features;
        final nextInvNum = business?.nextInvoiceNumber ?? 1001;
        final prefix = business?.invoicePrefix ?? 'INV';
        final invNumber = '$prefix-$nextInvNum';
        final invoiceLabel = terminology?.invoice ?? 'Invoice';
        final itemLabel = terminology?.item ?? 'Item';

        return BlocListener<InvoiceBloc, InvoiceState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!), backgroundColor: AppColors.error),
              );
            }

            if (state.savedInvoice != null) {
              // Trigger Sales and Inventory refresh
              context.read<SalesBloc>().add(LoadSalesEvent());
              context.read<InventoryBloc>().add(LoadInventoryEvent());
              context.read<CustomersBloc>().add(LoadCustomersEvent());

              final invoiceBloc = context.read<InvoiceBloc>();
              final navigator = Navigator.of(context);
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (ctx) => ReceiptPreviewDialog(
                  invoice: state.savedInvoice!,
                  business: AppDatabase.instance.currentBusiness!,
                ),
              ).then((_) {
                invoiceBloc.add(ResetCartEvent());
                if (navigator.canPop()) {
                  navigator.pop();
                }
              });
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.lightGray,
            appBar: AppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('New $invoiceLabel', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('#$invNumber', style: const TextStyle(fontSize: 12, color: AppColors.brightCyan)),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => context.read<InvoiceBloc>().add(ResetCartEvent()),
                  tooltip: 'Clear Cart',
                ),
              ],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  // Search & Quick Products Section
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        children: [
                          AppSearchField(
                            controller: _searchController,
                            focusNode: _searchFocusNode,
                            autoFocus: true,
                            hint: '🔍 Search ${itemLabel.toLowerCase()} name, SKU or category...',
                            onChanged: (q) {
                              context.read<InventoryBloc>().add(SearchInventoryEvent(q));
                            },
                            onScanTap: (features?.barcodeEnabled ?? true) ? () => _simulateBarcodeScan(context) : null,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          _buildCategoryChips(context),
                          const SizedBox(height: AppSpacing.sm),
                          Expanded(child: _buildProductGrid(context, itemLabel)),
                        ],
                      ),
                    ),
                  ),

                  // Cart & Summary Section (Bottom Area)
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2)),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildCartHeader(context),
                        _buildCartItemList(context),
                        const Divider(height: 1),
                        _buildCustomerAndPaymentRow(context, terminology?.customer ?? 'Customer'),
                        _buildTotalsAndActionBar(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _simulateBarcodeScan(BuildContext context) {
    final products = (context.read<InventoryBloc>().state as InventoryLoaded).products;
    if (products.isNotEmpty) {
      final sample = products.first;
      context.read<InvoiceBloc>().add(AddProductToCartEvent(sample));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Scanned: ${sample.name} added to invoice!'),
          backgroundColor: AppColors.darkNavy,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  Widget _buildCategoryChips(BuildContext context) {
    return BlocBuilder<InventoryBloc, InventoryState>(
      builder: (context, state) {
        Set<String> categoriesSet = {'All'};
        if (state is InventoryLoaded) {
          for (final item in state.products) {
            if (item.category.isNotEmpty) categoriesSet.add(item.category);
          }
        }
        final categories = categoriesSet.toList();

        return SizedBox(
          height: 34,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              final isSelected = _selectedCategory == cat;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedCategory = cat);
                  context.read<InventoryBloc>().add(SearchInventoryEvent(cat == 'All' ? '' : cat));
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.darkNavy : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isSelected ? AppColors.brightCyan : AppColors.border),
                  ),
                  child: Text(
                    cat,
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
      },
    );
  }

  Widget _buildProductGrid(BuildContext context, String itemLabel) {
    return BlocBuilder<InventoryBloc, InventoryState>(
      builder: (context, state) {
        if (state is InventoryLoaded) {
          final products = state.filteredProducts;
          if (products.isEmpty) {
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_shopping_cart, size: 36, color: Colors.black26),
                    const SizedBox(height: 8),
                    Text('No matching $itemLabel found', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 12),
                    AppButton(
                      text: '+ Add New $itemLabel',
                      onPressed: () => context.push(RouteConstants.addEditProduct),
                    ),
                  ],
                ),
              ),
            );
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return AppCard(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                onTap: () {
                  context.read<InvoiceBloc>().add(AddProductToCartEvent(product));
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(product.name, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text(product.isProduct ? 'Stock: ${product.currentStock} • ${product.unit}' : product.category, style: AppTextStyles.bodySmall),
                          Text(CurrencyFormatter.format(product.sellingPrice), style: AppTextStyles.bodyMedium.copyWith(color: AppColors.brightCyan, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: AppColors.brightCyan,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, color: AppColors.deepNavy, size: 20),
                    ),
                  ],
                ),
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildCartHeader(BuildContext context) {
    return BlocBuilder<InvoiceBloc, InvoiceState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Cart (${state.items.length} Items)', style: AppTextStyles.h3),
              if (state.items.isNotEmpty)
                Text(
                  'Subtotal: ${CurrencyFormatter.format(state.subtotal)}',
                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.darkNavy),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCartItemList(BuildContext context) {
    return BlocBuilder<InvoiceBloc, InvoiceState>(
      builder: (context, state) {
        if (state.items.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Tap items above to add to invoice', style: TextStyle(color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
          );
        }

        return Container(
          constraints: const BoxConstraints(maxHeight: 140),
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: state.items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = state.items[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.productName, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                          Text('${CurrencyFormatter.format(item.unitPrice)} × ${item.quantity}', style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: AppColors.error, size: 22),
                          onPressed: () => context.read<InvoiceBloc>().add(UpdateCartQuantityEvent(productId: item.productId, delta: -1)),
                        ),
                        Text('${item.quantity}', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, color: AppColors.brightCyan, size: 22),
                          onPressed: () => context.read<InvoiceBloc>().add(UpdateCartQuantityEvent(productId: item.productId, delta: 1)),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Text(CurrencyFormatter.format(item.totalAmount), style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCustomerAndPaymentRow(BuildContext context, String customerLabel) {
    return BlocBuilder<InvoiceBloc, InvoiceState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // Customer Selection Button
              Row(
                children: [
                  const Icon(Icons.person_outline, size: 20, color: AppColors.darkNavy),
                  const SizedBox(width: 8),
                  Text('$customerLabel: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _showCustomerSelectorBottomSheet(context, customerLabel),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.lightGray,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              state.customer.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: state.customer.id == 'cust_walk_in' ? AppColors.nearBlack : AppColors.darkNavy,
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Payment Method Chips
              Row(
                children: [
                  const Text('Payment: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: PaymentType.values.map((type) {
                        final isSelected = state.paymentType == type;
                        return ChoiceChip(
                          label: Text(
                            type.name.toUpperCase(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? AppColors.deepNavy : AppColors.nearBlack,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: AppColors.brightCyan,
                          onSelected: (_) {
                            context.read<InvoiceBloc>().add(SetPaymentTypeEvent(type));
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),

              if (state.paymentType == PaymentType.credit) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.shade300),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, size: 16, color: Colors.amber),
                      const SizedBox(width: 6),
                      Text(
                        'Outstanding: ${CurrencyFormatter.format(state.customer.outstandingBalance)}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.nearBlack),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildTotalsAndActionBar(BuildContext context) {
    return BlocBuilder<InvoiceBloc, InvoiceState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16),
          color: AppColors.deepNavy,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TOTAL AMOUNT',
                        style: TextStyle(color: AppColors.brightCyan.withValues(alpha: 0.8), fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        CurrencyFormatter.format(state.grandTotal),
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: state.isSaving
                        ? null
                        : () {
                            context.read<InvoiceBloc>().add(SaveInvoiceEvent());
                          },
                    icon: state.isSaving
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.deepNavy))
                        : const Icon(Icons.print, color: AppColors.deepNavy),
                    label: const Text(
                      'SAVE & PRINT',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.deepNavy),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brightCyan,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  void _showCustomerSelectorBottomSheet(BuildContext context, String customerLabel) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return BlocBuilder<CustomersBloc, CustomersState>(
          builder: (context, custState) {
            if (custState is CustomersLoaded) {
              return Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Select $customerLabel', style: AppTextStyles.h2),
                    const SizedBox(height: 12),
                    Expanded(
                      child: custState.customers.isEmpty
                          ? Center(
                              child: Text('No ${customerLabel.toLowerCase()}s found. Add one in Customer directory.'),
                            )
                          : ListView.builder(
                              itemCount: custState.customers.length,
                              itemBuilder: (context, index) {
                                final customer = custState.customers[index];
                                return ListTile(
                                  leading: const CircleAvatar(
                                    backgroundColor: AppColors.darkNavy,
                                    child: Icon(Icons.person, color: Colors.white),
                                  ),
                                  title: Text(customer.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  subtitle: Text(customer.phone),
                                  trailing: customer.outstandingBalance > 0
                                      ? Text(
                                          'Due: ${CurrencyFormatter.format(customer.outstandingBalance)}',
                                          style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
                                        )
                                      : null,
                                  onTap: () {
                                    context.read<InvoiceBloc>().add(SetCustomerEvent(customer));
                                    Navigator.pop(ctx);
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        );
      },
    );
  }
}
