import 'package:drift/drift.dart';
import '../../domain/entities/business.dart';
import '../../domain/entities/business_type.dart';
import '../database/drift_database.dart';

/// Mapper utility converting between Domain [Business] and Drift Database objects.
class BusinessMapper {
  BusinessMapper._();

  /// Converts a Drift [BusinessTableData] row into a Domain [Business] entity.
  static Business fromDrift(BusinessTableData data) {
    final typeEnum = BusinessType.fromString(data.businessType ?? 'retail');

    return Business(
      id: data.id,
      accountId: data.accountId,
      name: data.businessName,
      ownerName: data.ownerName,
      businessType: typeEnum,
      phone: data.phone ?? '',
      whatsappNumber: data.whatsappNumber,
      email: data.email ?? '',
      addressLine1: data.addressLine1,
      addressLine2: data.addressLine2,
      gstEnabled: data.gstEnabled,
      gstin: data.gstin ?? '',
      status: data.status,
      logoUrl: data.logoUrl,
      createdAt: data.createdAt,
      lastUsedAt: data.lastUsedAt,
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
      ownerName: Value(entity.ownerName),
      businessType: Value(entity.type.name),
      phone: Value(entity.phone.isEmpty ? null : entity.phone),
      whatsappNumber: Value(entity.whatsappNumber),
      email: Value(entity.email.isEmpty ? null : entity.email),
      addressLine1: Value(entity.addressLine1),
      addressLine2: Value(entity.addressLine2),
      gstEnabled: Value(entity.gstEnabled),
      gstin: Value(entity.gstin.isEmpty ? null : entity.gstin),
      status: Value(entity.status),
      logoUrl: Value(entity.logoUrl),
      createdAt: Value(entity.createdAt ?? DateTime.now()),
      lastUsedAt: Value(entity.lastUsedAt ?? DateTime.now()),
      updatedAt: Value(entity.updatedAt ?? DateTime.now()),
      clientUpdatedAt: Value(entity.clientUpdatedAt ?? DateTime.now()),
      syncStatus: Value(syncStatus ?? entity.syncStatus),
      lastSyncedAt: Value(lastSyncedAt ?? entity.lastSyncedAt),
      syncError: Value(syncError ?? entity.syncError),
    );
  }
}

