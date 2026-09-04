import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../application/invoice/invoice_bloc.dart';

class ExtraExpenseSection extends StatelessWidget {
  final List<ExtraExpenseItem> extraExpenses;
  final ValueChanged<({String name, double amount})> onAddExpense;
  final ValueChanged<String> onRemoveExpense;

  const ExtraExpenseSection({
    super.key,
    required this.extraExpenses,
    required this.onAddExpense,
    required this.onRemoveExpense,
  });

  @override
  Widget build(BuildContext context) {
    final double totalExpenses = extraExpenses.fold(0.0, (sum, e) => sum + e.amount);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.local_shipping_outlined, size: 16, color: AppColors.darkNavy),
                  const SizedBox(width: 6),
                  Text(
                    'Extra Expenses',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppColors.nearBlack,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => _showAddExpenseDialog(context),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.add_circle_outline, size: 14, color: AppColors.darkNavy),
                      const SizedBox(width: 4),
                      Text(
                        'Add',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.darkNavy,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (extraExpenses.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Divider(height: 1),
            const SizedBox(height: 8),
            ...extraExpenses.map((expense) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        expense.name,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            CurrencyFormatter.format(expense.amount),
                            style: AppTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: AppColors.nearBlack,
                            ),
                          ),
                          const SizedBox(width: 4),
                          InkWell(
                            onTap: () => onRemoveExpense(expense.id),
                            child: const Padding(
                              padding: EdgeInsets.all(2),
                              child: Icon(Icons.close, size: 14, color: AppColors.error),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
            const Divider(height: 1),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total extra expense',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
                Text(
                  CurrencyFormatter.format(totalExpenses),
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkNavy,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showAddExpenseDialog(BuildContext context) {
    String selectedType = 'Delivery';
    final customNameController = TextEditingController();
    final amountController = TextEditingController();

    final presetTypes = ['Delivery', 'Packaging', 'Transport', 'Service charge', 'Other'];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add Extra Expense', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Expense Type:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: presetTypes.map((type) {
                      final isSel = selectedType == type;
                      return ChoiceChip(
                        label: Text(type, style: TextStyle(fontSize: 11, color: isSel ? Colors.white : Colors.black87)),
                        selected: isSel,
                        selectedColor: AppColors.darkNavy,
                        onSelected: (_) => setState(() => selectedType = type),
                      );
                    }).toList(),
                  ),
                  if (selectedType == 'Other') ...[
                    const SizedBox(height: 10),
                    TextField(
                      controller: customNameController,
                      decoration: const InputDecoration(
                        labelText: 'Custom Expense Name',
                        isDense: true,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  TextField(
                    controller: amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Amount (₹)',
                      prefixText: '₹ ',
                      isDense: true,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final amount = double.tryParse(amountController.text);
                  final name = selectedType == 'Other' && customNameController.text.trim().isNotEmpty
                      ? customNameController.text.trim()
                      : selectedType;

                  if (amount != null && amount > 0) {
                    onAddExpense((name: name, amount: amount));
                  }
                  Navigator.pop(ctx);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkNavy,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Add Expense'),
              ),
            ],
          );
        },
      ),
    );
  }
}
