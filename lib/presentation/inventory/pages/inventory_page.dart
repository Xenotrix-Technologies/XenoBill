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
import '../../../application/inventory/inventory_bloc.dart';
import '../../../application/business/business_bloc.dart';
import '../../../domain/entities/business.dart';
import '../../../domain/entities/business_type.dart';
import '../../../domain/entities/business_features.dart';
import '../../../domain/entities/business_configuration.dart';
import '../../../domain/entities/item.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedTab = 0; // 0 = Products, 1 = Services

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

        // Auto-select tab if products/services are disabled
        if (!features.productsEnabled && features.servicesEnabled && _selectedTab == 0) {
          _selectedTab = 1;
        } else if (features.productsEnabled && !features.servicesEnabled && _selectedTab == 1) {
          _selectedTab = 0;
        }

        return Scaffold(
          backgroundColor: AppColors.lightGray,
          appBar: AppBar(
            title: Text('${terminology.shopSectionTitle} Catalog'),
            actions: [
              if (features.customersEnabled)
                IconButton(
                  icon: const Icon(Icons.people_outline),
                  onPressed: () => context.go(RouteConstants.customers),
                  tooltip: 'View ${terminology.customers}',
                ),
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 70),
            child: FloatingActionButton.extended(
              backgroundColor: AppColors.brightCyan,
              foregroundColor: AppColors.deepNavy,
              onPressed: () => context.push(RouteConstants.addEditProduct),
              icon: const Icon(Icons.add, color: AppColors.deepNavy),
              label: Text(
                _selectedTab == 0 ? terminology.addItem : 'Add Service',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                // Segmented Switch Container
                _buildShopSegmentedSwitch(context, features, terminology),

                // Summary Stats Cards
                _buildInventoryStats(context, features, terminology),

                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: AppSearchField(
                    controller: _searchController,
                    hint: _selectedTab == 0
                        ? 'Search ${terminology.items.toLowerCase()}...'
                        : 'Search services...',
                    onChanged: (q) {
                      context.read<InventoryBloc>().add(SearchInventoryEvent(q));
                    },
                  ),
                ),

                // Items List
                Expanded(
                  child: BlocBuilder<InventoryBloc, InventoryState>(
                    builder: (context, state) {
                      if (state is InventoryLoaded) {
                        final items = state.filteredProducts.where((i) {
                          if (_selectedTab == 0) return i.isProduct;
                          return i.isService || i.isRoomCharge;
                        }).toList();

                        if (items.isEmpty) {
                          final isProductTab = _selectedTab == 0;
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
                                      isProductTab ? Icons.inventory_2_outlined : Icons.build_outlined,
                                      size: 48,
                                      color: AppColors.brightCyan,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    isProductTab ? 'No ${terminology.items.toLowerCase()} yet' : 'No services yet',
                                    style: AppTextStyles.h2,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    isProductTab
                                        ? 'Add your first ${terminology.item.toLowerCase()} to start selling.'
                                        : 'Add your services to start billing.',
                                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 24),
                                  AppButton(
                                    text: isProductTab ? '+ ${terminology.addItem}' : '+ Add Service',
                                    onPressed: () => context.push(RouteConstants.addEditProduct),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 120),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return _buildItemTile(context, item, features);
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

  Widget _buildShopSegmentedSwitch(BuildContext context, BusinessFeatures features, dynamic terminology) {
    return Container(
      color: AppColors.deepNavy,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          if (features.productsEnabled)
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedTab = 0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: _selectedTab == 0 ? AppColors.brightCyan : AppColors.darkNavy,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      terminology.items.toUpperCase(),
                      style: TextStyle(
                        color: _selectedTab == 0 ? AppColors.deepNavy : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (features.productsEnabled && features.servicesEnabled)
            const SizedBox(width: 6),
          if (features.servicesEnabled)
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedTab = 1),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: _selectedTab == 1 ? AppColors.brightCyan : AppColors.darkNavy,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      'SERVICES',
                      style: TextStyle(
                        color: _selectedTab == 1 ? AppColors.deepNavy : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (features.customersEnabled) ...[
            const SizedBox(width: 6),
            Expanded(
              child: GestureDetector(
                onTap: () => context.go(RouteConstants.customers),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.darkNavy,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      terminology.customers.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
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
          padding: const EdgeInsets.all(AppSpacing.md),
          color: AppColors.darkNavy,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (features.productsEnabled)
                Column(
                  children: [
                    Text(terminology.items, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                    const SizedBox(height: 2),
                    Text('$productsCount', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              if (features.productsEnabled && features.servicesEnabled)
                Container(height: 24, width: 1, color: Colors.white24),
              if (features.servicesEnabled)
                Column(
                  children: [
                    const Text('Services', style: TextStyle(color: Colors.white70, fontSize: 11)),
                    const SizedBox(height: 2),
                    Text('$servicesCount', style: const TextStyle(color: AppColors.brightCyan, fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              if (features.inventoryEnabled) ...[
                Container(height: 24, width: 1, color: Colors.white24),
                Column(
                  children: [
                    const Text('Low Stock', style: TextStyle(color: Colors.white70, fontSize: 11)),
                    const SizedBox(height: 2),
                    Text(
                      '$lowStock',
                      style: TextStyle(color: lowStock > 0 ? AppColors.error : AppColors.brightCyan, fontSize: 18, fontWeight: FontWeight.bold),
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

  Widget _buildItemTile(BuildContext context, Item item, BusinessFeatures features) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        onTap: () => _showItemDetailModal(context, item, features),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: item.isLowStock && features.inventoryEnabled ? Colors.red.shade50 : AppColors.lightGray,
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.isProduct ? Icons.inventory_2 : Icons.build_outlined,
                color: item.isLowStock && features.inventoryEnabled ? AppColors.error : AppColors.darkNavy,
                size: 22,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                  Text('${item.category} • GST ${item.gstRate.toStringAsFixed(0)}%', style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(CurrencyFormatter.format(item.sellingPrice), style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                if (item.isProduct && features.inventoryEnabled)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: item.isLowStock ? Colors.red.shade100 : Colors.green.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Stock: ${item.currentStock} ${item.unit}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: item.isLowStock ? Colors.red.shade900 : Colors.green.shade900,
                      ),
                    ),
                  )
                else if (item.isService)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.cyan.shade100, borderRadius: BorderRadius.circular(4)),
                    child: Text('SERVICE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.cyan.shade900)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showItemDetailModal(BuildContext context, Item item, BusinessFeatures features) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item.name, style: AppTextStyles.h2),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                ],
              ),
              Text('${item.type.name.toUpperCase()} • ${item.category}', style: AppTextStyles.bodySmall),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMetric('Price', CurrencyFormatter.format(item.sellingPrice)),
                  _buildMetric('GST Rate', '${item.gstRate.toStringAsFixed(0)}%'),
                  if (item.isProduct && features.inventoryEnabled) _buildMetric('Stock', '${item.currentStock} ${item.unit}'),
                  if (item.isService) _buildMetric('Duration', '${item.durationMinutes} mins'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.bodySmall),
        const SizedBox(height: 2),
        Text(value, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
