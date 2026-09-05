import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/route_constants.dart';
import '../../../application/business/business_bloc.dart';
import '../../../infrastructure/database/app_database.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_group_card.dart';
import '../widgets/settings_tile.dart';

class BusinessSettingsPage extends StatelessWidget {
  const BusinessSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.darkNavy),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Business Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.darkNavy,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: BlocBuilder<BusinessBloc, BusinessState>(
            builder: (context, state) {
              final biz = (state is BusinessLoaded) ? state.business : AppDatabase.instance.currentBusiness;
              final bizType = biz?.businessType ?? 'Retail Shop';
              final isGst = biz?.gstEnabled ?? true;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SettingsSection(
                    title: 'Business',
                    subtitle: 'Configure your business information',
                  ),
                  SettingsGroupCard(
                    children: [
                      SettingsTile(
                        icon: Icons.storefront_outlined,
                        iconColor: const Color(0xFF7C3AED),
                        iconBackgroundColor: const Color(0xFFF3E8FF),
                        title: 'Business Profile',
                        subtitle: 'Edit business information and business type',
                        trailingText: bizType,
                        onTap: () => context.push(RouteConstants.editBusinessProfile),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const SettingsSection(
                    title: 'Tax & GST',
                    subtitle: 'Configure your tax settings',
                  ),
                  SettingsGroupCard(
                    children: [
                      SettingsTile(
                        icon: Icons.receipt_long_outlined,
                        iconColor: const Color(0xFF0D9488),
                        iconBackgroundColor: const Color(0xFFCCFBF1),
                        title: 'GST Settings',
                        subtitle: 'Manage GST registration and tax settings',
                        trailingText: isGst ? 'GST Active' : 'Exempt',
                        onTap: () => context.push(RouteConstants.gstSettings),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
