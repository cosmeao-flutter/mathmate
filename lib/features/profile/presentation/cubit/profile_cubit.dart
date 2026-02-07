import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_mate/core/constants/profile_avatars.dart';
import 'package:math_mate/features/profile/data/profile_repository.dart';

part 'profile_state.dart';

/// Cubit for managing user profile state.
///
/// Loads initial state from [ProfileRepository] and persists
/// changes on save.
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required this.repository})
      : super(
          ProfileState(
            name: repository.loadName(),
            email: repository.loadEmail(),
            school: repository.loadSchool(),
            avatar: repository.loadAvatar(),
          ),
        );

  /// Repository for persisting profile data.
  final ProfileRepository repository;

  /// Saves all profile fields atomically.
  ///
  /// Used by the form submit button after validation passes.
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
    emit(ProfileState(
      name: name,
      email: email,
      school: school,
      avatar: avatar,
    ));
  }

  /// Updates only the avatar selection.
  ///
  /// Used by the avatar grid for immediate feedback.
  Future<void> updateAvatar(ProfileAvatar avatar) async {
    await repository.saveAvatar(avatar);
    emit(state.copyWith(avatar: avatar));
  }
}
