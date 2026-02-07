import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_mate/core/constants/profile_avatars.dart';
import 'package:math_mate/features/profile/data/location_service.dart';
import 'package:math_mate/features/profile/data/profile_repository.dart';

part 'profile_state.dart';

/// Cubit for managing user profile state.
///
/// Loads initial state from [ProfileRepository] and persists
/// changes on save. Uses [LocationService] for detecting the
/// user's city and region.
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required this.repository,
    this.locationService,
  }) : super(
          ProfileState(
            name: repository.loadName(),
            email: repository.loadEmail(),
            school: repository.loadSchool(),
            avatar: repository.loadAvatar(),
            city: repository.loadCity(),
            region: repository.loadRegion(),
          ),
        );

  /// Repository for persisting profile data.
  final ProfileRepository repository;

  /// Service for detecting user location.
  final LocationService? locationService;

  /// Saves all profile fields atomically.
  ///
  /// Used by the form submit button after validation passes.
  /// Preserves existing city and region values.
  Future<void> saveProfile({
    required String name,
    required String email,
    required String school,
    required ProfileAvatar? avatar,
  }) async {
    await repository.saveName(name);
    await repository.saveEmail(email);
    await repository.saveSchool(school);
    if (avatar != null) {
      await repository.saveAvatar(avatar);
    }
    await repository.saveCity(state.city);
    await repository.saveRegion(state.region);
    emit(ProfileState(
      name: name,
      email: email,
      school: school,
      avatar: avatar,
      city: state.city,
      region: state.region,
    ));
  }

  /// Updates only the avatar selection.
  ///
  /// Used by the avatar grid for immediate feedback.
  Future<void> updateAvatar(ProfileAvatar avatar) async {
    await repository.saveAvatar(avatar);
    emit(state.copyWith(avatar: avatar));
  }

  /// Detects the user's city and region via GPS.
  ///
  /// Requests permission, gets coordinates, reverse geocodes,
  /// and updates state with the result. Handles permission
  /// denied and errors gracefully.
  Future<void> detectLocation() async {
    if (locationService == null) return;

    emit(state.copyWith(isDetectingLocation: true));

    final granted =
        await locationService!.requestPermission();
    if (!granted) {
      emit(state.copyWith(isDetectingLocation: false));
      return;
    }

    final result =
        await locationService!.detectCityAndRegion();
    if (result != null) {
      await repository.saveCity(result.city);
      await repository.saveRegion(result.region);
      emit(state.copyWith(
        city: result.city,
        region: result.region,
        isDetectingLocation: false,
      ));
    } else {
      emit(state.copyWith(isDetectingLocation: false));
    }
  }
}
