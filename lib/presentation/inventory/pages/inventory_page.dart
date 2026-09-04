import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/app_search_field.dart';
import '../../../application/inventory/inventory_bloc.dart';
import '../../../application/business/business_bloc.dart';
import '../../../domain/entities/business.dart';
import '../../../domain/entities/business_type.dart';
import '../../../domain/entities/business_features.dart';
import '../../../domain/entities/business_terminology.dart';
import '../../../domain/entities/business_configuration.dart';
import '../../../domain/entities/item.dart';
import '../widgets/shop_header.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final TextEditingController _searchController = TextEditingController();
  ShopTabType _activeTab = ShopTabType.products;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    context.read<InventoryBloc>().add(LoadInventoryEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusinessBloc, BusinessState>(
      builder: (context, bizState) {
        Business? business;
        if (bizState is BusinessLoaded) {
          business = bizState.business;
        }

        final config = business?.configuration ?? BusinessConfiguration.fromType(business?.type ?? BusinessType.retail);
        final terminology = config.terminology;
        final features = config.features;

        // Auto-select tab based on enabled features
        if (!features.productsEnabled && features.servicesEnabled && _activeTab == ShopTabType.products) {
          _activeTab = ShopTabType.services;
        } else if (features.productsEnabled && !features.servicesEnabled && _activeTab == ShopTabType.services) {
          _activeTab = ShopTabType.products;
        }

        final isServiceTab = _activeTab == ShopTabType.services;

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          body: SafeArea(
            child: Column(
              children: [
                // Adaptive Dynamic Shop Header
                ShopHeader(
                  features: features,
                  terminology: terminology,
                  activeTab: _activeTab,
                  onTabSelected: (tab) {
                    setState(() {
                      _activeTab = tab;
                      _selectedCategory = 'All';
                    });
                  },
                ),

                const SizedBox(height: 8),

                // Summary Stats Cards
                _buildInventoryStats(context, features, terminology),

                // Rounded Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: AppSearchField(
                    controller: _searchController,
                    hint: isServiceTab
                        ? 'Search services...'
                        : 'Search products or scan barcode...',
                    onChanged: (q) {
                      context.read<InventoryBloc>().add(SearchInventoryEvent(q));
                    },
                  ),
                ),

                // Items Grid & Category Filter Content
                Expanded(
                  child: BlocBuilder<InventoryBloc, InventoryState>(
                    builder: (context, state) {
                      if (state is InventoryLoaded) {
                        final rawItems = state.filteredProducts.where((i) {
                          if (isServiceTab) return i.isService || i.isRoomCharge;
                          return i.isProduct;
                        }).toList();

                        // Extract unique categories for category bar
                        final categoriesList = ['All', ...rawItems.map((i) => i.category).where((c) => c.isNotEmpty).toSet()];

                        // Filter by selected category
                        final items = rawItems.where((i) {
                          if (_selectedCategory == 'All') return true;
                          return i.category.toLowerCase() == _selectedCategory.toLowerCase();
                        }).toList();

                        if (rawItems.isEmpty) {
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
                                    child: Icon(
                                      isServiceTab ? Icons.build_outlined : Icons.inventory_2_outlined,
                                      size: 48,
                                      color: AppColors.deepNavy,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    isServiceTab ? 'No services yet' : 'No ${terminology.items.toLowerCase()} yet',
                                    style: AppTextStyles.h2,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    isServiceTab
                                        ? 'Add your services to start billing.'
                                        : 'Add your first ${terminology.item.toLowerCase()} to start selling.',
                                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return Column(
                          children: [
                            // Horizontal Category Filter Bar under Search Bar
                            _buildCategoryFilterBar(categoriesList),

                            const SizedBox(height: 8),

                            // 2-Column Product Grid View
                            Expanded(
                              child: items.isEmpty
                                  ? Center(
                                      child: Text(
                                        'No items in "$_selectedCategory"',
                                        style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
                                      ),
                                    )
                                  : GridView.builder(
                                      padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 100),
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 0.85,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                      ),
                                      itemCount: items.length,
                                      itemBuilder: (context, index) {
                                        final item = items[index];
                                        return _buildProductGridCard(context, item, features);
                                      },
                                    ),
                            ),
                          ],
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

  Widget _buildCategoryFilterBar(List<String> categories) {
    if (categories.length <= 1) return const SizedBox.shrink();

    return SizedBox(
      height: 38,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = _selectedCategory.toLowerCase() == cat.toLowerCase();

          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF111418) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? const Color(0xFF111418) : Colors.grey.shade300,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withAlpha(15),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: Text(
                cat,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF5A6275),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGridCard(BuildContext context, Item item, BusinessFeatures features) {
    return GestureDetector(
      onTap: () => _showProductOptionsModal(context, item, features),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Icon + Stock Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    item.isProduct ? Icons.folder_outlined : Icons.build_outlined,
                    color: const Color(0xFF475569),
                    size: 20,
                  ),
                ),
                _buildStockBadge(item, features),
              ],
            ),
            const Spacer(),
            // Product Name
            Text(
              item.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111418),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            // SKU & GST Info
            Text(
              '${item.sku.isNotEmpty ? "${item.sku} • " : ""}${item.category.isNotEmpty ? "${item.category} • " : ""}GST ${item.gstRate.toStringAsFixed(0)}%',
              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            // Selling Price
            Text(
              CurrencyFormatter.format(item.sellingPrice),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111418),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockBadge(Item item, BusinessFeatures features) {
    if (!item.isProduct || !features.inventoryEnabled) {
      if (item.isService) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(color: Colors.cyan.shade50, borderRadius: BorderRadius.circular(10)),
          child: Text('SERVICE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.cyan.shade900)),
        );
      }
      return const SizedBox.shrink();
    }

    if (item.currentStock <= 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(12)),
        child: Text('Out of stock', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red.shade900)),
      );
    }

    if (item.isLowStock) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(12)),
        child: Text('${item.currentStock} left', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.amber.shade900)),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
      child: Text('${item.currentStock} in stock', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
    );
  }

  Widget _buildInventoryStats(BuildContext context, BusinessFeatures features, dynamic terminology) {
    return BlocBuilder<InventoryBloc, InventoryState>(
      builder: (context, state) {
        int productsCount = 0;
        int servicesCount = 0;
        int lowStock = 0;

        if (state is InventoryLoaded) {
          productsCount = state.totalProducts;
          servicesCount = state.totalServices;
          lowStock = state.lowStockCount;
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(8),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (features.productsEnabled)
                Column(
                  children: [
                    Text(terminology.items, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 2),
                    Text('$productsCount', style: const TextStyle(color: Color(0xFF111418), fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              if (features.productsEnabled && features.servicesEnabled)
                Container(height: 24, width: 1, color: Colors.grey.shade300),
              if (features.servicesEnabled)
                Column(
                  children: [
                    const Text('Services', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 2),
                    Text('$servicesCount', style: const TextStyle(color: AppColors.deepNavy, fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              if (features.inventoryEnabled) ...[
                Container(height: 24, width: 1, color: Colors.grey.shade300),
                Column(
                  children: [
                    const Text('Low Stock', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 2),
                    Text(
                      '$lowStock',
                      style: TextStyle(color: lowStock > 0 ? AppColors.error : AppColors.deepNavy, fontSize: 18, fontWeight: FontWeight.bold),
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

  void _showProductOptionsModal(BuildContext context, Item item, BusinessFeatures features) {
    final terminology = BusinessTerminology.fromBusinessType(BusinessType.retail);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Grab Bar
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Item Header Preview
                Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        item.isProduct ? Icons.folder_outlined : Icons.build_outlined,
                        color: const Color(0xFF334155),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${item.category} • ${CurrencyFormatter.format(item.sellingPrice)}${item.isProduct ? " • ${item.currentStock} ${item.unit} in stock" : ""}',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                const SizedBox(height: 8),

                // Option 1: View Details & Adjust Stock
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F7FA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.visibility_outlined, color: Color(0xFF00ACC1), size: 22),
                  ),
                  title: const Text(
                    'View Details & Adjust Stock',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A)),
                  ),
                  subtitle: const Text('View full specs and update stock count', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  onTap: () {
                    Navigator.pop(ctx);
                    context.push(RouteConstants.productDetail, extra: item);
                  },
                ),

                // Option 2: Edit Product
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.edit_outlined, color: Color(0xFF334155), size: 22),
                  ),
                  title: Text(
                    'Edit ${item.isProduct ? terminology.item : "Service"}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A)),
                  ),
                  subtitle: const Text('Modify price, barcode, category & details', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  onTap: () {
                    Navigator.pop(ctx);
                    context.push(RouteConstants.addEditProduct, extra: item);
                  },
                ),

                // Option 3: Delete Product
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.delete_outline, color: Color(0xFFE53935), size: 22),
                  ),
                  title: Text(
                    'Delete ${item.isProduct ? terminology.item : "Service"}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFFE53935)),
                  ),
                  subtitle: const Text('Permanently remove from inventory', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  onTap: () {
                    Navigator.pop(ctx);
                    _confirmDeleteProduct(context, item);
                  },
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmDeleteProduct(BuildContext context, Item item) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "${item.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              context.read<InventoryBloc>().add(DeleteProductEvent(item.id));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${item.name} deleted')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}


