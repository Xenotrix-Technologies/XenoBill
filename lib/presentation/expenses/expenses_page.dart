import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../application/expenses/expenses_bloc.dart';
import '../../domain/entities/expense.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  @override
  void initState() {
    super.initState();
    context.read<ExpensesBloc>().add(LoadExpensesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        title: const Text('Expense Tracker'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.brightCyan,
        foregroundColor: AppColors.deepNavy,
        onPressed: () => _showAddExpenseModal(context),
        icon: const Icon(Icons.add, color: AppColors.deepNavy),
        label: const Text('Add Expense', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Expense Header Summary
            _buildExpenseHeader(),

            // Expense List
            Expanded(
              child: BlocBuilder<ExpensesBloc, ExpensesState>(
                builder: (context, state) {
                  if (state is ExpensesLoaded) {
                    if (state.expenses.isEmpty) {
                      return const Center(child: Text('No expenses recorded yet'));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      itemCount: state.expenses.length,
                      itemBuilder: (context, index) {
                        final exp = state.expenses[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: AppCard(
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.darkNavy.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.account_balance_wallet, color: AppColors.darkNavy, size: 22),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(exp.title, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                                      Text('${exp.category} • ${DateFormatter.formatShortDate(exp.date)}', style: AppTextStyles.bodySmall),
                                    ],
                                  ),
                                ),
                                Text(
                                  CurrencyFormatter.format(exp.amount),
                                  style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold, color: AppColors.error),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseHeader() {
    return BlocBuilder<ExpensesBloc, ExpensesState>(
      builder: (context, state) {
        double total = 0.0;
        double today = 0.0;
        if (state is ExpensesLoaded) {
          total = state.totalExpenses;
          today = state.todayExpenses;
        }

        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          color: AppColors.darkNavy,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Text('Total Expenses', style: TextStyle(color: Colors.white70, fontSize: 11)),
                  const SizedBox(height: 2),
                  Text(
                    CurrencyFormatter.format(total),
                    style: const TextStyle(color: AppColors.brightCyan, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(height: 24, width: 1, color: Colors.white24),
              Column(
                children: [
                  const Text('Today\'s Expense', style: TextStyle(color: Colors.white70, fontSize: 11)),
                  const SizedBox(height: 2),
                  Text(
                    CurrencyFormatter.format(today),
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddExpenseModal(BuildContext context) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    String category = 'Utilities';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom + 16, left: 16, right: 16, top: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Add New Expense', style: AppTextStyles.h2),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                ],
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: 'Expense Amount (₹)',
                hint: '2500',
                keyboardType: TextInputType.number,
                controller: amountController,
                autoFocus: true,
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: 'Title / Description',
                hint: 'e.g. Electricity Bill, Shop Rent',
                controller: titleController,
              ),
              const SizedBox(height: 16),
              AppButton(
                text: 'Save Expense',
                width: double.infinity,
                onPressed: () {
                  final amt = double.tryParse(amountController.text) ?? 0.0;
                  if (amt > 0 && titleController.text.isNotEmpty) {
                    final exp = Expense(
                      id: const Uuid().v4(),
                      businessId: 'biz_1',
                      category: category,
                      title: titleController.text,
                      amount: amt,
                      date: DateTime.now(),
                    );
                    context.read<ExpensesBloc>().add(AddExpenseEvent(exp));
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Expense added successfully!')),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
