import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/widgets/app_button.dart';
import '../../../application/business/business_bloc.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepNavy,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              // App Logo / Icon
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.darkNavy,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.brightCyan, width: 3),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.brightCyan,
                      blurRadius: 20,
                      spreadRadius: -5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.receipt_long,
                  size: 48,
                  color: AppColors.brightCyan,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'XENOBIZ',
                style: AppTextStyles.h1.copyWith(
                  color: Colors.white,
                  letterSpacing: 3.0,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Simple billing. Smarter business.',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.brightCyan,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),

              // Action Buttons
              AppButton(
                text: 'Register',
                width: double.infinity,
                onPressed: () => context.push(RouteConstants.register),
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton(
                text: 'Login',
                isSecondary: true,
                width: double.infinity,
                onPressed: () => context.push(RouteConstants.login),
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton(
                text: 'Start Demo (Explore Offline POS)',
                isOutlined: true,
                customTextColor: AppColors.brightCyan,
                width: double.infinity,
                onPressed: () {
                  context.read<BusinessBloc>().add(const ToggleDemoModeEvent(true));
                  context.go(RouteConstants.home);
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Offline-First Local POS • Built for Speed',
                style: AppTextStyles.bodySmall.copyWith(color: Colors.white54),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }
}
