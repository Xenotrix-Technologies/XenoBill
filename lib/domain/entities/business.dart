import 'package:equatable/equatable.dart';
import 'business_type.dart';
import 'business_features.dart';
import 'business_terminology.dart';
import 'business_configuration.dart';

class Business extends Equatable {
  final String id;
  final String? accountId;
  final String name;
  final BusinessType type;
  final String phone;
  final String? alternatePhone;
  final String email;
  final String address;
  final String? city;
  final String? state;
  final String? country;
  final String? pinCode;
  final String? gstRegistrationType;
  final bool gstEnabled;
  final String gstin;
  final String? pan;
  final String currency;
  final String invoicePrefix;
  final int nextInvoiceNumber;
  final String? logoUrl;
  final BusinessFeatures features;
  final BusinessTerminology terminology;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? clientUpdatedAt;
  final String syncStatus; // 'synced', 'pending', 'failed'
  final DateTime? lastSyncedAt;
  final String? syncError;

  Business({
    required this.id,
    this.accountId,
    required this.name,
    required dynamic businessType,
    required this.phone,
    this.alternatePhone,
    this.email = '',
    required this.address,
    this.city,
    this.state,
    this.country,
    this.pinCode,
    this.gstRegistrationType,
    required this.gstEnabled,
    required this.gstin,
    this.pan,
    this.currency = '₹',
    required this.invoicePrefix,
    required this.nextInvoiceNumber,
    this.logoUrl,
    BusinessFeatures? features,
    BusinessTerminology? terminology,
    this.createdAt,
    this.updatedAt,
    this.clientUpdatedAt,
    this.syncStatus = 'synced',
    this.lastSyncedAt,
    this.syncError,
  })  : type = businessType is BusinessType
            ? businessType
            : BusinessType.fromString(businessType.toString()),
        features = features ??
            (businessType is BusinessType
                ? businessType.defaultFeatures
                : BusinessType.fromString(businessType.toString()).defaultFeatures),
        terminology = terminology ??
            (businessType is BusinessType
                ? businessType.defaultTerminology
                : BusinessType.fromString(businessType.toString()).defaultTerminology);

  String get businessType => type.displayName;

  BusinessConfiguration get configuration => BusinessConfiguration(
        type: type,
        features: features,
        terminology: terminology,
      );

  Business copyWith({
    String? id,
    String? accountId,
    String? name,
    dynamic businessType,
    String? phone,
    String? alternatePhone,
    String? email,
    String? address,
    String? city,
    String? state,
    String? country,
    String? pinCode,
    String? gstRegistrationType,
    bool? gstEnabled,
    String? gstin,
    String? pan,
    String? currency,
    String? invoicePrefix,
    int? nextInvoiceNumber,
    String? logoUrl,
    BusinessFeatures? features,
    BusinessTerminology? terminology,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? clientUpdatedAt,
    String? syncStatus,
    DateTime? lastSyncedAt,
    String? syncError,
  }) {
    final newType = businessType != null
        ? (businessType is BusinessType
            ? businessType
            : BusinessType.fromString(businessType.toString()))
        : type;
    return Business(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      name: name ?? this.name,
      businessType: newType,
      phone: phone ?? this.phone,
      alternatePhone: alternatePhone ?? this.alternatePhone,
      email: email ?? this.email,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      pinCode: pinCode ?? this.pinCode,
      gstRegistrationType: gstRegistrationType ?? this.gstRegistrationType,
      gstEnabled: gstEnabled ?? this.gstEnabled,
      gstin: gstin ?? this.gstin,
      pan: pan ?? this.pan,
      currency: currency ?? this.currency,
      invoicePrefix: invoicePrefix ?? this.invoicePrefix,
      nextInvoiceNumber: nextInvoiceNumber ?? this.nextInvoiceNumber,
      logoUrl: logoUrl ?? this.logoUrl,
      features: features ?? (businessType != null ? newType.defaultFeatures : this.features),
      terminology: terminology ?? (businessType != null ? newType.defaultTerminology : this.terminology),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      clientUpdatedAt: clientUpdatedAt ?? this.clientUpdatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      syncError: syncError ?? this.syncError,
    );
  }

  @override
  List<Object?> get props => [
        id,
        accountId,
        name,
        type,
        phone,
        alternatePhone,
        email,
        address,
        city,
        state,
        country,
        pinCode,
        gstRegistrationType,
        gstEnabled,
        gstin,
        pan,
        currency,
        invoicePrefix,
        nextInvoiceNumber,
        logoUrl,
        features,
        terminology,
        createdAt,
        updatedAt,
        clientUpdatedAt,
        syncStatus,
        lastSyncedAt,
        syncError,
      ];
}
