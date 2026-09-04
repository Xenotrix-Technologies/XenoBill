import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isSecondary;
  final bool isOutlined;
  final bool isLoading;
  final Color? customColor;
  final Color? customTextColor;
  final double? width;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isSecondary = false,
    this.isOutlined = false,
    this.isLoading = false,
    this.customColor,
    this.customTextColor,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isOutlined
        ? Colors.transparent
        : customColor ?? (isSecondary ? AppColors.darkNavy : AppColors.brightCyan);

    final textColor = customTextColor ??
        (isOutlined
            ? (isSecondary ? AppColors.darkNavy : AppColors.brightCyan)
            : (isSecondary ? Colors.white : AppColors.deepNavy));

    final child = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(textColor),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: textColor),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(
                text,
                style: AppTextStyles.button.copyWith(color: textColor),
              ),
            ],
          );

    return SizedBox(
      width: width,
      height: 48,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: backgroundColor == Colors.transparent ? AppColors.brightCyan : backgroundColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
                ),
              ),
              child: child,
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                elevation: isSecondary ? 1 : 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
                ),
              ),
              child: child,
            ),
    );
  }
}
