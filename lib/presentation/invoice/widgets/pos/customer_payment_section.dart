import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../domain/entities/customer.dart';
import '../../../../domain/entities/invoice.dart';

class CustomerPaymentSection extends StatelessWidget {
  final Customer selectedCustomer;
  final PaymentType selectedPaymentType;
  final VoidCallback onTapCustomer;
  final ValueChanged<PaymentType> onSelectPayment;
  final String customerLabel;

  const CustomerPaymentSection({
    super.key,
    required this.selectedCustomer,
    required this.selectedPaymentType,
    required this.onTapCustomer,
    required this.onSelectPayment,
    this.customerLabel = 'Customer / Party',
  });

  @override
  Widget build(BuildContext context) {
    final bool isWalkIn = selectedCustomer.id == 'cust_walk_in';
    final bool hasOutstanding = selectedCustomer.outstandingBalance > 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              // Customer Selection Column (Left)
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          customerLabel,
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                        if (hasOutstanding) ...[
                          const SizedBox(width: 4),
                          Text(
                            '(Due: ${CurrencyFormatter.format(selectedCustomer.outstandingBalance)})',
                            style: const TextStyle(fontSize: 10, color: AppColors.error, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    InkWell(
                      onTap: onTapCustomer,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.lightGray,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isWalkIn ? Icons.store_outlined : Icons.person_outline,
                              size: 16,
                              color: AppColors.darkNavy,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                selectedCustomer.name,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: AppColors.nearBlack,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down, color: AppColors.darkNavy, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // Payment Selection Column (Right)
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    PopupMenuButton<PaymentType>(
                      onSelected: onSelectPayment,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      itemBuilder: (context) => PaymentType.values.map((type) {
                        final isSel = selectedPaymentType == type;
                        return PopupMenuItem<PaymentType>(
                          value: type,
                          child: Row(
                            children: [
                              Icon(
                                _getPaymentIcon(type),
                                size: 18,
                                color: isSel ? AppColors.brightCyan : AppColors.darkNavy,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _getPaymentLabel(type),
                                style: TextStyle(
                                  fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                  color: isSel ? AppColors.darkNavy : AppColors.nearBlack,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: selectedPaymentType == PaymentType.credit
                              ? Colors.amber.shade50
                              : AppColors.lightGray,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: selectedPaymentType == PaymentType.credit
                                ? Colors.amber.shade300
                                : AppColors.border,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _getPaymentLabel(selectedPaymentType),
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: selectedPaymentType == PaymentType.credit
                                      ? Colors.amber.shade900
                                      : AppColors.nearBlack,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down, color: AppColors.darkNavy, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getPaymentIcon(PaymentType type) {
    switch (type) {
      case PaymentType.cash:
        return Icons.payments_outlined;
      case PaymentType.credit:
        return Icons.account_balance_wallet_outlined;
      case PaymentType.upi:
        return Icons.qr_code;
      case PaymentType.card:
        return Icons.credit_card;
    }
  }

  String _getPaymentLabel(PaymentType type) {
    switch (type) {
      case PaymentType.cash:
        return 'Cash';
      case PaymentType.credit:
        return 'Credit';
      case PaymentType.upi:
        return 'UPI';
      case PaymentType.card:
        return 'Card';
    }
  }
}
