import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _contactController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome Back', style: AppTextStyles.h1),
              const SizedBox(height: AppSpacing.xs),
              Text('Login to access your shop data', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: 'Mobile / Email',
                hint: 'e.g. 9876543210',
                prefixIcon: Icons.phone_android,
                controller: _contactController,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Password',
                hint: '••••••••',
                obscureText: true,
                prefixIcon: Icons.lock_outline,
                controller: _passwordController,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                text: 'Login',
                width: double.infinity,
                onPressed: () {
                  context.go(RouteConstants.home);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
