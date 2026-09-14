import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'drift_database.g.dart';

/// Table schema for Accounts stored in Drift local SQLite database.
class AccountsTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get primaryBusinessId => text().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Table schema for Businesses stored in Drift local SQLite database.
class BusinessTable extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text().nullable()();
  TextColumn get businessName => text()();
  TextColumn get ownerName => text().nullable()();
  TextColumn get businessType => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get whatsappNumber => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get addressLine1 => text().nullable()();
  TextColumn get addressLine2 => text().nullable()();
  BoolColumn get gstEnabled => boolean().withDefault(const Constant(true))();
  TextColumn get gstin => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  TextColumn get logoUrl => text().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get lastUsedAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get clientUpdatedAt => dateTime().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('synced'))(); // 'synced', 'pending', 'failed'
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
  TextColumn get syncError => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Data Access Object (DAO) for local Drift BusinessTable queries.
///
/// MUST contain only local database operations. Does NOT call Supabase directly.
@DriftAccessor(tables: [BusinessTable, AccountsTable])
class BusinessDao extends DatabaseAccessor<AppDriftDatabase> with _$BusinessDaoMixin {
  BusinessDao(super.db);

  /// Reactive stream watching a business by ID.
  Stream<BusinessTableData?> watchBusinessById(String businessId) {
    return (select(businessTable)..where((tbl) => tbl.id.equals(businessId)))
        .watchSingleOrNull();
  }

  /// Reactive stream watching the active business record scoped by optional account ID.
  Stream<BusinessTableData?> watchCurrentBusiness({String? accountId}) {
    if (accountId != null && accountId.isNotEmpty) {
      return (select(businessTable)..where((tbl) => tbl.accountId.equals(accountId))..limit(1))
          .watchSingleOrNull();
    }
    return (select(businessTable)..limit(1)).watchSingleOrNull();
  }

  /// Reads a business by ID.
  Future<BusinessTableData?> getBusiness(String businessId) {
    return (select(businessTable)..where((tbl) => tbl.id.equals(businessId)))
        .getSingleOrNull();
  }

  /// Reads current active business scoped by optional account ID.
  Future<BusinessTableData?> getCurrentBusiness({String? accountId}) {
    if (accountId != null && accountId.isNotEmpty) {
      return (select(businessTable)..where((tbl) => tbl.accountId.equals(accountId))..limit(1))
          .getSingleOrNull();
    }
    return (select(businessTable)..limit(1)).getSingleOrNull();
  }

  /// Inserts a new business into Drift.
  Future<int> insertBusiness(BusinessTableCompanion companion) {
    return into(businessTable).insert(companion, mode: InsertMode.insertOrReplace);
  }

  /// Updates existing business columns present in companion in Drift.
  Future<int> updateBusinessRecord(BusinessTableCompanion companion) {
    return (update(businessTable)..where((tbl) => tbl.id.equals(companion.id.value)))
        .write(companion);
  }

  /// Upserts (insert or replace) a business in Drift.
  Future<int> upsertBusiness(BusinessTableCompanion companion) {
    return into(businessTable).insertOnConflictUpdate(companion);
  }

  /// Deletes a business record by ID.
  Future<int> deleteBusiness(String businessId) {
    return (delete(businessTable)..where((tbl) => tbl.id.equals(businessId))).go();
  }

  /// Deletes all local business records.
  Future<int> clearAllBusinesses() {
    return delete(businessTable).go();
  }
}

/// Main Drift Database Instance for Xenobiz Local Storage.
@DriftDatabase(tables: [BusinessTable, AccountsTable], daos: [BusinessDao])
class AppDriftDatabase extends _$AppDriftDatabase {
  static AppDriftDatabase? _instance;

  factory AppDriftDatabase([QueryExecutor? executor]) {
    if (executor != null) {
      return AppDriftDatabase._internal(executor);
    }
    _instance ??= AppDriftDatabase._internal(_openConnection());
    return _instance!;
  }

  static AppDriftDatabase get instance =>
      _instance ??= AppDriftDatabase._internal(_openConnection());

  AppDriftDatabase._internal(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(businessTable, businessTable.ownerName);
          }
        },
      );

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'xenobiz_local.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
