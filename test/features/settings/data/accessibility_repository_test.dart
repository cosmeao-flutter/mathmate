import 'package:flutter_test/flutter_test.dart';
import 'package:math_mate/features/settings/data/accessibility_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AccessibilityRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repository = await AccessibilityRepository.create();
  });

  group('AccessibilityRepository', () {
    group('saveReduceMotion', () {
      test('saves true value', () async {
        await repository.saveReduceMotion(value: true);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getBool('reduce_motion'), isTrue);
      });

      test('saves false value', () async {
        await repository.saveReduceMotion(value: false);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getBool('reduce_motion'), isFalse);
      });
    });

    group('loadReduceMotion', () {
      test('returns false when nothing saved (default)', () {
        final value = repository.loadReduceMotion();
        expect(value, isFalse);
      });

      test('returns true when true saved', () async {
        SharedPreferences.setMockInitialValues({'reduce_motion': true});
        repository = await AccessibilityRepository.create();

        final value = repository.loadReduceMotion();
        expect(value, isTrue);
      });

      test('returns false when false saved', () async {
        SharedPreferences.setMockInitialValues({'reduce_motion': false});
        repository = await AccessibilityRepository.create();

        final value = repository.loadReduceMotion();
        expect(value, isFalse);
      });
    });

    group('saveHapticFeedback', () {
      test('saves true value', () async {
        await repository.saveHapticFeedback(value: true);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getBool('haptic_feedback'), isTrue);
      });

      test('saves false value', () async {
        await repository.saveHapticFeedback(value: false);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getBool('haptic_feedback'), isFalse);
      });
    });

    group('loadHapticFeedback', () {
      test('returns true when nothing saved (default)', () {
        final value = repository.loadHapticFeedback();
        expect(value, isTrue);
      });

      test('returns true when true saved', () async {
        SharedPreferences.setMockInitialValues({'haptic_feedback': true});
        repository = await AccessibilityRepository.create();

        final value = repository.loadHapticFeedback();
        expect(value, isTrue);
      });

      test('returns false when false saved', () async {
        SharedPreferences.setMockInitialValues({'haptic_feedback': false});
        repository = await AccessibilityRepository.create();

        final value = repository.loadHapticFeedback();
        expect(value, isFalse);
      });
    });

    group('saveSoundFeedback', () {
      test('saves true value', () async {
        await repository.saveSoundFeedback(value: true);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getBool('sound_feedback'), isTrue);
      });

      test('saves false value', () async {
        await repository.saveSoundFeedback(value: false);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getBool('sound_feedback'), isFalse);
      });
    });

    group('loadSoundFeedback', () {
      test('returns false when nothing saved (default)', () {
        final value = repository.loadSoundFeedback();
        expect(value, isFalse);
      });

      test('returns true when true saved', () async {
        SharedPreferences.setMockInitialValues({'sound_feedback': true});
        repository = await AccessibilityRepository.create();

        final value = repository.loadSoundFeedback();
        expect(value, isTrue);
      });

      test('returns false when false saved', () async {
        SharedPreferences.setMockInitialValues({'sound_feedback': false});
        repository = await AccessibilityRepository.create();

        final value = repository.loadSoundFeedback();
        expect(value, isFalse);
      });
    });

    group('persistence roundtrip', () {
      test('saves and loads reduce motion correctly', () async {
        await repository.saveReduceMotion(value: true);
        final value = repository.loadReduceMotion();
        expect(value, isTrue);
      });

      test('saves and loads haptic feedback correctly', () async {
        await repository.saveHapticFeedback(value: false);
        final value = repository.loadHapticFeedback();
        expect(value, isFalse);
      });

      test('saves and loads sound feedback correctly', () async {
        await repository.saveSoundFeedback(value: true);
        final value = repository.loadSoundFeedback();
        expect(value, isTrue);
      });

      test('saves and loads all settings independently', () async {
        await repository.saveReduceMotion(value: true);
        await repository.saveHapticFeedback(value: false);
        await repository.saveSoundFeedback(value: true);

        final reduceMotion = repository.loadReduceMotion();
        final hapticFeedback = repository.loadHapticFeedback();
        final soundFeedback = repository.loadSoundFeedback();

        expect(reduceMotion, isTrue);
        expect(hapticFeedback, isFalse);
        expect(soundFeedback, isTrue);
      });
    });
  });
}
