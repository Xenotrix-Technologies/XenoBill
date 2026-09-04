import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'floating_add_invoice_button.dart';
import 'navigation_item.dart';

class XenobizBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  final String shopLabel;
  final IconData shopIcon;
  final IconData shopSelectedIcon;

  const XenobizBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    this.shopLabel = 'Shop',
    this.shopIcon = Icons.storefront_outlined,
    this.shopSelectedIcon = Icons.storefront,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    const double barHeight = 64.0;
    const double fabSize = 58.0;
    final double totalHeight = barHeight + 18.0 + bottomInset;

    return SizedBox(
      height: totalHeight,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          // Continuous Rounded Dark Navigation Bar Container (Docked at bottom)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: barHeight + bottomInset,
              padding: EdgeInsets.only(bottom: bottomInset),
              decoration: BoxDecoration(
                color: AppColors.darkNavy,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // LEFT SIDE: Home, Sales
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
                  Expanded(
                    child: NavigationItem(
                      label: 'Sales',
                      icon: Icons.receipt_long_outlined,
                      selectedIcon: Icons.receipt_long_rounded,
                      isSelected: selectedIndex == 1,
                      onTap: () => onItemTapped(1),
                      semanticLabel: 'Sales',
                    ),
                  ),

                  // CENTER: Clearance space for floating Add Invoice button
                  const SizedBox(width: fabSize + 8),

                  // RIGHT SIDE: Shop/Business/Hotel/Menu, Settings
                  Expanded(
                    child: NavigationItem(
                      label: shopLabel,
                      icon: shopIcon,
                      selectedIcon: shopSelectedIcon,
                      isSelected: selectedIndex == 3,
                      onTap: () => onItemTapped(3),
                      semanticLabel: shopLabel,
                    ),
                  ),
                  Expanded(
                    child: NavigationItem(
                      label: 'Settings',
                      icon: Icons.settings_outlined,
                      selectedIcon: Icons.settings_rounded,
                      isSelected: selectedIndex == 4,
                      onTap: () => onItemTapped(4),
                      semanticLabel: 'Settings',
                    ),
                  ),
                ],
              ),
            ),
          ),

          // CENTER: Floating Add Invoice Button (Raised with White Ring)
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
