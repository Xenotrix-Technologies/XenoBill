import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/route_constants.dart';
import '../../../infrastructure/database/app_database.dart';
import '../../../application/business/business_bloc.dart';
import '../../../domain/entities/business.dart';

/// Modal for Business Settings configuration
class BusinessSettingsModal extends StatelessWidget {
  final Business? business;

  const BusinessSettingsModal({super.key, required this.business});

  static void show(BuildContext context, Business? business) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BusinessSettingsModal(business: business),
    );
  }

  @override
  Widget build(BuildContext context) {
    final biz = business;
    final bType = biz?.businessType ?? 'Retail';
    final currency = biz?.currency ?? '₹';
    final isGst = biz?.gstEnabled ?? true;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.tune_outlined, color: AppColors.darkNavy, size: 24),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Business Settings',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.darkNavy),
                    ),
                  ),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ],
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.category_outlined, color: AppColors.darkNavy),
                title: const Text('Active Business Type'),
                subtitle: Text('Current: $bType'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context);
                  context.push(RouteConstants.businessTypeSelection);
                },
              ),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.attach_money_outlined, color: AppColors.darkNavy),
                title: const Text('Default Currency Symbol'),
                subtitle: Text('Current: $currency (Indian Rupee)'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Default Currency set to ₹ (INR)')),
                  );
                },
              ),
              const Divider(),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                secondary: const Icon(Icons.receipt_long_outlined, color: AppColors.darkNavy),
                title: const Text('GST Billing Mode'),
                subtitle: Text(isGst ? 'Enabled (Tax invoice generation active)' : 'Disabled'),
                value: isGst,
                activeColor: AppColors.brightCyan,
                onChanged: (v) {
                  if (biz != null) {
                    final updated = biz.copyWith(gstEnabled: v);
                    AppDatabase.instance.currentBusiness = updated;
                    context.read<BusinessBloc>().add(UpdateBusinessEvent(updated));
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Modal for App Theme Picker
class AppThemeModal extends StatefulWidget {
  const AppThemeModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const AppThemeModal(),
    );
  }

  @override
  State<AppThemeModal> createState() => _AppThemeModalState();
}

class _AppThemeModalState extends State<AppThemeModal> {
  String selectedTheme = 'System Default';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.palette_outlined, color: AppColors.darkNavy, size: 24),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'App Theme',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.darkNavy),
                  ),
                ),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
              ],
            ),
            const SizedBox(height: 12),
            ...['System Default', 'Light Theme', 'Dark Mode'].map(
              (theme) => RadioListTile<String>(
                value: theme,
                groupValue: selectedTheme,
                title: Text(theme, style: const TextStyle(fontWeight: FontWeight.w600)),
                activeColor: AppColors.brightCyan,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => selectedTheme = val);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Theme set to $val')),
                    );
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Modal for Notifications Settings
class NotificationsModal extends StatefulWidget {
  const NotificationsModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const NotificationsModal(),
    );
  }

  @override
  State<NotificationsModal> createState() => _NotificationsModalState();
}

class _NotificationsModalState extends State<NotificationsModal> {
  bool invoiceAlerts = true;
  bool paymentReminders = true;
  bool dueReminders = true;
  bool businessAlerts = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.notifications_none_outlined, color: AppColors.darkNavy, size: 24),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Notifications & Alerts',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.darkNavy),
                    ),
                  ),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ],
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Invoice Notifications'),
                subtitle: const Text('Alerts on creation and payment receipt'),
                value: invoiceAlerts,
                activeColor: AppColors.brightCyan,
                onChanged: (v) => setState(() => invoiceAlerts = v),
              ),
              SwitchListTile(
                title: const Text('Payment Reminders'),
                subtitle: const Text('Customer due date reminders'),
                value: paymentReminders,
                activeColor: AppColors.brightCyan,
                onChanged: (v) => setState(() => paymentReminders = v),
              ),
              SwitchListTile(
                title: const Text('Due Balance Alerts'),
                subtitle: const Text('Alerts for overdue credit accounts'),
                value: dueReminders,
                activeColor: AppColors.brightCyan,
                onChanged: (v) => setState(() => dueReminders = v),
              ),
              SwitchListTile(
                title: const Text('Business Performance Insights'),
                subtitle: const Text('Smart sales and low stock warnings'),
                value: businessAlerts,
                activeColor: AppColors.brightCyan,
                onChanged: (v) => setState(() => businessAlerts = v),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notification preferences saved successfully!')),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkNavy,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Save Preferences', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Modal for Backup & Restore
class BackupRestoreModal extends StatelessWidget {
  final bool isDemo;

  const BackupRestoreModal({super.key, required this.isDemo});

  static void show(BuildContext context, bool isDemo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BackupRestoreModal(isDemo: isDemo),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.cloud_sync_outlined, color: AppColors.darkNavy, size: 24),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Backup & Restore Data',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.darkNavy),
                    ),
                  ),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ],
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.cloud_upload_outlined, color: AppColors.brightCyan),
                title: const Text('Create Local Data Backup'),
                subtitle: const Text('Export JSON backup file to your device'),
                onTap: () {
                  final jsonStr = AppDatabase.instance.exportBackupJson();
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Backup Created Successfully'),
                      content: SingleChildScrollView(child: Text(jsonStr)),
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
                title: const Text('Restore Data from Backup'),
                subtitle: const Text('Import JSON backup file from device'),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Select JSON backup file to restore')),
                  );
                },
              ),
              if (isDemo) ...[
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.refresh, color: AppColors.error),
                  title: const Text('Reset Demo Data'),
                  subtitle: const Text('Reload pre-seeded demo records'),
                  onTap: () {
                    context.read<BusinessBloc>().add(const ToggleDemoModeEvent(true));
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Demo data reset successfully!')),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Modal for About Xenobiz
class AboutXenobizModal extends StatelessWidget {
  const AboutXenobizModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const AboutXenobizModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  color: AppColors.darkNavy,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.receipt_long, color: AppColors.brightCyan, size: 36),
              ),
              const SizedBox(height: 12),
              const Text('XENOBIZ POS', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: AppColors.darkNavy)),
              const Text('Version 1.0.0 (Adaptive Business Engine)', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              const SizedBox(height: 20),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.help_outline, color: AppColors.darkNavy),
                title: const Text('Help & Support'),
                subtitle: const Text('Contact support or view documentation'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.policy_outlined, color: AppColors.darkNavy),
                title: const Text('Privacy Policy'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.article_outlined, color: AppColors.darkNavy),
                title: const Text('Terms & Conditions'),
                onTap: () {},
              ),
              const SizedBox(height: 16),
              Text(
                '© 2026 Xenotrix Technologies. All Rights Reserved.',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
