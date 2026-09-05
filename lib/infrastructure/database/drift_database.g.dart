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
  static const VerificationMeta _alternatePhoneMeta =
      const VerificationMeta('alternatePhone');
  @override
  late final GeneratedColumn<String> alternatePhone = GeneratedColumn<String>(
      'alternate_phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
      'city', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
      'state', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _countryMeta =
      const VerificationMeta('country');
  @override
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
      'country', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pinCodeMeta =
      const VerificationMeta('pinCode');
  @override
  late final GeneratedColumn<String> pinCode = GeneratedColumn<String>(
      'pin_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _gstRegistrationTypeMeta =
      const VerificationMeta('gstRegistrationType');
  @override
  late final GeneratedColumn<String> gstRegistrationType =
      GeneratedColumn<String>('gst_registration_type', aliasedName, true,
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
  static const VerificationMeta _panMeta = const VerificationMeta('pan');
  @override
  late final GeneratedColumn<String> pan = GeneratedColumn<String>(
      'pan', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('₹'));
  static const VerificationMeta _invoicePrefixMeta =
      const VerificationMeta('invoicePrefix');
  @override
  late final GeneratedColumn<String> invoicePrefix = GeneratedColumn<String>(
      'invoice_prefix', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('INV'));
  static const VerificationMeta _nextInvoiceNumberMeta =
      const VerificationMeta('nextInvoiceNumber');
  @override
  late final GeneratedColumn<int> nextInvoiceNumber = GeneratedColumn<int>(
      'next_invoice_number', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1001));
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
        businessType,
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
        createdAt,
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
    if (data.containsKey('alternate_phone')) {
      context.handle(
          _alternatePhoneMeta,
          alternatePhone.isAcceptableOrUnknown(
              data['alternate_phone']!, _alternatePhoneMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('city')) {
      context.handle(
          _cityMeta, city.isAcceptableOrUnknown(data['city']!, _cityMeta));
    }
    if (data.containsKey('state')) {
      context.handle(
          _stateMeta, state.isAcceptableOrUnknown(data['state']!, _stateMeta));
    }
    if (data.containsKey('country')) {
      context.handle(_countryMeta,
          country.isAcceptableOrUnknown(data['country']!, _countryMeta));
    }
    if (data.containsKey('pin_code')) {
      context.handle(_pinCodeMeta,
          pinCode.isAcceptableOrUnknown(data['pin_code']!, _pinCodeMeta));
    }
    if (data.containsKey('gst_registration_type')) {
      context.handle(
          _gstRegistrationTypeMeta,
          gstRegistrationType.isAcceptableOrUnknown(
              data['gst_registration_type']!, _gstRegistrationTypeMeta));
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
    if (data.containsKey('pan')) {
      context.handle(
          _panMeta, pan.isAcceptableOrUnknown(data['pan']!, _panMeta));
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('invoice_prefix')) {
      context.handle(
          _invoicePrefixMeta,
          invoicePrefix.isAcceptableOrUnknown(
              data['invoice_prefix']!, _invoicePrefixMeta));
    }
    if (data.containsKey('next_invoice_number')) {
      context.handle(
          _nextInvoiceNumberMeta,
          nextInvoiceNumber.isAcceptableOrUnknown(
              data['next_invoice_number']!, _nextInvoiceNumberMeta));
    }
    if (data.containsKey('logo_url')) {
      context.handle(_logoUrlMeta,
          logoUrl.isAcceptableOrUnknown(data['logo_url']!, _logoUrlMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
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
      businessType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}business_type']),
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      alternatePhone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}alternate_phone']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      city: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}city']),
      state: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}state']),
      country: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}country']),
      pinCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pin_code']),
      gstRegistrationType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}gst_registration_type']),
      gstEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}gst_enabled'])!,
      gstin: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gstin']),
      pan: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pan']),
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      invoicePrefix: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}invoice_prefix'])!,
      nextInvoiceNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}next_invoice_number'])!,
      logoUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}logo_url']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
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
  final String? businessType;
  final String? phone;
  final String? alternatePhone;
  final String? email;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? pinCode;
  final String? gstRegistrationType;
  final bool gstEnabled;
  final String? gstin;
  final String? pan;
  final String currency;
  final String invoicePrefix;
  final int nextInvoiceNumber;
  final String? logoUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? clientUpdatedAt;
  final String syncStatus;
  final DateTime? lastSyncedAt;
  final String? syncError;
  const BusinessTableData(
      {required this.id,
      this.accountId,
      required this.businessName,
      this.businessType,
      this.phone,
      this.alternatePhone,
      this.email,
      this.address,
      this.city,
      this.state,
      this.country,
      this.pinCode,
      this.gstRegistrationType,
      required this.gstEnabled,
      this.gstin,
      this.pan,
      required this.currency,
      required this.invoicePrefix,
      required this.nextInvoiceNumber,
      this.logoUrl,
      this.createdAt,
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
    if (!nullToAbsent || businessType != null) {
      map['business_type'] = Variable<String>(businessType);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || alternatePhone != null) {
      map['alternate_phone'] = Variable<String>(alternatePhone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    if (!nullToAbsent || state != null) {
      map['state'] = Variable<String>(state);
    }
    if (!nullToAbsent || country != null) {
      map['country'] = Variable<String>(country);
    }
    if (!nullToAbsent || pinCode != null) {
      map['pin_code'] = Variable<String>(pinCode);
    }
    if (!nullToAbsent || gstRegistrationType != null) {
      map['gst_registration_type'] = Variable<String>(gstRegistrationType);
    }
    map['gst_enabled'] = Variable<bool>(gstEnabled);
    if (!nullToAbsent || gstin != null) {
      map['gstin'] = Variable<String>(gstin);
    }
    if (!nullToAbsent || pan != null) {
      map['pan'] = Variable<String>(pan);
    }
    map['currency'] = Variable<String>(currency);
    map['invoice_prefix'] = Variable<String>(invoicePrefix);
    map['next_invoice_number'] = Variable<int>(nextInvoiceNumber);
    if (!nullToAbsent || logoUrl != null) {
      map['logo_url'] = Variable<String>(logoUrl);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
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
      businessType: businessType == null && nullToAbsent
          ? const Value.absent()
          : Value(businessType),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      alternatePhone: alternatePhone == null && nullToAbsent
          ? const Value.absent()
          : Value(alternatePhone),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      state:
          state == null && nullToAbsent ? const Value.absent() : Value(state),
      country: country == null && nullToAbsent
          ? const Value.absent()
          : Value(country),
      pinCode: pinCode == null && nullToAbsent
          ? const Value.absent()
          : Value(pinCode),
      gstRegistrationType: gstRegistrationType == null && nullToAbsent
          ? const Value.absent()
          : Value(gstRegistrationType),
      gstEnabled: Value(gstEnabled),
      gstin:
          gstin == null && nullToAbsent ? const Value.absent() : Value(gstin),
      pan: pan == null && nullToAbsent ? const Value.absent() : Value(pan),
      currency: Value(currency),
      invoicePrefix: Value(invoicePrefix),
      nextInvoiceNumber: Value(nextInvoiceNumber),
      logoUrl: logoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(logoUrl),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
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
      businessType: serializer.fromJson<String?>(json['businessType']),
      phone: serializer.fromJson<String?>(json['phone']),
      alternatePhone: serializer.fromJson<String?>(json['alternatePhone']),
      email: serializer.fromJson<String?>(json['email']),
      address: serializer.fromJson<String?>(json['address']),
      city: serializer.fromJson<String?>(json['city']),
      state: serializer.fromJson<String?>(json['state']),
      country: serializer.fromJson<String?>(json['country']),
      pinCode: serializer.fromJson<String?>(json['pinCode']),
      gstRegistrationType:
          serializer.fromJson<String?>(json['gstRegistrationType']),
      gstEnabled: serializer.fromJson<bool>(json['gstEnabled']),
      gstin: serializer.fromJson<String?>(json['gstin']),
      pan: serializer.fromJson<String?>(json['pan']),
      currency: serializer.fromJson<String>(json['currency']),
      invoicePrefix: serializer.fromJson<String>(json['invoicePrefix']),
      nextInvoiceNumber: serializer.fromJson<int>(json['nextInvoiceNumber']),
      logoUrl: serializer.fromJson<String?>(json['logoUrl']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
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
      'businessType': serializer.toJson<String?>(businessType),
      'phone': serializer.toJson<String?>(phone),
      'alternatePhone': serializer.toJson<String?>(alternatePhone),
      'email': serializer.toJson<String?>(email),
      'address': serializer.toJson<String?>(address),
      'city': serializer.toJson<String?>(city),
      'state': serializer.toJson<String?>(state),
      'country': serializer.toJson<String?>(country),
      'pinCode': serializer.toJson<String?>(pinCode),
      'gstRegistrationType': serializer.toJson<String?>(gstRegistrationType),
      'gstEnabled': serializer.toJson<bool>(gstEnabled),
      'gstin': serializer.toJson<String?>(gstin),
      'pan': serializer.toJson<String?>(pan),
      'currency': serializer.toJson<String>(currency),
      'invoicePrefix': serializer.toJson<String>(invoicePrefix),
      'nextInvoiceNumber': serializer.toJson<int>(nextInvoiceNumber),
      'logoUrl': serializer.toJson<String?>(logoUrl),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
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
          Value<String?> businessType = const Value.absent(),
          Value<String?> phone = const Value.absent(),
          Value<String?> alternatePhone = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> address = const Value.absent(),
          Value<String?> city = const Value.absent(),
          Value<String?> state = const Value.absent(),
          Value<String?> country = const Value.absent(),
          Value<String?> pinCode = const Value.absent(),
          Value<String?> gstRegistrationType = const Value.absent(),
          bool? gstEnabled,
          Value<String?> gstin = const Value.absent(),
          Value<String?> pan = const Value.absent(),
          String? currency,
          String? invoicePrefix,
          int? nextInvoiceNumber,
          Value<String?> logoUrl = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent(),
          Value<DateTime?> clientUpdatedAt = const Value.absent(),
          String? syncStatus,
          Value<DateTime?> lastSyncedAt = const Value.absent(),
          Value<String?> syncError = const Value.absent()}) =>
      BusinessTableData(
        id: id ?? this.id,
        accountId: accountId.present ? accountId.value : this.accountId,
        businessName: businessName ?? this.businessName,
        businessType:
            businessType.present ? businessType.value : this.businessType,
        phone: phone.present ? phone.value : this.phone,
        alternatePhone:
            alternatePhone.present ? alternatePhone.value : this.alternatePhone,
        email: email.present ? email.value : this.email,
        address: address.present ? address.value : this.address,
        city: city.present ? city.value : this.city,
        state: state.present ? state.value : this.state,
        country: country.present ? country.value : this.country,
        pinCode: pinCode.present ? pinCode.value : this.pinCode,
        gstRegistrationType: gstRegistrationType.present
            ? gstRegistrationType.value
            : this.gstRegistrationType,
        gstEnabled: gstEnabled ?? this.gstEnabled,
        gstin: gstin.present ? gstin.value : this.gstin,
        pan: pan.present ? pan.value : this.pan,
        currency: currency ?? this.currency,
        invoicePrefix: invoicePrefix ?? this.invoicePrefix,
        nextInvoiceNumber: nextInvoiceNumber ?? this.nextInvoiceNumber,
        logoUrl: logoUrl.present ? logoUrl.value : this.logoUrl,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
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
      businessType: data.businessType.present
          ? data.businessType.value
          : this.businessType,
      phone: data.phone.present ? data.phone.value : this.phone,
      alternatePhone: data.alternatePhone.present
          ? data.alternatePhone.value
          : this.alternatePhone,
      email: data.email.present ? data.email.value : this.email,
      address: data.address.present ? data.address.value : this.address,
      city: data.city.present ? data.city.value : this.city,
      state: data.state.present ? data.state.value : this.state,
      country: data.country.present ? data.country.value : this.country,
      pinCode: data.pinCode.present ? data.pinCode.value : this.pinCode,
      gstRegistrationType: data.gstRegistrationType.present
          ? data.gstRegistrationType.value
          : this.gstRegistrationType,
      gstEnabled:
          data.gstEnabled.present ? data.gstEnabled.value : this.gstEnabled,
      gstin: data.gstin.present ? data.gstin.value : this.gstin,
      pan: data.pan.present ? data.pan.value : this.pan,
      currency: data.currency.present ? data.currency.value : this.currency,
      invoicePrefix: data.invoicePrefix.present
          ? data.invoicePrefix.value
          : this.invoicePrefix,
      nextInvoiceNumber: data.nextInvoiceNumber.present
          ? data.nextInvoiceNumber.value
          : this.nextInvoiceNumber,
      logoUrl: data.logoUrl.present ? data.logoUrl.value : this.logoUrl,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
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
          ..write('businessType: $businessType, ')
          ..write('phone: $phone, ')
          ..write('alternatePhone: $alternatePhone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('city: $city, ')
          ..write('state: $state, ')
          ..write('country: $country, ')
          ..write('pinCode: $pinCode, ')
          ..write('gstRegistrationType: $gstRegistrationType, ')
          ..write('gstEnabled: $gstEnabled, ')
          ..write('gstin: $gstin, ')
          ..write('pan: $pan, ')
          ..write('currency: $currency, ')
          ..write('invoicePrefix: $invoicePrefix, ')
          ..write('nextInvoiceNumber: $nextInvoiceNumber, ')
          ..write('logoUrl: $logoUrl, ')
          ..write('createdAt: $createdAt, ')
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
        businessType,
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
        createdAt,
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
          other.businessType == this.businessType &&
          other.phone == this.phone &&
          other.alternatePhone == this.alternatePhone &&
          other.email == this.email &&
          other.address == this.address &&
          other.city == this.city &&
          other.state == this.state &&
          other.country == this.country &&
          other.pinCode == this.pinCode &&
          other.gstRegistrationType == this.gstRegistrationType &&
          other.gstEnabled == this.gstEnabled &&
          other.gstin == this.gstin &&
          other.pan == this.pan &&
          other.currency == this.currency &&
          other.invoicePrefix == this.invoicePrefix &&
          other.nextInvoiceNumber == this.nextInvoiceNumber &&
          other.logoUrl == this.logoUrl &&
          other.createdAt == this.createdAt &&
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
  final Value<String?> businessType;
  final Value<String?> phone;
  final Value<String?> alternatePhone;
  final Value<String?> email;
  final Value<String?> address;
  final Value<String?> city;
  final Value<String?> state;
  final Value<String?> country;
  final Value<String?> pinCode;
  final Value<String?> gstRegistrationType;
  final Value<bool> gstEnabled;
  final Value<String?> gstin;
  final Value<String?> pan;
  final Value<String> currency;
  final Value<String> invoicePrefix;
  final Value<int> nextInvoiceNumber;
  final Value<String?> logoUrl;
  final Value<DateTime?> createdAt;
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
    this.businessType = const Value.absent(),
    this.phone = const Value.absent(),
    this.alternatePhone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.city = const Value.absent(),
    this.state = const Value.absent(),
    this.country = const Value.absent(),
    this.pinCode = const Value.absent(),
    this.gstRegistrationType = const Value.absent(),
    this.gstEnabled = const Value.absent(),
    this.gstin = const Value.absent(),
    this.pan = const Value.absent(),
    this.currency = const Value.absent(),
    this.invoicePrefix = const Value.absent(),
    this.nextInvoiceNumber = const Value.absent(),
    this.logoUrl = const Value.absent(),
    this.createdAt = const Value.absent(),
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
    this.businessType = const Value.absent(),
    this.phone = const Value.absent(),
    this.alternatePhone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.city = const Value.absent(),
    this.state = const Value.absent(),
    this.country = const Value.absent(),
    this.pinCode = const Value.absent(),
    this.gstRegistrationType = const Value.absent(),
    this.gstEnabled = const Value.absent(),
    this.gstin = const Value.absent(),
    this.pan = const Value.absent(),
    this.currency = const Value.absent(),
    this.invoicePrefix = const Value.absent(),
    this.nextInvoiceNumber = const Value.absent(),
    this.logoUrl = const Value.absent(),
    this.createdAt = const Value.absent(),
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
    Expression<String>? businessType,
    Expression<String>? phone,
    Expression<String>? alternatePhone,
    Expression<String>? email,
    Expression<String>? address,
    Expression<String>? city,
    Expression<String>? state,
    Expression<String>? country,
    Expression<String>? pinCode,
    Expression<String>? gstRegistrationType,
    Expression<bool>? gstEnabled,
    Expression<String>? gstin,
    Expression<String>? pan,
    Expression<String>? currency,
    Expression<String>? invoicePrefix,
    Expression<int>? nextInvoiceNumber,
    Expression<String>? logoUrl,
    Expression<DateTime>? createdAt,
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
      if (businessType != null) 'business_type': businessType,
      if (phone != null) 'phone': phone,
      if (alternatePhone != null) 'alternate_phone': alternatePhone,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (country != null) 'country': country,
      if (pinCode != null) 'pin_code': pinCode,
      if (gstRegistrationType != null)
        'gst_registration_type': gstRegistrationType,
      if (gstEnabled != null) 'gst_enabled': gstEnabled,
      if (gstin != null) 'gstin': gstin,
      if (pan != null) 'pan': pan,
      if (currency != null) 'currency': currency,
      if (invoicePrefix != null) 'invoice_prefix': invoicePrefix,
      if (nextInvoiceNumber != null) 'next_invoice_number': nextInvoiceNumber,
      if (logoUrl != null) 'logo_url': logoUrl,
      if (createdAt != null) 'created_at': createdAt,
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
      Value<String?>? businessType,
      Value<String?>? phone,
      Value<String?>? alternatePhone,
      Value<String?>? email,
      Value<String?>? address,
      Value<String?>? city,
      Value<String?>? state,
      Value<String?>? country,
      Value<String?>? pinCode,
      Value<String?>? gstRegistrationType,
      Value<bool>? gstEnabled,
      Value<String?>? gstin,
      Value<String?>? pan,
      Value<String>? currency,
      Value<String>? invoicePrefix,
      Value<int>? nextInvoiceNumber,
      Value<String?>? logoUrl,
      Value<DateTime?>? createdAt,
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
      businessType: businessType ?? this.businessType,
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
      createdAt: createdAt ?? this.createdAt,
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
    if (businessType.present) {
      map['business_type'] = Variable<String>(businessType.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (alternatePhone.present) {
      map['alternate_phone'] = Variable<String>(alternatePhone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    if (pinCode.present) {
      map['pin_code'] = Variable<String>(pinCode.value);
    }
    if (gstRegistrationType.present) {
      map['gst_registration_type'] =
          Variable<String>(gstRegistrationType.value);
    }
    if (gstEnabled.present) {
      map['gst_enabled'] = Variable<bool>(gstEnabled.value);
    }
    if (gstin.present) {
      map['gstin'] = Variable<String>(gstin.value);
    }
    if (pan.present) {
      map['pan'] = Variable<String>(pan.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (invoicePrefix.present) {
      map['invoice_prefix'] = Variable<String>(invoicePrefix.value);
    }
    if (nextInvoiceNumber.present) {
      map['next_invoice_number'] = Variable<int>(nextInvoiceNumber.value);
    }
    if (logoUrl.present) {
      map['logo_url'] = Variable<String>(logoUrl.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
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
          ..write('businessType: $businessType, ')
          ..write('phone: $phone, ')
          ..write('alternatePhone: $alternatePhone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('city: $city, ')
          ..write('state: $state, ')
          ..write('country: $country, ')
          ..write('pinCode: $pinCode, ')
          ..write('gstRegistrationType: $gstRegistrationType, ')
          ..write('gstEnabled: $gstEnabled, ')
          ..write('gstin: $gstin, ')
          ..write('pan: $pan, ')
          ..write('currency: $currency, ')
          ..write('invoicePrefix: $invoicePrefix, ')
          ..write('nextInvoiceNumber: $nextInvoiceNumber, ')
          ..write('logoUrl: $logoUrl, ')
          ..write('createdAt: $createdAt, ')
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
  Value<String?> businessType,
  Value<String?> phone,
  Value<String?> alternatePhone,
  Value<String?> email,
  Value<String?> address,
  Value<String?> city,
  Value<String?> state,
  Value<String?> country,
  Value<String?> pinCode,
  Value<String?> gstRegistrationType,
  Value<bool> gstEnabled,
  Value<String?> gstin,
  Value<String?> pan,
  Value<String> currency,
  Value<String> invoicePrefix,
  Value<int> nextInvoiceNumber,
  Value<String?> logoUrl,
  Value<DateTime?> createdAt,
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
  Value<String?> businessType,
  Value<String?> phone,
  Value<String?> alternatePhone,
  Value<String?> email,
  Value<String?> address,
  Value<String?> city,
  Value<String?> state,
  Value<String?> country,
  Value<String?> pinCode,
  Value<String?> gstRegistrationType,
  Value<bool> gstEnabled,
  Value<String?> gstin,
  Value<String?> pan,
  Value<String> currency,
  Value<String> invoicePrefix,
  Value<int> nextInvoiceNumber,
  Value<String?> logoUrl,
  Value<DateTime?> createdAt,
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

  ColumnFilters<String> get businessType => $composableBuilder(
      column: $table.businessType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get alternatePhone => $composableBuilder(
      column: $table.alternatePhone,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get city => $composableBuilder(
      column: $table.city, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get state => $composableBuilder(
      column: $table.state, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get country => $composableBuilder(
      column: $table.country, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pinCode => $composableBuilder(
      column: $table.pinCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gstRegistrationType => $composableBuilder(
      column: $table.gstRegistrationType,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get gstEnabled => $composableBuilder(
      column: $table.gstEnabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gstin => $composableBuilder(
      column: $table.gstin, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pan => $composableBuilder(
      column: $table.pan, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get invoicePrefix => $composableBuilder(
      column: $table.invoicePrefix, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get nextInvoiceNumber => $composableBuilder(
      column: $table.nextInvoiceNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get logoUrl => $composableBuilder(
      column: $table.logoUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

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

  ColumnOrderings<String> get businessType => $composableBuilder(
      column: $table.businessType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get alternatePhone => $composableBuilder(
      column: $table.alternatePhone,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get city => $composableBuilder(
      column: $table.city, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get state => $composableBuilder(
      column: $table.state, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get country => $composableBuilder(
      column: $table.country, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pinCode => $composableBuilder(
      column: $table.pinCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gstRegistrationType => $composableBuilder(
      column: $table.gstRegistrationType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get gstEnabled => $composableBuilder(
      column: $table.gstEnabled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gstin => $composableBuilder(
      column: $table.gstin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pan => $composableBuilder(
      column: $table.pan, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get invoicePrefix => $composableBuilder(
      column: $table.invoicePrefix,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get nextInvoiceNumber => $composableBuilder(
      column: $table.nextInvoiceNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get logoUrl => $composableBuilder(
      column: $table.logoUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

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

  GeneratedColumn<String> get businessType => $composableBuilder(
      column: $table.businessType, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get alternatePhone => $composableBuilder(
      column: $table.alternatePhone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get country =>
      $composableBuilder(column: $table.country, builder: (column) => column);

  GeneratedColumn<String> get pinCode =>
      $composableBuilder(column: $table.pinCode, builder: (column) => column);

  GeneratedColumn<String> get gstRegistrationType => $composableBuilder(
      column: $table.gstRegistrationType, builder: (column) => column);

  GeneratedColumn<bool> get gstEnabled => $composableBuilder(
      column: $table.gstEnabled, builder: (column) => column);

  GeneratedColumn<String> get gstin =>
      $composableBuilder(column: $table.gstin, builder: (column) => column);

  GeneratedColumn<String> get pan =>
      $composableBuilder(column: $table.pan, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get invoicePrefix => $composableBuilder(
      column: $table.invoicePrefix, builder: (column) => column);

  GeneratedColumn<int> get nextInvoiceNumber => $composableBuilder(
      column: $table.nextInvoiceNumber, builder: (column) => column);

  GeneratedColumn<String> get logoUrl =>
      $composableBuilder(column: $table.logoUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

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
            Value<String?> businessType = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> alternatePhone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> city = const Value.absent(),
            Value<String?> state = const Value.absent(),
            Value<String?> country = const Value.absent(),
            Value<String?> pinCode = const Value.absent(),
            Value<String?> gstRegistrationType = const Value.absent(),
            Value<bool> gstEnabled = const Value.absent(),
            Value<String?> gstin = const Value.absent(),
            Value<String?> pan = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<String> invoicePrefix = const Value.absent(),
            Value<int> nextInvoiceNumber = const Value.absent(),
            Value<String?> logoUrl = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
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
            businessType: businessType,
            phone: phone,
            alternatePhone: alternatePhone,
            email: email,
            address: address,
            city: city,
            state: state,
            country: country,
            pinCode: pinCode,
            gstRegistrationType: gstRegistrationType,
            gstEnabled: gstEnabled,
            gstin: gstin,
            pan: pan,
            currency: currency,
            invoicePrefix: invoicePrefix,
            nextInvoiceNumber: nextInvoiceNumber,
            logoUrl: logoUrl,
            createdAt: createdAt,
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
            Value<String?> businessType = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> alternatePhone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> city = const Value.absent(),
            Value<String?> state = const Value.absent(),
            Value<String?> country = const Value.absent(),
            Value<String?> pinCode = const Value.absent(),
            Value<String?> gstRegistrationType = const Value.absent(),
            Value<bool> gstEnabled = const Value.absent(),
            Value<String?> gstin = const Value.absent(),
            Value<String?> pan = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<String> invoicePrefix = const Value.absent(),
            Value<int> nextInvoiceNumber = const Value.absent(),
            Value<String?> logoUrl = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
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
            businessType: businessType,
            phone: phone,
            alternatePhone: alternatePhone,
            email: email,
            address: address,
            city: city,
            state: state,
            country: country,
            pinCode: pinCode,
            gstRegistrationType: gstRegistrationType,
            gstEnabled: gstEnabled,
            gstin: gstin,
            pan: pan,
            currency: currency,
            invoicePrefix: invoicePrefix,
            nextInvoiceNumber: nextInvoiceNumber,
            logoUrl: logoUrl,
            createdAt: createdAt,
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
