import 'package:equatable/equatable.dart';
import 'business_type.dart';
import 'business_features.dart';
import 'business_terminology.dart';
import 'business_configuration.dart';

class Business extends Equatable {
  final String id;
  final String name;
  final BusinessType type;
  final String phone;
  final String email;
  final String address;
  final bool gstEnabled;
  final String gstin;
  final String currency;
  final String invoicePrefix;
  final int nextInvoiceNumber;
  final String? logoUrl;
  final BusinessFeatures features;
  final BusinessTerminology terminology;

  Business({
    required this.id,
    required this.name,
    required dynamic businessType,
    required this.phone,
    this.email = '',
    required this.address,
    required this.gstEnabled,
    required this.gstin,
    this.currency = '₹',
    required this.invoicePrefix,
    required this.nextInvoiceNumber,
    this.logoUrl,
    BusinessFeatures? features,
    BusinessTerminology? terminology,
  })  : type = businessType is BusinessType ? businessType : BusinessType.fromString(businessType.toString()),
        features = features ?? (businessType is BusinessType ? businessType.defaultFeatures : BusinessType.fromString(businessType.toString()).defaultFeatures),
        terminology = terminology ?? (businessType is BusinessType ? businessType.defaultTerminology : BusinessType.fromString(businessType.toString()).defaultTerminology);

  String get businessType => type.displayName;

  BusinessConfiguration get configuration => BusinessConfiguration(
        type: type,
        features: features,
        terminology: terminology,
      );

  Business copyWith({
    String? id,
    String? name,
    dynamic businessType,
    String? phone,
    String? email,
    String? address,
    bool? gstEnabled,
    String? gstin,
    String? currency,
    String? invoicePrefix,
    int? nextInvoiceNumber,
    String? logoUrl,
    BusinessFeatures? features,
    BusinessTerminology? terminology,
  }) {
    final newType = businessType != null
        ? (businessType is BusinessType ? businessType : BusinessType.fromString(businessType.toString()))
        : type;
    return Business(
      id: id ?? this.id,
      name: name ?? this.name,
      businessType: newType,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      gstEnabled: gstEnabled ?? this.gstEnabled,
      gstin: gstin ?? this.gstin,
      currency: currency ?? this.currency,
      invoicePrefix: invoicePrefix ?? this.invoicePrefix,
      nextInvoiceNumber: nextInvoiceNumber ?? this.nextInvoiceNumber,
      logoUrl: logoUrl ?? this.logoUrl,
      features: features ?? (businessType != null ? newType.defaultFeatures : this.features),
      terminology: terminology ?? (businessType != null ? newType.defaultTerminology : this.terminology),
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        phone,
        email,
        address,
        gstEnabled,
        gstin,
        currency,
        invoicePrefix,
        nextInvoiceNumber,
        logoUrl,
        features,
        terminology,
      ];
}
