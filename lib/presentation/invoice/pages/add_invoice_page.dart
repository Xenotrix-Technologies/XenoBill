import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../application/invoice/invoice_bloc.dart';
import '../../../application/inventory/inventory_bloc.dart';
import '../../../application/customers/customers_bloc.dart';
import '../../../application/sales/sales_bloc.dart';
import '../../../application/business/business_bloc.dart';
import '../../../domain/entities/business.dart';
import '../../../infrastructure/database/app_database.dart';
import '../widgets/receipt_preview_dialog.dart';
import '../widgets/pos/invoice_app_bar.dart';
import '../widgets/pos/customer_payment_section.dart';
import '../widgets/pos/customer_selector.dart';
import '../widgets/pos/product_search_bar.dart';
import '../widgets/pos/category_selector.dart';
import '../widgets/pos/product_grid.dart';
import '../widgets/pos/collapsible_cart.dart';
import '../widgets/pos/extra_expense_section.dart';
import '../widgets/pos/invoice_action_buttons.dart';

class AddInvoicePage extends StatefulWidget {
  const AddInvoicePage({super.key});

  @override
  State<AddInvoicePage> createState() => _AddInvoicePageState();
}

class _AddInvoicePageState extends State<AddInvoicePage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _selectedCategory = 'All';
  bool _shouldPrintAfterSave = false;

  @override
  void initState() {
    super.initState();
    context.read<InvoiceBloc>().add(ResetCartEvent());
    context.read<InventoryBloc>().add(LoadInventoryEvent());
    context.read<CustomersBloc>().add(LoadCustomersEvent());

    // Autofocus product search for fast 1-tap workflow
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
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
        final customerLabel = terminology?.customer ?? 'Customer / Party';

        return BlocListener<InvoiceBloc, InvoiceState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: AppColors.error,
                  duration: const Duration(seconds: 2),
                ),
              );
            }

            if (state.savedInvoice != null) {
              // Trigger Sales and Inventory refresh
              context.read<SalesBloc>().add(LoadSalesEvent());
              context.read<InventoryBloc>().add(LoadInventoryEvent());
              context.read<CustomersBloc>().add(LoadCustomersEvent());

              final invoiceBloc = context.read<InvoiceBloc>();
              final navigator = Navigator.of(context);
              final savedInv = state.savedInvoice!;

              if (_shouldPrintAfterSave) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (ctx) => ReceiptPreviewDialog(
                    invoice: savedInv,
                    business: AppDatabase.instance.currentBusiness!,
                  ),
                ).then((_) {
                  invoiceBloc.add(ResetCartEvent());
                  if (navigator.canPop()) {
                    navigator.pop();
                  }
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$invoiceLabel #${savedInv.invoiceNumber} saved successfully!'),
                    backgroundColor: AppColors.darkNavy,
                    duration: const Duration(seconds: 1),
                  ),
                );
                invoiceBloc.add(ResetCartEvent());
                if (navigator.canPop()) {
                  navigator.pop();
                }
              }
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.lightGray,
            // 2. APP BAR
            appBar: InvoiceAppBar(
              invoiceNumber: invNumber,
              title: 'New $invoiceLabel',
              onResetTap: () {
                context.read<InvoiceBloc>().add(ResetCartEvent());
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Invoice cart reset'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
            body: SafeArea(
              child: BlocBuilder<InvoiceBloc, InvoiceState>(
                builder: (context, invoiceState) {
                  return Column(
                    children: [
                      // Main Content View (Vertically Scrollable Wireframe Layout)
                      Expanded(
                        child: SingleChildScrollView(
                          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 3. CUSTOMER + PAYMENT HEADER (Immediately below App Bar)
                              CustomerPaymentSection(
                                selectedCustomer: invoiceState.customer,
                                selectedPaymentType: invoiceState.paymentType,
                                customerLabel: customerLabel,
                                onTapCustomer: () {
                                  CustomerSelector.showCustomerPicker(context, label: customerLabel);
                                },
                                onSelectPayment: (type) {
                                  context.read<InvoiceBloc>().add(SetPaymentTypeEvent(type));
                                },
                              ),
                              const SizedBox(height: AppSpacing.sm),

                              // 5. PRODUCT SEARCH
                              ProductSearchBar(
                                controller: _searchController,
                                focusNode: _searchFocusNode,
                                hintText: 'Search $itemLabel name, SKU or barcode',
                                onChanged: (q) {
                                  context.read<InventoryBloc>().add(SearchInventoryEvent(q));
                                },
                                onScanTap: (features?.barcodeEnabled ?? true)
                                    ? () => _simulateBarcodeScan(context)
                                    : null,
                              ),
                              const SizedBox(height: AppSpacing.sm),

                              // 6. PRODUCT CATEGORIES
                              _buildCategorySelector(context),
                              const SizedBox(height: AppSpacing.sm),

                              // 7. PRODUCT GRID (2-column mobile grid)
                              _buildProductGridSection(context, itemLabel),
                              const SizedBox(height: AppSpacing.md),

                              // 8 & 9. COLLAPSED CART BAR (Hidden cart items by default, expandable panel)
                              CollapsibleCart(
                                items: invoiceState.items,
                                totalItemCount: invoiceState.totalItemCount,
                              ),
                              const SizedBox(height: AppSpacing.md),

                              // 12. DIVIDER
                              const Divider(height: 1, color: AppColors.border),
                              const SizedBox(height: AppSpacing.md),

                              // 13. EXTRA EXPENSE
                              ExtraExpenseSection(
                                extraExpenses: invoiceState.extraExpenses,
                                onAddExpense: (exp) {
                                  context.read<InvoiceBloc>().add(
                                        AddExtraExpenseEvent(name: exp.name, amount: exp.amount),
                                      );
                                },
                                onRemoveExpense: (id) {
                                  context.read<InvoiceBloc>().add(RemoveExtraExpenseEvent(id));
                                },
                              ),
                              const SizedBox(height: AppSpacing.sm),
                            ],
                          ),
                        ),
                      ),

                      // 15. SAVE ACTIONS & FINANCIAL SUMMARY (Bottom Sticky Bar)
                      InvoiceActionButtons(
                        subtotal: invoiceState.subtotal,
                        cgst: invoiceState.cgst,
                        sgst: invoiceState.sgst,
                        igst: invoiceState.igst,
                        totalTax: invoiceState.totalTax,
                        grandTotal: invoiceState.grandTotal,
                        isSaving: invoiceState.isSaving,
                        onSave: () {
                          setState(() => _shouldPrintAfterSave = false);
                          context.read<InvoiceBloc>().add(SaveInvoiceEvent());
                        },
                        onSaveAndPrint: () {
                          setState(() => _shouldPrintAfterSave = true);
                          context.read<InvoiceBloc>().add(SaveInvoiceEvent());
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _simulateBarcodeScan(BuildContext context) {
    final invState = context.read<InventoryBloc>().state;
    if (invState is InventoryLoaded && invState.products.isNotEmpty) {
      final sample = invState.products.firstWhere((p) => p.isProduct && p.currentStock > 0, orElse: () => invState.products.first);
      context.read<InvoiceBloc>().add(AddProductToCartEvent(sample));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Scanned barcode: ${sample.name} added to cart!'),
          backgroundColor: AppColors.darkNavy,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  Widget _buildCategorySelector(BuildContext context) {
    return BlocBuilder<InventoryBloc, InventoryState>(
      builder: (context, state) {
        Set<String> categoriesSet = {'All'};
        if (state is InventoryLoaded) {
          for (final item in state.products) {
            if (item.category.isNotEmpty) categoriesSet.add(item.category);
          }
        }
        final categories = categoriesSet.toList();

        return CategorySelector(
          categories: categories,
          selectedCategory: _selectedCategory,
          onSelectCategory: (cat) {
            setState(() => _selectedCategory = cat);
            context.read<InventoryBloc>().add(SearchInventoryEvent(cat == 'All' ? '' : cat));
          },
        );
      },
    );
  }

  Widget _buildProductGridSection(BuildContext context, String itemLabel) {
    return BlocBuilder<InventoryBloc, InventoryState>(
      builder: (context, state) {
        if (state is InventoryLoaded) {
          final products = state.filteredProducts;
          return ProductGrid(
            products: products,
            itemLabel: itemLabel,
            onAddProduct: (product) {
              context.read<InvoiceBloc>().add(AddProductToCartEvent(product));
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added ${product.name} to cart'),
                  duration: const Duration(milliseconds: 800),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          );
        }
        return const Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
