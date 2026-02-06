import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'history_database.g.dart';

/// Table definition for calculation history entries.
///
/// Each entry stores a completed calculation with:
/// - [id]: Auto-incrementing primary key
/// - [expression]: The mathematical expression (e.g., "2 + 3 × 4")
/// - [result]: The calculated result (e.g., "14")
/// - [timestamp]: When the calculation was performed
class HistoryEntries extends Table {
  /// Auto-incrementing primary key.
  IntColumn get id => integer().autoIncrement()();

  /// The mathematical expression that was evaluated.
  TextColumn get expression => text()();

  /// The result of the calculation.
  TextColumn get result => text()();

  /// When this calculation was performed.
  DateTimeColumn get timestamp => dateTime()();
}

/// The Drift database for calculation history.
///
/// This database uses SQLite to persist calculation history entries.
/// It provides type-safe queries and reactive streams for data updates.
///
/// Usage:
/// ```dart
/// final database = HistoryDatabase();
///
/// // Insert entry
/// await database.into(database.historyEntries).insert(
///   HistoryEntriesCompanion.insert(
///     expression: '2 + 3',
///     result: '5',
///     timestamp: DateTime.now(),
///   ),
/// );
///
/// // Watch all entries (reactive)
/// database.select(database.historyEntries).watch();
/// ```
@DriftDatabase(tables: [HistoryEntries])
class HistoryDatabase extends _$HistoryDatabase {
  /// Creates a new [HistoryDatabase] with the default connection.
  HistoryDatabase() : super(_openConnection());

  /// Creates a [HistoryDatabase] with a custom query executor.
  ///
  /// This is useful for testing with an in-memory database.
  HistoryDatabase.forTesting(super.executor);

  /// The current schema version.
  ///
  /// Increment this when making schema changes and add migration logic.
  @override
  int get schemaVersion => 1;

  /// Migration strategy for database schema updates.
  ///
  /// Called when the database is opened with a different schema version.
  /// Add migration logic here when updating the schema in future versions.
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        // Create all tables on first run
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Add migration logic here for future schema changes
        // Example:
        // if (from < 2) {
        //   await m.addColumn(historyEntries, historyEntries.someNewColumn);
        // }
      },
    );
  }
}

/// Opens a connection to the SQLite database.
///
/// The database file is stored in the app's documents directory.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'history.db'));
    return NativeDatabase.createInBackground(file);
  });
}
