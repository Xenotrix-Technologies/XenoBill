import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class FloatingAddInvoiceButton extends StatelessWidget {
  final VoidCallback onTap;

  const FloatingAddInvoiceButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const String tooltipText = 'Add Invoice';

    return Tooltip(
      message: tooltipText,
      child: Semantics(
        label: tooltipText,
        button: true,
        container: true,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.brightCyan,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 4.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.brightCyan.withValues(alpha: 0.5),
                  blurRadius: 14,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 8,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.add,
              color: AppColors.deepNavy,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}
