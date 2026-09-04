import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_colors.dart';
import '../../../application/customers/customers_bloc.dart';
import '../../../domain/entities/customer.dart';

class AddEditCustomerPage extends StatefulWidget {
  final Customer? initialCustomer;

  const AddEditCustomerPage({
    super.key,
    this.initialCustomer,
  });

  @override
  State<AddEditCustomerPage> createState() => _AddEditCustomerPageState();
}

class _AddEditCustomerPageState extends State<AddEditCustomerPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _altPhoneController;
  late TextEditingController _emailController;

  late TextEditingController _billingAddressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _pinCodeController;

  late TextEditingController _openingBalanceController;
  late TextEditingController _creditLimitController;

  String _customerType = 'Individual';

  bool get isEditing => widget.initialCustomer != null;

  @override
  void initState() {
    super.initState();
    final cust = widget.initialCustomer;
    _nameController = TextEditingController(text: cust?.name ?? '');
    _phoneController = TextEditingController(text: cust?.phone ?? '');
    _altPhoneController = TextEditingController(text: '');
    _emailController = TextEditingController(text: cust?.email ?? '');
    _billingAddressController = TextEditingController(text: cust?.address ?? '');
    _cityController = TextEditingController(text: '');
    _stateController = TextEditingController(text: '');
    _pinCodeController = TextEditingController(text: '');
    _openingBalanceController = TextEditingController(
      text: cust != null && cust.outstandingBalance > 0
          ? cust.outstandingBalance.toStringAsFixed(0)
          : '',
    );
    _creditLimitController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _altPhoneController.dispose();
    _emailController.dispose();
    _billingAddressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pinCodeController.dispose();
    _openingBalanceController.dispose();
    _creditLimitController.dispose();
    super.dispose();
  }

  void _confirmDelete(BuildContext context) {
    if (!isEditing) return;
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Customer'),
        content: Text(
          'Are you sure you want to delete "${widget.initialCustomer!.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              context.read<CustomersBloc>().add(DeleteCustomerEvent(widget.initialCustomer!.id));
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${widget.initialCustomer!.name} deleted')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  String _buildFullAddress() {
    final parts = <String>[];
    final street = _billingAddressController.text.trim();
    final city = _cityController.text.trim();
    final state = _stateController.text.trim();
    final pin = _pinCodeController.text.trim();

    if (street.isNotEmpty) parts.add(street);
    if (city.isNotEmpty) parts.add(city);
    if (state.isNotEmpty) parts.add(state);
    if (pin.isNotEmpty) parts.add(pin);

    return parts.join(', ');
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final address = _buildFullAddress();
    final openBalance = double.tryParse(_openingBalanceController.text.trim()) ?? 0.0;

    if (isEditing) {
      final updatedCust = widget.initialCustomer!.copyWith(
        name: name,
        phone: phone,
        email: email,
        address: address.isNotEmpty ? address : widget.initialCustomer!.address,
        outstandingBalance: openBalance > 0 ? openBalance : widget.initialCustomer!.outstandingBalance,
      );
      context.read<CustomersBloc>().add(UpdateCustomerEvent(updatedCust));
      context.pop(updatedCust);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Customer updated successfully!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      final newCust = Customer(
        id: const Uuid().v4(),
        businessId: 'biz_1',
        name: name,
        phone: phone,
        email: email,
        address: address,
        gstin: '',
        outstandingBalance: openBalance,
        totalInvoices: 0,
      );
      context.read<CustomersBloc>().add(AddCustomerEvent(newCust));
      context.pop(newCust);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Customer created successfully!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // 1. SCREEN HEADER
            _buildAppBar(context),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),

            // 2. FORM BODY (Vertically Scrollable)
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // CUSTOMER INFORMATION SECTION
                      _buildSectionHeader('CUSTOMER INFORMATION'),
                      
                      // Name (Required)
                      _buildFormField(
                        label: 'Customer Name',
                        hint: 'Enter customer name',
                        controller: _nameController,
                        isRequired: true,
                        autoFocus: !isEditing,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Customer Name is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Phone & Alternate Phone Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildFormField(
                              label: 'Phone',
                              hint: 'Enter phone',
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              validator: (v) {
                                if (v != null && v.trim().isNotEmpty) {
                                  final clean = v.trim().replaceAll(RegExp(r'[\s\-\+\(\)]'), '');
                                  if (clean.length < 7 || clean.length > 15 || !RegExp(r'^\d+$').hasMatch(clean)) {
                                    return 'Invalid phone';
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildFormField(
                              label: 'Alternate Phone',
                              hint: 'Alt phone',
                              controller: _altPhoneController,
                              keyboardType: TextInputType.phone,
                              validator: (v) {
                                if (v != null && v.trim().isNotEmpty) {
                                  final clean = v.trim().replaceAll(RegExp(r'[\s\-\+\(\)]'), '');
                                  if (clean.length < 7 || clean.length > 15 || !RegExp(r'^\d+$').hasMatch(clean)) {
                                    return 'Invalid phone';
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Email Field
                      _buildFormField(
                        label: 'Email',
                        hint: 'Enter email address',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v != null && v.trim().isNotEmpty) {
                            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (!emailRegex.hasMatch(v.trim())) {
                              return 'Enter a valid email address';
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 28),

                      // ADDRESS SECTION
                      _buildSectionHeader('ADDRESS'),
                      
                      // Billing Address
                      _buildFormField(
                        label: 'Billing Address',
                        hint: 'Street, Building, Area',
                        controller: _billingAddressController,
                      ),
                      const SizedBox(height: 16),

                      // City, State, PIN Code Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildFormField(
                              label: 'City',
                              hint: 'City',
                              controller: _cityController,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildFormField(
                              label: 'State',
                              hint: 'State',
                              controller: _stateController,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildFormField(
                              label: 'PIN Code',
                              hint: 'PIN Code',
                              controller: _pinCodeController,
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                if (v != null && v.trim().isNotEmpty) {
                                  final clean = v.trim();
                                  if (clean.length < 4 || clean.length > 10 || !RegExp(r'^\d+$').hasMatch(clean)) {
                                    return 'Invalid PIN';
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // OPTIONAL CUSTOMER DETAILS SECTION
                      _buildSectionHeader('ADDITIONAL DETAILS'),

                      // Customer Type
                      _buildCustomerTypeDropdown(),
                      const SizedBox(height: 16),

                      // Opening Balance & Credit Limit
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildFormField(
                              label: 'Opening Balance',
                              hint: '₹ Enter balance',
                              controller: _openingBalanceController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildFormField(
                              label: 'Credit Limit',
                              hint: '₹ Enter limit',
                              controller: _creditLimitController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),

            // 3. FIXED BOTTOM CREATE / UPDATE BUTTON
            Container(
              padding: const EdgeInsets.all(16),
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
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brightCyan,
                      foregroundColor: AppColors.deepNavy,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      isEditing ? 'Update Customer' : 'Create Customer',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.pop(),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFF0F172A),
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isEditing ? 'Edit Customer' : 'Add Customer',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isEditing
                      ? 'Update customer details'
                      : 'Add a customer or party to your business',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
              onPressed: () => _confirmDelete(context),
              tooltip: 'Delete Customer',
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 6),
        const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFormField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
    bool autoFocus = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF334155),
            ),
            children: [
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          autofocus: autoFocus,
          validator: validator,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF0F172A),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.brightCyan, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Customer Type',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: _customerType,
          items: const [
            DropdownMenuItem(value: 'Individual', child: Text('Individual')),
            DropdownMenuItem(value: 'Business', child: Text('Business')),
            DropdownMenuItem(value: 'Other', child: Text('Other')),
          ],
          onChanged: (val) {
            if (val != null) {
              setState(() {
                _customerType = val;
              });
            }
          },
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF0F172A),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.brightCyan, width: 1.5),
            ),
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B)),
        ),
      ],
    );
  }
}

