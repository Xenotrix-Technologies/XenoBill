import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/widgets/app_button.dart';
import '../../../domain/entities/business_type.dart';

class BusinessTypeSelectionPage extends StatefulWidget {
  const BusinessTypeSelectionPage({super.key});

  @override
  State<BusinessTypeSelectionPage> createState() => _BusinessTypeSelectionPageState();
}

class _BusinessTypeSelectionPageState extends State<BusinessTypeSelectionPage> {
  BusinessType _selectedType = BusinessType.retail;

  final List<BusinessType> _typesToDisplay = [
    BusinessType.retail,
    BusinessType.wholesale,
    BusinessType.restaurant,
    BusinessType.cafe,
    BusinessType.hotel,
    BusinessType.salon,
    BusinessType.service,
    BusinessType.mixed,
    BusinessType.other,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        title: const Text('Business Type'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What type of business do you run?',
                      style: AppTextStyles.h1.copyWith(fontSize: 24),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Xenobiz will customize your workspace based on your business.',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _typesToDisplay.length,
                      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final type = _typesToDisplay[index];
                        final isSelected = _selectedType == type;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedType = type;
                            });
                          },
                          child: AnimatedContainer(
                            duration: Duration.zero, // STATIC - no animations
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.brightCyan.withValues(alpha: 0.08) : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? AppColors.brightCyan : AppColors.border,
                                width: isSelected ? 2.5 : 1.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppColors.brightCyan : AppColors.lightGray,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    type.icon,
                                    color: isSelected ? AppColors.deepNavy : AppColors.darkNavy,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        type.displayName,
                                        style: AppTextStyles.bodyLarge.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: isSelected ? AppColors.deepNavy : AppColors.nearBlack,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        type.description,
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: isSelected ? AppColors.deepNavy.withValues(alpha: 0.8) : AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: AppColors.brightCyan,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: AppColors.deepNavy,
                                      size: 16,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Fixed Bottom Action Button Bar
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: AppButton(
                text: 'Continue',
                width: double.infinity,
                onPressed: () {
                  context.push(
                    RouteConstants.businessSetup,
                    extra: _selectedType,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
