import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_mate/core/services/app_logger.dart';
import 'package:math_mate/features/history/data/history_database.dart';
import 'package:math_mate/features/history/data/history_repository.dart';
import 'package:math_mate/features/history/presentation/cubit/history_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockAppLogger extends Mock implements AppLogger {}

class MockHistoryRepository extends Mock implements HistoryRepository {}

void main() {
  late HistoryDatabase database;
  late HistoryRepository repository;

  setUp(() {
    database = HistoryDatabase.forTesting(
      NativeDatabase.memory(),
    );
    repository = HistoryRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('HistoryCubit', () {
    group('initial state', () {
      test('is HistoryInitial', () {
        final cubit = HistoryCubit(repository: repository);

        expect(cubit.state, isA<HistoryInitial>());

        cubit.close();
      });
    });

    group('load', () {
      blocTest<HistoryCubit, HistoryState>(
        'emits [HistoryLoading, HistoryLoaded] with empty list initially',
        build: () => HistoryCubit(repository: repository),
        act: (cubit) => cubit.load(),
        expect: () => [
          isA<HistoryLoading>(),
          isA<HistoryLoaded>().having(
            (s) => s.entries,
            'entries',
            isEmpty,
          ),
        ],
      );

      blocTest<HistoryCubit, HistoryState>(
        'emits [HistoryLoading, HistoryLoaded] with entries when data exists',
        setUp: () async {
          await repository.addEntry(expression: '2 + 3', result: '5');
          await repository.addEntry(expression: '10 × 2', result: '20');
        },
        build: () => HistoryCubit(repository: repository),
        act: (cubit) => cubit.load(),
        expect: () => [
          isA<HistoryLoading>(),
          isA<HistoryLoaded>().having(
            (s) => s.entries.length,
            'entries.length',
            2,
          ),
        ],
      );

      blocTest<HistoryCubit, HistoryState>(
        'entries are ordered newest first',
        setUp: () async {
          await repository.addEntry(expression: 'first', result: '1');
          await repository.addEntry(expression: 'second', result: '2');
        },
        build: () => HistoryCubit(repository: repository),
        act: (cubit) => cubit.load(),
        expect: () => [
          isA<HistoryLoading>(),
          isA<HistoryLoaded>().having(
            (s) => s.entries.first.expression,
            'newest entry',
            'second',
          ),
        ],
      );

      test('reactively updates when new entries are added', () async {
        final cubit = HistoryCubit(repository: repository);
        cubit.load();

        // Wait for initial load
        await Future<void>.delayed(const Duration(milliseconds: 50));

        expect((cubit.state as HistoryLoaded).entries, isEmpty);

        // Add an entry
        await repository.addEntry(expression: '5 + 5', result: '10');

        // Wait for stream update
        await Future<void>.delayed(const Duration(milliseconds: 50));

        expect((cubit.state as HistoryLoaded).entries.length, equals(1));
        expect(
          (cubit.state as HistoryLoaded).entries.first.expression,
          equals('5 + 5'),
        );

        await cubit.close();
      });
    });

    group('delete', () {
      blocTest<HistoryCubit, HistoryState>(
        'removes entry from list',
        setUp: () async {
          await repository.addEntry(expression: '1 + 1', result: '2');
          await repository.addEntry(expression: '2 + 2', result: '4');
        },
        build: () => HistoryCubit(repository: repository),
        act: (cubit) async {
          cubit.load();
          await Future<void>.delayed(const Duration(milliseconds: 50));

          // Get the first entry's id and delete it
          final entries = (cubit.state as HistoryLoaded).entries;
          await cubit.delete(id: entries.first.id);
        },
        verify: (cubit) {
          final state = cubit.state as HistoryLoaded;
          expect(state.entries.length, equals(1));
        },
      );

      blocTest<HistoryCubit, HistoryState>(
        'does nothing when id does not exist',
        setUp: () async {
          await repository.addEntry(expression: '1 + 1', result: '2');
        },
        build: () => HistoryCubit(repository: repository),
        act: (cubit) async {
          cubit.load();
          await Future<void>.delayed(const Duration(milliseconds: 50));
          await cubit.delete(id: 9999);
        },
        verify: (cubit) {
          final state = cubit.state as HistoryLoaded;
          expect(state.entries.length, equals(1));
        },
      );
    });

    group('clearAll', () {
      blocTest<HistoryCubit, HistoryState>(
        'removes all entries',
        setUp: () async {
          await repository.addEntry(expression: '1 + 1', result: '2');
          await repository.addEntry(expression: '2 + 2', result: '4');
          await repository.addEntry(expression: '3 + 3', result: '6');
        },
        build: () => HistoryCubit(repository: repository),
        act: (cubit) async {
          cubit.load();
          await Future<void>.delayed(const Duration(milliseconds: 50));
          await cubit.clearAll();
        },
        verify: (cubit) {
          final state = cubit.state as HistoryLoaded;
          expect(state.entries, isEmpty);
        },
      );
    });

    group('close', () {
      test('cancels stream subscription', () async {
        final cubit = HistoryCubit(repository: repository);
        cubit.load();
        await Future<void>.delayed(const Duration(milliseconds: 50));

        // Should not throw
        await cubit.close();

        // Adding entry after close should not affect closed cubit
        await repository.addEntry(expression: 'after close', result: '0');
      });
    });

    group('HistoryState', () {
      test('HistoryInitial supports equality', () {
        const state1 = HistoryInitial();
        const state2 = HistoryInitial();

        expect(state1, equals(state2));
      });

      test('HistoryLoading supports equality', () {
        const state1 = HistoryLoading();
        const state2 = HistoryLoading();

        expect(state1, equals(state2));
      });

      test('HistoryLoaded supports equality with same entries', () {
        final entry = HistoryEntry(
          id: 1,
          expression: '2 + 2',
          result: '4',
          timestamp: DateTime(2024),
        );
        final state1 = HistoryLoaded(entries: [entry]);
        final state2 = HistoryLoaded(entries: [entry]);

        expect(state1, equals(state2));
      });

      test('HistoryLoaded differs with different entries', () {
        final entry1 = HistoryEntry(
          id: 1,
          expression: '2 + 2',
          result: '4',
          timestamp: DateTime(2024),
        );
        final entry2 = HistoryEntry(
          id: 2,
          expression: '3 + 3',
          result: '6',
          timestamp: DateTime(2024),
        );
        final state1 = HistoryLoaded(entries: [entry1]);
        final state2 = HistoryLoaded(entries: [entry2]);

        expect(state1, isNot(equals(state2)));
      });
    });

    group('error handling', () {
      test('stream error is logged and cubit does not crash',
          () async {
        final mockLogger = MockAppLogger();
        final mockRepo = MockHistoryRepository();
        final controller =
            StreamController<List<HistoryEntry>>();

        when(() => mockLogger.error(any(), any(), any()))
            .thenReturn(null);
        when(() => mockRepo.getAllEntries())
            .thenAnswer((_) => controller.stream);

        final cubit = HistoryCubit(
          repository: mockRepo,
          logger: mockLogger,
        )..load();

        // Emit data first, then error
        controller.add(<HistoryEntry>[]);
        await Future<void>.delayed(
          const Duration(milliseconds: 50),
        );

        controller.addError(
          Exception('db error'),
          StackTrace.current,
        );
        await Future<void>.delayed(
          const Duration(milliseconds: 50),
        );

        verify(
          () => mockLogger.error(any(), any(), any()),
        ).called(1);

        await controller.close();
        await cubit.close();
      });
    });
  });
}
