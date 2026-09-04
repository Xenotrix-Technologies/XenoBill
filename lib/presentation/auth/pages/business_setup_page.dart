import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../domain/entities/business.dart';
import '../../../domain/entities/business_type.dart';
import '../../../domain/entities/business_features.dart';
import '../../../application/business/business_bloc.dart';

class BusinessSetupPage extends StatefulWidget {
  final BusinessType? selectedType;

  const BusinessSetupPage({
    super.key,
    this.selectedType,
  });

  @override
  State<BusinessSetupPage> createState() => _BusinessSetupPageState();
}

class _BusinessSetupPageState extends State<BusinessSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _gstinController = TextEditingController();
  final _prefixController = TextEditingController(text: 'INV');
  final _startNumController = TextEditingController(text: '1001');

  late BusinessType _businessType;
  late BusinessFeatures _features;
  bool _gstEnabled = true;

  @override
  void initState() {
    super.initState();
    _businessType = widget.selectedType ?? BusinessType.retail;
    _features = _businessType.defaultFeatures;
    _gstEnabled = _features.gstEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        title: Text('Configure ${_businessType.displayName}'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Business Details', style: AppTextStyles.h1),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Selected Type: ${_businessType.displayName}',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.brightCyan, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSpacing.lg),

                AppTextField(
                  label: 'Business / Shop Name',
                  hint: 'e.g. Apex Retail, Spark Salon',
                  controller: _nameController,
                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: AppSpacing.md),

                AppTextField(
                  label: 'Phone Number (Optional)',
                  hint: 'e.g. 9876543210',
                  keyboardType: TextInputType.phone,
                  controller: _phoneController,
                ),
                const SizedBox(height: AppSpacing.md),

                AppTextField(
                  label: 'Address (Optional)',
                  hint: 'Street, City, State',
                  controller: _addressController,
                ),
                const SizedBox(height: AppSpacing.md),

                // GST Toggle
                SwitchListTile(
                  title: Text('GST Registered Business', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                  value: _gstEnabled,
                  activeThumbColor: AppColors.brightCyan,
                  onChanged: (val) {
                    setState(() {
                      _gstEnabled = val;
                      _features = _features.copyWith(gstEnabled: val);
                    });
                  },
                ),

                if (_gstEnabled) ...[
                  const SizedBox(height: AppSpacing.sm),
                  AppTextField(
                    label: 'GSTIN (GST Number)',
                    hint: 'e.g. 27AABCU9603R1ZM',
                    controller: _gstinController,
                  ),
                ],

                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'Invoice Prefix',
                        hint: 'INV',
                        controller: _prefixController,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: AppTextField(
                        label: 'Starting Inv #',
                        hint: '1001',
                        keyboardType: TextInputType.number,
                        controller: _startNumController,
                      ),
                    ),
                  ],
                ),

                // Feature Configuration for "Other" or Customization
                if (_businessType == BusinessType.other) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Text('Workspace Feature Modules', style: AppTextStyles.h2),
                  const SizedBox(height: AppSpacing.xs),
                  Text('Enable modules specific to your business needs', style: AppTextStyles.bodySmall),
                  const SizedBox(height: AppSpacing.sm),
                  _buildFeatureSwitch('Products Module', _features.productsEnabled, (v) => setState(() => _features = _features.copyWith(productsEnabled: v))),
                  _buildFeatureSwitch('Services Module', _features.servicesEnabled, (v) => setState(() => _features = _features.copyWith(servicesEnabled: v))),
                  _buildFeatureSwitch('Stock / Inventory Tracking', _features.inventoryEnabled, (v) => setState(() => _features = _features.copyWith(inventoryEnabled: v, stockTrackingEnabled: v))),
                  _buildFeatureSwitch('Customers & Credit Sales', _features.customersEnabled, (v) => setState(() => _features = _features.copyWith(customersEnabled: v, creditSalesEnabled: v))),
                  _buildFeatureSwitch('Expense Tracker', _features.expenseTrackingEnabled, (v) => setState(() => _features = _features.copyWith(expenseTrackingEnabled: v))),
                  _buildFeatureSwitch('Smart Insights', _features.smartInsightsEnabled, (v) => setState(() => _features = _features.copyWith(smartInsightsEnabled: v))),
                ],

                const SizedBox(height: AppSpacing.xl),
                AppButton(
                  text: 'Create Business & Start',
                  width: double.infinity,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final bizName = _nameController.text.trim();
                      final newBiz = Business(
                        id: 'biz_${DateTime.now().millisecondsSinceEpoch}',
                        name: bizName.isEmpty ? 'My Business' : bizName,
                        businessType: _businessType,
                        phone: _phoneController.text.trim(),
                        address: _addressController.text.trim(),
                        gstEnabled: _gstEnabled,
                        gstin: _gstEnabled ? _gstinController.text.trim() : '',
                        currency: '₹',
                        invoicePrefix: _prefixController.text.trim().isEmpty ? 'INV' : _prefixController.text.trim().toUpperCase(),
                        nextInvoiceNumber: int.tryParse(_startNumController.text) ?? 1001,
                        features: _features,
                      );

                      context.read<BusinessBloc>().add(UpdateBusinessEvent(newBiz));
                      context.go(RouteConstants.home);
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

  Widget _buildFeatureSwitch(String label, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      dense: true,
      title: Text(label, style: AppTextStyles.bodyMedium),
      value: value,
      activeThumbColor: AppColors.brightCyan,
      onChanged: onChanged,
    );
  }
}
