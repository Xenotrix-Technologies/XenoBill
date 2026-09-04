import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../application/inventory/inventory_bloc.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/business_type.dart';
import '../../../domain/entities/business_terminology.dart';
import '../../../domain/entities/business_features.dart';
import '../../../domain/entities/item.dart';

class ProductDetailPage extends StatefulWidget {
  final Item item;

  const ProductDetailPage({
    super.key,
    required this.item,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late Item _currentItem;

  @override
  void initState() {
    super.initState();
    _currentItem = widget.item;
  }

  void _adjustStockBy(int delta) {
    if (!_currentItem.isProduct) return;
    final newStock = (_currentItem.currentStock + delta).clamp(0, 999999);
    setState(() {
      _currentItem = _currentItem.copyWith(currentStock: newStock);
    });
    context.read<InventoryBloc>().add(
          AdjustStockEvent(productId: _currentItem.id, newStock: newStock),
        );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Stock updated to $newStock ${_currentItem.unit}'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showCustomStockDialog() {
    final controller = TextEditingController(text: _currentItem.currentStock.toString());
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Adjust Stock Count', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter exact current stock level for ${_currentItem.name}:', style: AppTextStyles.bodySmall),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'New Stock Quantity',
                suffixText: _currentItem.unit,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C2FF),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              final parsed = int.tryParse(controller.text.trim());
              if (parsed != null && parsed >= 0) {
                Navigator.pop(dialogCtx);
                setState(() {
                  _currentItem = _currentItem.copyWith(currentStock: parsed);
                });
                context.read<InventoryBloc>().add(
                      AdjustStockEvent(productId: _currentItem.id, newStock: parsed),
                    );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Stock set to $parsed ${_currentItem.unit}'),
                    duration: const Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Save Stock', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "${_currentItem.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              context.read<InventoryBloc>().add(DeleteProductEvent(_currentItem.id));
              context.pop(); // Return to inventory
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${_currentItem.name} deleted')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const businessType = BusinessType.retail;
    final terminology = BusinessTerminology.fromBusinessType(businessType);
    final features = BusinessFeatures.fromBusinessType(businessType);

    return BlocBuilder<InventoryBloc, InventoryState>(
      builder: (context, state) {
        if (state is InventoryLoaded) {
          final updated = state.products.firstWhere(
            (p) => p.id == _currentItem.id,
            orElse: () => _currentItem,
          );
          _currentItem = updated;
        }

        final item = _currentItem;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF8FAFC),
            elevation: 0,
            leadingWidth: 56,
            leading: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Center(
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
                    onPressed: () => context.pop(),
                  ),
                ),
              ),
            ),
            title: Text(
              '${item.isProduct ? terminology.item : "Service"} Details',
              style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Color(0xFF1E293B)),
                tooltip: 'Edit Item',
                onPressed: () => context.push(RouteConstants.addEditProduct, extra: item),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppColors.error),
                tooltip: 'Delete Item',
                onPressed: () => _confirmDelete(context),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Header Card
                _buildHeroCard(item),

                const SizedBox(height: 16),

                // Stock Adjustment Section (If Product)
                if (item.isProduct && features.inventoryEnabled) ...[
                  _buildStockAdjustmentCard(item),
                  const SizedBox(height: 16),
                ],

                // Pricing Breakdown Card
                _buildPricingCard(item),

                const SizedBox(height: 16),

                // Tax & Unit Information Card
                _buildDetailsCard(item),

                const SizedBox(height: 32),

                // Edit Product CTA Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00C2FF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                      elevation: 2,
                    ),
                    icon: const Icon(Icons.edit, color: Colors.white),
                    label: Text(
                      'Edit ${item.isProduct ? terminology.item : "Service"}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () => context.push(RouteConstants.addEditProduct, extra: item),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeroCard(Item item) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Icon Container
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              item.isProduct ? Icons.folder_outlined : Icons.build_outlined,
              color: const Color(0xFF334155),
              size: 40,
            ),
          ),
          const SizedBox(height: 14),

          // Title
          Text(
            item.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 6),

          // Chips Row
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              if (item.category.isNotEmpty)
                _buildBadge(item.category, Colors.blue.shade700, Colors.blue.shade50),
              if (item.sku.isNotEmpty)
                _buildBadge('SKU: ${item.sku}', const Color(0xFF475569), const Color(0xFFF1F5F9)),
              if (item.barcode.isNotEmpty)
                _buildBadge('Barcode: ${item.barcode}', const Color(0xFF475569), const Color(0xFFF1F5F9)),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 16),

          // Price Tag
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Selling Price: ', style: TextStyle(color: Color(0xFF64748B), fontSize: 14)),
              Text(
                CurrencyFormatter.format(item.sellingPrice),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStockAdjustmentCard(Item item) {
    final isLowStock = item.isLowStock;
    final isOutOfStock = item.isOutOfStock;

    Color badgeBg = Colors.green.shade50;
    Color badgeTextColor = Colors.green.shade800;
    String statusText = 'In Stock';

    if (isOutOfStock) {
      badgeBg = Colors.red.shade50;
      badgeTextColor = Colors.red.shade800;
      statusText = 'Out of Stock';
    } else if (isLowStock) {
      badgeBg = Colors.amber.shade50;
      badgeTextColor = Colors.amber.shade900;
      statusText = 'Low Stock Alert';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isLowStock ? Colors.amber.shade300 : const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row: Title + Stock Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.inventory_2_outlined, color: Color(0xFF00C2FF), size: 22),
                  SizedBox(width: 8),
                  Text(
                    'Stock Management',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: badgeTextColor),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Main Stepper Control Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Decrease Button
                Material(
                  color: item.currentStock > 0 ? const Color(0xFFF1F5F9) : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: item.currentStock > 0 ? () => _adjustStockBy(-1) : null,
                    child: Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.remove,
                        color: item.currentStock > 0 ? const Color(0xFF0F172A) : Colors.grey,
                        size: 22,
                      ),
                    ),
                  ),
                ),

                // Stock Display
                Column(
                  children: [
                    Text(
                      '${item.currentStock}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      '${item.unit} available',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                  ],
                ),

                // Increase Button
                Material(
                  color: const Color(0xFF00C2FF),
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _adjustStockBy(1),
                    child: Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Quick Increment Chips
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickStockChip('-10', -10),
              _buildQuickStockChip('-5', -5),
              _buildQuickStockChip('+5', 5),
              _buildQuickStockChip('+10', 10),
              _buildQuickStockChip('+50', 50),
            ],
          ),

          const SizedBox(height: 14),

          // Manual Stock Set Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF00C2FF)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              icon: const Icon(Icons.edit_note, color: Color(0xFF00C2FF)),
              label: const Text(
                'Set Exact Stock Count',
                style: TextStyle(color: Color(0xFF00C2FF), fontWeight: FontWeight.bold),
              ),
              onPressed: _showCustomStockDialog,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStockChip(String label, int delta) {
    return ActionChip(
      backgroundColor: const Color(0xFFF1F5F9),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      label: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF334155)),
      ),
      onPressed: () => _adjustStockBy(delta),
    );
  }

  Widget _buildPricingCard(Item item) {
    final profitMargin = item.sellingPrice - item.purchasePrice;
    final profitPercentage = item.purchasePrice > 0
        ? ((profitMargin / item.purchasePrice) * 100).toStringAsFixed(1)
        : '0.0';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.payments_outlined, color: Color(0xFF00C2FF), size: 22),
              SizedBox(width: 8),
              Text(
                'Pricing & Profit Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Purchase Price', CurrencyFormatter.format(item.purchasePrice)),
          const Divider(height: 20, color: Color(0xFFF1F5F9)),
          _buildInfoRow('Selling Price', CurrencyFormatter.format(item.sellingPrice)),
          if (item.mrp > 0) ...[
            const Divider(height: 20, color: Color(0xFFF1F5F9)),
            _buildInfoRow('MRP', CurrencyFormatter.format(item.mrp)),
          ],
          const Divider(height: 20, color: Color(0xFFF1F5F9)),
          _buildInfoRow(
            'Estimated Margin',
            '${CurrencyFormatter.format(profitMargin)} ($profitPercentage%)',
            valueColor: profitMargin >= 0 ? Colors.green.shade700 : Colors.red.shade700,
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(Item item) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.receipt_long_outlined, color: Color(0xFF00C2FF), size: 22),
              SizedBox(width: 8),
              Text(
                'Tax & Specifications',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow('GST Rate', '${item.gstRate.toStringAsFixed(0)}%'),
          const Divider(height: 20, color: Color(0xFFF1F5F9)),
          _buildInfoRow('Unit Type', item.unit.isNotEmpty ? item.unit : 'Unit'),
          if (item.isProduct) ...[
            const Divider(height: 20, color: Color(0xFFF1F5F9)),
            _buildInfoRow('Low Stock Alert', '${item.lowStockLimit} ${item.unit}'),
          ],
          if (item.isService) ...[
            const Divider(height: 20, color: Color(0xFFF1F5F9)),
            _buildInfoRow('Service Duration', '${item.durationMinutes} mins'),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: valueColor ?? const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(String text, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textColor),
      ),
    );
  }
}
