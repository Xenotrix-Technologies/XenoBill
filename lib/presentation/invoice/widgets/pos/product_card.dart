import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../domain/entities/item.dart';

class ProductCard extends StatelessWidget {
  final Item product;
  final VoidCallback onAddTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isProduct = product.isProduct;
    final int stock = product.currentStock;
    final bool isOutOfStock = isProduct && stock <= 0;
    final bool isLowStock = isProduct && stock > 0 && stock <= 5;

    return Container(
      decoration: BoxDecoration(
        color: isOutOfStock ? Colors.grey.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isOutOfStock ? Colors.grey.shade300 : AppColors.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isOutOfStock ? null : onAddTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top header: Product image/icon & Stock badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isOutOfStock
                            ? Colors.grey.shade200
                            : AppColors.brightCyan.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        isProduct ? Icons.inventory_2_outlined : Icons.design_services_outlined,
                        color: isOutOfStock ? Colors.grey.shade500 : AppColors.darkNavy,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (isOutOfStock)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.red.shade200),
                              ),
                              child: Text(
                                'Out of stock',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.red.shade700,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          else if (isLowStock)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.orange.shade200),
                              ),
                              child: Text(
                                'Low stock ($stock)',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.orange.shade800,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          else if (isProduct)
                            Text(
                              'Stock: $stock',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 10,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Product Name
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: isOutOfStock ? Colors.grey.shade600 : AppColors.nearBlack,
                  ),
                ),

                // Product SKU / Category code
                if (product.sku.isNotEmpty || product.category.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    product.sku.isNotEmpty ? product.sku : product.category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ],

                const Spacer(),

                // Price and Add (+) Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      CurrencyFormatter.format(product.sellingPrice),
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isOutOfStock ? Colors.grey.shade500 : AppColors.darkNavy,
                      ),
                    ),
                    InkWell(
                      onTap: isOutOfStock ? null : onAddTap,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isOutOfStock ? Colors.grey.shade300 : AppColors.brightCyan,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add,
                          color: isOutOfStock ? Colors.grey.shade600 : AppColors.deepNavy,
                          size: 20,
                        ),
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
}
