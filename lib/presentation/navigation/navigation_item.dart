import 'package:flutter/material.dart';

class NavigationItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool isSelected;
  final VoidCallback onTap;
  final String semanticLabel;

  const NavigationItem({
    super.key,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.isSelected,
    required this.onTap,
    required this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    const unselectedColor = Color(0xFF64748B);
    const selectedTextColor = Color(0xFF0F172A);
    const selectedIconColor = Color(0xFF1E293B);
    const selectedPillBg = Color(0xFFEEF2FF);

    return Semantics(
      label: semanticLabel,
      selected: isSelected,
      button: true,
      container: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          height: 52,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon Area with small compact pill if selected
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 52,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? selectedPillBg : Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  isSelected ? selectedIcon : icon,
                  color: isSelected ? selectedIconColor : unselectedColor,
                  size: 20,
                ),
              ),
              const SizedBox(height: 2),
              // Text Label
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? selectedTextColor : unselectedColor,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
