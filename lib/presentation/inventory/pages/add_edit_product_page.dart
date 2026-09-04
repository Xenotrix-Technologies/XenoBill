import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../application/inventory/inventory_bloc.dart';
import '../../../domain/entities/item.dart';

class AddEditProductPage extends StatefulWidget {
  const AddEditProductPage({super.key});

  @override
  State<AddEditProductPage> createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends State<AddEditProductPage> {
  final _formKey = GlobalKey<FormState>();
  ItemType _selectedType = ItemType.product;
  final _nameController = TextEditingController();
  final _skuController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _categoryController = TextEditingController(text: 'General');
  final _unitController = TextEditingController(text: 'Unit');
  final _purchasePriceController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _mrpController = TextEditingController();
  final _gstRateController = TextEditingController(text: '5');
  final _stockController = TextEditingController(text: '20');
  final _lowStockController = TextEditingController(text: '5');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        title: Text(_selectedType == ItemType.product ? 'Add New Product' : 'Add New Service'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item Type Selector Switch
                Text('Item Type', style: AppTextStyles.h2),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    ChoiceChip(
                      label: const Text('PRODUCT (With Stock)'),
                      selected: _selectedType == ItemType.product,
                      selectedColor: AppColors.brightCyan,
                      onSelected: (_) => setState(() => _selectedType = ItemType.product),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('SERVICE (No Stock)'),
                      selected: _selectedType == ItemType.service,
                      selectedColor: AppColors.brightCyan,
                      onSelected: (_) => setState(() => _selectedType = ItemType.service),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                Text('Basic Information', style: AppTextStyles.h2),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(
                  label: _selectedType == ItemType.product ? 'Product Name' : 'Service Name',
                  hint: _selectedType == ItemType.product ? 'e.g. Basmati Rice 5kg' : 'e.g. Haircut, AC Service',
                  controller: _nameController,
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                if (_selectedType == ItemType.product) ...[
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: 'SKU Code',
                          hint: 'RICE-005',
                          controller: _skuController,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: AppTextField(
                          label: 'Barcode',
                          hint: '8901234567',
                          controller: _barcodeController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'Category',
                        hint: _selectedType == ItemType.product ? 'Groceries' : 'Salon / Repair',
                        controller: _categoryController,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: AppTextField(
                        label: 'Unit',
                        hint: _selectedType == ItemType.product ? 'kg, Pack' : 'Service, Job',
                        controller: _unitController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                Text('Pricing & Tax', style: AppTextStyles.h2),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'Selling Price (₹)',
                        hint: '350',
                        keyboardType: TextInputType.number,
                        controller: _sellingPriceController,
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: AppTextField(
                        label: 'GST Rate (%)',
                        hint: '5, 12, 18',
                        keyboardType: TextInputType.number,
                        controller: _gstRateController,
                      ),
                    ),
                  ],
                ),

                if (_selectedType == ItemType.product) ...[
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: 'Purchase Price (₹)',
                          hint: '280',
                          keyboardType: TextInputType.number,
                          controller: _purchasePriceController,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: AppTextField(
                          label: 'MRP (₹)',
                          hint: '380',
                          keyboardType: TextInputType.number,
                          controller: _mrpController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  Text('Inventory & Stock', style: AppTextStyles.h2),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: 'Opening Stock',
                          hint: '20',
                          keyboardType: TextInputType.number,
                          controller: _stockController,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: AppTextField(
                          label: 'Low Stock Limit',
                          hint: '5',
                          keyboardType: TextInputType.number,
                          controller: _lowStockController,
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: AppSpacing.xl),
                AppButton(
                  text: _selectedType == ItemType.product ? 'Save Product' : 'Save Service',
                  width: double.infinity,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newItem = Item(
                        id: const Uuid().v4(),
                        businessId: 'biz_1',
                        type: _selectedType,
                        name: _nameController.text,
                        sku: _skuController.text,
                        barcode: _barcodeController.text,
                        category: _categoryController.text,
                        unit: _unitController.text,
                        purchasePrice: double.tryParse(_purchasePriceController.text) ?? 0.0,
                        sellingPrice: double.tryParse(_sellingPriceController.text) ?? 0.0,
                        mrp: double.tryParse(_mrpController.text) ?? 0.0,
                        gstRate: double.tryParse(_gstRateController.text) ?? 5.0,
                        currentStock: _selectedType == ItemType.product ? (int.tryParse(_stockController.text) ?? 0) : 0,
                        lowStockLimit: _selectedType == ItemType.product ? (int.tryParse(_lowStockController.text) ?? 5) : 0,
                      );

                      context.read<InventoryBloc>().add(AddProductEvent(newItem));
                      context.pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${_selectedType.name.toUpperCase()} saved successfully!')),
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
