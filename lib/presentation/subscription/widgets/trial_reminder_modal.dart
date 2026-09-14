import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/subscription_details.dart';
import '../../../application/subscription/subscription_bloc.dart';
import '../../../application/subscription/subscription_event.dart';

class TrialReminderModal extends StatelessWidget {
  final SubscriptionDetails details;

  const TrialReminderModal({
    super.key,
    required this.details,
  });

  static Future<void> show(BuildContext context, SubscriptionDetails details) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => TrialReminderModal(details: details),
    );
  }

  @override
  Widget build(BuildContext context) {
    final remainingDays = details.remainingTrialDays;
    final expiryFormatted = DateFormat('dd MMMM yyyy').format(details.trialEndDate);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon Badge
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.brightCyan.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.workspace_premium_rounded,
                color: AppColors.darkNavy,
                size: 38,
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              "You're currently on a ${details.totalTrialDays}-day free trial",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.darkNavy,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 12),

            // Summary Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  _buildDetailRow('Current Plan', details.planName, isBold: true),
                  const SizedBox(height: 8),
                  _buildDetailRow('Trial Duration', '${details.totalTrialDays} Days'),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    'Remaining Days',
                    '$remainingDays ${remainingDays == 1 ? 'day' : 'days'}',
                    valueColor: remainingDays <= 2 ? Colors.orange.shade800 : AppColors.darkNavy,
                    isBold: true,
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow('Expires On', expiryFormatted),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Explanation
            Text(
              'Explore Xenobill with full access for ${details.totalTrialDays} days. Upgrade anytime to continue using all features without interruption.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),

            // Primary Action Button — Purchase Xenobill
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  context.read<SubscriptionBloc>().add(DismissTrialPopupEvent());
                  Navigator.of(context).pop();
                  context.push('/subscription');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brightCyan,
                  foregroundColor: AppColors.darkNavy,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Purchase Xenobill',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Secondary Action Button — Continue with Demo
            SizedBox(
              width: double.infinity,
              height: 44,
              child: TextButton(
                onPressed: () {
                  context.read<SubscriptionBloc>().add(DismissTrialPopupEvent());
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Continue with Demo',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: valueColor ?? const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}
