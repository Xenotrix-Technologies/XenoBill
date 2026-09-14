import 'package:equatable/equatable.dart';
import 'business_type.dart';
import 'business_features.dart';
import 'business_terminology.dart';
import 'business_configuration.dart';

class Business extends Equatable {
  final String id;
  final String? accountId; // user_id in public.accounts
  final String name; // business_name
  final String? ownerName; // owner_name
  final BusinessType type; // business_type
  final String phone;
  final String? whatsappNumber; // whatsapp_number
  final String email;
  final String? addressLine1; // address_line_1
  final String? addressLine2; // address_line_2
  final bool gstEnabled; // is_gst_registered
  final String gstin; // gst_number
  final String status; // status ('active')
  final DateTime? createdAt;
  final DateTime? lastUsedAt;
  final DateTime? updatedAt;

  // Local Drift Storage Only
  final String? logoUrl;
  final DateTime? clientUpdatedAt;
  final String syncStatus;
  final DateTime? lastSyncedAt;
  final String? syncError;

  Business({
    required this.id,
    this.accountId,
    required this.name,
    this.ownerName,
    required dynamic businessType,
    required this.phone,
    this.whatsappNumber,
    this.email = '',
    String? addressLine1,
    this.addressLine2,
    String? address,
    required this.gstEnabled,
    required this.gstin,
    this.status = 'active',
    this.logoUrl,
    this.createdAt,
    this.lastUsedAt,
    this.updatedAt,
    this.clientUpdatedAt,
    this.syncStatus = 'synced',
    this.lastSyncedAt,
    this.syncError,
    dynamic features,
    dynamic terminology,
    String? currency,
    String? invoicePrefix,
    int? nextInvoiceNumber,
  })  : type = businessType is BusinessType
            ? businessType
            : BusinessType.fromString(businessType.toString()),
        addressLine1 = addressLine1 ?? (address != null && address.isNotEmpty ? address : null);

  String get businessType => type.displayName;
  String get address => [addressLine1, addressLine2].where((s) => s != null && s.trim().isNotEmpty).join(', ');
  String get currency => '₹';
  String get invoicePrefix => 'INV';
  int get nextInvoiceNumber => 1001;
  BusinessFeatures get features => type.defaultFeatures;
  BusinessTerminology get terminology => type.defaultTerminology;

  BusinessConfiguration get configuration => BusinessConfiguration(
        type: type,
        features: features,
        terminology: terminology,
      );

  Map<String, dynamic> toSupabaseJson() {
    return {
      'id': id,
      'user_id': accountId,
      'owner_name': ownerName ?? '',
      'email': email,
      'whatsapp_number': whatsappNumber ?? phone,
      'is_gst_registered': gstEnabled,
      'gst_number': gstin,
      'address_line_1': addressLine1 ?? '',
      'address_line_2': addressLine2 ?? '',
      'status': status,
      'created_at': createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'last_used_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
      'business_name': name,
      'business_type': type.displayName,
      'phone': phone,
    };
  }

  factory Business.fromSupabaseJson(Map<String, dynamic> json) {
    return Business(
      id: json['id']?.toString() ?? '',
      accountId: json['user_id']?.toString(),
      name: json['business_name']?.toString() ?? '',
      ownerName: json['owner_name']?.toString(),
      businessType: BusinessType.fromString(json['business_type']?.toString() ?? 'retail'),
      phone: json['phone']?.toString() ?? '',
      whatsappNumber: json['whatsapp_number']?.toString(),
      email: json['email']?.toString() ?? '',
      addressLine1: json['address_line_1']?.toString(),
      addressLine2: json['address_line_2']?.toString(),
      gstEnabled: json['is_gst_registered'] == true,
      gstin: json['gst_number']?.toString() ?? '',
      status: json['status']?.toString() ?? 'active',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
      lastUsedAt: DateTime.tryParse(json['last_used_at']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? ''),
    );
  }

  Business copyWith({
    String? id,
    String? accountId,
    String? name,
    String? ownerName,
    dynamic businessType,
    String? phone,
    String? whatsappNumber,
    String? email,
    String? addressLine1,
    String? addressLine2,
    String? address,
    bool? gstEnabled,
    String? gstin,
    String? status,
    String? logoUrl,
    DateTime? createdAt,
    DateTime? lastUsedAt,
    DateTime? updatedAt,
    DateTime? clientUpdatedAt,
    String? syncStatus,
    DateTime? lastSyncedAt,
    String? syncError,
    dynamic features,
    dynamic terminology,
    String? currency,
    String? invoicePrefix,
    int? nextInvoiceNumber,
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
      ownerName: ownerName ?? this.ownerName,
      businessType: newType,
      phone: phone ?? this.phone,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      email: email ?? this.email,
      addressLine1: addressLine1 ?? address ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      gstEnabled: gstEnabled ?? this.gstEnabled,
      gstin: gstin ?? this.gstin,
      status: status ?? this.status,
      logoUrl: logoUrl ?? this.logoUrl,
      createdAt: createdAt ?? this.createdAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
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
        ownerName,
        type,
        phone,
        whatsappNumber,
        email,
        addressLine1,
        addressLine2,
        gstEnabled,
        gstin,
        status,
        logoUrl,
        createdAt,
        lastUsedAt,
        updatedAt,
        clientUpdatedAt,
        syncStatus,
        lastSyncedAt,
        syncError,
      ];
}

