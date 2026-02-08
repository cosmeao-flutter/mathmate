import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_mate/core/error/app_error_widget.dart';

void main() {
  group('AppErrorWidget', () {
    final details = FlutterErrorDetails(
      exception: Exception('test error'),
    );

    testWidgets('renders error icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppErrorWidget(details: details),
          ),
        ),
      );

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('renders error message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppErrorWidget(details: details),
          ),
        ),
      );

      expect(
        find.text('Something went wrong'),
        findsOneWidget,
      );
    });

    testWidgets(
      'renders within MaterialApp context',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppErrorWidget(details: details),
            ),
          ),
        );

        expect(find.byType(AppErrorWidget), findsOneWidget);
      },
    );
  });
}
