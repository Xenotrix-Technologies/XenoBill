import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../application/customers/customers_bloc.dart';
import '../../../domain/entities/customer.dart';

class AddEditCustomerPage extends StatefulWidget {
  const AddEditCustomerPage({super.key});

  @override
  State<AddEditCustomerPage> createState() => _AddEditCustomerPageState();
}

class _AddEditCustomerPageState extends State<AddEditCustomerPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _gstinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        title: const Text('Add New Customer'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Customer Profile', style: AppTextStyles.h2),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(
                  label: 'Customer Name',
                  hint: 'e.g. Ramesh Sharma',
                  controller: _nameController,
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Phone Number',
                  hint: '9876543210',
                  keyboardType: TextInputType.phone,
                  controller: _phoneController,
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Email (Optional)',
                  hint: 'ramesh@example.com',
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Address (Optional)',
                  hint: 'Flat/Street address',
                  controller: _addressController,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'GSTIN (If B2B Business)',
                  hint: '27AAAAA0000A1Z5',
                  controller: _gstinController,
                ),

                const SizedBox(height: AppSpacing.xl),
                AppButton(
                  text: 'Save Customer',
                  width: double.infinity,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newCust = Customer(
                        id: const Uuid().v4(),
                        businessId: 'biz_1',
                        name: _nameController.text,
                        phone: _phoneController.text,
                        email: _emailController.text,
                        address: _addressController.text,
                        gstin: _gstinController.text,
                        outstandingBalance: 0.0,
                        totalInvoices: 0,
                      );

                      context.read<CustomersBloc>().add(AddCustomerEvent(newCust));
                      context.pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Customer added successfully!')),
                      );
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
