// GENERATED CODE - DO NOT MODIFY BY HAND
// Emitted on: 2019-05-15 00:33:16.415844

// **************************************************************************
// DatabaseHelperGenerator
// **************************************************************************

import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:sqlite_m8_demo/models/gym_location.g.m8.dart';
import 'package:sqlite_m8_demo/models/health_entry.g.m8.dart';
import 'package:sqlite_m8_demo/models/receipt.g.m8.dart';
import 'package:sqlite_m8_demo/models/to_do.g.m8.dart';
import 'package:sqlite_m8_demo/models/user_account.g.m8.dart';

enum InitMode { developmentAlwaysReinitDb, testingMockDb, production }

class DatabaseBuilder {
  InitMode _initMode;
  static InitMode _startInitMode;
  static final DatabaseBuilder _instance = DatabaseBuilder._internal();
  static Database _db;

  /// Default initMode is production
  /// [developmentAlwaysReinitDb] then the database will be deleteted on each init
  /// [testingMockDb] then the database will be initialized as mock
  /// [production] then the database will be initialized as production
  factory DatabaseBuilder([InitMode initMode = InitMode.production]) {
    _startInitMode = initMode;
    return _instance;
  }

  DatabaseBuilder._internal() {
    if (_initMode == null) {
      _initMode = _startInitMode;
    }
  }

  InitMode get initMode => _initMode;

  Future<Database> getDb(dynamic _onCreate) async {
    if (_db != null) {
      return _db;
    }
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'm8_store_0.2.0.db');

    if (_startInitMode == InitMode.developmentAlwaysReinitDb) {
      await deleteDatabase(path);
    }

    _db = await openDatabase(path, version: 2, onCreate: _onCreate);
    return _db;
  }
}

class DatabaseHelper
    with
        GymLocationDatabaseHelper,
        HealthEntryDatabaseHelper,
        ReceiptDatabaseHelper,
        ToDoDatabaseHelper,
        UserAccountDatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database _db;

  static DatabaseBuilder _dbBuilder;

  factory DatabaseHelper(DatabaseBuilder dbBuilder) {
    _dbBuilder = dbBuilder;
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await _dbBuilder.getDb(_onCreate);

    return _db;
  }

  void _onCreate(Database db, int newVersion) async {
    await createGymLocationTable(db);
    await createHealthEntryTable(db);
    await createReceiptTable(db);
    await createToDoTable(db);
    await createUserAccountTable(db);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }

  Future deleteAll() async {
    await deleteGymLocationProxiesAll();
    await deleteHealthEntryProxiesAll();
    await deleteReceiptProxiesAll();
    await deleteToDoProxiesAll();
    await deleteUserAccountProxiesAll();
  }
}
