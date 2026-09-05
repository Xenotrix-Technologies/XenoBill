import 'dart:convert';
import 'package:equatable/equatable.dart';

class InvoiceDisplaySettings extends Equatable {
  // 1. Business Information
  final bool showBusinessLogo;
  final bool showBusinessName;
  final bool showBusinessAddress;
  final bool showPhone;
  final bool showEmail;
  final bool showGstin;

  // 2. Invoice Details
  final bool showInvoiceNumber;
  final bool showInvoiceDate;
  final bool showInvoiceTime;
  final bool showCustomerDetails;
  final bool showPreviousCustomerBalance;

  // 3. Items & Line Pricing
  final bool showQuantity;
  final bool showUnitPrice;
  final bool showDiscount;
  final bool showTaxRowAndRate;

  // 4. Payment & Totals
  final bool showPaymentMethod;
  final bool showAmountPaid;
  final bool showBalanceDue;
  final bool showSubtotal;
  final bool showTaxTotal;
  final bool showDiscountTotal;
  final bool showAdditionalExpenses;
  final bool showGrandTotal; // Always true

  // 5. Additional Expenses
  final bool showExpenseDetails;
  final bool showExpenseAmount;
  final bool showExpenseTotal;

  // 6. Footer
  final bool showFooterMessage;
  final String footerMessage;
  final bool showTermsAndConditions;
  final String termsAndConditions;
  final bool showAuthorizedSignature;
  final bool showThankYouMessage;
  final bool showCustomFooterNote;
  final String customFooterNote;

  // 7. Invoice Display
  final bool showItemImages;
  final bool compactItemLayout;
  final bool showSku;
  final bool showHsnSac;
  final bool showBarcode;

  // 8. Printing
  final String paperSize; // 'Thermal 80mm', 'Thermal 58mm', 'A4', 'A5'
  final String invoiceFormat; // 'Standard', 'Compact', 'Thermal', 'Detailed'
  final bool autoPrintAfterSaving;
  final bool showPrintButton;

  const InvoiceDisplaySettings({
    this.showBusinessLogo = true,
    this.showBusinessName = true,
    this.showBusinessAddress = true,
    this.showPhone = true,
    this.showEmail = true,
    this.showGstin = true,
    this.showInvoiceNumber = true,
    this.showInvoiceDate = true,
    this.showInvoiceTime = true,
    this.showCustomerDetails = true,
    this.showPreviousCustomerBalance = false,
    this.showQuantity = true,
    this.showUnitPrice = true,
    this.showDiscount = true,
    this.showTaxRowAndRate = true,
    this.showPaymentMethod = true,
    this.showAmountPaid = true,
    this.showBalanceDue = true,
    this.showSubtotal = true,
    this.showTaxTotal = true,
    this.showDiscountTotal = true,
    this.showAdditionalExpenses = true,
    this.showGrandTotal = true,
    this.showExpenseDetails = true,
    this.showExpenseAmount = true,
    this.showExpenseTotal = true,
    this.showFooterMessage = true,
    this.footerMessage = 'Thank you for your business!',
    this.showTermsAndConditions = true,
    this.termsAndConditions = 'Thank you for your business! Goods once sold cannot be returned.',
    this.showAuthorizedSignature = true,
    this.showThankYouMessage = true,
    this.showCustomFooterNote = false,
    this.customFooterNote = '',
    this.showItemImages = false,
    this.compactItemLayout = false,
    this.showSku = false,
    this.showHsnSac = true,
    this.showBarcode = false,
    this.paperSize = 'Thermal 80mm',
    this.invoiceFormat = 'Standard',
    this.autoPrintAfterSaving = false,
    this.showPrintButton = true,
  });

