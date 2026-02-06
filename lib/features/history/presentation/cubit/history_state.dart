part of 'history_cubit.dart';

/// Base class for history states.
sealed class HistoryState extends Equatable {
  const HistoryState();
}

/// Initial state before loading history.
class HistoryInitial extends HistoryState {
  const HistoryInitial();

  @override
  List<Object> get props => [];
}

/// State while history is being loaded.
class HistoryLoading extends HistoryState {
  const HistoryLoading();

  @override
  List<Object> get props => [];
}

/// State when history has been loaded successfully.
class HistoryLoaded extends HistoryState {
  const HistoryLoaded({required this.entries});

  /// The list of history entries, ordered newest first.
  final List<HistoryEntry> entries;

  @override
  List<Object> get props => [entries];
}
