import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/widgets/app_card.dart';
import '../../application/smart/smart_bloc.dart';
import '../../domain/entities/smart_insight.dart';

class SmartInsightsPage extends StatefulWidget {
  const SmartInsightsPage({super.key});

  @override
  State<SmartInsightsPage> createState() => _SmartInsightsPageState();
}

class _SmartInsightsPageState extends State<SmartInsightsPage> {
  @override
  void initState() {
    super.initState();
    context.read<SmartBloc>().add(LoadSmartInsightsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        title: const Text('Smart Insights & Analytics'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profit Insights Card
              BlocBuilder<SmartBloc, SmartState>(
                builder: (context, state) {
                  double profit = 0.0;
                  if (state is SmartLoaded) {
                    profit = state.netProfit;
                  }

                  return AppCard(
                    color: AppColors.deepNavy,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.auto_awesome, color: AppColors.brightCyan, size: 22),
                            const SizedBox(width: 8),
                            Text('ESTIMATED NET PROFIT', style: TextStyle(color: AppColors.brightCyan.withValues(alpha: 0.9), fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          CurrencyFormatter.format(profit),
                          style: TextStyle(
                            color: profit >= 0 ? Colors.white : AppColors.error,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Net Profit = Total Sales Revenue − Item Cost − Expenses',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.md),

              Text('Actionable Business Insights', style: AppTextStyles.h2),
              const SizedBox(height: AppSpacing.sm),

              BlocBuilder<SmartBloc, SmartState>(
                builder: (context, state) {
                  if (state is SmartLoaded) {
                    if (state.insights.isEmpty) {
                      return AppCard(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              const Icon(Icons.auto_awesome, size: 40, color: AppColors.brightCyan),
                              const SizedBox(height: 12),
                              Text('Not enough data yet', style: AppTextStyles.h3),
                              const SizedBox(height: 4),
                              Text(
                                'Keep using Xenobiz and Smart Insights will appear here.',
                                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: state.insights.map((SmartInsight insight) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: AppCard(
                            color: insight.isPositive ? Colors.white : Colors.amber.shade50,
                            border: Border.all(color: insight.isPositive ? AppColors.border : Colors.amber.shade300),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      insight.isPositive ? Icons.trending_up : Icons.warning_amber_rounded,
                                      color: insight.isPositive ? AppColors.success : Colors.amber.shade900,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      insight.title,
                                      style: AppTextStyles.h3.copyWith(color: insight.isPositive ? AppColors.nearBlack : Colors.amber.shade900),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(insight.message, style: AppTextStyles.bodyMedium),
                                if (insight.actionLabel != null && insight.actionRoute != null) ...[
                                  const SizedBox(height: 10),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton.icon(
                                      onPressed: () => context.push(insight.actionRoute!),
                                      icon: const Icon(Icons.arrow_forward, size: 16),
                                      label: Text(insight.actionLabel!),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.brightCyan,
                                        foregroundColor: AppColors.deepNavy,
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
