import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_mate/features/history/data/history_database.dart';
import 'package:math_mate/features/history/data/history_repository.dart';

part 'history_state.dart';

/// Cubit for managing calculation history state.
///
/// Subscribes to the history repository's stream for reactive updates.
/// Provides methods to delete entries and clear all history.
///
/// Usage:
/// ```dart
/// final cubit = HistoryCubit(repository: repository);
///
/// // Start listening to history changes
/// cubit.load();
///
/// // Delete a single entry
/// await cubit.delete(id: 1);
///
/// // Clear all history
/// await cubit.clearAll();
/// ```
class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit({required this.repository}) : super(const HistoryInitial());

  /// Repository for accessing history data.
  final HistoryRepository repository;

  /// Subscription to the history entries stream.
  StreamSubscription<List<HistoryEntry>>? _subscription;

  /// Starts listening to history changes from the repository.
  ///
  /// Emits [HistoryLoading] immediately, then [HistoryLoaded] with
  /// the current entries. Continues to emit [HistoryLoaded] whenever
  /// the data changes (entries added, deleted, or cleared).
  void load() {
    emit(const HistoryLoading());

    _subscription?.cancel();
    _subscription = repository.getAllEntries().listen(
      (entries) {
        emit(HistoryLoaded(entries: entries));
      },
    );
  }

  /// Deletes the history entry with the specified [id].
  ///
  /// The stream subscription will automatically emit a new [HistoryLoaded]
  /// state with the updated list after deletion.
  Future<void> delete({required int id}) async {
    await repository.deleteEntry(id: id);
  }

  /// Clears all history entries.
  ///
  /// The stream subscription will automatically emit a new [HistoryLoaded]
  /// state with an empty list after clearing.
  Future<void> clearAll() async {
    await repository.clearAll();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
