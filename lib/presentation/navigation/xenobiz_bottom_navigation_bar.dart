import 'package:flutter/material.dart';
import 'floating_add_invoice_button.dart';
import 'navigation_item.dart';

class XenobizBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  final String inventoryLabel;
  final IconData inventoryIcon;
  final IconData inventorySelectedIcon;

  const XenobizBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    this.inventoryLabel = 'Inventory',
    this.inventoryIcon = Icons.inventory_2_outlined,
    this.inventorySelectedIcon = Icons.inventory_2,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    const double barHeight = 60.0;
    const double fabSize = 50.0;
    const double fabOverlap = 10.0;
    final double totalHeight = barHeight + fabOverlap + bottomInset;

    return SizedBox(
      height: totalHeight,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          // Flat White Navigation Bar Container at exact bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: barHeight + bottomInset,
              padding: EdgeInsets.only(bottom: bottomInset),
              decoration: BoxDecoration(
                color: Colors.white,
                border: const Border(
                  top: BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // 1. Home
                  Expanded(
                    child: NavigationItem(
                      label: 'Home',
                      icon: Icons.home_outlined,
                      selectedIcon: Icons.home_rounded,
                      isSelected: selectedIndex == 0,
                      onTap: () => onItemTapped(0),
                      semanticLabel: 'Home',
                    ),
                  ),

                  // 2. Sales
                  Expanded(
                    child: NavigationItem(
                      label: 'Sales',
                      icon: Icons.shopping_bag_outlined,
                      selectedIcon: Icons.shopping_bag,
                      isSelected: selectedIndex == 1,
                      onTap: () => onItemTapped(1),
                      semanticLabel: 'Sales',
                    ),
                  ),

                  // 3. Center clearance space for + button
                  const SizedBox(width: fabSize),

                  // 4. Inventory
                  Expanded(
                    child: NavigationItem(
                      label: inventoryLabel,
                      icon: inventoryIcon,
                      selectedIcon: inventorySelectedIcon,
                      isSelected: selectedIndex == 3,
                      onTap: () => onItemTapped(3),
                      semanticLabel: inventoryLabel,
                    ),
                  ),

                  // 5. More
                  Expanded(
                    child: NavigationItem(
                      label: 'More',
                      icon: Icons.more_horiz_rounded,
                      selectedIcon: Icons.more_horiz_rounded,
                      isSelected: selectedIndex == 4,
                      onTap: () => onItemTapped(4),
                      semanticLabel: 'More',
                    ),
                  ),
                ],
              ),
            ),
          ),

          // CENTER "+": Royal Blue circular button slightly overlapping top edge
          Positioned(
            top: 0,
            child: FloatingAddInvoiceButton(
              onTap: () => onItemTapped(2),
            ),
          ),
        ],
      ),
    );
  }
}
