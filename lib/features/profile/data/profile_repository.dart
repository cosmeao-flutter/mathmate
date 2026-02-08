import 'package:flutter/foundation.dart';
import 'package:math_mate/core/constants/profile_avatars.dart';
import 'package:math_mate/core/services/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Keys for storing profile data in SharedPreferences.
class _StorageKeys {
  static const String name = 'profile_name';
  static const String email = 'profile_email';
  static const String school = 'profile_school';
  static const String avatar = 'profile_avatar';
  static const String city = 'profile_city';
  static const String region = 'profile_region';
}

/// Repository for persisting user profile data using SharedPreferences.
///
/// Stores name, email, school, and avatar selection.
/// Defaults to empty strings for text fields and null for avatar.
class ProfileRepository {
  ProfileRepository._(this._prefs, this._logger);

  /// Creates a [ProfileRepository] for testing with injected
  /// dependencies.
  @visibleForTesting
  ProfileRepository.forTesting(
    this._prefs, {
    AppLogger? logger,
  }) : _logger = logger ?? AppLogger();

  final SharedPreferences _prefs;
  final AppLogger _logger;

  /// Creates a new [ProfileRepository] instance.
  static Future<ProfileRepository> create({
    AppLogger? logger,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    return ProfileRepository._(prefs, logger ?? AppLogger());
  }

  /// Saves the user's name to persistent storage.
  Future<void> saveName(String value) async {
    try {
      await _prefs.setString(_StorageKeys.name, value);
    } on Exception catch (e, stackTrace) {
      _logger.error('Failed to save name', e, stackTrace);
    }
  }

  /// Loads the saved name.
  ///
  /// Returns empty string if nothing is saved.
  String loadName() {
    return _prefs.getString(_StorageKeys.name) ?? '';
  }

  /// Saves the user's email to persistent storage.
  Future<void> saveEmail(String value) async {
    try {
      await _prefs.setString(_StorageKeys.email, value);
    } on Exception catch (e, stackTrace) {
      _logger.error('Failed to save email', e, stackTrace);
    }
  }

  /// Loads the saved email.
  ///
  /// Returns empty string if nothing is saved.
  String loadEmail() {
    return _prefs.getString(_StorageKeys.email) ?? '';
  }

  /// Saves the user's school to persistent storage.
  Future<void> saveSchool(String value) async {
    try {
      await _prefs.setString(_StorageKeys.school, value);
    } on Exception catch (e, stackTrace) {
      _logger.error('Failed to save school', e, stackTrace);
    }
  }

  /// Loads the saved school.
  ///
  /// Returns empty string if nothing is saved.
  String loadSchool() {
    return _prefs.getString(_StorageKeys.school) ?? '';
  }

  /// Saves the selected avatar to persistent storage.
  Future<void> saveAvatar(ProfileAvatar value) async {
    try {
      await _prefs.setString(_StorageKeys.avatar, value.name);
    } on Exception catch (e, stackTrace) {
      _logger.error('Failed to save avatar', e, stackTrace);
    }
  }

  /// Saves the user's city to persistent storage.
  Future<void> saveCity(String value) async {
    try {
      await _prefs.setString(_StorageKeys.city, value);
    } on Exception catch (e, stackTrace) {
      _logger.error('Failed to save city', e, stackTrace);
    }
  }

  /// Loads the saved city.
  ///
  /// Returns empty string if nothing is saved.
  String loadCity() {
    return _prefs.getString(_StorageKeys.city) ?? '';
  }

  /// Saves the user's region (state) to persistent storage.
  Future<void> saveRegion(String value) async {
    try {
      await _prefs.setString(_StorageKeys.region, value);
    } on Exception catch (e, stackTrace) {
      _logger.error('Failed to save region', e, stackTrace);
    }
  }

  /// Loads the saved region.
  ///
  /// Returns empty string if nothing is saved.
  String loadRegion() {
    return _prefs.getString(_StorageKeys.region) ?? '';
  }

  /// Loads the saved avatar.
  ///
  /// Returns `null` if nothing is saved or if the saved value
  /// doesn't match a valid [ProfileAvatar].
  ProfileAvatar? loadAvatar() {
    final value = _prefs.getString(_StorageKeys.avatar);
    if (value == null) return null;
    final index = ProfileAvatar.values.indexWhere(
      (a) => a.name == value,
    );
    return index == -1 ? null : ProfileAvatar.values[index];
  }
}
