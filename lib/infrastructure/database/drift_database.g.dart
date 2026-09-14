// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_database.dart';

// ignore_for_file: type=lint
mixin _$BusinessDaoMixin on DatabaseAccessor<AppDriftDatabase> {
  $BusinessTableTable get businessTable => attachedDatabase.businessTable;
  $AccountsTableTable get accountsTable => attachedDatabase.accountsTable;
  BusinessDaoManager get managers => BusinessDaoManager(this);
}

class BusinessDaoManager {
  final _$BusinessDaoMixin _db;
  BusinessDaoManager(this._db);
  $$BusinessTableTableTableManager get businessTable =>
      $$BusinessTableTableTableManager(_db.attachedDatabase, _db.businessTable);
  $$AccountsTableTableTableManager get accountsTable =>
      $$AccountsTableTableTableManager(_db.attachedDatabase, _db.accountsTable);
}

class $BusinessTableTable extends BusinessTable
    with TableInfo<$BusinessTableTable, BusinessTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BusinessTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
      'account_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _businessNameMeta =
      const VerificationMeta('businessName');
  @override
  late final GeneratedColumn<String> businessName = GeneratedColumn<String>(
      'business_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ownerNameMeta =
      const VerificationMeta('ownerName');
  @override
  late final GeneratedColumn<String> ownerName = GeneratedColumn<String>(
      'owner_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _businessTypeMeta =
      const VerificationMeta('businessType');
  @override
  late final GeneratedColumn<String> businessType = GeneratedColumn<String>(
      'business_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _whatsappNumberMeta =
      const VerificationMeta('whatsappNumber');
  @override
  late final GeneratedColumn<String> whatsappNumber = GeneratedColumn<String>(
      'whatsapp_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressLine1Meta =
      const VerificationMeta('addressLine1');
  @override
  late final GeneratedColumn<String> addressLine1 = GeneratedColumn<String>(
      'address_line1', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressLine2Meta =
      const VerificationMeta('addressLine2');
  @override
  late final GeneratedColumn<String> addressLine2 = GeneratedColumn<String>(
      'address_line2', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _gstEnabledMeta =
      const VerificationMeta('gstEnabled');
  @override
  late final GeneratedColumn<bool> gstEnabled = GeneratedColumn<bool>(
      'gst_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("gst_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _gstinMeta = const VerificationMeta('gstin');
  @override
  late final GeneratedColumn<String> gstin = GeneratedColumn<String>(
      'gstin', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('active'));
  static const VerificationMeta _logoUrlMeta =
      const VerificationMeta('logoUrl');
  @override
  late final GeneratedColumn<String> logoUrl = GeneratedColumn<String>(
      'logo_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastUsedAtMeta =
      const VerificationMeta('lastUsedAt');
  @override
  late final GeneratedColumn<DateTime> lastUsedAt = GeneratedColumn<DateTime>(
      'last_used_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _clientUpdatedAtMeta =
      const VerificationMeta('clientUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> clientUpdatedAt =
      GeneratedColumn<DateTime>('client_updated_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('synced'));
  static const VerificationMeta _lastSyncedAtMeta =
      const VerificationMeta('lastSyncedAt');
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
      'last_synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _syncErrorMeta =
      const VerificationMeta('syncError');
  @override
  late final GeneratedColumn<String> syncError = GeneratedColumn<String>(
      'sync_error', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        accountId,
        businessName,
        ownerName,
        businessType,
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
        syncError
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'business_table';
  @override
  VerificationContext validateIntegrity(Insertable<BusinessTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    }
    if (data.containsKey('business_name')) {
      context.handle(
          _businessNameMeta,
          businessName.isAcceptableOrUnknown(
              data['business_name']!, _businessNameMeta));
    } else if (isInserting) {
      context.missing(_businessNameMeta);
    }
    if (data.containsKey('owner_name')) {
      context.handle(_ownerNameMeta,
          ownerName.isAcceptableOrUnknown(data['owner_name']!, _ownerNameMeta));
    }
    if (data.containsKey('business_type')) {
      context.handle(
          _businessTypeMeta,
          businessType.isAcceptableOrUnknown(
              data['business_type']!, _businessTypeMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('whatsapp_number')) {
      context.handle(
          _whatsappNumberMeta,
          whatsappNumber.isAcceptableOrUnknown(
              data['whatsapp_number']!, _whatsappNumberMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('address_line1')) {
      context.handle(
          _addressLine1Meta,
          addressLine1.isAcceptableOrUnknown(
              data['address_line1']!, _addressLine1Meta));
    }
    if (data.containsKey('address_line2')) {
      context.handle(
          _addressLine2Meta,
          addressLine2.isAcceptableOrUnknown(
              data['address_line2']!, _addressLine2Meta));
    }
    if (data.containsKey('gst_enabled')) {
      context.handle(
          _gstEnabledMeta,
          gstEnabled.isAcceptableOrUnknown(
              data['gst_enabled']!, _gstEnabledMeta));
    }
    if (data.containsKey('gstin')) {
      context.handle(
          _gstinMeta, gstin.isAcceptableOrUnknown(data['gstin']!, _gstinMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('logo_url')) {
      context.handle(_logoUrlMeta,
          logoUrl.isAcceptableOrUnknown(data['logo_url']!, _logoUrlMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('last_used_at')) {
      context.handle(
          _lastUsedAtMeta,
          lastUsedAt.isAcceptableOrUnknown(
              data['last_used_at']!, _lastUsedAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('client_updated_at')) {
      context.handle(
          _clientUpdatedAtMeta,
          clientUpdatedAt.isAcceptableOrUnknown(
              data['client_updated_at']!, _clientUpdatedAtMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
          _lastSyncedAtMeta,
          lastSyncedAt.isAcceptableOrUnknown(
              data['last_synced_at']!, _lastSyncedAtMeta));
    }
    if (data.containsKey('sync_error')) {
      context.handle(_syncErrorMeta,
          syncError.isAcceptableOrUnknown(data['sync_error']!, _syncErrorMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BusinessTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BusinessTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_id']),
      businessName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}business_name'])!,
      ownerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}owner_name']),
      businessType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}business_type']),
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      whatsappNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}whatsapp_number']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      addressLine1: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address_line1']),
      addressLine2: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address_line2']),
      gstEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}gst_enabled'])!,
      gstin: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gstin']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      logoUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}logo_url']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      lastUsedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_used_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      clientUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}client_updated_at']),
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_synced_at']),
      syncError: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_error']),
    );
  }

  @override
  $BusinessTableTable createAlias(String alias) {
    return $BusinessTableTable(attachedDatabase, alias);
  }
}

class BusinessTableData extends DataClass
    implements Insertable<BusinessTableData> {
  final String id;
  final String? accountId;
  final String businessName;
  final String? ownerName;
  final String? businessType;
  final String? phone;
  final String? whatsappNumber;
  final String? email;
  final String? addressLine1;
  final String? addressLine2;
  final bool gstEnabled;
  final String? gstin;
  final String status;
  final String? logoUrl;
  final DateTime? createdAt;
  final DateTime? lastUsedAt;
  final DateTime? updatedAt;
  final DateTime? clientUpdatedAt;
  final String syncStatus;
  final DateTime? lastSyncedAt;
  final String? syncError;
  const BusinessTableData(
      {required this.id,
      this.accountId,
      required this.businessName,
      this.ownerName,
      this.businessType,
      this.phone,
      this.whatsappNumber,
      this.email,
      this.addressLine1,
      this.addressLine2,
      required this.gstEnabled,
      this.gstin,
      required this.status,
      this.logoUrl,
      this.createdAt,
      this.lastUsedAt,
      this.updatedAt,
      this.clientUpdatedAt,
      required this.syncStatus,
      this.lastSyncedAt,
      this.syncError});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<String>(accountId);
    }
    map['business_name'] = Variable<String>(businessName);
    if (!nullToAbsent || ownerName != null) {
      map['owner_name'] = Variable<String>(ownerName);
    }
    if (!nullToAbsent || businessType != null) {
      map['business_type'] = Variable<String>(businessType);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || whatsappNumber != null) {
      map['whatsapp_number'] = Variable<String>(whatsappNumber);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || addressLine1 != null) {
      map['address_line1'] = Variable<String>(addressLine1);
    }
    if (!nullToAbsent || addressLine2 != null) {
      map['address_line2'] = Variable<String>(addressLine2);
    }
    map['gst_enabled'] = Variable<bool>(gstEnabled);
    if (!nullToAbsent || gstin != null) {
      map['gstin'] = Variable<String>(gstin);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || logoUrl != null) {
      map['logo_url'] = Variable<String>(logoUrl);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || lastUsedAt != null) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || clientUpdatedAt != null) {
      map['client_updated_at'] = Variable<DateTime>(clientUpdatedAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    if (!nullToAbsent || syncError != null) {
      map['sync_error'] = Variable<String>(syncError);
    }
    return map;
  }

  BusinessTableCompanion toCompanion(bool nullToAbsent) {
    return BusinessTableCompanion(
      id: Value(id),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      businessName: Value(businessName),
      ownerName: ownerName == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerName),
      businessType: businessType == null && nullToAbsent
          ? const Value.absent()
          : Value(businessType),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      whatsappNumber: whatsappNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(whatsappNumber),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      addressLine1: addressLine1 == null && nullToAbsent
          ? const Value.absent()
          : Value(addressLine1),
      addressLine2: addressLine2 == null && nullToAbsent
          ? const Value.absent()
          : Value(addressLine2),
      gstEnabled: Value(gstEnabled),
      gstin:
          gstin == null && nullToAbsent ? const Value.absent() : Value(gstin),
      status: Value(status),
      logoUrl: logoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(logoUrl),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      lastUsedAt: lastUsedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUsedAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      clientUpdatedAt: clientUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(clientUpdatedAt),
      syncStatus: Value(syncStatus),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      syncError: syncError == null && nullToAbsent
          ? const Value.absent()
          : Value(syncError),
    );
  }

  factory BusinessTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BusinessTableData(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String?>(json['accountId']),
      businessName: serializer.fromJson<String>(json['businessName']),
      ownerName: serializer.fromJson<String?>(json['ownerName']),
      businessType: serializer.fromJson<String?>(json['businessType']),
      phone: serializer.fromJson<String?>(json['phone']),
      whatsappNumber: serializer.fromJson<String?>(json['whatsappNumber']),
      email: serializer.fromJson<String?>(json['email']),
      addressLine1: serializer.fromJson<String?>(json['addressLine1']),
      addressLine2: serializer.fromJson<String?>(json['addressLine2']),
      gstEnabled: serializer.fromJson<bool>(json['gstEnabled']),
      gstin: serializer.fromJson<String?>(json['gstin']),
      status: serializer.fromJson<String>(json['status']),
      logoUrl: serializer.fromJson<String?>(json['logoUrl']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      lastUsedAt: serializer.fromJson<DateTime?>(json['lastUsedAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      clientUpdatedAt: serializer.fromJson<DateTime?>(json['clientUpdatedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      syncError: serializer.fromJson<String?>(json['syncError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String?>(accountId),
      'businessName': serializer.toJson<String>(businessName),
      'ownerName': serializer.toJson<String?>(ownerName),
      'businessType': serializer.toJson<String?>(businessType),
      'phone': serializer.toJson<String?>(phone),
      'whatsappNumber': serializer.toJson<String?>(whatsappNumber),
      'email': serializer.toJson<String?>(email),
      'addressLine1': serializer.toJson<String?>(addressLine1),
      'addressLine2': serializer.toJson<String?>(addressLine2),
      'gstEnabled': serializer.toJson<bool>(gstEnabled),
      'gstin': serializer.toJson<String?>(gstin),
      'status': serializer.toJson<String>(status),
      'logoUrl': serializer.toJson<String?>(logoUrl),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'lastUsedAt': serializer.toJson<DateTime?>(lastUsedAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'clientUpdatedAt': serializer.toJson<DateTime?>(clientUpdatedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'syncError': serializer.toJson<String?>(syncError),
    };
  }

  BusinessTableData copyWith(
          {String? id,
          Value<String?> accountId = const Value.absent(),
          String? businessName,
          Value<String?> ownerName = const Value.absent(),
          Value<String?> businessType = const Value.absent(),
          Value<String?> phone = const Value.absent(),
          Value<String?> whatsappNumber = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> addressLine1 = const Value.absent(),
          Value<String?> addressLine2 = const Value.absent(),
          bool? gstEnabled,
          Value<String?> gstin = const Value.absent(),
          String? status,
          Value<String?> logoUrl = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> lastUsedAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent(),
          Value<DateTime?> clientUpdatedAt = const Value.absent(),
          String? syncStatus,
          Value<DateTime?> lastSyncedAt = const Value.absent(),
          Value<String?> syncError = const Value.absent()}) =>
      BusinessTableData(
        id: id ?? this.id,
        accountId: accountId.present ? accountId.value : this.accountId,
        businessName: businessName ?? this.businessName,
        ownerName: ownerName.present ? ownerName.value : this.ownerName,
        businessType:
            businessType.present ? businessType.value : this.businessType,
        phone: phone.present ? phone.value : this.phone,
        whatsappNumber:
            whatsappNumber.present ? whatsappNumber.value : this.whatsappNumber,
        email: email.present ? email.value : this.email,
        addressLine1:
            addressLine1.present ? addressLine1.value : this.addressLine1,
        addressLine2:
            addressLine2.present ? addressLine2.value : this.addressLine2,
        gstEnabled: gstEnabled ?? this.gstEnabled,
        gstin: gstin.present ? gstin.value : this.gstin,
        status: status ?? this.status,
        logoUrl: logoUrl.present ? logoUrl.value : this.logoUrl,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        lastUsedAt: lastUsedAt.present ? lastUsedAt.value : this.lastUsedAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        clientUpdatedAt: clientUpdatedAt.present
            ? clientUpdatedAt.value
            : this.clientUpdatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        lastSyncedAt:
            lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
        syncError: syncError.present ? syncError.value : this.syncError,
      );
  BusinessTableData copyWithCompanion(BusinessTableCompanion data) {
    return BusinessTableData(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      businessName: data.businessName.present
          ? data.businessName.value
          : this.businessName,
      ownerName: data.ownerName.present ? data.ownerName.value : this.ownerName,
      businessType: data.businessType.present
          ? data.businessType.value
          : this.businessType,
      phone: data.phone.present ? data.phone.value : this.phone,
      whatsappNumber: data.whatsappNumber.present
          ? data.whatsappNumber.value
          : this.whatsappNumber,
      email: data.email.present ? data.email.value : this.email,
      addressLine1: data.addressLine1.present
          ? data.addressLine1.value
          : this.addressLine1,
      addressLine2: data.addressLine2.present
          ? data.addressLine2.value
          : this.addressLine2,
      gstEnabled:
          data.gstEnabled.present ? data.gstEnabled.value : this.gstEnabled,
      gstin: data.gstin.present ? data.gstin.value : this.gstin,
      status: data.status.present ? data.status.value : this.status,
      logoUrl: data.logoUrl.present ? data.logoUrl.value : this.logoUrl,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastUsedAt:
          data.lastUsedAt.present ? data.lastUsedAt.value : this.lastUsedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      clientUpdatedAt: data.clientUpdatedAt.present
          ? data.clientUpdatedAt.value
          : this.clientUpdatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      syncError: data.syncError.present ? data.syncError.value : this.syncError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BusinessTableData(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('businessName: $businessName, ')
          ..write('ownerName: $ownerName, ')
          ..write('businessType: $businessType, ')
          ..write('phone: $phone, ')
          ..write('whatsappNumber: $whatsappNumber, ')
          ..write('email: $email, ')
          ..write('addressLine1: $addressLine1, ')
          ..write('addressLine2: $addressLine2, ')
          ..write('gstEnabled: $gstEnabled, ')
          ..write('gstin: $gstin, ')
          ..write('status: $status, ')
          ..write('logoUrl: $logoUrl, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('clientUpdatedAt: $clientUpdatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('syncError: $syncError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        accountId,
        businessName,
        ownerName,
        businessType,
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
        syncError
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BusinessTableData &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.businessName == this.businessName &&
          other.ownerName == this.ownerName &&
          other.businessType == this.businessType &&
          other.phone == this.phone &&
          other.whatsappNumber == this.whatsappNumber &&
          other.email == this.email &&
          other.addressLine1 == this.addressLine1 &&
          other.addressLine2 == this.addressLine2 &&
          other.gstEnabled == this.gstEnabled &&
          other.gstin == this.gstin &&
          other.status == this.status &&
          other.logoUrl == this.logoUrl &&
          other.createdAt == this.createdAt &&
          other.lastUsedAt == this.lastUsedAt &&
          other.updatedAt == this.updatedAt &&
          other.clientUpdatedAt == this.clientUpdatedAt &&
          other.syncStatus == this.syncStatus &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.syncError == this.syncError);
}

class BusinessTableCompanion extends UpdateCompanion<BusinessTableData> {
  final Value<String> id;
  final Value<String?> accountId;
  final Value<String> businessName;
  final Value<String?> ownerName;
  final Value<String?> businessType;
  final Value<String?> phone;
  final Value<String?> whatsappNumber;
  final Value<String?> email;
  final Value<String?> addressLine1;
  final Value<String?> addressLine2;
  final Value<bool> gstEnabled;
  final Value<String?> gstin;
  final Value<String> status;
  final Value<String?> logoUrl;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> lastUsedAt;
  final Value<DateTime?> updatedAt;
  final Value<DateTime?> clientUpdatedAt;
  final Value<String> syncStatus;
  final Value<DateTime?> lastSyncedAt;
  final Value<String?> syncError;
  final Value<int> rowid;
  const BusinessTableCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.businessName = const Value.absent(),
    this.ownerName = const Value.absent(),
    this.businessType = const Value.absent(),
    this.phone = const Value.absent(),
    this.whatsappNumber = const Value.absent(),
    this.email = const Value.absent(),
    this.addressLine1 = const Value.absent(),
    this.addressLine2 = const Value.absent(),
    this.gstEnabled = const Value.absent(),
    this.gstin = const Value.absent(),
    this.status = const Value.absent(),
    this.logoUrl = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.clientUpdatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.syncError = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BusinessTableCompanion.insert({
    required String id,
    this.accountId = const Value.absent(),
    required String businessName,
    this.ownerName = const Value.absent(),
    this.businessType = const Value.absent(),
    this.phone = const Value.absent(),
    this.whatsappNumber = const Value.absent(),
    this.email = const Value.absent(),
    this.addressLine1 = const Value.absent(),
    this.addressLine2 = const Value.absent(),
    this.gstEnabled = const Value.absent(),
    this.gstin = const Value.absent(),
    this.status = const Value.absent(),
    this.logoUrl = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.clientUpdatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.syncError = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        businessName = Value(businessName);
  static Insertable<BusinessTableData> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<String>? businessName,
    Expression<String>? ownerName,
    Expression<String>? businessType,
    Expression<String>? phone,
    Expression<String>? whatsappNumber,
    Expression<String>? email,
    Expression<String>? addressLine1,
    Expression<String>? addressLine2,
    Expression<bool>? gstEnabled,
    Expression<String>? gstin,
    Expression<String>? status,
    Expression<String>? logoUrl,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastUsedAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? clientUpdatedAt,
    Expression<String>? syncStatus,
    Expression<DateTime>? lastSyncedAt,
    Expression<String>? syncError,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (businessName != null) 'business_name': businessName,
      if (ownerName != null) 'owner_name': ownerName,
      if (businessType != null) 'business_type': businessType,
      if (phone != null) 'phone': phone,
      if (whatsappNumber != null) 'whatsapp_number': whatsappNumber,
      if (email != null) 'email': email,
      if (addressLine1 != null) 'address_line1': addressLine1,
      if (addressLine2 != null) 'address_line2': addressLine2,
      if (gstEnabled != null) 'gst_enabled': gstEnabled,
      if (gstin != null) 'gstin': gstin,
      if (status != null) 'status': status,
      if (logoUrl != null) 'logo_url': logoUrl,
      if (createdAt != null) 'created_at': createdAt,
      if (lastUsedAt != null) 'last_used_at': lastUsedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (clientUpdatedAt != null) 'client_updated_at': clientUpdatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (syncError != null) 'sync_error': syncError,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BusinessTableCompanion copyWith(
      {Value<String>? id,
      Value<String?>? accountId,
      Value<String>? businessName,
      Value<String?>? ownerName,
      Value<String?>? businessType,
      Value<String?>? phone,
      Value<String?>? whatsappNumber,
      Value<String?>? email,
      Value<String?>? addressLine1,
      Value<String?>? addressLine2,
      Value<bool>? gstEnabled,
      Value<String?>? gstin,
      Value<String>? status,
      Value<String?>? logoUrl,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? lastUsedAt,
      Value<DateTime?>? updatedAt,
      Value<DateTime?>? clientUpdatedAt,
      Value<String>? syncStatus,
      Value<DateTime?>? lastSyncedAt,
      Value<String?>? syncError,
      Value<int>? rowid}) {
    return BusinessTableCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      businessName: businessName ?? this.businessName,
      ownerName: ownerName ?? this.ownerName,
      businessType: businessType ?? this.businessType,
      phone: phone ?? this.phone,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      email: email ?? this.email,
      addressLine1: addressLine1 ?? this.addressLine1,
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
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (businessName.present) {
      map['business_name'] = Variable<String>(businessName.value);
    }
    if (ownerName.present) {
      map['owner_name'] = Variable<String>(ownerName.value);
    }
    if (businessType.present) {
      map['business_type'] = Variable<String>(businessType.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (whatsappNumber.present) {
      map['whatsapp_number'] = Variable<String>(whatsappNumber.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (addressLine1.present) {
      map['address_line1'] = Variable<String>(addressLine1.value);
    }
    if (addressLine2.present) {
      map['address_line2'] = Variable<String>(addressLine2.value);
    }
    if (gstEnabled.present) {
      map['gst_enabled'] = Variable<bool>(gstEnabled.value);
    }
    if (gstin.present) {
      map['gstin'] = Variable<String>(gstin.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (logoUrl.present) {
      map['logo_url'] = Variable<String>(logoUrl.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastUsedAt.present) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (clientUpdatedAt.present) {
      map['client_updated_at'] = Variable<DateTime>(clientUpdatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (syncError.present) {
      map['sync_error'] = Variable<String>(syncError.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BusinessTableCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('businessName: $businessName, ')
          ..write('ownerName: $ownerName, ')
          ..write('businessType: $businessType, ')
          ..write('phone: $phone, ')
          ..write('whatsappNumber: $whatsappNumber, ')
          ..write('email: $email, ')
          ..write('addressLine1: $addressLine1, ')
          ..write('addressLine2: $addressLine2, ')
          ..write('gstEnabled: $gstEnabled, ')
          ..write('gstin: $gstin, ')
          ..write('status: $status, ')
          ..write('logoUrl: $logoUrl, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('clientUpdatedAt: $clientUpdatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('syncError: $syncError, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AccountsTableTable extends AccountsTable
    with TableInfo<$AccountsTableTable, AccountsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _primaryBusinessIdMeta =
      const VerificationMeta('primaryBusinessId');
  @override
  late final GeneratedColumn<String> primaryBusinessId =
      GeneratedColumn<String>('primary_business_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, userId, primaryBusinessId, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts_table';
  @override
  VerificationContext validateIntegrity(Insertable<AccountsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('primary_business_id')) {
      context.handle(
          _primaryBusinessIdMeta,
          primaryBusinessId.isAcceptableOrUnknown(
              data['primary_business_id']!, _primaryBusinessIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      primaryBusinessId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}primary_business_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $AccountsTableTable createAlias(String alias) {
    return $AccountsTableTable(attachedDatabase, alias);
  }
}

class AccountsTableData extends DataClass
    implements Insertable<AccountsTableData> {
  final String id;
  final String userId;
  final String? primaryBusinessId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const AccountsTableData(
      {required this.id,
      required this.userId,
      this.primaryBusinessId,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || primaryBusinessId != null) {
      map['primary_business_id'] = Variable<String>(primaryBusinessId);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  AccountsTableCompanion toCompanion(bool nullToAbsent) {
    return AccountsTableCompanion(
      id: Value(id),
      userId: Value(userId),
      primaryBusinessId: primaryBusinessId == null && nullToAbsent
          ? const Value.absent()
          : Value(primaryBusinessId),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory AccountsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountsTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      primaryBusinessId:
          serializer.fromJson<String?>(json['primaryBusinessId']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'primaryBusinessId': serializer.toJson<String?>(primaryBusinessId),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  AccountsTableData copyWith(
          {String? id,
          String? userId,
          Value<String?> primaryBusinessId = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      AccountsTableData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        primaryBusinessId: primaryBusinessId.present
            ? primaryBusinessId.value
            : this.primaryBusinessId,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  AccountsTableData copyWithCompanion(AccountsTableCompanion data) {
    return AccountsTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      primaryBusinessId: data.primaryBusinessId.present
          ? data.primaryBusinessId.value
          : this.primaryBusinessId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountsTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('primaryBusinessId: $primaryBusinessId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, primaryBusinessId, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountsTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.primaryBusinessId == this.primaryBusinessId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AccountsTableCompanion extends UpdateCompanion<AccountsTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String?> primaryBusinessId;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const AccountsTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.primaryBusinessId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountsTableCompanion.insert({
    required String id,
    required String userId,
    this.primaryBusinessId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId);
  static Insertable<AccountsTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? primaryBusinessId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (primaryBusinessId != null) 'primary_business_id': primaryBusinessId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String?>? primaryBusinessId,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return AccountsTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      primaryBusinessId: primaryBusinessId ?? this.primaryBusinessId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (primaryBusinessId.present) {
      map['primary_business_id'] = Variable<String>(primaryBusinessId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('primaryBusinessId: $primaryBusinessId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDriftDatabase extends GeneratedDatabase {
  _$AppDriftDatabase(QueryExecutor e) : super(e);
  $AppDriftDatabaseManager get managers => $AppDriftDatabaseManager(this);
  late final $BusinessTableTable businessTable = $BusinessTableTable(this);
  late final $AccountsTableTable accountsTable = $AccountsTableTable(this);
  late final BusinessDao businessDao = BusinessDao(this as AppDriftDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [businessTable, accountsTable];
}

typedef $$BusinessTableTableCreateCompanionBuilder = BusinessTableCompanion
    Function({
  required String id,
  Value<String?> accountId,
  required String businessName,
  Value<String?> ownerName,
  Value<String?> businessType,
  Value<String?> phone,
  Value<String?> whatsappNumber,
  Value<String?> email,
  Value<String?> addressLine1,
  Value<String?> addressLine2,
  Value<bool> gstEnabled,
  Value<String?> gstin,
  Value<String> status,
  Value<String?> logoUrl,
  Value<DateTime?> createdAt,
  Value<DateTime?> lastUsedAt,
  Value<DateTime?> updatedAt,
  Value<DateTime?> clientUpdatedAt,
  Value<String> syncStatus,
  Value<DateTime?> lastSyncedAt,
  Value<String?> syncError,
  Value<int> rowid,
});
typedef $$BusinessTableTableUpdateCompanionBuilder = BusinessTableCompanion
    Function({
  Value<String> id,
  Value<String?> accountId,
  Value<String> businessName,
  Value<String?> ownerName,
  Value<String?> businessType,
  Value<String?> phone,
  Value<String?> whatsappNumber,
  Value<String?> email,
  Value<String?> addressLine1,
  Value<String?> addressLine2,
  Value<bool> gstEnabled,
  Value<String?> gstin,
  Value<String> status,
  Value<String?> logoUrl,
  Value<DateTime?> createdAt,
  Value<DateTime?> lastUsedAt,
  Value<DateTime?> updatedAt,
  Value<DateTime?> clientUpdatedAt,
  Value<String> syncStatus,
  Value<DateTime?> lastSyncedAt,
  Value<String?> syncError,
  Value<int> rowid,
});

class $$BusinessTableTableFilterComposer
    extends Composer<_$AppDriftDatabase, $BusinessTableTable> {
  $$BusinessTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get businessName => $composableBuilder(
      column: $table.businessName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ownerName => $composableBuilder(
      column: $table.ownerName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get businessType => $composableBuilder(
      column: $table.businessType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get whatsappNumber => $composableBuilder(
      column: $table.whatsappNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get addressLine1 => $composableBuilder(
      column: $table.addressLine1, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get addressLine2 => $composableBuilder(
      column: $table.addressLine2, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get gstEnabled => $composableBuilder(
      column: $table.gstEnabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gstin => $composableBuilder(
      column: $table.gstin, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get logoUrl => $composableBuilder(
      column: $table.logoUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastUsedAt => $composableBuilder(
      column: $table.lastUsedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get clientUpdatedAt => $composableBuilder(
      column: $table.clientUpdatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncError => $composableBuilder(
      column: $table.syncError, builder: (column) => ColumnFilters(column));
}

class $$BusinessTableTableOrderingComposer
    extends Composer<_$AppDriftDatabase, $BusinessTableTable> {
  $$BusinessTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get businessName => $composableBuilder(
      column: $table.businessName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ownerName => $composableBuilder(
      column: $table.ownerName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get businessType => $composableBuilder(
      column: $table.businessType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get whatsappNumber => $composableBuilder(
      column: $table.whatsappNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get addressLine1 => $composableBuilder(
      column: $table.addressLine1,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get addressLine2 => $composableBuilder(
      column: $table.addressLine2,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get gstEnabled => $composableBuilder(
      column: $table.gstEnabled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gstin => $composableBuilder(
      column: $table.gstin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get logoUrl => $composableBuilder(
      column: $table.logoUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastUsedAt => $composableBuilder(
      column: $table.lastUsedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get clientUpdatedAt => $composableBuilder(
      column: $table.clientUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncError => $composableBuilder(
      column: $table.syncError, builder: (column) => ColumnOrderings(column));
}

class $$BusinessTableTableAnnotationComposer
    extends Composer<_$AppDriftDatabase, $BusinessTableTable> {
  $$BusinessTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get businessName => $composableBuilder(
      column: $table.businessName, builder: (column) => column);

  GeneratedColumn<String> get ownerName =>
      $composableBuilder(column: $table.ownerName, builder: (column) => column);

  GeneratedColumn<String> get businessType => $composableBuilder(
      column: $table.businessType, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get whatsappNumber => $composableBuilder(
      column: $table.whatsappNumber, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get addressLine1 => $composableBuilder(
      column: $table.addressLine1, builder: (column) => column);

  GeneratedColumn<String> get addressLine2 => $composableBuilder(
      column: $table.addressLine2, builder: (column) => column);

  GeneratedColumn<bool> get gstEnabled => $composableBuilder(
      column: $table.gstEnabled, builder: (column) => column);

  GeneratedColumn<String> get gstin =>
      $composableBuilder(column: $table.gstin, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get logoUrl =>
      $composableBuilder(column: $table.logoUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUsedAt => $composableBuilder(
      column: $table.lastUsedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get clientUpdatedAt => $composableBuilder(
      column: $table.clientUpdatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => column);

  GeneratedColumn<String> get syncError =>
      $composableBuilder(column: $table.syncError, builder: (column) => column);
}

class $$BusinessTableTableTableManager extends RootTableManager<
    _$AppDriftDatabase,
    $BusinessTableTable,
    BusinessTableData,
    $$BusinessTableTableFilterComposer,
    $$BusinessTableTableOrderingComposer,
    $$BusinessTableTableAnnotationComposer,
    $$BusinessTableTableCreateCompanionBuilder,
    $$BusinessTableTableUpdateCompanionBuilder,
    (
      BusinessTableData,
      BaseReferences<_$AppDriftDatabase, $BusinessTableTable, BusinessTableData>
    ),
    BusinessTableData,
    PrefetchHooks Function()> {
  $$BusinessTableTableTableManager(
      _$AppDriftDatabase db, $BusinessTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BusinessTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BusinessTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BusinessTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> accountId = const Value.absent(),
            Value<String> businessName = const Value.absent(),
            Value<String?> ownerName = const Value.absent(),
            Value<String?> businessType = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> whatsappNumber = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> addressLine1 = const Value.absent(),
            Value<String?> addressLine2 = const Value.absent(),
            Value<bool> gstEnabled = const Value.absent(),
            Value<String?> gstin = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> logoUrl = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> lastUsedAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<DateTime?> clientUpdatedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<String?> syncError = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BusinessTableCompanion(
            id: id,
            accountId: accountId,
            businessName: businessName,
            ownerName: ownerName,
            businessType: businessType,
            phone: phone,
            whatsappNumber: whatsappNumber,
            email: email,
            addressLine1: addressLine1,
            addressLine2: addressLine2,
            gstEnabled: gstEnabled,
            gstin: gstin,
            status: status,
            logoUrl: logoUrl,
            createdAt: createdAt,
            lastUsedAt: lastUsedAt,
            updatedAt: updatedAt,
            clientUpdatedAt: clientUpdatedAt,
            syncStatus: syncStatus,
            lastSyncedAt: lastSyncedAt,
            syncError: syncError,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> accountId = const Value.absent(),
            required String businessName,
            Value<String?> ownerName = const Value.absent(),
            Value<String?> businessType = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> whatsappNumber = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> addressLine1 = const Value.absent(),
            Value<String?> addressLine2 = const Value.absent(),
            Value<bool> gstEnabled = const Value.absent(),
            Value<String?> gstin = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> logoUrl = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> lastUsedAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<DateTime?> clientUpdatedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<String?> syncError = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BusinessTableCompanion.insert(
            id: id,
            accountId: accountId,
            businessName: businessName,
            ownerName: ownerName,
            businessType: businessType,
            phone: phone,
            whatsappNumber: whatsappNumber,
            email: email,
            addressLine1: addressLine1,
            addressLine2: addressLine2,
            gstEnabled: gstEnabled,
            gstin: gstin,
            status: status,
            logoUrl: logoUrl,
            createdAt: createdAt,
            lastUsedAt: lastUsedAt,
            updatedAt: updatedAt,
            clientUpdatedAt: clientUpdatedAt,
            syncStatus: syncStatus,
            lastSyncedAt: lastSyncedAt,
            syncError: syncError,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$BusinessTableTable, BusinessTableData>(table),
                    BaseReferences<_$AppDriftDatabase, $BusinessTableTable,
                        BusinessTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BusinessTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDriftDatabase,
    $BusinessTableTable,
    BusinessTableData,
    $$BusinessTableTableFilterComposer,
    $$BusinessTableTableOrderingComposer,
    $$BusinessTableTableAnnotationComposer,
    $$BusinessTableTableCreateCompanionBuilder,
    $$BusinessTableTableUpdateCompanionBuilder,
    (
      BusinessTableData,
      BaseReferences<_$AppDriftDatabase, $BusinessTableTable, BusinessTableData>
    ),
    BusinessTableData,
    PrefetchHooks Function()>;
typedef $$AccountsTableTableCreateCompanionBuilder = AccountsTableCompanion
    Function({
  required String id,
  required String userId,
  Value<String?> primaryBusinessId,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$AccountsTableTableUpdateCompanionBuilder = AccountsTableCompanion
    Function({
  Value<String> id,
  Value<String> userId,
  Value<String?> primaryBusinessId,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

class $$AccountsTableTableFilterComposer
    extends Composer<_$AppDriftDatabase, $AccountsTableTable> {
  $$AccountsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get primaryBusinessId => $composableBuilder(
      column: $table.primaryBusinessId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$AccountsTableTableOrderingComposer
    extends Composer<_$AppDriftDatabase, $AccountsTableTable> {
  $$AccountsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get primaryBusinessId => $composableBuilder(
      column: $table.primaryBusinessId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$AccountsTableTableAnnotationComposer
    extends Composer<_$AppDriftDatabase, $AccountsTableTable> {
  $$AccountsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get primaryBusinessId => $composableBuilder(
      column: $table.primaryBusinessId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AccountsTableTableTableManager extends RootTableManager<
    _$AppDriftDatabase,
    $AccountsTableTable,
    AccountsTableData,
    $$AccountsTableTableFilterComposer,
    $$AccountsTableTableOrderingComposer,
    $$AccountsTableTableAnnotationComposer,
    $$AccountsTableTableCreateCompanionBuilder,
    $$AccountsTableTableUpdateCompanionBuilder,
    (
      AccountsTableData,
      BaseReferences<_$AppDriftDatabase, $AccountsTableTable, AccountsTableData>
    ),
    AccountsTableData,
    PrefetchHooks Function()> {
  $$AccountsTableTableTableManager(
      _$AppDriftDatabase db, $AccountsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String?> primaryBusinessId = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AccountsTableCompanion(
            id: id,
            userId: userId,
            primaryBusinessId: primaryBusinessId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            Value<String?> primaryBusinessId = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AccountsTableCompanion.insert(
            id: id,
            userId: userId,
            primaryBusinessId: primaryBusinessId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$AccountsTableTable, AccountsTableData>(table),
                    BaseReferences<_$AppDriftDatabase, $AccountsTableTable,
                        AccountsTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AccountsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDriftDatabase,
    $AccountsTableTable,
    AccountsTableData,
    $$AccountsTableTableFilterComposer,
    $$AccountsTableTableOrderingComposer,
    $$AccountsTableTableAnnotationComposer,
    $$AccountsTableTableCreateCompanionBuilder,
    $$AccountsTableTableUpdateCompanionBuilder,
    (
      AccountsTableData,
      BaseReferences<_$AppDriftDatabase, $AccountsTableTable, AccountsTableData>
    ),
    AccountsTableData,
    PrefetchHooks Function()>;

class $AppDriftDatabaseManager {
  final _$AppDriftDatabase _db;
  $AppDriftDatabaseManager(this._db);
  $$BusinessTableTableTableManager get businessTable =>
      $$BusinessTableTableTableManager(_db, _db.businessTable);
  $$AccountsTableTableTableManager get accountsTable =>
      $$AccountsTableTableTableManager(_db, _db.accountsTable);
}
