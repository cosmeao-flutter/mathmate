import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_mate/core/constants/profile_avatars.dart';
import 'package:math_mate/features/profile/data/location_service.dart';
import 'package:math_mate/features/profile/data/profile_repository.dart';
import 'package:math_mate/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockLocationService extends Mock
    implements LocationService {}

void main() {
  late ProfileRepository repository;
  late MockLocationService locationService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repository = await ProfileRepository.create();
    locationService = MockLocationService();
  });

  group('ProfileCubit', () {
    group('initial state', () {
      test('defaults to empty profile with no avatar', () async {
        final cubit = ProfileCubit(repository: repository);

        expect(cubit.state.name, '');
        expect(cubit.state.email, '');
        expect(cubit.state.school, '');
        expect(cubit.state.avatar, isNull);

        await cubit.close();
      });

      test('loads saved preferences from repository', () async {
        SharedPreferences.setMockInitialValues({
          'profile_name': 'Alice',
          'profile_email': 'alice@school.edu',
          'profile_school': 'Springfield Elementary',
          'profile_avatar': 'star',
        });
        repository = await ProfileRepository.create();

        final cubit = ProfileCubit(repository: repository);

        expect(cubit.state.name, 'Alice');
        expect(cubit.state.email, 'alice@school.edu');
        expect(cubit.state.school, 'Springfield Elementary');
        expect(cubit.state.avatar, ProfileAvatar.star);

        await cubit.close();
      });
    });

    group('saveProfile', () {
      blocTest<ProfileCubit, ProfileState>(
        'emits state with all fields updated',
        build: () => ProfileCubit(repository: repository),
        act: (cubit) => cubit.saveProfile(
          name: 'Alice',
          email: 'alice@school.edu',
          school: 'Springfield Elementary',
          avatar: ProfileAvatar.rocket,
        ),
        expect: () => [
          const ProfileState(
            name: 'Alice',
            email: 'alice@school.edu',
            school: 'Springfield Elementary',
            avatar: ProfileAvatar.rocket,
          ),
        ],
      );

      blocTest<ProfileCubit, ProfileState>(
        'saves with empty school (optional field)',
        build: () => ProfileCubit(repository: repository),
        act: (cubit) => cubit.saveProfile(
          name: 'Bob',
          email: 'bob@example.com',
          school: '',
          avatar: ProfileAvatar.face,
        ),
        expect: () => [
          const ProfileState(
            name: 'Bob',
            email: 'bob@example.com',
            school: '',
            avatar: ProfileAvatar.face,
          ),
        ],
      );

      test('persists all fields to repository', () async {
        final cubit = ProfileCubit(repository: repository);
        await cubit.saveProfile(
          name: 'Alice',
          email: 'alice@school.edu',
          school: 'Springfield Elementary',
          avatar: ProfileAvatar.science,
        );

        expect(repository.loadName(), 'Alice');
        expect(repository.loadEmail(), 'alice@school.edu');
        expect(
          repository.loadSchool(),
          'Springfield Elementary',
        );
        expect(repository.loadAvatar(), ProfileAvatar.science);

        await cubit.close();
      });
    });

    group('updateAvatar', () {
      blocTest<ProfileCubit, ProfileState>(
        'emits state with updated avatar only',
        build: () => ProfileCubit(repository: repository),
        act: (cubit) =>
            cubit.updateAvatar(ProfileAvatar.musicNote),
        expect: () => [
          const ProfileState(avatar: ProfileAvatar.musicNote),
        ],
      );

      test('persists avatar to repository', () async {
        final cubit = ProfileCubit(repository: repository);
        await cubit.updateAvatar(ProfileAvatar.brush);

        expect(repository.loadAvatar(), ProfileAvatar.brush);

        await cubit.close();
      });
    });

    group('ProfileState', () {
      test('supports value equality', () {
        const state1 = ProfileState(
          name: 'Alice',
          email: 'alice@school.edu',
          avatar: ProfileAvatar.star,
        );
        const state2 = ProfileState(
          name: 'Alice',
          email: 'alice@school.edu',
          avatar: ProfileAvatar.star,
        );
        const state3 = ProfileState(
          name: 'Bob',
          email: 'bob@example.com',
          avatar: ProfileAvatar.star,
        );

        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
      });

      test('copyWith creates new instance with updated values',
          () {
        const state = ProfileState(
          name: 'Alice',
          email: 'alice@school.edu',
          school: 'Springfield',
          avatar: ProfileAvatar.star,
        );

        final updated = state.copyWith(name: 'Bob');
        expect(updated.name, 'Bob');
        expect(updated.email, 'alice@school.edu');
        expect(updated.school, 'Springfield');
        expect(updated.avatar, ProfileAvatar.star);
      });

      test('hasProfile returns true when name is not empty', () {
        const empty = ProfileState();
        const filled = ProfileState(name: 'Alice');

        expect(empty.hasProfile, isFalse);
        expect(filled.hasProfile, isTrue);
      });
    });

    group('nullable avatar', () {
      test('state avatar defaults to null', () {
        const state = ProfileState();
        expect(state.avatar, isNull);
      });

      test(
          'copyWith preserves null avatar '
          'when not specified', () {
        const state = ProfileState(
          name: 'Alice',
          avatar: ProfileAvatar.star,
        );

        final updated = state.copyWith(name: 'Bob');
        expect(updated.avatar, ProfileAvatar.star);
      });
    });

    group('detectLocation', () {
      blocTest<ProfileCubit, ProfileState>(
        'emits loading then city/region on success',
        build: () {
          when(() => locationService.requestPermission())
              .thenAnswer((_) async => true);
          when(() => locationService.detectCityAndRegion())
              .thenAnswer(
            (_) async => (
              city: 'San Francisco',
              region: 'California',
            ),
          );
          return ProfileCubit(
            repository: repository,
            locationService: locationService,
          );
        },
        act: (cubit) => cubit.detectLocation(),
        expect: () => [
          const ProfileState(isDetectingLocation: true),
          const ProfileState(
            city: 'San Francisco',
            region: 'California',
          ),
        ],
      );

      blocTest<ProfileCubit, ProfileState>(
        'does not update location when permission denied',
        build: () {
          when(() => locationService.requestPermission())
              .thenAnswer((_) async => false);
          return ProfileCubit(
            repository: repository,
            locationService: locationService,
          );
        },
        act: (cubit) => cubit.detectLocation(),
        expect: () => [
          const ProfileState(isDetectingLocation: true),
          const ProfileState(),
        ],
      );

      blocTest<ProfileCubit, ProfileState>(
        'handles null result from detectCityAndRegion',
        build: () {
          when(() => locationService.requestPermission())
              .thenAnswer((_) async => true);
          when(() => locationService.detectCityAndRegion())
              .thenAnswer((_) async => null);
          return ProfileCubit(
            repository: repository,
            locationService: locationService,
          );
        },
        act: (cubit) => cubit.detectLocation(),
        expect: () => [
          const ProfileState(isDetectingLocation: true),
          const ProfileState(),
        ],
      );

      test('persists city and region to repository',
          () async {
        when(() => locationService.requestPermission())
            .thenAnswer((_) async => true);
        when(() => locationService.detectCityAndRegion())
            .thenAnswer(
          (_) async => (
            city: 'Austin',
            region: 'Texas',
          ),
        );

        final cubit = ProfileCubit(
          repository: repository,
          locationService: locationService,
        );
        await cubit.detectLocation();

        expect(repository.loadCity(), 'Austin');
        expect(repository.loadRegion(), 'Texas');

        await cubit.close();
      });
    });

    group('saveProfile with location', () {
      blocTest<ProfileCubit, ProfileState>(
        'emits state with city and region included',
        build: () => ProfileCubit(
          repository: repository,
          locationService: locationService,
        ),
        seed: () => const ProfileState(
          city: 'Austin',
          region: 'Texas',
        ),
        act: (cubit) => cubit.saveProfile(
          name: 'Alice',
          email: 'alice@school.edu',
          school: 'Springfield',
          avatar: ProfileAvatar.star,
        ),
        expect: () => [
          const ProfileState(
            name: 'Alice',
            email: 'alice@school.edu',
            school: 'Springfield',
            avatar: ProfileAvatar.star,
            city: 'Austin',
            region: 'Texas',
          ),
        ],
      );

      test('persists city and region on save', () async {
        when(() => locationService.requestPermission())
            .thenAnswer((_) async => true);
        when(() => locationService.detectCityAndRegion())
            .thenAnswer(
          (_) async => (
            city: 'Denver',
            region: 'Colorado',
          ),
        );

        final cubit = ProfileCubit(
          repository: repository,
          locationService: locationService,
        );
        await cubit.detectLocation();
        await cubit.saveProfile(
          name: 'Bob',
          email: 'bob@example.com',
          school: '',
          avatar: ProfileAvatar.face,
        );

        expect(repository.loadCity(), 'Denver');
        expect(repository.loadRegion(), 'Colorado');

        await cubit.close();
      });
    });
  });
}
