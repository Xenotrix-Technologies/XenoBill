import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/subscription_details.dart';
import '../../../domain/entities/subscription_transaction.dart';
import '../../../application/subscription/subscription_bloc.dart';
import '../../../application/subscription/subscription_event.dart';
import '../../../application/subscription/subscription_state.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: AppColors.darkNavy,
        foregroundColor: Colors.white,
        title: const Text(
          'Subscription & Billing',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<SubscriptionBloc, SubscriptionState>(
          builder: (context, state) {
            if (state is SubscriptionLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is! SubscriptionLoaded) {
              return const Center(child: Text('Failed to load subscription status'));
            }

            final details = state.details;
            final transactions = state.transactions;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. CURRENT PLAN SECTION
                  _buildCurrentPlanCard(context, details),
                  const SizedBox(height: 24),

                  // 2. AVAILABLE PLANS SECTION
                  _buildPlansHeader(),
                  const SizedBox(height: 12),
                  _buildPlansSection(context, details),
                  const SizedBox(height: 24),

                  // 3. PAYMENT MANAGEMENT SECTION
                  _buildPaymentManagementSection(context, details),
                  const SizedBox(height: 24),

                  // 4. TRANSACTION / PAYMENT HISTORY SECTION
                  _buildTransactionHistorySection(context, transactions),
                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ===========================================================================
  // 1. CURRENT PLAN CARD
  // ===========================================================================
  Widget _buildCurrentPlanCard(BuildContext context, SubscriptionDetails details) {
    final status = details.status;
    final isPro = status == SubscriptionStatus.subscriptionActive;
    final remainingDays = details.remainingTrialDays;

    String dateLabel = 'Expires On';
    String dateVal = DateFormat('dd MMM yyyy').format(details.trialEndDate);

    if (isPro && details.subscriptionEndDate != null) {
      dateLabel = 'Renews On';
      dateVal = DateFormat('dd MMM yyyy').format(details.subscriptionEndDate!);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.darkNavy,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkNavy.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isPro ? const Color(0xFF16A34A) : AppColors.brightCyan,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status.displayName.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isPro ? Colors.white : AppColors.darkNavy,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              if (!isPro)
                Text(
                  '$remainingDays ${remainingDays == 1 ? 'day' : 'days'} left',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.brightCyan,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),

          Text(
            details.planName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),

          Row(
            children: [
              Text(
                '$dateLabel: $dateVal',
                style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(width: 12),
              Text(
                'Status: ${details.paymentStatus}',
                style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Action Buttons
          if (!isPro)
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                onPressed: () => _selectPlan(context, 'Monthly Pro', 499.0),
                icon: const Icon(Icons.bolt, size: 20),
                label: const Text(
                  'Upgrade Now',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brightCyan,
                  foregroundColor: AppColors.darkNavy,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showChangePlanModal(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFF475569)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Change Plan'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _confirmCancelSubscription(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFFCA5A5),
                      side: const BorderSide(color: Color(0xFF7F1D1D)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Cancel Subscription'),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 2. PLANS SECTION
  // ===========================================================================
  Widget _buildPlansHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Plans',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
        SizedBox(height: 2),
        Text(
          'Choose the perfect plan for your business needs',
          style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
        ),
      ],
    );
  }

  Widget _buildPlansSection(BuildContext context, SubscriptionDetails details) {
    final currentPlan = details.planName;

    return Column(
      children: [
        // Free / Demo Plan Card
        _buildPlanTile(
          context: context,
          title: 'Free Trial / Demo',
          price: '₹0',
          period: '7 Days',
          features: ['Basic POS & Invoicing', 'Customer Ledger', 'Standard Receipts'],
          isCurrent: currentPlan.contains('Trial') || currentPlan.contains('Demo'),
          onSelect: null,
        ),
        const SizedBox(height: 12),

        // Monthly Pro Card
        _buildPlanTile(
          context: context,
          title: 'Xenobill Pro — Monthly',
          price: '₹499',
          period: '/ month',
          features: ['Unlimited Invoices & Purchases', 'Full Analytics & Smart Insights', 'WhatsApp & Email Billing', 'Cloud Backup & Multi-device Sync'],
          isCurrent: currentPlan.contains('Monthly'),
          onSelect: () => _selectPlan(context, 'Xenobill Pro Monthly', 499.0),
        ),
        const SizedBox(height: 12),

        // Yearly Pro Card (RECOMMENDED)
        _buildPlanTile(
          context: context,
          title: 'Xenobill Pro — Yearly',
          price: '₹4,999',
          period: '/ year (Save 17%)',
          features: ['All Pro Monthly Features', 'Priority Support & Onboarding', 'GST Tax Returns & E-Way Bills', 'Custom Invoice Templates'],
          isRecommended: true,
          isCurrent: currentPlan.contains('Yearly'),
          onSelect: () => _selectPlan(context, 'Xenobill Pro Yearly', 4999.0),
        ),
      ],
    );
  }

  Widget _buildPlanTile({
    required BuildContext context,
    required String title,
    required String price,
    required String period,
    required List<String> features,
    bool isRecommended = false,
    bool isCurrent = false,
    VoidCallback? onSelect,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isRecommended
              ? AppColors.brightCyan
              : (isCurrent ? AppColors.darkNavy : const Color(0xFFE2E8F0)),
          width: isRecommended || isCurrent ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                  if (isRecommended) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.brightCyan.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'RECOMMENDED',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.darkNavy),
                      ),
                    ),
                  ],
                ],
              ),
              if (isCurrent)
                const Icon(Icons.check_circle, color: AppColors.darkNavy, size: 20),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                price,
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              const SizedBox(width: 4),
              Text(
                period,
                style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 12),

          ...features.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    const Icon(Icons.check, size: 16, color: Color(0xFF16A34A)),
                    const SizedBox(width: 8),
                    Text(f, style: const TextStyle(fontSize: 13, color: Color(0xFF334155))),
                  ],
                ),
              )),
          const SizedBox(height: 14),

          if (!isCurrent && onSelect != null)
            SizedBox(
              width: double.infinity,
              height: 42,
              child: ElevatedButton(
                onPressed: onSelect,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isRecommended ? AppColors.brightCyan : AppColors.darkNavy,
                  foregroundColor: isRecommended ? AppColors.darkNavy : Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  'Select $title',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            )
          else if (isCurrent)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Active Current Plan',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
              ),
            ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 3. PAYMENT MANAGEMENT SECTION
  // ===========================================================================
  Widget _buildPaymentManagementSection(BuildContext context, SubscriptionDetails details) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Method & Billing',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 12),

          _buildBillingInfoRow('Current Method', details.paymentMethod),
          _buildBillingInfoRow('Payment Status', details.paymentStatus),
          if (details.subscriptionEndDate != null)
            _buildBillingInfoRow('Next Billing Date', DateFormat('dd MMM yyyy').format(details.subscriptionEndDate!)),

          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showUpdatePaymentMethodDialog(context),
                  icon: const Icon(Icons.payment_outlined, size: 16),
                  label: const Text('Update Payment Method'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBillingInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
        ],
      ),
    );
  }

  // ===========================================================================
  // 4. TRANSACTION HISTORY SECTION
  // ===========================================================================
  Widget _buildTransactionHistorySection(BuildContext context, List<SubscriptionTransaction> transactions) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Transaction History',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 12),

          if (transactions.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text('No billing transactions recorded yet', style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final tx = transactions[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.receipt_long, color: AppColors.darkNavy, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tx.planName,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                            ),
                            Text(
                              '${DateFormat('dd MMM yyyy').format(tx.date)} · ${tx.paymentMethod}',
                              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            CurrencyFormatter.format(tx.amount),
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                          InkWell(
                            onTap: () => _showReceiptModal(context, tx),
                            child: const Text(
                              'View Receipt',
                              style: TextStyle(fontSize: 12, color: AppColors.darkNavy, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // ===========================================================================
  // ACTION MODALS & DIALOGS
  // ===========================================================================
  void _selectPlan(BuildContext context, String planName, double amount) {
    String selectedMethod = 'UPI (GPay / PhonePe)';

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Purchase $planName', style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Amount: ${CurrencyFormatter.format(amount)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF059669))),
              const SizedBox(height: 16),
              const Text('Select Payment Method:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedMethod,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'UPI (GPay / PhonePe)', child: Text('UPI (GPay / PhonePe / Paytm)')),
                  DropdownMenuItem(value: 'Credit / Debit Card', child: Text('Credit / Debit Card')),
                  DropdownMenuItem(value: 'Netbanking', child: Text('Netbanking')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => selectedMethod = val);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogCtx);
                context.read<SubscriptionBloc>().add(PurchasePlanEvent(
                      planName: planName,
                      amount: amount,
                      paymentMethod: selectedMethod,
                    ));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Successfully upgraded to $planName!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.brightCyan, foregroundColor: AppColors.darkNavy),
              child: const Text('Confirm & Pay', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePlanModal(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Select an available plan from the list below to switch'), behavior: SnackBarBehavior.floating),
    );
  }

  void _confirmCancelSubscription(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Cancel Subscription?'),
        content: const Text('Are you sure you want to cancel your Xenobill Pro subscription? Your account will switch to Demo Mode at the end of the billing period.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('Keep Subscription')),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              context.read<SubscriptionBloc>().add(CancelSubscriptionEvent());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Subscription cancelled. Account set to Demo Mode.')),
              );
            },
            child: const Text('Cancel Plan', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showUpdatePaymentMethodDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment method settings updated successfully'), behavior: SnackBarBehavior.floating),
    );
  }

  void _showReceiptModal(BuildContext context, SubscriptionTransaction tx) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Subscription Receipt', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Transaction ID: ${tx.id.substring(0, 8).toUpperCase()}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const Divider(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Plan'), Text(tx.planName, style: const TextStyle(fontWeight: FontWeight.bold))]),
            const SizedBox(height: 6),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Date'), Text(DateFormat('dd MMM yyyy, h:mm a').format(tx.date))]),
            const SizedBox(height: 6),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Payment Method'), Text(tx.paymentMethod)]),
            const SizedBox(height: 6),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Amount Paid'), Text(CurrencyFormatter.format(tx.amount), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green))]),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('Close')),
        ],
      ),
    );
  }
}
