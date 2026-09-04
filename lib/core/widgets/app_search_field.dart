import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class AppSearchField extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  final VoidCallback? onScanTap;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autoFocus;

  const AppSearchField({
    super.key,
    this.hint = 'Search product or scan barcode...',
    required this.onChanged,
    this.onScanTap,
    this.controller,
    this.focusNode,
    this.autoFocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        autofocus: autoFocus,
        onChanged: onChanged,
        style: AppTextStyles.bodyMedium,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.bodyMedium.copyWith(color: Colors.grey.shade500),
          prefixIcon: const Icon(Icons.search, color: AppColors.brightCyan, size: 24),
          suffixIcon: onScanTap != null
              ? IconButton(
                  icon: const Icon(Icons.qr_code_scanner, color: AppColors.darkNavy),
                  onPressed: onScanTap,
                  tooltip: 'Scan Barcode',
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
            borderSide: const BorderSide(color: AppColors.brightCyan, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
