import 'package:drift/drift.dart';
import '../../domain/entities/business.dart';
import '../../domain/entities/business_type.dart';
import '../database/drift_database.dart';

/// Mapper utility converting between Domain [Business], Supabase JSON Maps, and Drift Database objects.
class BusinessMapper {
  BusinessMapper._();

  /// Converts a Drift [BusinessTableData] row into a Domain [Business] entity.
  static Business fromDrift(BusinessTableData data) {
    final typeEnum = BusinessType.fromString(data.businessType ?? 'retail');

    return Business(
      id: data.id,
      accountId: data.accountId,
      name: data.businessName,
      businessType: typeEnum,
      phone: data.phone ?? '',
      alternatePhone: data.alternatePhone,
      email: data.email ?? '',
      address: data.address ?? '',
      city: data.city,
      state: data.state,
      country: data.country,
      pinCode: data.pinCode,
      gstRegistrationType: data.gstRegistrationType,
      gstEnabled: data.gstEnabled,
      gstin: data.gstin ?? '',
      pan: data.pan,
      currency: data.currency,
      invoicePrefix: data.invoicePrefix,
      nextInvoiceNumber: data.nextInvoiceNumber,
      logoUrl: data.logoUrl,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      clientUpdatedAt: data.clientUpdatedAt,
      syncStatus: data.syncStatus,
      lastSyncedAt: data.lastSyncedAt,
      syncError: data.syncError,
    );
  }

  /// Converts a Domain [Business] entity into a Drift [BusinessTableCompanion].
  static BusinessTableCompanion toDriftCompanion(
    Business entity, {
    String? syncStatus,
    DateTime? lastSyncedAt,
    String? syncError,
  }) {
    return BusinessTableCompanion(
      id: Value(entity.id),
      accountId: Value(entity.accountId),
      businessName: Value(entity.name),
      businessType: Value(entity.type.name),
      phone: Value(entity.phone.isEmpty ? null : entity.phone),
      alternatePhone: Value(entity.alternatePhone),
      email: Value(entity.email.isEmpty ? null : entity.email),
      address: Value(entity.address.isEmpty ? null : entity.address),
      city: Value(entity.city),
      state: Value(entity.state),
      country: Value(entity.country),
      pinCode: Value(entity.pinCode),
      gstRegistrationType: Value(entity.gstRegistrationType),
      gstEnabled: Value(entity.gstEnabled),
      gstin: Value(entity.gstin.isEmpty ? null : entity.gstin),
      pan: Value(entity.pan),
      currency: Value(entity.currency),
      invoicePrefix: Value(entity.invoicePrefix),
      nextInvoiceNumber: Value(entity.nextInvoiceNumber),
      logoUrl: Value(entity.logoUrl),
      createdAt: Value(entity.createdAt ?? DateTime.now()),
      updatedAt: Value(entity.updatedAt ?? DateTime.now()),
      clientUpdatedAt: Value(entity.clientUpdatedAt ?? DateTime.now()),
      syncStatus: Value(syncStatus ?? entity.syncStatus),
      lastSyncedAt: Value(lastSyncedAt ?? entity.lastSyncedAt),
      syncError: Value(syncError ?? entity.syncError),
    );
  }

  /// Converts a Supabase Database JSON map into a Domain [Business] entity.
  static Business fromSupabaseJson(Map<String, dynamic> json) {
    final typeEnum = BusinessType.fromString(json['business_type']?.toString() ?? 'retail');

    return Business(
      id: json['id'] as String,
      accountId: json['account_id'] as String?,
      name: json['business_name'] as String? ?? 'My Shop',
      businessType: typeEnum,
      phone: json['phone'] as String? ?? '',
      alternatePhone: json['alternate_phone'] as String?,
      email: json['email'] as String? ?? '',
      address: json['address'] as String? ?? '',
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      pinCode: json['pin_code'] as String?,
      gstRegistrationType: json['gst_registration_type'] as String?,
      gstEnabled: json['gstin'] != null && (json['gstin'] as String).isNotEmpty,
      gstin: json['gstin'] as String? ?? '',
      pan: json['pan'] as String?,
      currency: '₹',
      invoicePrefix: 'INV',
      nextInvoiceNumber: 1001,
      logoUrl: json['logo_url'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      clientUpdatedAt: json['client_updated_at'] != null
          ? DateTime.parse(json['client_updated_at'])
          : null,
      syncStatus: 'synced',
      lastSyncedAt: DateTime.now(),
    );
  }

  /// Converts a Domain [Business] entity into a Supabase Database JSON map.
  static Map<String, dynamic> toSupabaseJson(Business entity, String accountId) {
    return {
      'id': entity.id,
      'account_id': accountId,
      'business_name': entity.name,
      'business_type': entity.type.name,
      'phone': entity.phone.isEmpty ? null : entity.phone,
      'alternate_phone': entity.alternatePhone,
      'email': entity.email.isEmpty ? null : entity.email,
      'address': entity.address.isEmpty ? null : entity.address,
      'city': entity.city,
      'state': entity.state,
      'country': entity.country,
      'pin_code': entity.pinCode,
      'gst_registration_type': entity.gstRegistrationType,
      'gstin': entity.gstin.isEmpty ? null : entity.gstin,
      'pan': entity.pan,
      'logo_url': entity.logoUrl,
      'client_updated_at': (entity.clientUpdatedAt ?? DateTime.now()).toIso8601String(),
    };
  }
}
