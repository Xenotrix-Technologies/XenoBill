import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/route_constants.dart';
import '../../../domain/entities/business_features.dart';
import '../../../domain/entities/business_terminology.dart';

enum ShopTabType { products, services }

class ShopTabItem {
  final ShopTabType type;
  final String label;

  const ShopTabItem({
    required this.type,
    required this.label,
  });
}

class ShopHeader extends StatelessWidget {
  final BusinessFeatures features;
  final BusinessTerminology terminology;
  final ShopTabType activeTab;
  final ValueChanged<ShopTabType>? onTabSelected;

  const ShopHeader({
    super.key,
    required this.features,
    required this.terminology,
    required this.activeTab,
    this.onTabSelected,
  });

  List<ShopTabItem> _buildTabs() {
    final tabs = <ShopTabItem>[];

    if (features.productsEnabled) {
      tabs.add(ShopTabItem(
        type: ShopTabType.products,
        label: terminology.items.isNotEmpty ? terminology.items : 'Products',
      ));
    }
    if (features.servicesEnabled) {
      tabs.add(const ShopTabItem(
        type: ShopTabType.services,
        label: 'Services',
      ));
    }

    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    final inventoryTitle =
        terminology.inventory.isNotEmpty ? terminology.inventory : 'Inventory';
    final tabs = _buildTabs();

    final buttonLabel = activeTab == ShopTabType.services
        ? 'Add Service'
        : terminology.addItem;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title Row with Labeled Add Product Button
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                inventoryTitle,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111418),
                  letterSpacing: -0.5,
                ),
              ),
              InkWell(
                onTap: () {
                  context.push(RouteConstants.addEditProduct);
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.add,
                        color: Color(0xFF111418),
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        buttonLabel,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111418),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Segmented Tab Switch Container (Products | Services)
        if (tabs.length > 1)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFEBECEF),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: tabs.map((tab) {
                final isSelected = tab.type == activeTab;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      onTabSelected?.call(tab.type);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.black.withAlpha(15),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                      child: Center(
                        child: Text(
                          tab.label,
                          style: TextStyle(
                            color: isSelected
                                ? const Color(0xFF111418)
                                : const Color(0xFF5A6275),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
