import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:math_mate/core/l10n/l10n.dart';
import 'package:math_mate/features/history/data/history_database.dart';
import 'package:math_mate/features/history/presentation/cubit/history_cubit.dart';

/// Shows the history bottom sheet.
///
/// Requires [HistoryCubit] to be available in the widget tree.
/// [onEntryTap] is called when a history entry is tapped,
/// passing the expression to load into the calculator.
void showHistoryBottomSheet(
  BuildContext context, {
  required void Function(String expression) onEntryTap,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) => HistoryBottomSheet(onEntryTap: onEntryTap),
  );
}

/// Bottom sheet for viewing and managing calculation history.
///
/// Features:
/// - Scrollable list of past calculations
/// - Tap entry to load expression into calculator
/// - Swipe left to delete individual entry
/// - Clear all button with confirmation
class HistoryBottomSheet extends StatelessWidget {
  const HistoryBottomSheet({
    required this.onEntryTap,
    super.key,
  });

  /// Called when a history entry is tapped.
  final void Function(String expression) onEntryTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        return DraggableScrollableSheet(
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return SafeArea(
              child: Column(
                children: [
                  // Handle
                  const _DragHandle(),

                  // Header with title and clear all button
                  _Header(
                    showClearAll: state is HistoryLoaded &&
                        state.entries.isNotEmpty,
                    onClearAll: () => _showClearConfirmation(context),
                  ),

                  const Divider(height: 1),

                  // Content
                  Expanded(
                    child: _buildContent(context, state, scrollController),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    HistoryState state,
    ScrollController scrollController,
  ) {
    if (state is HistoryLoading || state is HistoryInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is HistoryLoaded) {
      if (state.entries.isEmpty) {
        return const _EmptyState();
      }

      return ListView.builder(
        controller: scrollController,
        itemCount: state.entries.length,
        itemBuilder: (context, index) {
          final entry = state.entries[index];
          return _HistoryEntryTile(
            entry: entry,
            onTap: () {
              onEntryTap(entry.expression);
              Navigator.pop(context);
            },
            onDismissed: () {
              context.read<HistoryCubit>().delete(id: entry.id);
            },
          );
        },
      );
    }

    return const SizedBox.shrink();
  }

  void _showClearConfirmation(BuildContext context) {
    final l10n = context.l10n;
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.historyClearConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.historyClearCancel),
          ),
          TextButton(
            onPressed: () {
              context.read<HistoryCubit>().clearAll();
              Navigator.pop(dialogContext);
            },
            child: Text(
              l10n.historyClearAll,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Drag handle at top of bottom sheet.
class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(100),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

/// Header with title and clear all button.
class _Header extends StatelessWidget {
  const _Header({
    required this.showClearAll,
    required this.onClearAll,
  });

  final bool showClearAll;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l10n.historyTitle,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          if (showClearAll)
            TextButton(
              onPressed: onClearAll,
              child: Text(
                l10n.historyClearAll,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Empty state when no history entries.
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: Theme.of(context)
                .colorScheme
                .onSurfaceVariant
                .withAlpha(128),
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.historyEmpty,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withAlpha(179),
                ),
          ),
        ],
      ),
    );
  }
}

/// A single history entry tile with swipe to delete.
class _HistoryEntryTile extends StatelessWidget {
  const _HistoryEntryTile({
    required this.entry,
    required this.onTap,
    required this.onDismissed,
  });

  final HistoryEntry entry;
  final VoidCallback onTap;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(entry.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismissed(),
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: Icon(
          Icons.delete,
          color: Theme.of(context).colorScheme.onError,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(
          entry.expression,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        subtitle: Text(
          _formatTimestamp(context, entry.timestamp),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        trailing: Text(
          '= ${entry.result}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }

  String _formatTimestamp(BuildContext context, DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final entryDate = DateTime(
      timestamp.year,
      timestamp.month,
      timestamp.day,
    );

    if (entryDate == today) {
      return DateFormat.jm().format(timestamp);
    } else if (entryDate == today.subtract(const Duration(days: 1))) {
      return context.l10n.historyYesterday(DateFormat.jm().format(timestamp));
    } else {
      return DateFormat.MMMd().add_jm().format(timestamp);
    }
  }
}
