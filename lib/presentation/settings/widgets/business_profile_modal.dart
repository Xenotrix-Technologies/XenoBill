import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/route_constants.dart';
import '../../../domain/entities/business.dart';
import '../../../domain/entities/business_type.dart';

class BusinessProfileModal extends StatelessWidget {
  final Business? business;

  const BusinessProfileModal({super.key, required this.business});

  static void show(BuildContext context, Business? business) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BusinessProfileModal(business: business),
    );
  }

  @override
  Widget build(BuildContext context) {
    final biz = business;
    final bizName = biz?.name ?? 'My Business';
    final bizType = biz?.businessType ?? 'Retail';
    final phone = (biz?.phone.isEmpty ?? true) ? 'Not provided' : biz!.phone;
    final email = (biz?.email.isEmpty ?? true) ? 'Not provided' : biz!.email;
    final address = (biz?.address.isEmpty ?? true) ? 'Not provided' : biz!.address;
    final gstin = (biz?.gstin.isEmpty ?? true) ? 'Not specified' : biz!.gstin;

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
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.brightCyan.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(biz?.type.icon ?? Icons.storefront, color: AppColors.darkNavy, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Business Profile', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkNavy)),
                        Text(bizName, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Business Information List
              _buildInfoItem(Icons.business, 'Business / Trade Name', bizName),
              _buildInfoItem(Icons.category, 'Business Type', bizType),
              _buildInfoItem(Icons.phone, 'Phone', phone),
              _buildInfoItem(Icons.email, 'Email', email),
              _buildInfoItem(Icons.location_on, 'Business Address', address),
              _buildInfoItem(Icons.receipt_long, 'GSTIN', gstin),
              _buildInfoItem(Icons.badge, 'PAN Number', 'Not specified'),

              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 12),

              // Actions
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    context.push(RouteConstants.businessSetup, extra: biz?.type ?? BusinessType.retail);
                  },
                  icon: const Icon(Icons.edit, color: Colors.white),
                  label: const Text('Edit Business Profile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkNavy,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    context.push(RouteConstants.businessTypeSelection);
                  },
                  icon: const Icon(Icons.swap_horiz, color: AppColors.darkNavy),
                  label: const Text('Change Business Type', style: TextStyle(color: AppColors.darkNavy)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF64748B)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.darkNavy)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
