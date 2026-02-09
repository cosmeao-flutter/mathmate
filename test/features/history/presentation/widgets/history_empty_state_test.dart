// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_mate/core/constants/app_assets.dart';
import 'package:math_mate/core/theme/app_theme.dart';
import 'package:math_mate/features/history/presentation/cubit/history_cubit.dart';
import 'package:math_mate/features/history/presentation/widgets/history_bottom_sheet.dart';
import 'package:math_mate/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class MockHistoryCubit extends MockCubit<HistoryState>
    implements HistoryCubit {}

void main() {
  late MockHistoryCubit mockHistoryCubit;

  setUp(() {
    mockHistoryCubit = MockHistoryCubit();
    when(() => mockHistoryCubit.state)
        .thenReturn(const HistoryLoaded(entries: []));
  });

  Widget buildTestWidget() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light,
      home: Scaffold(
        body: BlocProvider<HistoryCubit>.value(
          value: mockHistoryCubit,
          child: Builder(
            builder: (context) => HistoryBottomSheet(
              onEntryTap: (_) {},
            ),
          ),
        ),
      ),
    );
  }

  group('History empty state', () {
    testWidgets('shows Image widget instead of Icon', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Should have an Image, not an Icon
      expect(find.byType(Image), findsOneWidget);
      expect(find.byIcon(Icons.history), findsNothing);
    });

    testWidgets('Image uses correct asset path', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final image = tester.widget<Image>(find.byType(Image));
      final assetImage = image.image as AssetImage;
      expect(assetImage.assetName, AppAssets.emptyHistory);
    });

    testWidgets('still shows localized empty text', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // "No calculations yet" in English
      expect(find.text('No calculations yet'), findsOneWidget);
    });
  });
}
