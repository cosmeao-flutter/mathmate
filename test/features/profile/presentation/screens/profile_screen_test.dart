import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_mate/core/constants/app_strings.dart';
import 'package:math_mate/core/constants/profile_avatars.dart';
import 'package:math_mate/features/profile/data/profile_repository.dart';
import 'package:math_mate/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:math_mate/features/profile/presentation/screens/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late ProfileRepository repository;
  late ProfileCubit cubit;

  Future<Widget> buildSubject() async {
    return MaterialApp(
      home: BlocProvider.value(
        value: cubit,
        child: const ProfileScreen(),
      ),
    );
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repository = await ProfileRepository.create();
    cubit = ProfileCubit(repository: repository);
  });

  tearDown(() async {
    await cubit.close();
  });

  group('ProfileScreen', () {
    group('rendering', () {
      testWidgets('shows title in app bar', (tester) async {
        await tester.pumpWidget(await buildSubject());

        expect(
          find.text(AppStrings.profileTitle),
          findsOneWidget,
        );
      });

      testWidgets('shows name, email, and school fields',
          (tester) async {
        await tester.pumpWidget(await buildSubject());

        expect(
          find.text(AppStrings.profileName),
          findsOneWidget,
        );
        expect(
          find.text(AppStrings.profileEmail),
          findsOneWidget,
        );
        expect(
          find.text(AppStrings.profileSchool),
          findsOneWidget,
        );
      });

      testWidgets('shows avatar grid with 10 avatars',
          (tester) async {
        await tester.pumpWidget(await buildSubject());

        expect(
          find.text(AppStrings.profileAvatar),
          findsOneWidget,
        );
        expect(
          find.byType(CircleAvatar),
          findsNWidgets(ProfileAvatar.values.length),
        );
      });

      testWidgets('shows save button', (tester) async {
        await tester.pumpWidget(await buildSubject());

        expect(
          find.text(AppStrings.profileSave),
          findsOneWidget,
        );
      });

      testWidgets('pre-populates fields from cubit state',
          (tester) async {
        SharedPreferences.setMockInitialValues({
          'profile_name': 'Alice',
          'profile_email': 'alice@school.edu',
          'profile_school': 'Springfield',
        });
        repository = await ProfileRepository.create();
        await cubit.close();
        cubit = ProfileCubit(repository: repository);

        await tester.pumpWidget(await buildSubject());

        expect(find.text('Alice'), findsOneWidget);
        expect(find.text('alice@school.edu'), findsOneWidget);
        expect(find.text('Springfield'), findsOneWidget);
      });
    });

    group('validation', () {
      testWidgets('shows error when name is empty',
          (tester) async {
        await tester.pumpWidget(await buildSubject());

        await tester.tap(find.text(AppStrings.profileSave));
        await tester.pumpAndSettle();

        expect(
          find.text(AppStrings.profileNameRequired),
          findsOneWidget,
        );
      });

      testWidgets('shows error when email is empty',
          (tester) async {
        await tester.pumpWidget(await buildSubject());

        // Fill name to pass name validation
        await tester.enterText(
          find.byType(TextFormField).first,
          'Alice',
        );

        await tester.tap(find.text(AppStrings.profileSave));
        await tester.pumpAndSettle();

        expect(
          find.text(AppStrings.profileEmailRequired),
          findsOneWidget,
        );
      });

      testWidgets('shows error when email is invalid',
          (tester) async {
        await tester.pumpWidget(await buildSubject());

        // Fill name
        await tester.enterText(
          find.byType(TextFormField).first,
          'Alice',
        );
        // Fill invalid email
        await tester.enterText(
          find.byType(TextFormField).at(1),
          'not-an-email',
        );

        await tester.tap(find.text(AppStrings.profileSave));
        await tester.pumpAndSettle();

        expect(
          find.text(AppStrings.profileEmailInvalid),
          findsOneWidget,
        );
      });

      testWidgets('shows error when avatar not selected',
          (tester) async {
        await tester.pumpWidget(await buildSubject());

        // Fill valid name and email
        await tester.enterText(
          find.byType(TextFormField).first,
          'Alice',
        );
        await tester.enterText(
          find.byType(TextFormField).at(1),
          'alice@school.edu',
        );

        await tester.tap(find.text(AppStrings.profileSave));
        await tester.pumpAndSettle();

        expect(
          find.text(AppStrings.profileAvatarRequired),
          findsOneWidget,
        );
      });

      testWidgets('shows error when name is too short',
          (tester) async {
        await tester.pumpWidget(await buildSubject());

        await tester.enterText(
          find.byType(TextFormField).first,
          'A',
        );

        await tester.tap(find.text(AppStrings.profileSave));
        await tester.pumpAndSettle();

        expect(
          find.text(AppStrings.profileNameTooShort),
          findsOneWidget,
        );
      });
    });

    group('location', () {
      testWidgets('shows location section with label',
          (tester) async {
        await tester.pumpWidget(await buildSubject());

        expect(
          find.text(AppStrings.profileLocation),
          findsOneWidget,
        );
      });

      testWidgets('shows detect location button',
          (tester) async {
        await tester.pumpWidget(await buildSubject());

        expect(
          find.text(AppStrings.profileDetectLocation),
          findsOneWidget,
        );
      });

      testWidgets('shows pre-populated city and region',
          (tester) async {
        SharedPreferences.setMockInitialValues({
          'profile_name': 'Alice',
          'profile_city': 'Austin',
          'profile_region': 'Texas',
        });
        repository = await ProfileRepository.create();
        await cubit.close();
        cubit = ProfileCubit(repository: repository);

        await tester.pumpWidget(await buildSubject());

        expect(
          find.text('Austin, Texas'),
          findsOneWidget,
        );
      });
    });

    group('form submission', () {
      testWidgets('saves profile when all fields valid',
          (tester) async {
        await tester.pumpWidget(await buildSubject());

        // Fill all fields
        await tester.enterText(
          find.byType(TextFormField).first,
          'Alice',
        );
        await tester.enterText(
          find.byType(TextFormField).at(1),
          'alice@school.edu',
        );
        await tester.enterText(
          find.byType(TextFormField).at(2),
          'Springfield',
        );

        // Select avatar (tap first CircleAvatar)
        await tester.tap(find.byType(CircleAvatar).first);
        await tester.pumpAndSettle();

        // Submit
        await tester.tap(find.text(AppStrings.profileSave));
        await tester.pumpAndSettle();

        // Verify cubit state was updated
        expect(cubit.state.name, 'Alice');
        expect(cubit.state.email, 'alice@school.edu');
        expect(cubit.state.school, 'Springfield');
        expect(cubit.state.avatar, ProfileAvatar.person);
      });

      testWidgets('shows success snackbar after save',
          (tester) async {
        await tester.pumpWidget(await buildSubject());

        // Fill all fields
        await tester.enterText(
          find.byType(TextFormField).first,
          'Alice',
        );
        await tester.enterText(
          find.byType(TextFormField).at(1),
          'alice@school.edu',
        );

        // Select avatar
        await tester.tap(find.byType(CircleAvatar).first);
        await tester.pumpAndSettle();

        // Submit
        await tester.tap(find.text(AppStrings.profileSave));
        await tester.pumpAndSettle();

        expect(
          find.text(AppStrings.profileSaved),
          findsOneWidget,
        );
      });
    });
  });
}
