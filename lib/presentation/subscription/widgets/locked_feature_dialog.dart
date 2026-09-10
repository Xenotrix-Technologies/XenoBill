import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class LockedFeatureDialog extends StatelessWidget {
  final String featureName;

  const LockedFeatureDialog({
    super.key,
    required this.featureName,
  });

  static Future<void> show(BuildContext context, String featureName) async {
    await showDialog(
      context: context,
      builder: (dialogCtx) => LockedFeatureDialog(featureName: featureName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lock_rounded, color: Colors.red, size: 24),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'This feature is unavailable in Demo Mode',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1.25),
            ),
          ),
        ],
      ),
      content: Text(
        'Your free trial has ended. Upgrade your Xenobill plan to continue using $featureName and all premium capabilities without restriction.',
        style: const TextStyle(fontSize: 13.5, color: Color(0xFF475569), height: 1.4),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Not Now',
            style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
            context.push('/subscription');
          },
          icon: const Icon(Icons.workspace_premium, size: 18),
          label: const Text('View Plans'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.darkNavy,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}
