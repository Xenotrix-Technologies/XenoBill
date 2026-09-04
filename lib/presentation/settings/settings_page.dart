import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/route_constants.dart';
import '../../core/widgets/app_card.dart';
import '../../application/business/business_bloc.dart';
import '../../infrastructure/database/app_database.dart';
import '../../domain/entities/business_type.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        title: const Text('More & Settings'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 100),
          child: BlocBuilder<BusinessBloc, BusinessState>(
            builder: (context, state) {
              final biz = (state is BusinessLoaded) ? state.business : AppDatabase.instance.currentBusiness;
              final isDemo = AppDatabase.instance.isDemoMode;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mode Header Banner
                  if (isDemo) ...[
                    AppCard(
                      color: Colors.amber.shade50,
                      border: Border.all(color: Colors.amber.shade300),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.amber.shade900),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('You are exploring in DEMO MODE', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber.shade900)),
                                const Text('Changes made here use temporary demo data.', style: TextStyle(fontSize: 11)),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => context.push(RouteConstants.businessTypeSelection),
                            child: const Text('Setup Real Shop'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  // 1. Business Management & Directory
                  Text('Business Management', style: AppTextStyles.h2),
                  const SizedBox(height: AppSpacing.xs),
                  AppCard(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.people_alt_outlined, color: AppColors.brightCyan),
                          title: Text(
                            biz?.terminology.customers ?? 'Customers',
                            style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Manage ${biz?.terminology.customers.toLowerCase() ?? "customers"} directory & credit balances'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => context.push(RouteConstants.customers),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.analytics_outlined, color: AppColors.darkNavy),
                          title: const Text('Analytics & Reports'),
                          subtitle: const Text('Sales reports, GST summary & profit analysis'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => context.push(RouteConstants.reports),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.account_balance_wallet_outlined, color: AppColors.darkNavy),
                          title: const Text('Expense Tracker'),
                          subtitle: const Text('Track business overheads, bills & vendor expenses'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => context.push('/expenses'),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.auto_awesome, color: AppColors.brightCyan),
                          title: const Text('Smart AI Insights'),
                          subtitle: const Text('Sales forecasts, inventory alerts & growth recommendations'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => context.push('/smart'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // 1. Business Profile & Type Selection
                  Text('Business Profile', style: AppTextStyles.h2),
                  const SizedBox(height: AppSpacing.xs),
                  AppCard(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(biz?.type.icon ?? Icons.storefront, color: AppColors.brightCyan),
                          title: Text(biz?.name ?? 'My Business', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                          subtitle: Text('${biz?.businessType ?? "Retail"} • ${(biz?.phone.isEmpty ?? true) ? "No phone" : biz!.phone}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit, color: AppColors.darkNavy),
                            onPressed: () => context.push(RouteConstants.businessSetup, extra: biz?.type ?? BusinessType.retail),
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.category, color: AppColors.darkNavy),
                          title: const Text('Change Business Type'),
                          subtitle: Text('Current: ${biz?.businessType ?? "Retail"} (Never deletes data)'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => context.push(RouteConstants.businessTypeSelection),
                        ),
                        if (biz != null && biz.address.isNotEmpty) ...[
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.location_on_outlined, color: AppColors.darkNavy),
                            title: const Text('Address'),
                            subtitle: Text(biz.address),
                          ),
                        ],
                        if (biz != null && biz.gstEnabled) ...[
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.receipt_long, color: AppColors.darkNavy),
                            title: const Text('GSTIN'),
                            subtitle: Text(biz.gstin.isEmpty ? 'Not specified' : biz.gstin),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // 2. Invoice Settings
                  Text('Invoice Settings', style: AppTextStyles.h2),
                  const SizedBox(height: AppSpacing.xs),
                  AppCard(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.pin, color: AppColors.darkNavy),
                          title: const Text('Invoice Prefix & Sequence'),
                          subtitle: Text('${biz?.invoicePrefix ?? "INV"}-${biz?.nextInvoiceNumber ?? 1001}'),
                        ),
                        const Divider(),
                        const ListTile(
                          leading: Icon(Icons.print_outlined, color: AppColors.darkNavy),
                          title: Text('Receipt Print Format'),
                          subtitle: Text('Thermal 80mm / 3 Inch (Default)'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // 3. Backup & Restore
                  Text('Backup & Restore', style: AppTextStyles.h2),
                  const SizedBox(height: AppSpacing.xs),
                  AppCard(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.cloud_upload_outlined, color: AppColors.brightCyan),
                          title: const Text('Create Local Data Backup'),
                          subtitle: const Text('Export JSON backup file to device'),
                          onTap: () {
                            final backupJson = AppDatabase.instance.exportBackupJson();
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Backup Created Successfully'),
                                content: SingleChildScrollView(child: Text(backupJson)),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
                                ],
                              ),
                            );
                          },
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.restore, color: AppColors.darkNavy),
                          title: const Text('Restore Data'),
                          subtitle: const Text('Import JSON backup file'),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Select backup file to restore')),
                            );
                          },
                        ),
                        if (isDemo) ...[
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.refresh, color: AppColors.error),
                            title: const Text('Reset / Reload Demo Data'),
                            subtitle: const Text('Restores pre-seeded demo records'),
                            onTap: () {
                              context.read<BusinessBloc>().add(const ToggleDemoModeEvent(true));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Demo data reset successfully!')),
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // 4. App Info & Auth
                  Text('App Information', style: AppTextStyles.h2),
                  const SizedBox(height: AppSpacing.xs),
                  AppCard(
                    child: Column(
                      children: [
                        const ListTile(
                          leading: Icon(Icons.info_outline, color: AppColors.darkNavy),
                          title: Text('Xenobiz POS'),
                          subtitle: Text('Version 1.0.0 (Adaptive Business Engine)'),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.logout, color: AppColors.error),
                          title: const Text('Log Out / Exit to Welcome Screen'),
                          onTap: () => context.go(RouteConstants.welcome),
                        ),
                      ],
                    ),
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
