import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../domain/entities/business.dart';
import '../../../domain/entities/business_type.dart';
import '../../../infrastructure/database/app_database.dart';
import '../../../infrastructure/supabase/supabase_client.dart';
import '../../../application/business/business_bloc.dart';

class BusinessProfileEditPage extends StatefulWidget {
  const BusinessProfileEditPage({super.key});

  @override
  State<BusinessProfileEditPage> createState() => _BusinessProfileEditPageState();
}

class _BusinessProfileEditPageState extends State<BusinessProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ownerNameController;
  late TextEditingController _phoneController;
  late TextEditingController _whatsappController;
  late TextEditingController _emailController;
  late TextEditingController _addressLine1Controller;
  late TextEditingController _addressLine2Controller;
  late TextEditingController _passwordController;

  late BusinessType _selectedType;
  bool _isObscurePassword = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final biz = AppDatabase.instance.currentBusiness;
    _nameController = TextEditingController(text: biz?.name ?? '');
    _ownerNameController = TextEditingController(text: biz?.ownerName ?? '');
    _phoneController = TextEditingController(text: biz?.phone ?? '');
    _whatsappController = TextEditingController(text: biz?.whatsappNumber ?? '');
    _emailController = TextEditingController(text: biz?.email ?? '');
    _addressLine1Controller = TextEditingController(text: biz?.addressLine1 ?? '');
    _addressLine2Controller = TextEditingController(text: biz?.addressLine2 ?? '');
    _passwordController = TextEditingController();
    _selectedType = biz?.type ?? BusinessType.retail;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ownerNameController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    _emailController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final newPassword = _passwordController.text.trim();
      if (newPassword.isNotEmpty) {
        if (newPassword.length < 6) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password must be at least 6 characters long.'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() => _isSaving = false);
          return;
        }

        final client = SupabaseClientManager.instance.client;
        if (client.auth.currentUser != null) {
          await client.auth.updateUser(UserAttributes(password: newPassword));
        }
      }

      final current = AppDatabase.instance.currentBusiness;
      final updatedName = _nameController.text.trim();
      final updatedOwnerName = _ownerNameController.text.trim();
      final updatedPhone = _phoneController.text.trim();
      final updatedWhatsapp = _whatsappController.text.trim();
      final updatedEmail = _emailController.text.trim();
      final updatedAddr1 = _addressLine1Controller.text.trim();
      final updatedAddr2 = _addressLine2Controller.text.trim();

      final updated = (current != null)
          ? current.copyWith(
              name: updatedName.isEmpty ? 'My Business' : updatedName,
              ownerName: updatedOwnerName,
              businessType: _selectedType,
              phone: updatedPhone,
              whatsappNumber: updatedWhatsapp,
              email: updatedEmail,
              addressLine1: updatedAddr1,
              addressLine2: updatedAddr2,
            )
          : Business(
              id: const Uuid().v4(),
              accountId: SupabaseClientManager.instance.client.auth.currentUser?.id,
              name: updatedName.isEmpty ? 'My Business' : updatedName,
              ownerName: updatedOwnerName,
              businessType: _selectedType,
              phone: updatedPhone,
              whatsappNumber: updatedWhatsapp,
              email: updatedEmail,
              addressLine1: updatedAddr1,
              addressLine2: updatedAddr2,
              gstEnabled: true,
              gstin: '',
              invoicePrefix: 'INV',
              nextInvoiceNumber: 1001,
            );

      AppDatabase.instance.currentBusiness = updated;
      if (!mounted) return;
      context.read<BusinessBloc>().add(UpdateBusinessEvent(updated));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Business Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
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
                  'Update your trade name, owner name, contact information and business type',
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

                // Owner Name
                AppTextField(
                  label: 'Owner / Proprietor Name',
                  hint: 'e.g. Ramesh Kumar',
                  controller: _ownerNameController,
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

                // WhatsApp Number
                AppTextField(
                  label: 'WhatsApp Number (Optional)',
                  hint: 'e.g. 9876543210',
                  keyboardType: TextInputType.phone,
                  controller: _whatsappController,
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

                // Address Line 1
                AppTextField(
                  label: 'Address Line 1 (Optional)',
                  hint: 'Shop / Flat No., Building Name, Street',
                  controller: _addressLine1Controller,
                ),
                const SizedBox(height: 16),

                // Address Line 2
                AppTextField(
                  label: 'Address Line 2 (Optional)',
                  hint: 'Area, Landmark, City, Pincode',
                  controller: _addressLine2Controller,
                ),
                const SizedBox(height: 24),

                // Password Section
                const Divider(),
                const SizedBox(height: 12),
                const Text(
                  'Security',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkNavy),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Leave password blank if you do not wish to change it',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 12),

                AppTextField(
                  label: 'Change Password (Optional)',
                  hint: 'Enter new password',
                  obscureText: _isObscurePassword,
                  controller: _passwordController,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: const Color(0xFF64748B),
                    ),
                    onPressed: () {
                      setState(() => _isObscurePassword = !_isObscurePassword);
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: AppButton(
            text: _isSaving ? 'Saving Changes...' : 'Save Profile Changes',
            isLoading: _isSaving,
            width: double.infinity,
            onPressed: _isSaving ? null : _saveProfile,
          ),
        ),
      ),
    );
  }
}
