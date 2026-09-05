import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../domain/entities/business.dart';
import '../../../domain/entities/business_type.dart';
import '../../../infrastructure/database/app_database.dart';
import '../../../application/business/business_bloc.dart';

class BusinessProfileEditPage extends StatefulWidget {
  const BusinessProfileEditPage({super.key});

  @override
  State<BusinessProfileEditPage> createState() => _BusinessProfileEditPageState();
}

class _BusinessProfileEditPageState extends State<BusinessProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _altPhoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;

  late BusinessType _selectedType;

  @override
  void initState() {
    super.initState();
    final biz = AppDatabase.instance.currentBusiness;
    _nameController = TextEditingController(text: biz?.name ?? '');
    _phoneController = TextEditingController(text: biz?.phone ?? '');
    _altPhoneController = TextEditingController(text: '');
    _emailController = TextEditingController(text: biz?.email ?? '');
    _addressController = TextEditingController(text: biz?.address ?? '');
    _selectedType = biz?.type ?? BusinessType.retail;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _altPhoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.darkNavy),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Business Profile',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.darkNavy,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Edit Business Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkNavy),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Update your trade name, contact information and business type',
                  style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 20),

                // Business Name
                AppTextField(
                  label: 'Business / Trade Name',
                  hint: 'e.g. Apex Retail Stores',
                  controller: _nameController,
                  validator: (v) => v == null || v.trim().isEmpty ? 'Business name is required' : null,
                ),
                const SizedBox(height: 16),

                // Business Type Picker
                const Text(
                  'Business Type',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.darkNavy),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<BusinessType>(
                      value: _selectedType,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.darkNavy),
                      items: BusinessType.values.map((type) {
                        return DropdownMenuItem<BusinessType>(
                          value: type,
                          child: Row(
                            children: [
                              Icon(type.icon, size: 20, color: AppColors.brightCyan),
                              const SizedBox(width: 10),
                              Text(
                                type.displayName,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.darkNavy),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedType = val);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Primary Phone
                AppTextField(
                  label: 'Primary Phone Number',
                  hint: 'e.g. 9876543210',
                  keyboardType: TextInputType.phone,
                  controller: _phoneController,
                ),
                const SizedBox(height: 16),

                // Alternate Phone
                AppTextField(
                  label: 'Alternate Phone Number (Optional)',
                  hint: 'e.g. 9876543211',
                  keyboardType: TextInputType.phone,
                  controller: _altPhoneController,
                ),
                const SizedBox(height: 16),

                // Email
                AppTextField(
                  label: 'Email Address (Optional)',
                  hint: 'e.g. contact@business.com',
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                ),
                const SizedBox(height: 16),

                // Business Address
                AppTextField(
                  label: 'Business Address (Optional)',
                  hint: 'Street, Shop #, City, Pincode',
                  maxLines: 2,
                  controller: _addressController,
                ),
                const SizedBox(height: 28),

                // Save Button
                AppButton(
                  text: 'Save Profile Changes',
                  width: double.infinity,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final current = AppDatabase.instance.currentBusiness;
                      final updatedName = _nameController.text.trim();
                      final updatedPhone = _phoneController.text.trim();
                      final updatedEmail = _emailController.text.trim();
                      final updatedAddr = _addressController.text.trim();

                      final updated = (current != null)
                          ? current.copyWith(
                              name: updatedName.isEmpty ? 'My Business' : updatedName,
                              businessType: _selectedType,
                              phone: updatedPhone,
                              email: updatedEmail,
                              address: updatedAddr,
                            )
                          : Business(
                              id: 'biz_real_1',
                              name: updatedName.isEmpty ? 'My Business' : updatedName,
                              businessType: _selectedType,
                              phone: updatedPhone,
                              email: updatedEmail,
                              address: updatedAddr,
                              gstEnabled: true,
                              gstin: '',
                              invoicePrefix: 'INV',
                              nextInvoiceNumber: 1001,
                            );

                      AppDatabase.instance.currentBusiness = updated;
                      context.read<BusinessBloc>().add(UpdateBusinessEvent(updated));

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Business Profile updated successfully!')),
                      );
                      context.pop();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
