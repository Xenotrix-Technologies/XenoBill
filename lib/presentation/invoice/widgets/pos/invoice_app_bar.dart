import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class InvoiceAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String invoiceNumber;
  final String title;
  final VoidCallback? onResetTap;

  const InvoiceAppBar({
    super.key,
    required this.invoiceNumber,
    this.title = 'New Invoice',
    this.onResetTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedTime = DateFormat('h:mm a').format(now);
    final timeStr = 'Today, $formattedTime';

    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.darkNavy, size: 22),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  }
                },
                tooltip: 'Back to Sales',
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.h3.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.nearBlack,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '#$invoiceNumber · $timeStr',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.receipt_long_outlined, color: AppColors.darkNavy, size: 22),
                onPressed: onResetTap,
                tooltip: 'Clear Invoice / Cart',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
