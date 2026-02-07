part of 'profile_cubit.dart';

/// State representing the current user profile.
///
/// Contains:
/// - [name]: User's display name (default: empty)
/// - [email]: User's email address (default: empty)
/// - [school]: User's school name (default: empty, optional)
/// - [avatar]: Selected avatar icon (default: null = not chosen)
class ProfileState extends Equatable {
  const ProfileState({
    this.name = '',
    this.email = '',
    this.school = '',
    this.avatar,
  });

  /// The user's display name.
  final String name;

  /// The user's email address.
  final String email;

  /// The user's school (optional).
  final String school;

  /// The selected avatar, or null if not yet chosen.
  final ProfileAvatar? avatar;

  /// Whether the user has set up their profile (name is not empty).
  bool get hasProfile => name.isNotEmpty;

  /// Creates a copy with optionally updated values.
  ProfileState copyWith({
    String? name,
    String? email,
    String? school,
    ProfileAvatar? avatar,
  }) {
    return ProfileState(
      name: name ?? this.name,
      email: email ?? this.email,
      school: school ?? this.school,
      avatar: avatar ?? this.avatar,
    );
  }

  @override
  List<Object?> get props => [name, email, school, avatar];
}
