import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class InvoiceActionButtons extends StatelessWidget {
  final bool isSaving;
  final VoidCallback onSave;
  final VoidCallback onSaveAndPrint;

  const InvoiceActionButtons({
    super.key,
    required this.isSaving,
    required this.onSave,
    required this.onSaveAndPrint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Save button
            Expanded(
              flex: 2,
              child: OutlinedButton(
                onPressed: isSaving ? null : onSave,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.darkNavy,
                  side: const BorderSide(color: AppColors.darkNavy, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  minimumSize: const Size(0, 48),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Save & Print primary button
            Expanded(
              flex: 3,
              child: ElevatedButton.icon(
                onPressed: isSaving ? null : onSaveAndPrint,
                icon: isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.deepNavy),
                      )
                    : const Icon(Icons.print_outlined, color: AppColors.deepNavy, size: 20),
                label: Text(
                  isSaving ? 'Saving...' : 'Save & Print',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepNavy,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brightCyan,
                  foregroundColor: AppColors.deepNavy,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  minimumSize: const Size(0, 48),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