  InvoiceDisplaySettings copyWith({
    bool? showBusinessLogo,
    bool? showBusinessName,
    bool? showBusinessAddress,
    bool? showPhone,
    bool? showEmail,
    bool? showGstin,
    bool? showInvoiceNumber,
    bool? showInvoiceDate,
    bool? showInvoiceTime,
    bool? showCustomerDetails,
    bool? showPreviousCustomerBalance,
    bool? showQuantity,
    bool? showUnitPrice,
    bool? showDiscount,
    bool? showTaxRowAndRate,
    bool? showPaymentMethod,
    bool? showAmountPaid,
    bool? showBalanceDue,
    bool? showSubtotal,
    bool? showTaxTotal,
    bool? showDiscountTotal,
    bool? showAdditionalExpenses,
    bool? showGrandTotal,
    bool? showExpenseDetails,
    bool? showExpenseAmount,
    bool? showExpenseTotal,
    bool? showFooterMessage,
    String? footerMessage,
    bool? showTermsAndConditions,
    String? termsAndConditions,
    bool? showAuthorizedSignature,
    bool? showThankYouMessage,
    bool? showCustomFooterNote,
    String? customFooterNote,
    bool? showItemImages,
    bool? compactItemLayout,
    bool? showSku,
    bool? showHsnSac,
    bool? showBarcode,
    String? paperSize,
    String? invoiceFormat,
    bool? autoPrintAfterSaving,
    bool? showPrintButton,
  }) {
    return InvoiceDisplaySettings(
      showBusinessLogo: showBusinessLogo ?? this.showBusinessLogo,
      showBusinessName: showBusinessName ?? this.showBusinessName,
      showBusinessAddress: showBusinessAddress ?? this.showBusinessAddress,
      showPhone: showPhone ?? this.showPhone,
      showEmail: showEmail ?? this.showEmail,
      showGstin: showGstin ?? this.showGstin,
      showInvoiceNumber: showInvoiceNumber ?? this.showInvoiceNumber,
      showInvoiceDate: showInvoiceDate ?? this.showInvoiceDate,
      showInvoiceTime: showInvoiceTime ?? this.showInvoiceTime,
      showCustomerDetails: showCustomerDetails ?? this.showCustomerDetails,
      showPreviousCustomerBalance: showPreviousCustomerBalance ?? this.showPreviousCustomerBalance,
      showQuantity: showQuantity ?? this.showQuantity,
      showUnitPrice: showUnitPrice ?? this.showUnitPrice,
      showDiscount: showDiscount ?? this.showDiscount,
      showTaxRowAndRate: showTaxRowAndRate ?? this.showTaxRowAndRate,
      showPaymentMethod: showPaymentMethod ?? this.showPaymentMethod,
      showAmountPaid: showAmountPaid ?? this.showAmountPaid,
      showBalanceDue: showBalanceDue ?? this.showBalanceDue,
      showSubtotal: showSubtotal ?? this.showSubtotal,
      showTaxTotal: showTaxTotal ?? this.showTaxTotal,
      showDiscountTotal: showDiscountTotal ?? this.showDiscountTotal,
      showAdditionalExpenses: showAdditionalExpenses ?? this.showAdditionalExpenses,
      showGrandTotal: true,
      showExpenseDetails: showExpenseDetails ?? this.showExpenseDetails,
      showExpenseAmount: showExpenseAmount ?? this.showExpenseAmount,
      showExpenseTotal: showExpenseTotal ?? this.showExpenseTotal,
      showFooterMessage: showFooterMessage ?? this.showFooterMessage,
      footerMessage: footerMessage ?? this.footerMessage,
      showTermsAndConditions: showTermsAndConditions ?? this.showTermsAndConditions,
      termsAndConditions: termsAndConditions ?? this.termsAndConditions,
      showAuthorizedSignature: showAuthorizedSignature ?? this.showAuthorizedSignature,
      showThankYouMessage: showThankYouMessage ?? this.showThankYouMessage,
      showCustomFooterNote: showCustomFooterNote ?? this.showCustomFooterNote,
      customFooterNote: customFooterNote ?? this.customFooterNote,
      showItemImages: showItemImages ?? this.showItemImages,
      compactItemLayout: compactItemLayout ?? this.compactItemLayout,
      showSku: showSku ?? this.showSku,
      showHsnSac: showHsnSac ?? this.showHsnSac,
      showBarcode: showBarcode ?? this.showBarcode,
      paperSize: paperSize ?? this.paperSize,
      invoiceFormat: invoiceFormat ?? this.invoiceFormat,
      autoPrintAfterSaving: autoPrintAfterSaving ?? this.autoPrintAfterSaving,
      showPrintButton: showPrintButton ?? this.showPrintButton,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'showBusinessLogo': showBusinessLogo,
      'showBusinessName': showBusinessName,
      'showBusinessAddress': showBusinessAddress,
      'showPhone': showPhone,
      'showEmail': showEmail,
      'showGstin': showGstin,
      'showInvoiceNumber': showInvoiceNumber,
      'showInvoiceDate': showInvoiceDate,
      'showInvoiceTime': showInvoiceTime,
      'showCustomerDetails': showCustomerDetails,
      'showPreviousCustomerBalance': showPreviousCustomerBalance,
      'showQuantity': showQuantity,
      'showUnitPrice': showUnitPrice,
      'showDiscount': showDiscount,
      'showTaxRowAndRate': showTaxRowAndRate,
      'showPaymentMethod': showPaymentMethod,
      'showAmountPaid': showAmountPaid,
      'showBalanceDue': showBalanceDue,
      'showSubtotal': showSubtotal,
      'showTaxTotal': showTaxTotal,
      'showDiscountTotal': showDiscountTotal,
      'showAdditionalExpenses': showAdditionalExpenses,
      'showGrandTotal': showGrandTotal,
      'showExpenseDetails': showExpenseDetails,
      'showExpenseAmount': showExpenseAmount,
      'showExpenseTotal': showExpenseTotal,
      'showFooterMessage': showFooterMessage,
      'footerMessage': footerMessage,
      'showTermsAndConditions': showTermsAndConditions,
      'termsAndConditions': termsAndConditions,
      'showAuthorizedSignature': showAuthorizedSignature,
      'showThankYouMessage': showThankYouMessage,
      'showCustomFooterNote': showCustomFooterNote,
      'customFooterNote': customFooterNote,
      'showItemImages': showItemImages,
      'compactItemLayout': compactItemLayout,
      'showSku': showSku,
      'showHsnSac': showHsnSac,
      'showBarcode': showBarcode,
      'paperSize': paperSize,
      'invoiceFormat': invoiceFormat,
      'autoPrintAfterSaving': autoPrintAfterSaving,
      'showPrintButton': showPrintButton,
    };
  }

