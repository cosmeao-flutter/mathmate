import 'package:drift/drift.dart';
import 'package:math_mate/features/history/data/history_database.dart';

/// Repository for managing calculation history with Drift.
///
/// This repository provides a clean interface for CRUD operations on
/// calculation history entries, abstracting away the Drift database details.
///
/// Usage:
/// ```dart
/// final repository = HistoryRepository(database);
///
/// // Add a new entry
/// await repository.addEntry(expression: '2 + 3', result: '5');
///
/// // Get all entries (reactive stream)
/// repository.getAllEntries().listen((entries) {
///   print('${entries.length} entries');
/// });
///
/// // Delete an entry
/// await repository.deleteEntry(id: 1);
///
/// // Clear all history
/// await repository.clearAll();
/// ```
class HistoryRepository {
  /// Creates a new [HistoryRepository] with the given database.
  HistoryRepository(this._database);

  final HistoryDatabase _database;

  /// Adds a new calculation entry to the history.
  ///
  /// [expression] is the mathematical expression that was evaluated.
  /// [result] is the calculated result.
  ///
  /// The timestamp is automatically set to the current time.
  Future<void> addEntry({
    required String expression,
    required String result,
  }) async {
    await _database.into(_database.historyEntries).insert(
          HistoryEntriesCompanion.insert(
            expression: expression,
            result: result,
            timestamp: DateTime.now(),
          ),
        );
  }

  /// Returns a reactive stream of all history entries.
  ///
  /// The stream emits a new list whenever the data changes (insert, delete).
  /// Entries are ordered by id descending (newest first).
  Stream<List<HistoryEntry>> getAllEntries() {
    return (_database.select(_database.historyEntries)
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.id,
                  mode: OrderingMode.desc,
                ),
          ]))
        .watch();
  }

  /// Deletes the entry with the specified [id].
  ///
  /// Does nothing if no entry with the given id exists.
  Future<void> deleteEntry({required int id}) async {
    await (_database.delete(_database.historyEntries)
          ..where((t) => t.id.equals(id)))
        .go();
  }

  /// Removes all entries from the history.
  Future<void> clearAll() async {
    await _database.delete(_database.historyEntries).go();
  }

  /// Returns the total number of entries in the history.
  Future<int> getEntryCount() async {
    final count = _database.historyEntries.id.count();
    final query = _database.selectOnly(_database.historyEntries)
      ..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }
}
