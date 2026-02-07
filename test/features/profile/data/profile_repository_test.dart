import 'package:flutter_test/flutter_test.dart';
import 'package:math_mate/core/constants/profile_avatars.dart';
import 'package:math_mate/features/profile/data/profile_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late ProfileRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repository = await ProfileRepository.create();
  });

  group('ProfileRepository', () {
    group('saveName / loadName', () {
      test('saves name value', () async {
        await repository.saveName('Alice');

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('profile_name'), 'Alice');
      });

      test('returns empty string when nothing saved (default)', () {
        final value = repository.loadName();
        expect(value, '');
      });

      test('returns saved name', () async {
        SharedPreferences.setMockInitialValues({
          'profile_name': 'Bob',
        });
        repository = await ProfileRepository.create();

        final value = repository.loadName();
        expect(value, 'Bob');
      });

      test('overwrites previous name', () async {
        await repository.saveName('Alice');
        await repository.saveName('Bob');

        final value = repository.loadName();
        expect(value, 'Bob');
      });
    });

    group('saveEmail / loadEmail', () {
      test('saves email value', () async {
        await repository.saveEmail('alice@school.edu');

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('profile_email'), 'alice@school.edu');
      });

      test('returns empty string when nothing saved (default)', () {
        final value = repository.loadEmail();
        expect(value, '');
      });

      test('returns saved email', () async {
        SharedPreferences.setMockInitialValues({
          'profile_email': 'bob@example.com',
        });
        repository = await ProfileRepository.create();

        final value = repository.loadEmail();
        expect(value, 'bob@example.com');
      });
    });

    group('saveSchool / loadSchool', () {
      test('saves school value', () async {
        await repository.saveSchool('Springfield Elementary');

        final prefs = await SharedPreferences.getInstance();
        expect(
          prefs.getString('profile_school'),
          'Springfield Elementary',
        );
      });

      test('returns empty string when nothing saved (default)', () {
        final value = repository.loadSchool();
        expect(value, '');
      });

      test('returns saved school', () async {
        SharedPreferences.setMockInitialValues({
          'profile_school': 'Hogwarts',
        });
        repository = await ProfileRepository.create();

        final value = repository.loadSchool();
        expect(value, 'Hogwarts');
      });
    });

    group('saveAvatar / loadAvatar', () {
      test('saves avatar value', () async {
        await repository.saveAvatar(ProfileAvatar.star);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('profile_avatar'), 'star');
      });

      test('returns null when nothing saved (default)', () {
        final value = repository.loadAvatar();
        expect(value, isNull);
      });

      test('returns saved avatar', () async {
        SharedPreferences.setMockInitialValues({
          'profile_avatar': 'rocket',
        });
        repository = await ProfileRepository.create();

        final value = repository.loadAvatar();
        expect(value, ProfileAvatar.rocket);
      });

      test('returns null for invalid avatar string', () async {
        SharedPreferences.setMockInitialValues({
          'profile_avatar': 'invalid_avatar',
        });
        repository = await ProfileRepository.create();

        final value = repository.loadAvatar();
        expect(value, isNull);
      });
    });

    group('persistence roundtrip', () {
      test('saves and loads name correctly', () async {
        await repository.saveName('Alice');
        final value = repository.loadName();
        expect(value, 'Alice');
      });

      test('saves and loads email correctly', () async {
        await repository.saveEmail('alice@school.edu');
        final value = repository.loadEmail();
        expect(value, 'alice@school.edu');
      });

      test('saves and loads school correctly', () async {
        await repository.saveSchool('Springfield Elementary');
        final value = repository.loadSchool();
        expect(value, 'Springfield Elementary');
      });

      test('saves and loads all fields independently', () async {
        await repository.saveName('Alice');
        await repository.saveEmail('alice@school.edu');
        await repository.saveSchool('Springfield Elementary');
        await repository.saveAvatar(ProfileAvatar.science);

        final name = repository.loadName();
        final email = repository.loadEmail();
        final school = repository.loadSchool();
        final avatar = repository.loadAvatar();

        expect(name, 'Alice');
        expect(email, 'alice@school.edu');
        expect(school, 'Springfield Elementary');
        expect(avatar, ProfileAvatar.science);
      });
    });
  });
}