  factory InvoiceDisplaySettings.fromJson(Map<String, dynamic> json) {
    return InvoiceDisplaySettings(
      showBusinessLogo: json['showBusinessLogo'] ?? true,
      showBusinessName: json['showBusinessName'] ?? true,
      showBusinessAddress: json['showBusinessAddress'] ?? true,
      showPhone: json['showPhone'] ?? true,
      showEmail: json['showEmail'] ?? true,
      showGstin: json['showGstin'] ?? true,
      showInvoiceNumber: json['showInvoiceNumber'] ?? true,
      showInvoiceDate: json['showInvoiceDate'] ?? true,
      showInvoiceTime: json['showInvoiceTime'] ?? true,
      showCustomerDetails: json['showCustomerDetails'] ?? true,
      showPreviousCustomerBalance: json['showPreviousCustomerBalance'] ?? false,
      showQuantity: json['showQuantity'] ?? true,
      showUnitPrice: json['showUnitPrice'] ?? true,
      showDiscount: json['showDiscount'] ?? true,
      showTaxRowAndRate: json['showTaxRowAndRate'] ?? true,
      showPaymentMethod: json['showPaymentMethod'] ?? true,
      showAmountPaid: json['showAmountPaid'] ?? true,
      showBalanceDue: json['showBalanceDue'] ?? true,
      showSubtotal: json['showSubtotal'] ?? true,
      showTaxTotal: json['showTaxTotal'] ?? true,
      showDiscountTotal: json['showDiscountTotal'] ?? true,
      showAdditionalExpenses: json['showAdditionalExpenses'] ?? true,
      showGrandTotal: true,
      showExpenseDetails: json['showExpenseDetails'] ?? true,
      showExpenseAmount: json['showExpenseAmount'] ?? true,
      showExpenseTotal: json['showExpenseTotal'] ?? true,
      showFooterMessage: json['showFooterMessage'] ?? true,
      footerMessage: json['footerMessage'] ?? 'Thank you for your business!',
      showTermsAndConditions: json['showTermsAndConditions'] ?? true,
      termsAndConditions: json['termsAndConditions'] ?? 'Thank you for your business! Goods once sold cannot be returned.',
      showAuthorizedSignature: json['showAuthorizedSignature'] ?? true,
      showThankYouMessage: json['showThankYouMessage'] ?? true,
      showCustomFooterNote: json['showCustomFooterNote'] ?? false,
      customFooterNote: json['customFooterNote'] ?? '',
      showItemImages: json['showItemImages'] ?? false,
      compactItemLayout: json['compactItemLayout'] ?? false,
      showSku: json['showSku'] ?? false,
      showHsnSac: json['showHsnSac'] ?? true,
      showBarcode: json['showBarcode'] ?? false,
      paperSize: json['paperSize'] ?? 'Thermal 80mm',
      invoiceFormat: json['invoiceFormat'] ?? 'Standard',
      autoPrintAfterSaving: json['autoPrintAfterSaving'] ?? false,
      showPrintButton: json['showPrintButton'] ?? true,
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory InvoiceDisplaySettings.fromJsonString(String source) =>
      InvoiceDisplaySettings.fromJson(jsonDecode(source));

  @override
  List<Object?> get props => [
        showBusinessLogo,
        showBusinessName,
        showBusinessAddress,
        showPhone,
        showEmail,
        showGstin,
        showInvoiceNumber,
        showInvoiceDate,
        showInvoiceTime,
        showCustomerDetails,
        showPreviousCustomerBalance,
        showQuantity,
        showUnitPrice,
        showDiscount,
        showTaxRowAndRate,
        showPaymentMethod,
        showAmountPaid,
        showBalanceDue,
        showSubtotal,
        showTaxTotal,
        showDiscountTotal,
        showAdditionalExpenses,
        showGrandTotal,
        showExpenseDetails,
        showExpenseAmount,
        showExpenseTotal,
        showFooterMessage,
        footerMessage,
        showTermsAndConditions,
        termsAndConditions,
        showAuthorizedSignature,
        showThankYouMessage,
        showCustomFooterNote,
        customFooterNote,
        showItemImages,
        compactItemLayout,
        showSku,
        showHsnSac,
        showBarcode,
        paperSize,
        invoiceFormat,
        autoPrintAfterSaving,
        showPrintButton,
      ];
}
