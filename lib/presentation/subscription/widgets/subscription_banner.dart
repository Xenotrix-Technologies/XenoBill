import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/subscription_details.dart';
import '../../../application/subscription/subscription_bloc.dart';
import '../../../application/subscription/subscription_event.dart';
import '../../../application/subscription/subscription_state.dart';

class SubscriptionBanner extends StatelessWidget {
  const SubscriptionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionBloc, SubscriptionState>(
      builder: (context, state) {
        if (state is! SubscriptionLoaded) return const SizedBox.shrink();

        final details = state.details;
        final status = details.status;

        if (status == SubscriptionStatus.subscriptionActive) {
          // Compact active badge
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFBBF7D0)),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_rounded, color: Color(0xFF16A34A), size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${details.planName} — Active',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF14532D),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/subscription'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Manage',
                    style: TextStyle(color: Color(0xFF16A34A), fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
          );
        }

        // Config per status
        String title = '';
        String subtitle = '';
        String buttonText = 'Purchase Plan';
        Color bgColor = Colors.cyan.shade50;
        Color borderColor = AppColors.brightCyan;
        Color textColor = AppColors.darkNavy;
        IconData icon = Icons.info_outline;

        if (status == SubscriptionStatus.trialActive || status == SubscriptionStatus.retrialActive) {
          final days = details.remainingTrialDays;
          if (days <= 1) {
            title = "Your trial ends in 1 day";
            subtitle = "Upgrade to continue using Xenobill without interruption.";
            buttonText = "Choose a Plan";
            bgColor = const Color(0xFFFFFBEB);
            borderColor = const Color(0xFFFCD34D);
            textColor = const Color(0xFF92400E);
            icon = Icons.warning_amber_rounded;
          } else {
            title = "You're using Xenobill Trial";
            subtitle = "$days days remaining. Upgrade to continue using Xenobill after trial ends.";
            buttonText = "Purchase Plan";
            bgColor = const Color(0xFFEFF6FF);
            borderColor = const Color(0xFF93C5FD);
            textColor = const Color(0xFF1E40AF);
            icon = Icons.timer_outlined;
          }
        } else if (status.isRestricted) {
          title = "Your trial has ended";
          subtitle = "Upgrade your Xenobill plan to unlock all feature access.";
          buttonText = "Upgrade to Continue";
          bgColor = const Color(0xFFFEF2F2);
          borderColor = const Color(0xFFFCA5A5);
          textColor = const Color(0xFF991B1B);
          icon = Icons.lock_outline;
        } else if (status == SubscriptionStatus.retrialEligible) {
          title = "Welcome back — 7-day trial available";
          subtitle = "Re-explore latest Xenobill features with full trial access.";
          buttonText = "Start Trial";
          bgColor = const Color(0xFFF0FDF4);
          borderColor = const Color(0xFF86EFAC);
          textColor = const Color(0xFF166534);
          icon = Icons.stars_rounded;
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor.withValues(alpha: 0.6)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: textColor, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: textColor.withValues(alpha: 0.85)),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () {
                      if (status == SubscriptionStatus.retrialEligible) {
                        context.read<SubscriptionBloc>().add(StartReTrialEvent());
                      } else {
                        context.push('/subscription');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: textColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: Text(
                      buttonText,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
