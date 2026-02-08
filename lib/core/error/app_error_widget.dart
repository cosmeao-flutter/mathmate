import 'package:flutter/material.dart';

/// A friendly error widget shown instead of the red error screen.
///
/// Replaces the default [ErrorWidget] in release/profile builds
/// via [ErrorWidget.builder]. Uses hardcoded English since the
/// l10n system may not be available during error states.
class AppErrorWidget extends StatelessWidget {
  /// Creates an [AppErrorWidget] with the given error details.
  const AppErrorWidget({required this.details, super.key});

  /// The Flutter error details that triggered this widget.
  final FlutterErrorDetails details;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            const Text(
              'Something went wrong',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
