import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/subscription_details.dart';
import '../../../application/subscription/subscription_bloc.dart';
import '../../../application/subscription/subscription_state.dart';

class SubscriptionAppBarButton extends StatelessWidget {
  const SubscriptionAppBarButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionBloc, SubscriptionState>(
      builder: (context, state) {
        if (state is! SubscriptionLoaded) return const SizedBox.shrink();

        final details = state.details;
        final status = details.status;

        IconData iconData = Icons.workspace_premium_outlined;
        Color badgeColor = Colors.grey;
        String tooltip = 'Subscription & Billing';

        if (status == SubscriptionStatus.subscriptionActive) {
          iconData = Icons.workspace_premium_rounded;
          badgeColor = Colors.green;
          tooltip = 'Subscription Active (${details.planName})';
        } else if (status == SubscriptionStatus.trialActive || status == SubscriptionStatus.retrialActive) {
          final days = details.remainingTrialDays;
          if (days <= 1) {
            iconData = Icons.timer_outlined;
            badgeColor = Colors.amber.shade800;
            tooltip = 'Trial Ending Soon (1 day left)';
          } else {
            iconData = Icons.workspace_premium_outlined;
            badgeColor = AppColors.brightCyan;
            tooltip = 'Trial Active ($days days left)';
          }
        } else if (status.isRestricted) {
          iconData = Icons.lock_outline_rounded;
          badgeColor = Colors.red;
          tooltip = 'Trial / Plan Expired';
        } else if (status == SubscriptionStatus.retrialEligible) {
          iconData = Icons.stars_rounded;
          badgeColor = Colors.green;
          tooltip = '7-Day Re-Trial Available';
        }

        return Tooltip(
          message: tooltip,
          child: GestureDetector(
            onTap: () => context.push('/subscription'),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 10,
                        spreadRadius: 0,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    iconData,
                    color: AppColors.darkNavy,
                    size: 22,
                  ),
                ),
                Positioned(
                  top: 2,
                  right: 2,
                  child: Container(
                    width: 11,
                    height: 11,
                    decoration: BoxDecoration(
                      color: badgeColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
