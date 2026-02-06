import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_mate/features/history/data/history_database.dart';
import 'package:math_mate/features/history/data/history_repository.dart';

void main() {
  late HistoryDatabase database;
  late HistoryRepository repository;

  setUp(() {
    // Use in-memory database for testing
    database = HistoryDatabase.forTesting(NativeDatabase.memory());
    repository = HistoryRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('HistoryRepository', () {
    group('addEntry', () {
      test('inserts a new entry into the database', () async {
        await repository.addEntry(
          expression: '2 + 3',
          result: '5',
        );

        final entries = await repository.getAllEntries().first;
        expect(entries, hasLength(1));
        expect(entries.first.expression, '2 + 3');
        expect(entries.first.result, '5');
      });

      test('sets timestamp to current time', () async {
        final before = DateTime.now();

        await repository.addEntry(
          expression: '10 × 5',
          result: '50',
        );

        final after = DateTime.now();
        final entries = await repository.getAllEntries().first;

        final lowerBound = before.subtract(const Duration(seconds: 1));
        final upperBound = after.add(const Duration(seconds: 1));
        expect(entries.first.timestamp.isAfter(lowerBound), isTrue);
        expect(entries.first.timestamp.isBefore(upperBound), isTrue);
      });

      test('auto-increments id for each entry', () async {
        await repository.addEntry(expression: '1 + 1', result: '2');
        await repository.addEntry(expression: '2 + 2', result: '4');
        await repository.addEntry(expression: '3 + 3', result: '6');

        final entries = await repository.getAllEntries().first;

        expect(entries[0].id, 3); // Most recent first
        expect(entries[1].id, 2);
        expect(entries[2].id, 1);
      });

      test('stores special characters in expression', () async {
        await repository.addEntry(
          expression: '(2 + 3) × 4 ÷ 2 − 1',
          result: '9',
        );

        final entries = await repository.getAllEntries().first;
        expect(entries.first.expression, '(2 + 3) × 4 ÷ 2 − 1');
      });

      test('stores decimal results', () async {
        await repository.addEntry(
          expression: '10 ÷ 3',
          result: '3.333333',
        );

        final entries = await repository.getAllEntries().first;
        expect(entries.first.result, '3.333333');
      });
    });

    group('getAllEntries', () {
      test('returns empty list when no entries exist', () async {
        final entries = await repository.getAllEntries().first;
        expect(entries, isEmpty);
      });

      test('returns entries in reverse chronological order', () async {
        await repository.addEntry(expression: 'first', result: '1');
        await repository.addEntry(expression: 'second', result: '2');
        await repository.addEntry(expression: 'third', result: '3');

        final entries = await repository.getAllEntries().first;

        // Newest entries (highest id) should be first
        expect(entries[0].expression, 'third');
        expect(entries[1].expression, 'second');
        expect(entries[2].expression, 'first');
      });

      test('returns a reactive stream that updates on insert', () async {
        final stream = repository.getAllEntries();
        final emissions = <List<HistoryEntry>>[];

        final subscription = stream.listen(emissions.add);

        // Wait for initial emission
        await Future<void>.delayed(const Duration(milliseconds: 50));

        await repository.addEntry(expression: '1 + 1', result: '2');
        await Future<void>.delayed(const Duration(milliseconds: 50));

        await repository.addEntry(expression: '2 + 2', result: '4');
        await Future<void>.delayed(const Duration(milliseconds: 50));

        await subscription.cancel();

        expect(emissions.length, greaterThanOrEqualTo(3));
        expect(emissions.first, isEmpty); // Initial empty state
        expect(emissions.last, hasLength(2)); // After two inserts
      });

      test('returns a reactive stream that updates on delete', () async {
        await repository.addEntry(expression: '1 + 1', result: '2');
        final entries = await repository.getAllEntries().first;
        final entryId = entries.first.id;

        final stream = repository.getAllEntries();
        final emissions = <List<HistoryEntry>>[];

        final subscription = stream.listen(emissions.add);
        await Future<void>.delayed(const Duration(milliseconds: 50));

        await repository.deleteEntry(id: entryId);
        await Future<void>.delayed(const Duration(milliseconds: 50));

        await subscription.cancel();

        expect(emissions.length, greaterThanOrEqualTo(2));
        expect(emissions.first, hasLength(1)); // Before delete
        expect(emissions.last, isEmpty); // After delete
      });
    });

    group('deleteEntry', () {
      test('removes the specified entry', () async {
        await repository.addEntry(expression: '1 + 1', result: '2');
        await repository.addEntry(expression: '2 + 2', result: '4');

        var entries = await repository.getAllEntries().first;
        expect(entries, hasLength(2));

        final idToDelete = entries.first.id;
        await repository.deleteEntry(id: idToDelete);

        entries = await repository.getAllEntries().first;
        expect(entries, hasLength(1));
        expect(entries.first.expression, '1 + 1');
      });

      test('does nothing if entry does not exist', () async {
        await repository.addEntry(expression: '1 + 1', result: '2');

        await repository.deleteEntry(id: 999);

        final entries = await repository.getAllEntries().first;
        expect(entries, hasLength(1));
      });

      test('only removes the entry with matching id', () async {
        await repository.addEntry(expression: 'a', result: '1');
        await repository.addEntry(expression: 'b', result: '2');
        await repository.addEntry(expression: 'c', result: '3');

        final entries = await repository.getAllEntries().first;
        final middleId = entries[1].id; // 'b'

        await repository.deleteEntry(id: middleId);

        final remaining = await repository.getAllEntries().first;
        expect(remaining, hasLength(2));
        final expressions = remaining.map((e) => e.expression).toList();
        expect(expressions, containsAll(['a', 'c']));
      });
    });

    group('clearAll', () {
      test('removes all entries from the database', () async {
        await repository.addEntry(expression: '1', result: '1');
        await repository.addEntry(expression: '2', result: '2');
        await repository.addEntry(expression: '3', result: '3');

        var entries = await repository.getAllEntries().first;
        expect(entries, hasLength(3));

        await repository.clearAll();

        entries = await repository.getAllEntries().first;
        expect(entries, isEmpty);
      });

      test('works when database is already empty', () async {
        await repository.clearAll();

        final entries = await repository.getAllEntries().first;
        expect(entries, isEmpty);
      });
    });

    group('getEntryCount', () {
      test('returns 0 when no entries exist', () async {
        final count = await repository.getEntryCount();
        expect(count, 0);
      });

      test('returns correct count after adding entries', () async {
        await repository.addEntry(expression: '1', result: '1');
        expect(await repository.getEntryCount(), 1);

        await repository.addEntry(expression: '2', result: '2');
        expect(await repository.getEntryCount(), 2);

        await repository.addEntry(expression: '3', result: '3');
        expect(await repository.getEntryCount(), 3);
      });

      test('returns correct count after deleting entries', () async {
        await repository.addEntry(expression: '1', result: '1');
        await repository.addEntry(expression: '2', result: '2');

        final entries = await repository.getAllEntries().first;
        await repository.deleteEntry(id: entries.first.id);

        expect(await repository.getEntryCount(), 1);
      });

      test('returns 0 after clearAll', () async {
        await repository.addEntry(expression: '1', result: '1');
        await repository.addEntry(expression: '2', result: '2');

        await repository.clearAll();

        expect(await repository.getEntryCount(), 0);
      });
    });

    group('edge cases', () {
      test('handles empty expression', () async {
        await repository.addEntry(expression: '', result: '0');

        final entries = await repository.getAllEntries().first;
        expect(entries.first.expression, '');
      });

      test('handles very long expressions', () async {
        final longExpression = '1 + ' * 100 + '1';

        await repository.addEntry(expression: longExpression, result: '101');

        final entries = await repository.getAllEntries().first;
        expect(entries.first.expression, longExpression);
      });

      test('handles negative results', () async {
        await repository.addEntry(expression: '5 − 10', result: '-5');

        final entries = await repository.getAllEntries().first;
        expect(entries.first.result, '-5');
      });
    });
  });
}
